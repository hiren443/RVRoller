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

//if using RVViewController pealse ignore it.
@property (nonatomic, assign)   id<RVContentViewDelegate>  delegate;

// set titles
@property (nonatomic, strong)   NSArray     *titles;
- (void)setTitles:(NSArray *)titles animated:(BOOL)animated;

// the font of titles in header 
@property (nonatomic, strong)   UIFont      *font;
// the color of titles
@property (nonatomic, strong)   UIColor     *headerTextColor;

// spacing of each title
@property (nonatomic, assign)   CGFloat     spacing;
// the backgroud color of header
@property (nonatomic, strong)   UIColor     *headrColor;
// the height of the header.
@property (nonatomic, assign)   CGFloat     headerHeight;

// now whitch view controller is selected?
@property (nonatomic, assign)   NSInteger   index;
- (void)setIndex:(NSInteger)index animated:(BOOL)animated;

//if set shadowImage , it will ignore showShadow,
@property (nonatomic, strong)   UIImage     *shadowImage;
@property (nonatomic, assign)   BOOL        showShadow;

//just mean as name.
@property (nonatomic, assign)   BOOL        scrollEnable;

// is contents use the full screen
@property (nonatomic, assign)   BOOL        contentFullScreen;
//
@property (nonatomic, assign)   BOOL        fullScreen;

// one page flip.
- (void)nextPage;
- (void)prevPage;

@end

@protocol RVContentViewDelegate <NSObject>

- (UIView*)contentView:(RVContentView*)view contentAtIndex:(NSInteger)index;
- (UIView*)contentView:(RVContentView*)view leftViewAt:(NSInteger)index;
- (UIView*)contentView:(RVContentView*)view rightViewAt:(NSInteger)index;

@optional

- (void)contentView:(RVContentView*)view willRollToIndex:(NSInteger)index;

@end
