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
