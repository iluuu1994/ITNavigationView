// DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
// Version 2, December 2004
//
// Copyright (C) 2013 Ilija Tovilo <support@ilijatovilo.ch>
//
// Everyone is permitted to copy and distribute verbatim or modified
// copies of this license document, and changing it is allowed as long
// as the name is changed.
//
// DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
// TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
// 0. You just DO WHAT THE FUCK YOU WANT TO.

//
//  ITAppDelegate.m
//  ITNavigationViewDemo
//
//  Created by Ilija Tovilo on 4/25/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import "ITAppDelegate.h"
#import "ITNavigationView.h"
#import "ITTestViewController.h"
#import "ITTestTwoViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ITAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.navigationView.animationDuration = 0.5;
    
    [self switchViewControllerWithTag:0];
}

- (IBAction)switchViewController:(id)sender {
    [self switchViewControllerWithTag:[sender tag]];
}

- (void)switchViewControllerWithTag:(NSUInteger)tag {    
    if (tag == 0 && self.navigationView.currentView != self.testViewController.view) {
        [self.navigationView setCurrentView:self.testViewController.view
                         withAnimationStyle:ITNavigationViewAnimationStylePop];
    } else if (tag == 1 && self.navigationView.currentView != self.testTwoViewController.view) {
        [self.navigationView setCurrentView:self.testTwoViewController.view
                         withAnimationStyle:ITNavigationViewAnimationStylePush];
    }
}

@end
