    //
//  MainMenuController.m
//  SpinArt
//
//  Created by Rim Rami on 10/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"
#import "SwitchView.h"
#import "HelloWorldScene.h"


@implementation MainMenuController

@synthesize popoverController;

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
	
	SwitchView* menuView = [[SwitchView alloc] initWithFrame:rc];
	menuView.parent = self;
 	self.view = menuView;
	[menuView.parent release];
//	[menuView release];
	
	delegate = [[UIApplication sharedApplication] delegate];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"Menu";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Back" 
																			   style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease]; 	
}

- (void) loadFromlibrary
{
	isPhone = YES;
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];	
}

- (void) loadFromlibraryPad
{
	isPhone = NO;
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
	[imagePicker release];
	
	self.popoverController = popover;
	[popover release];
	
	[self.popoverController presentPopoverFromRect:CGRectMake(100, 100, 600, 200) 
											inView:self.view
						  permittedArrowDirections:UIPopoverArrowDirectionAny 
										  animated:YES];
	
/*	UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
	popover.delegate = self;
	[imagePicker release];
	 
	self.popoverController = popover;
	[popover release];
	 
//	[self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 500, 500)
//							inView:backItem
//						  permittedArrowDirections:UIPopoverArrowDirectionAny 
//										  animated:YES];
	[self.popoverController presentPopoverFromBarButtonItem:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
*/
}

//call back
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    [self dismissModalViewControllerAnimated:YES];
	
	if (!isPhone)
		[self.popoverController dismissPopoverAnimated:YES];

	[delegate createClearImage:selectedImage];
	UIImage* shadow = [UIImage imageNamed:@"00000.png"];
	[self setShadow:shadow];
}

-(void) back
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) setShape:(UIImage*)image
{
	[delegate.gameView createClearImage:image];
}

-(void)setShadow:(UIImage*)image
{
	[delegate.gameView createShadow:image];
}

-(void) setWhiteColor
{
	[delegate.gameView setBGColor:255 g:255 b:255];
	[self back];
}

-(void) setCurrentColor
{
	[delegate.gameView setBGCurrentColor];
	[self back];
}

-(void) clearBackground
{
	[delegate.gameView clearBackground];
	[self back];
}

-(void)setSelectImage:(UIImage*)image
{
	SwitchView* view = (SwitchView*)self.view;
	[view setSelectImage:image];
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
