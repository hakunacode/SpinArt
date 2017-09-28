    //
//  AboutController.m
//  SpinArt
//
//  Created by Rim Rami on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutController.h"
#import "AboutView.h"

@implementation AboutController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect rc;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		rc = CGRectMake(0, 0, 320, 480);
	}else{ 
		rc = CGRectMake(0, 0, 768, 1024);
	}
	
	AboutView* menuView = [[AboutView alloc] initWithFrame:rc];
 	self.view = menuView;
	[menuView release];
	
	delegate = [[UIApplication sharedApplication] delegate];	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"About";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Done" 
																			   style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease]; 	
}

-(void) back
{
	[self dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
