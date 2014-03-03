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

- (void)setCurrentView:(NSView *)currentView {
    if (self.animationStyle != ITNavigationViewAnimationStyleNone) {
        [self setCurrentView:currentView withAnimation:YES];
    } else {
        [self setCurrentView:currentView withAnimation:NO];
    }
}

- (void)setCurrentView:(NSView *)currentView withAnimation:(BOOL)animationFlag {
    if (_isLocked) return;
    
    // Make view resize properly
    currentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    // Resize the subview to fit perfectly and add it
    _currentView.frame = self.bounds;
    currentView.frame = self.bounds;
    _animationView.frame = self.bounds;
    _cachedImageView.frame = self.bounds;
    _oldCachedImageView.frame = self.bounds;
    
    // Remove old subview
    [_currentView removeFromSuperview];
    
    if (!_currentView || !animationFlag) {
        // Add the new view
        [self addSubview:currentView];
    } else {
        // Animate
        _isLocked = YES;
        
        // Display Animation View
        self.oldCachedImageView.frame = self.bounds;
        self.oldCachedImageView.image = [self imageOfView:_currentView];
        
        // Removes object from memory
        _currentView = nil;
        
        self.cachedImageView.frame = [self rectForViewWithAnimationStyle:self.animationStyle oldView:NO];
        self.cachedImageView.image = [self imageOfView:currentView];
        
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
                    [self addSubview:currentView];
                    
                    // Set the first responder
                    [currentView becomeFirstResponder];
                    
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
    
    _currentView = currentView;
}

- (void)setCurrentView:(NSView *)currentView withAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle {
    self.animationStyle = animationStyle;
    self.currentView = currentView;
}

- (BOOL)enableShiftModifier {
    return YES;
}



#pragma mark -
#pragma mark Helpers

- (NSRect)rectForViewWithAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle oldView:(BOOL)oldRect{
    NSRect modifiedRect = self.bounds;
    int reverser = (oldRect)?-1:1;
    
    switch (animationStyle) {
        case ITNavigationViewAnimationStyleFade:
            break;
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
    [view layoutSubtreeIfNeeded];
    [view setNeedsUpdateConstraints:YES];
    [view updateConstraintsForSubtreeIfNeeded];
    
    NSBitmapImageRep* rep = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
    [view cacheDisplayInRect:view.bounds toBitmapImageRep:rep];
    
    return [[NSImage alloc] initWithCGImage:[rep CGImage] size:view.bounds.size];
}



#pragma mark - Deprecated

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

- (void)setCurrentViewController:(NSViewController *)currentViewController {
    if (self.animationStyle != ITNavigationViewAnimationStyleNone) {
        [self setCurrentViewController:currentViewController withAnimation:YES];
    } else {
        [self setCurrentViewController:currentViewController withAnimation:NO];
    }
}


@end
