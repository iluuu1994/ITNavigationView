//
// Copyright (c) 2014, Ilija Tovilo
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the organization nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL ILIJA TOVILO BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

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
                         withAnimationStyle:ITNavigationViewAnimationStylePushUp];
    } else if (tag == 1 && self.navigationView.currentView != self.testTwoViewController.view) {
        [self.navigationView setCurrentView:self.testTwoViewController.view
                         withAnimationStyle:ITNavigationViewAnimationStylePushDown];
    }
}

@end
