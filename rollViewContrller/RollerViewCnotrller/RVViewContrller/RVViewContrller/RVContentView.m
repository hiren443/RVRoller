//
//  RVContentView.m
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RVContentView.h"
#define TempCount(count)    (0x00100000|count)
#define ShowCount(count)    (0x11011111&count)

@implementation RVContentView{
    UIScrollView    *_titleScrollView;
    NSMutableArray  *_indexes;
}

@synthesize titles = _titles, font = _font;
@synthesize delegate = _delegate, index = _index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleScrollView = [[UIScrollView alloc] initWithFrame:
                            CGRectMake(0, 0, frame.size.width, 25)];
        [self addSubview:_titleScrollView];
        
        _indexes = [NSMutableArray new];
        
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.backgroundColor = [UIColor blackColor];
        _titleScrollView.contentInset = UIEdgeInsetsMake(0, self.bounds.size.width / 2,
                                                         0, self.bounds.size.width / 2);
        self.backgroundColor = [UIColor whiteColor];
        
        _font = [UIFont boldSystemFontOfSize:13];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _titleScrollView.frame = CGRectMake(0, 0, frame.size.width, 25);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setIndex:(NSInteger)index
{
    _index = index;
}

- (void)setTitles:(NSArray *)titles
{
    [self setTitles:titles animated:NO];
}

- (void)setTitles:(NSArray *)titles animated:(BOOL)animated
{
    int count = [_titles count];
    _titles = titles;
    if (animated) {
        //set animation here.
        [UIView transitionWithView:_titleScrollView
                          duration:0.2
                           options:UIViewAnimationCurveEaseOut
                        animations:^
         {
             _titleScrollView.contentOffset = CGPointMake(-100, 0);
         } 
                        completion:^(BOOL finished) 
         {
             [self setTitlesWithOldCount:count];
             CGFloat left = [[_indexes objectAtIndex:_index] floatValue];
             [_titleScrollView setContentOffset:CGPointMake(left, 0) animated:YES];
         }];
    }else
        [self setTitlesWithOldCount:count];
}

- (void)setTitlesWithOldCount:(NSInteger)count
{
    for (int n = 0; n < count; n ++) {
        UIView *view = [_titleScrollView viewWithTag:TempCount(n)];
        [view removeFromSuperview];
    }
    
    int total = [_titles count];
    [_indexes removeAllObjects];
    
    CGFloat fv = 0;
    CGFloat upper = 0;
    for (int n = 0; n < total; n ++) {
        
        NSString *title = [_titles objectAtIndex:n];
        [_indexes addObject:[NSNumber numberWithFloat:fv]];
        CGSize size = [title sizeWithFont:_font
                        constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
        
        //make the button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(fv + 25, 0, size.width, 25);
        [button setTitle:title
                forState:UIControlStateNormal];
        button.titleLabel.font = _font;
        [_titleScrollView addSubview:button];
        button.tag = TempCount(n);
        [button addTarget:self
                   action:@selector(clickAtButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // set for next
        fv += size.width / 2 + 25 + upper / 2;
        upper = size.width;
        
    }
    
    _titleScrollView.contentSize = CGSizeMake(fv - upper / 2 + 25, 0);
}
         
- (void)clickAtButton:(UIButton*)sender
{
    [self setIndex:ShowCount(sender.tag)
          animated:YES];
}

- (void)setIndex:(NSInteger)index animated:(BOOL)animated
{
    
}

@end
