//
//  RVViewContrller.m
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RVViewContrller.h"
#import "RVContentView.h"

@interface RVViewContrller()
<RVContentViewDelegate>

@end

@implementation RVViewContrller {
    int _oldIndex;
}

@synthesize viewControllers = _viewControllers;
@synthesize contentView = _contentView;


- (void)loadView
{
   self.view = _contentView = [[RVContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.delegate = self;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [self setViewControllers:viewControllers aniamted:NO];
}

- (void)setViewControllers:(NSArray *)viewControllers aniamted:(BOOL)animated
{
    [self view];
    _viewControllers = viewControllers;
    if (animated) {
        //if aniamtion
        
    }
    NSMutableArray *array = [NSMutableArray array];
    BOOL add = [self respondsToSelector:@selector(addChildViewController:)];
    for (UIViewController *c in viewControllers) {
        [array addObject:c.title];
        if (add) {
            [self addChildViewController:c];
        }
    }
    [_contentView setTitles:array animated:animated];
}

- (RVContentView*)contentView
{
    if (!_contentView) {
        [self view];
    }
    return _contentView;
}

- (UIView*)contentView:(RVContentView *)view contentAtIndex:(NSInteger)index
{
    return [[_viewControllers objectAtIndex:index] view];
}

- (void)contentView:(RVContentView *)view willRollToIndex:(NSInteger)index
{
    if (_oldIndex == index) {
        return;
    }
    UIViewController *ctrl = [_viewControllers objectAtIndex:_oldIndex];
    [ctrl viewWillDisappear:NO];
    [ctrl performSelector:@selector(viewDidDisappear:)
               withObject:nil afterDelay:0];
    _oldIndex = index;
    ctrl = [_viewControllers objectAtIndex:index];
    [ctrl viewDidAppear:NO];
    [ctrl performSelector:@selector(viewDidAppear:)
               withObject:nil afterDelay:0];
}

- (UIView*)getViewAt:(NSInteger)index
{
    UIViewController *ctrl = [_viewControllers objectAtIndex:index];
    if ([ctrl isViewLoaded]) {
        return ctrl.view;
    }
    return nil;
}

- (UIView*)contentView:(RVContentView *)view leftViewAt:(NSInteger)index
{
    return [self getViewAt:index];
}

- (UIView*)contentView:(RVContentView *)view rightViewAt:(NSInteger)index
{
    return [self getViewAt:index];
}

@end
