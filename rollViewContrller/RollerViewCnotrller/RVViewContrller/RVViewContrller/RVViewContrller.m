//
//  RVViewContrller.m
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RVViewContrller.h"
#import "RVContentView.h"
#import "RVContentView_private.h"

@interface RVViewContrller()
<RVContentViewDelegate>

@end

@implementation RVViewContrller {
    int _oldIndex;
}

@synthesize viewControllers = _viewControllers;
@synthesize contentView = _contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedMemoryWarningNotification:) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}

- (void)receivedMemoryWarningNotification:(id)sender
{
    [_contentView didMemoryWarring];
    for (int n = 0, t = [_viewControllers count] ; n < t ; n++) {
        if (n != _oldIndex) {
            UIViewController *ctrl = [_viewControllers objectAtIndex:n];
            ctrl.view = nil;
            [ctrl viewDidUnload];
        }
    }
}

- (void)loadView
{
    self.view = _contentView = [[RVContentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _contentView.delegate = self;
    [self setViewControllers:_viewControllers];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _contentView = nil;
    for (UIViewController *ctrl in _viewControllers) {
        ctrl.view = nil;
        [ctrl viewDidUnload];
    }
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
    for (UIViewController *c in viewControllers) {
        if (c.title) {
            [array addObject:c.title];
        }else [array addObject:@""];
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

- (void)setWantsFullScreenLayout:(BOOL)wantsFullScreenLayout
{
    [super setWantsFullScreenLayout:wantsFullScreenLayout];
    self.contentView.fullScreen = wantsFullScreenLayout;
}

- (void)contentView:(RVContentView *)view willRollToIndex:(NSInteger)index
{
    if (_oldIndex == index) {
        return;
    }
    
    BOOL lower5 = [[[UIDevice currentDevice] systemVersion] floatValue] < 5.0;
    
    UIViewController *ctrl = [_viewControllers objectAtIndex:_oldIndex];
    if ([ctrl respondsToSelector:@selector(removeFromParentViewController)])
        [ctrl removeFromParentViewController];
    if (lower5) {
        [ctrl viewWillDisappear:NO];
        [ctrl performSelector:@selector(viewDidDisappear:)
                   withObject:nil afterDelay:0];
    }
    _oldIndex = index;
    UIViewController *ctrl2 = [_viewControllers objectAtIndex:index];
    if ([self respondsToSelector:@selector(addChildViewController:)]) {
        [self addChildViewController:ctrl2];
    }
    if (lower5) {
        [ctrl2 viewDidAppear:NO];
        [ctrl2 performSelector:@selector(viewDidAppear:)
                    withObject:nil afterDelay:0];
    }
    
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
