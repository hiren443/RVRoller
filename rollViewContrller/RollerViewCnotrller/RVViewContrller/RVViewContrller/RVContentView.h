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

- (void)setTitles:(NSArray *)titles animated:(BOOL)animated;

@property (nonatomic, strong)   NSArray     *titles;
@property (nonatomic, strong)   UIFont      *font;
@property (nonatomic, assign)   NSInteger   index;
@property (nonatomic, assign)   CGFloat     spacing;

- (void)setIndex:(NSInteger)index animated:(BOOL)animated;

- (void)nextPage;
- (void)prevPage;

@end

@protocol RVContentViewDelegate <NSObject>

- (UIView*)contentView:(RVContentView*)view contentAtIndex:(NSInteger)index;

@end
