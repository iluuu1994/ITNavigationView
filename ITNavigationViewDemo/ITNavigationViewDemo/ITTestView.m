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
//  ITTestView.m
//  ITNavigationViewDemo
//
//  Created by Ilija Tovilo on 4/25/13.
//  Copyright (c) 2013 Ilija Tovilo. All rights reserved.
//

#import "ITTestView.h"

@implementation ITTestView

- (void)drawRect:(NSRect)dirtyRect {
    NSGradient *grad = [[NSGradient alloc] initWithColors:@[ [NSColor colorWithDeviceWhite:0.2 alpha:1.0],
                                          [NSColor colorWithDeviceWhite:0.1 alpha:1.0] ]];
    
    [grad drawInBezierPath:[NSBezierPath bezierPathWithRect:self.bounds] relativeCenterPosition:NSMakePoint(0.0, 0.0)];
}

@end
