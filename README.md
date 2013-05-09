ITNavigationView
================

A iOS like view driven by Core Animation, that can replace it's subview with a sleek animation

Usage
-----

### Copy files

Copy the following files:

* `ITNavigationView.h`
* `ITNavigationView.m`

Make sure to copy them to the project, and to add them to the target.
Also, make sure to include the QuartzCore framework.

### Use in a project

Drag a custom view onto your window.
Set it's custom class to `ITNavigationView`.

Now you can connect an outlet to it, and use the following methods and properties:

    @property (nonatomic, strong) NSViewController *currentViewController;
    
    - (void)setCurrentViewController:(NSViewController *)currentViewController
                  withAnimationStyle:(ITNavigationViewAnimationStyle)animationStyle;
                  
    - (void)setCurrentViewController:(NSViewController *)currentViewController
                       withAnimation:(BOOL)animationFlag;
                       
    @property ITNavigationViewAnimationStyle animationStyle;
    @property (nonatomic) NSTimeInterval animationDuration;
    @property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
    @property (nonatomic) BOOL fadeAnimation;

    
### License

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
    Version 2, December 2004 
    
    Copyright (C) 2013 Ilija Tovilo <support@ilijatovilo.ch> 
     
    Everyone is permitted to copy and distribute verbatim or modified 
    copies of this license document, and changing it is allowed as long 
    as the name is changed. 
    
    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
    
    0. You just DO WHAT THE FUCK YOU WANT TO.

### Help

If you have any questions, feel free to let me know at support@ilijatovilo.ch
