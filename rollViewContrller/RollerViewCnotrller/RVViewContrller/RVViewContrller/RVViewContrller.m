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

@implementation RVViewContrller 

@synthesize viewControllers = _viewControllers, index = _index;
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
    for (UIViewController *c in viewControllers) {
        [array addObject:c.title];
    }
    [_contentView setTitles:array animated:animated];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
}

- (UIView*)contentView:(RVContentView *)view contentAtIndex:(NSInteger)index
{
    return [[_viewControllers objectAtIndex:index] view];
}

@end
