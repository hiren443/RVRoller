//
//  RVContentView.h
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RVContentViewDelegate;

@interface RVContentView : UIView

@property (nonatomic, assign)   id<RVContentViewDelegate>  delegate;

@property (nonatomic, strong)   NSArray *titles;
- (void)setTitles:(NSArray *)titles animated:(BOOL)animated;

@property (nonatomic, strong)   UIFont  *font;
@property (nonatomic, assign)   NSInteger   index;

- (void)setIndex:(NSInteger)index animated:(BOOL)animated;

@end

@protocol RVContentViewDelegate <NSObject>

- (UIView*)contentView:(RVContentView*)view contentAtIndex:(NSInteger)index;

@end
