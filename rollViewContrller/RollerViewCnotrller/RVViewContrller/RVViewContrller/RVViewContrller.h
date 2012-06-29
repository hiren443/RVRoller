//
//  RVViewContrller.h
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RVContentView.h"

@interface RVViewContrller : UIViewController

@property (nonatomic, readonly) RVContentView   *contentView;

//set the view contrllers
@property (nonatomic, strong)   NSArray *viewControllers;

- (void)setViewControllers:(NSArray *)viewControllers aniamted:(BOOL)animated;

@end
