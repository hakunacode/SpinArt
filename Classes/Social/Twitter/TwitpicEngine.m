

#import "TwitpicEngine.h"

#define kTwitpicUploadURL @"https://twitpic.com/api/uploadAndPost"  // Note: This URL automatically posts to Twitter on upload
#define kTwitpicImageJPEGCompression 1  // Between 0.1 and 1.0, where 1.0 is the highest quality JPEG compression setting


@implementation TwitpicEngine


- (id)initWithDelegate:(id)theDelegate
{
	if (self = [super init])
	{
		delegate = theDelegate;  // Set delegate (don't make the mistake and release this later...)
	}
	return self;
}


- (void)uploadingDataWithURLRequest:(NSURLRequest *)urlRequest
{
	// Called on a separate thread; upload and handle server response
	NSHTTPURLResponse *urlResponse;
	NSError			  *error;
	NSString		  *responseString;
	NSData			  *responseData;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];		// Each thread must have its own NSAutoreleasePool
	
	[urlRequest retain];  // Retain since we autoreleased it before
	
	// Send the request
	urlResponse = nil;  
	responseData = [NSURLConnection sendSynchronousRequest:urlRequest
										 returningResponse:&urlResponse   
													 error:&error];  
	responseString = [[NSString alloc] initWithData:responseData
										   encoding:NSUTF8StringEncoding];
	
	// Handle the error or success
	// If error, create error message and throw up UIAlertView
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
	{
		NSLog(@"urlResultString: %@", responseString);
		NSDictionary *responseDictionary = [OFXMLMapper dictionaryMappedFromXMLData:responseData];
		
		for(id key in responseDictionary)
			NSLog(@"Key: %@ Value: %@", key, [responseDictionary valueForKey:key]);
		
		if( [[responseDictionary valueForKeyPath:@"rsp.stat"] isEqualToString:@"fail"])
		{
			NSLog(@"Error String: %@\n",[responseDictionary valueForKeyPath:@"rsp.err.msg"]);
			
			// Send back notice to delegate
			[delegate twitpicEngine:self didUploadImageWithResponse:[responseDictionary valueForKeyPath:@"rsp.err.msg"]]; 
		}
		else if( [[responseDictionary valueForKeyPath:@"rsp.status"] isEqualToString:@"ok"] )
		{
			NSLog(@"Media URL: %@\n",[[responseDictionary valueForKeyPath:@"rsp.mediaurl"] textContent]);
			
			// Send back notice to delegate
			[delegate twitpicEngine:self didUploadImageWithResponse:[[responseDictionary valueForKeyPath:@"rsp.mediaurl"] textContent]]; 
		}
	}
	else
	{
		NSLog(@"Error while uploading, got 400 error back or no response at all: %@", [urlResponse statusCode]);
		[delegate twitpicEngine:self didUploadImageWithResponse:@"Error"];  // Nil should mean "upload failed" to the delegate
	}
	
	[pool release];	 // Release everything except responseData and urlResponse–they're autoreleased on creation
	[responseString release];  
	[urlRequest release];
}


- (BOOL)uploadImageToTwitpic:(NSData *)imageData withMessage:(NSString *)theMessage 
					username:(NSString *)username password:(NSString *)password
{
	NSString			*stringBoundary, *contentType, *message, *baseURLString, *urlString;
	NSURL				*url;
	NSMutableURLRequest *urlRequest;
	NSMutableData		*postBody;
	
	// Create POST request from message, imageData, username and password
	baseURLString	= kTwitpicUploadURL;
	urlString		= [NSString stringWithFormat:@"%@", baseURLString];  
	url				= [NSURL URLWithString:urlString];
	urlRequest		= [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"POST"];	
	
	// Set the params
	message		  = ([theMessage length] > 1) ? theMessage : @"Here's my new Light Table collage.";
	//imageData	  = UIImageJPEGRepresentation(image, kTwitpicImageJPEGCompression);
	
	// Setup POST body
	stringBoundary = [NSString stringWithString:@"CBXEROqaGfEPjnBLN0W8g"];
	contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
	[urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
	// Setting up the POST request's multipart/form-data body
	postBody = [NSMutableData data];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"lighttable"] dataUsingEncoding:NSUTF8StringEncoding]];  // So Light Table show up as source in Twitter post
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:username] dataUsingEncoding:NSUTF8StringEncoding]];  // username
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:password] dataUsingEncoding:NSUTF8StringEncoding]];  // password
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:message] dataUsingEncoding:NSUTF8StringEncoding]];  // message
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", @"lighttable_twitpic_image.jpg" ] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];  // jpeg as data
	[postBody appendData:[[NSString stringWithString:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:imageData];  // Tack on the imageData to the end
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[urlRequest setHTTPBody:postBody];
	
	// Spawn a new thread so the UI isn't blocked while we're uploading the image
    [NSThread detachNewThreadSelector:@selector(uploadingDataWithURLRequest:) toTarget:self withObject:urlRequest];	
	
	return YES;  // TODO: Should raise exception on error
}


#pragma mark -
#pragma mark Misc


- (void)dealloc 
{	
	// No ivars to release
    [super dealloc];
}


@end
