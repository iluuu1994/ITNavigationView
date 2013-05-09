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
//  ITNavigationView.m
//  ITNavigationView
//
//  Created by Ilija Tovilo on 2/27/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import "ITNavigationView.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultAnimationDuration 0.4
#define kSlowAnimationMultiplier 10
#define kDefaultTimingFunction [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]

@interface ITNavigationView ()
@property (nonatomic, strong) NSView *animationView;
@property (strong) NSImageView *oldCachedImageView;
@property (strong) NSImageView *cachedImageView;
@end

@implementation ITNavigationView
{}
@synthesize isLocked = _isLocked;

#pragma mark -
#pragma mark Initialise
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initNavigationController];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initNavigationController];
    }
    return self;
}

- (void)initNavigationController {
}

- (void)awakeFromNib {
    // Initialises the animation view
    // Else the first change does not get animated
    [self animationView];
}

#pragma mark -
#pragma mark Setters & Getters

- (BOOL)isLocked {
    return _isLocked;
}

- (NSTimeInterval)animationDuration {
    if (!_animationDuration) {
        return kDefaultAnimationDuration;
    }
    
    return _animationDuration;
}

- (CAMediaTimingFunction *)timingFunction {
    if (!_timingFunction) {
        return kDefaultTimingFunction;
    }
    
    return _timingFunction;
}

- (NSView *)animationView {
    if (!_animationView) {
        _animationView = [[NSView alloc] initWithFrame:self.bounds];

        self.oldCachedImageView = [[NSImageView alloc] initWithFrame:self.bounds];
        [_animationView addSubview:self.oldCachedImageView];
        self.oldCachedImageView.wantsLayer = YES;
        
        self.cachedImageView = [[NSImageView alloc] initWithFrame:self.bounds];
        [_animationView addSubview:self.cachedImageView];
        self.cachedImageView.wantsLayer = YES;
        
        self.animationView.wantsLayer = YES;
    }
    
    return _animationView;
}

- (void)setCurrentViewController:(NSViewController *)currentViewController {
    if (self.animationStyle != ITNavigationViewAnimationStyleNone) {
        [self setCurrentViewController:currentViewController withAnimation:YES];
    } else {
        [self setCurrentViewController:currentViewController withAnimation:NO];
    }
}

- (BOOL)enableShiftModifier {
    return YES;
}

- (void)setCurrentViewController:(NSViewController *)currentViewController withAnimation:(BOOL)animationFlag {
    if (_isLocked) return;
    
    // Resize the subview to fit perfectly and add it
    _currentViewController.view.frame = self.bounds;
    currentViewController.view.frame = self.bounds;
    _animationView.frame = self.bounds;
    _cachedImageView.frame = self.bounds;
    _oldCachedImageView.frame = self.bounds;
    
    // Remove old subview
    [_currentViewController.view removeFromSuperview];
    
    if (!_currentViewController || !animationFlag) {
        // Add the new view
        [self addSubview:currentViewController.view];
    } else {
        // Animate
        _isLocked = YES;

        // Display Animation View
        self.oldCachedImageView.frame = self.bounds;
        self.oldCachedImageView.image = [self imageOfView:_currentViewController.view];
        
        // Removes object from memory
        _currentViewController = nil;
        
        self.cachedImageView.frame = [self rectForViewWithAnimationStyle:self.animationStyle oldView:NO];
        self.cachedImageView.image = [self imageOfView:currentViewController.view];

        [self addSubview:self.animationView];
        self.cachedImageView.alphaValue = 0.0;
        self.oldCachedImageView.alphaValue = 1.0;

        dispatch_async(dispatch_get_main_queue(), ^{
            [NSAnimationContext beginGrouping];
            {
                // Removes the old view after the animation
                [[NSAnimationContext currentContext] setCompletionHandler:^{
                    [self.animationView removeFromSuperview];
                    
                    _cachedImageView.image = nil;
                    _oldCachedImageView.image = nil;
                    
                    // Add the new view
                    [self addSubview:currentViewController.view];
                    
                    // Set the first responder
                    [currentViewController.view becomeFirstResponder];
                    
                    _isLocked = NO;
                }];
                
                [[NSAnimationContext currentContext] setDuration:((([NSEvent modifierFlags] & NSShiftKeyMask) && [self enableShiftModifier])?self.animationDuration*kSlowAnimationMultiplier:self.animationDuration)];
                [[NSAnimationContext currentContext] setTimingFunction:self.timingFunction];
                
                // Animates the new view to the same frame as the current view is right now
                [[self.cachedImageView animator] setFrame:self.bounds];
                [self.cachedImageView.animator setAlphaValue:1.0];
                
                // This is the old frame
                [[self.oldCachedImageView animator] setFrame:[self rectForViewWithAnimationStyle:self.animationStyle oldView:YES]];
                [self.oldCachedImageView.animator setAlphaValue:0.0];
            }
            [NSAnimationContext endGrouping];
        });
    }
    
    _currentViewController = currentViewController;
}

- (void)setCurrentViewController:(NSViewController *)currentViewController
              withAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle {
    
    self.animationStyle = animationStyle;
    self.currentViewController = currentViewController;
}

#pragma mark -
#pragma mark Helpers

- (NSRect)rectForViewWithAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle oldView:(BOOL)oldRect{
    NSRect modifiedRect = self.bounds;
    int reverser = (oldRect)?-1:1;
    
    switch (animationStyle) {
        case ITNavigationViewAnimationStylePush:
            modifiedRect.origin.x = modifiedRect.size.width * reverser;
            break;
        case ITNavigationViewAnimationStylePop:
            modifiedRect.origin.x = -modifiedRect.size.width * reverser;
            break;
        case ITNavigationViewAnimationStylePushDown:
            modifiedRect.origin.y = modifiedRect.size.height * reverser;
            break;
        case ITNavigationViewAnimationStylePushUp:
            modifiedRect.origin.y = -modifiedRect.size.height * reverser;
            break;
        default:
            break;
    }
    
    return modifiedRect;
}

- (NSImage *)imageOfView:(NSView *)view {
    NSBitmapImageRep* rep = [view bitmapImageRepForCachingDisplayInRect:self.bounds];
    [view cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
    
    return [[NSImage alloc] initWithCGImage:[rep CGImage] size:view.bounds.size];
}

@end
