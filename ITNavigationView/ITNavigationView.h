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
//  ITNavigationView.h
//  ITNavigationView
//
//  Created by Ilija Tovilo on 2/27/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef ITNavigationViewTypedef
#define ITNavigationViewTypedef

typedef enum {
    ITNavigationViewAnimationStyleFade,
    ITNavigationViewAnimationStylePush,
    ITNavigationViewAnimationStylePop,
    ITNavigationViewAnimationStylePushDown,
    ITNavigationViewAnimationStylePushUp,
    ITNavigationViewAnimationStyleNone
} ITNavigationViewAnimationStyle;

#endif

@interface ITNavigationView : NSView

/**
 *  The current view, that is being displayed in the navigation controller
 */
@property (nonatomic, strong) NSView *currentView;
- (void)setCurrentView:(NSView *)currentView
    withAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle;

/**
 * The style of the animation
 */
@property ITNavigationViewAnimationStyle animationStyle;

/**
 * Duration of the animation
 */
@property (nonatomic) NSTimeInterval animationDuration;

/**
 * The timing function of the animation
 */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/**
 * Is fade animation enabled?
 */
@property (nonatomic) BOOL fadeAnimation;

/**
 * See if the navigation view is locked
 */
@property (nonatomic, readonly) BOOL isLocked;



// ****************************
// ***************** DEPRECATED
// ****************************

/**
 * This property is depricated. Use `currentViewController` instead.
 * The current view controller, that is being displayed in the navigation controller
 */
@property (nonatomic, strong) NSViewController *currentViewController __deprecated;

/**
 * This method is depricated. Use `setCurrentViewController:withAnimationStyle:` instead.
 * Set the current view controller, that is being displayed in the navigation controller
 */
- (void)setCurrentViewController:(NSViewController *)currentViewController
              withAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle __deprecated;

/**
 * This method is depricated. Use `setCurrentViewController:withAnimation:` instead.
 * Change the view controller with, or without an animation
 */
- (void)setCurrentViewController:(NSViewController *)currentViewController
                   withAnimation:(BOOL)animationFlag __deprecated;

@end
