    //
//  MUPopupViewController.m
//  MUKit
//
//  Created by Malaar on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MUPopupViewController.h"
#import "MUPopupView.h"
#import "MUCocoaExtentions.h"

#define MOTION_DURATION         0.4f


//==============================================================================
//==============================================================================
//==============================================================================
@interface MUPopupViewController (Private)

- (void) hidedButtonPressed:(id)aSender;
- (void) setupSubviews;

- (void) popupWillAppear:(BOOL)animated;
- (void) popupDidAppear:(BOOL)animated;
- (void) popupWillDisappear:(BOOL)animated;
- (void) popupDidDisappear:(BOOL)animated;

@end


//==============================================================================
//==============================================================================
//==============================================================================
@implementation MUPopupViewController

@synthesize popupedView;

//@synthesize hideByTapOutside;
@synthesize isShow;
//@synthesize showOverlayView;
@synthesize overlayView;
@synthesize overlayViewAlpha;

//@synthesize navigationController;

#pragma mark - init/dealloc
//==============================================================================
- (id) init
{
    if( (self = [super init]) )
    {
//		weakRef = [[MUWeakRef alloc] initWithObject:self];
		
        overlayView = nil;
        overlayViewAlpha = 0.3f;
        
//        hideByTapOutside = YES;
        animatingNow = NO;
        isShow = NO;
    }
    return self;
}

//==============================================================================
- (void) dealloc
{
    [popupedView release];
    NSLog(@"retainCount: %i", popupedView.retainCount);
    
//	[weakRef invalidate];
//	[weakRef release];
	
	[super dealloc];
}

#pragma mark - properties
////==============================================================================
//- (void) setHideByTapOutside:(BOOL)aShowHidedButton
//{
//    hideByTapOutside = aShowHidedButton;
//    btHided.hidden = !hideByTapOutside;
//}

////==============================================================================
//- (void) setShowOverlayView:(BOOL)aShowOverlayView
//{
//    showOverlayView = aShowOverlayView;
//    
//    if(!overlayView && showOverlayView)
//    {
//        overlayView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
//        [self.view addSubview:overlayView];
//        overlayView.backgroundColor = [UIColor grayColor];
//        overlayView.alpha = 0.0f;
//        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self.view sendSubviewToBack:overlayView];
//    }
//    overlayView.hidden = !showOverlayView;
//}

#pragma mark - view life cicle
//==============================================================================
- (void) setupSubviews
{
    CGRect frame;

    frame = self.view.bounds;
    frame.origin.y = self.view.bounds.size.height;
    popupedViewOwner = [[[UIView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:popupedViewOwner];
    popupedViewOwner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // btHided
    btHided = [UIButton buttonWithType:UIButtonTypeCustom];
    [popupedViewOwner addSubview:btHided];
    btHided.frame = self.view.bounds;
    btHided.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [btHided addTarget:self action:@selector(hidedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btHided.hidden = !popupedView.hideByTapOutside;
//    self.hideByTapOutside = hideByTapOutside;

    if(popupedView.showOverlayView)
    {
        overlayView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
        [self.view addSubview:overlayView];
        overlayView.backgroundColor = [UIColor grayColor];
        overlayView.alpha = 0.0f;
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view sendSubviewToBack:overlayView];
//        overlayView.hidden = !showOverlayView;
    }

    // popuped view
//    popupedView = [self createPopupedView];
    if(popupedView)
    {
        NSLog(@"retainCount: %i", popupedView.retainCount);

//        popupedView.owner = self;
        [popupedViewOwner addSubview:popupedView];
        frame = popupedView.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        popupedView.frame = frame;
        
//        NSLog(@"popupedView size:: %@", NSStringFromCGSize(popupedView.bounds.size));
        NSLog(@"retainCount: %i", popupedView.retainCount);

    }
}

//==============================================================================
- (void)loadView
{
	self.view = [[[UIView alloc]init] autorelease];
    self.view.hidden = YES;	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.view.backgroundColor = [UIColor clearColor];
}

//==============================================================================
- (void) popupWillAppear:(BOOL)animated
{
	//calculate and setup frame for view
	CGRect frame;
    frame.origin = CGPointZero;
    
    float navBarHeight = 0;
    UIViewController* parentVC = [self.view.superview firstAvailableUIViewController];
    if(parentVC)
    {
        UINavigationController* nc = parentVC.navigationController;
        if(nc && !nc.navigationBarHidden)
            navBarHeight = nc.navigationBar.bounds.size.height;
    }

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
	if( UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )
	{
		frame.size.width = screenSize.height;
		frame.size.height = screenSize.width - 20 - navBarHeight;
	}
	else
	{
		frame.size.width = screenSize.width;
		frame.size.height = screenSize.height - 20 - navBarHeight;
	}
	self.view.frame = frame;

    [self setupSubviews];
    
    [self.view.superview bringSubviewToFront:self.view];
    self.view.hidden = NO;
    
    [popupedView popupWillAppear:animated];
}

//==============================================================================
- (void) popupDidAppear:(BOOL)animated
{
    NSLog(@"retainCount: %i", popupedView.retainCount);
    [popupedView popupDidAppear:animated];
}

//==============================================================================
- (void) popupWillDisappear:(BOOL)animated
{
    NSLog(@"retainCount: %i", popupedView.retainCount);
    [popupedView popupWillDisappear:animated];
}

//==============================================================================
- (void) popupDidDisappear:(BOOL)animated
{
    NSLog(@"retainCount: %i", popupedView.retainCount);
    [self.view removeFromSuperview];
    [popupedView popupDidDisappear:animated];
    NSLog(@"retainCount: %i", popupedView.retainCount);

    //kill self
    [self autorelease];
}

#pragma mark - rotations
//==============================================================================
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - show/hide
//==============================================================================
- (void) showWithAnimation:(BOOL)animation inView:(UIView*)aView
{
    if(isShow) return;

    [aView addSubview:self.view];
	[self popupWillAppear:animation];
    
    // anim
    
    isShow = YES;
    
    if(animation)
    {
        // animations
        [UIView animateWithDuration:MOTION_DURATION
                         animations:^(void)
         {
             animatingNow = YES;

             // motion
             CGRect frame = popupedViewOwner.frame;
             frame.origin = CGPointZero;
             popupedViewOwner.frame = frame;
             
             // change overlay alpha
             overlayView.alpha = overlayViewAlpha;
         }
                         completion:^(BOOL finished)
         {
             animatingNow = NO;

             [self popupDidAppear:animation];
         }];
    }
    else
    {
        // placed
        CGRect frame = popupedViewOwner.frame;
        frame.origin = CGPointZero;
        popupedViewOwner.frame = frame;

        [self popupDidAppear:animation];
    }
    
}

//==============================================================================
- (void) hideWithAnimation:(BOOL)animation
{
    if(!isShow) return;
    
    [self popupWillDisappear:animation];

    if(animation)
    {
        animatingNow = YES;
        
        // animations
        [UIView animateWithDuration:MOTION_DURATION
                         animations:^(void)
         {
             // motion
             CGRect frame = popupedViewOwner.frame;
             frame.origin.y = self.view.bounds.size.height;
             popupedViewOwner.frame = frame;
             
             // change overlay alpha
             overlayView.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             animatingNow = NO;
             [self popupDidDisappear:animation];
         }];
    }
    else
    {
        [self popupDidDisappear:animation];
    }
}

//==============================================================================
- (void) hidedButtonPressed:(id)aSender
{
    [self hideWithAnimation:YES];
}

//#pragma mark - override to configure
////==============================================================================
//- (UIView*) createPopupedView
//{
//    return nil;
//}

//#pragma mark - weakReference
////==============================================================================
//- (MUWeakRef*) weakReference
//{
//	return weakRef;
//}

//==============================================================================
//==============================================================================
//==============================================================================
@end
