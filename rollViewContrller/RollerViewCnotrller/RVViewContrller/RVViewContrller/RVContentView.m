//
//  RVContentView.m
//  RVViewContrller
//
//  Created by zrz on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RVContentView.h"
#import <QuartzCore/QuartzCore.h>

#define TempCount(count)    (0x00100000|count)
#define ShowCount(count)    (0xff0fffff&count)
#define kHeightOfTitle      25

@interface UILabel(RVView)

- (void)setUp;

@end

@implementation UILabel(RVView)

- (void)setUp
{
    self.font = [UIFont boldSystemFontOfSize:30];
    self.textColor = [UIColor grayColor];
    self.shadowColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.shadowOffset =CGSizeMake(1, 3);
    self.textAlignment = UITextAlignmentCenter;
}

@end

@interface RVContentView()
<UIScrollViewDelegate>

@end

@implementation RVContentView{
    UIScrollView    *_titleScrollView;
    NSMutableArray  *_indexes;
    UIView          *_whiteView1,
                    *_whiteView2,
                    *_contentView;
    CALayer         *_blackLayer,
                    *_makeLayer;
    NSTimeInterval  _startTime;
    UIImageView     *_shadowImageView;
    __unsafe_unretained UIView  *_leftView,
                                *_rightView,
                                *_nowView;
    UIPanGestureRecognizer      *_pan;
}

@synthesize titles = _titles, font = _font;
@synthesize delegate = _delegate, index = _index;
@synthesize spacing = _spacing, headrColor = _headrColor;
@synthesize headerTextColor = _headerTextColor;
@synthesize headerHeight = _headerHeight;
@synthesize shadowImage = _shadowImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _headerHeight = kHeightOfTitle;
        _titleScrollView = [[UIScrollView alloc] initWithFrame:
                            CGRectMake(0, 0, frame.size.width, _headerHeight)];
        [self addSubview:_titleScrollView];
        
        _indexes = [NSMutableArray new];
        
        _headrColor = [UIColor blackColor];
        _headerTextColor = [UIColor whiteColor];
        
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.delegate = self;
        _titleScrollView.backgroundColor = _headrColor;
        _titleScrollView.contentInset = UIEdgeInsetsMake(0, frame.size.width / 2,
                                                         0, frame.size.width / 2);
        _titleScrollView.decelerationRate = 20;
        self.backgroundColor = [UIColor whiteColor];
        
        _font = [UIFont boldSystemFontOfSize:13];
        _spacing = 45;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _headerHeight, frame.size.width, frame.size.height - _headerHeight)];
        [self insertSubview:_contentView belowSubview:_titleScrollView];
        
        CGRect bounds = _contentView.bounds;
        
        _whiteView1 = [[UIView alloc] initWithFrame:(CGRect){0, 0, bounds.size}];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        [activity startAnimating];
        [_whiteView1 addSubview:activity];
        
        _whiteView2 = [[UIView alloc] initWithFrame:(CGRect){0, 0, bounds.size}];
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center = CGPointMake(bounds.size.width/2, bounds.size.height/2);
        [_whiteView2 addSubview:activity];
        [activity startAnimating];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(panedOn:)];
        [_contentView addGestureRecognizer:_pan];
        _makeLayer = [CALayer layer];
        _makeLayer.contents = (id)[UIImage imageNamed:@"rv_mask"].CGImage;
        _makeLayer.frame = CGRectMake(0, 0, 320, _headerHeight);
        _blackLayer = [CALayer layer];
        _blackLayer.frame = _titleScrollView.frame;
        _blackLayer.backgroundColor = _headrColor.CGColor;
        [self.layer addSublayer:_blackLayer];
        _blackLayer.mask = _makeLayer;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _makeLayer.frame = _blackLayer.frame = _titleScrollView.frame =
                CGRectMake(0, 0, frame.size.width, _headerHeight);
    _titleScrollView.contentInset = UIEdgeInsetsMake(0, frame.size.width / 2 - 1,
                                                     0, frame.size.width / 2 - 1);
    
    _contentView.frame = CGRectMake(0, _headerHeight, frame.size.width, 
                                    frame.size.height - _headerHeight);
    _whiteView2.bounds = _whiteView1.bounds = (CGRect){0, 0, frame.size};
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self _showAtPage];
}

#pragma mark - setters

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
                          duration:0.3
                           options:UIViewAnimationCurveEaseOut
                        animations:^
         {
             _titleScrollView.contentInset = UIEdgeInsetsMake(0, 320, 0, 0);
             _titleScrollView.contentOffset = CGPointMake(-320 , 0);
         } 
                        completion:^(BOOL finished) 
         {
             [self setTitlesWithOldCount:count];
             [self _showAtPage];
             id obj = nil;
             if (animated) {
                 //just some valued
                 obj = @"1";
             }
             [self performSelector:@selector(_setbackInset:)
                        withObject:obj afterDelay:0.2];
         }];
    }else {
        [self setTitlesWithOldCount:count];
        [self _setIndexAnimated:animated];
        [self _showAtPage];
    }
}

- (void)setHeadrColor:(UIColor *)headrColor
{
    _headrColor = headrColor;
    _blackLayer.backgroundColor = [headrColor CGColor];
    _titleScrollView.backgroundColor = headrColor;
}

- (void)setHeaderTextColor:(UIColor *)headerTextColor
{
    for (int n = 0, t = [_titles count]; n < t; n ++) {
        UIButton *button = (id)[_titleScrollView viewWithTag:TempCount(n)];
        [button setTitleColor:headerTextColor
                     forState:UIControlStateNormal];
        [button setTitleColor:[headerTextColor colorWithAlphaComponent:0.8]
                     forState:UIControlStateHighlighted];
    }
    _headerTextColor = headerTextColor;
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = shadowImage;
    _titleScrollView.layer.shadowOpacity = 0;
    if (!_shadowImageView && shadowImage) {
        CGRect frame = _titleScrollView.frame;
        _shadowImageView = [[UIImageView alloc] initWithFrame:
                            CGRectMake(frame.origin.x, frame.origin.y+frame.size.height,
                                       frame.size.width, 3)];
        [self insertSubview:_shadowImageView
               belowSubview:_titleScrollView];
    }
    _shadowImageView.image = shadowImage;
}

- (void)setHeaderHeight:(CGFloat)headerHeight
{
    _headerHeight = headerHeight;
    
    CGRect frame = self.frame;
    _makeLayer.frame = _blackLayer.frame = _titleScrollView.frame =
            CGRectMake(0, 0, frame.size.width, _headerHeight);
    
    _contentView.frame = CGRectMake(0, _headerHeight, frame.size.width, 
                                    frame.size.height - _headerHeight);
    _whiteView2.bounds = _whiteView1.bounds = (CGRect){0, 0, frame.size};
    _shadowImageView.frame = CGRectMake(0, _headerHeight, frame.size.width, 3);
    
    for (int n = 0, t = [_titles count]; n < t; n ++) {
        UIButton *button = (id)[_titleScrollView viewWithTag:TempCount(n)];
        CGRect rect = button.frame;
        rect.size.height = _headerHeight;
        button.frame = rect;
    }
}

- (void)_setbackInset:(BOOL)animated
{
    CGRect frame = _titleScrollView.bounds;
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^
         {
             _titleScrollView.contentInset = UIEdgeInsetsMake(0, frame.size.width / 2 - 1,
                                                              0, frame.size.width / 2 - 1);
             [self _setIndexAnimated:animated];
         }];
    }else {
        _titleScrollView.contentInset = UIEdgeInsetsMake(0, frame.size.width / 2 - 1,
                                                         0, frame.size.width / 2 - 1);
        [self _setIndexAnimated:animated];
    }
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
        CGSize size = [title sizeWithFont:_font
                        constrainedToSize:CGSizeMake(MAXFLOAT, _headerHeight)];
        
        //make the button.
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(fv + _spacing, 0, size.width, 25)];
//        label.textAlignment = UITextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//        label.font = _font;
//        label.tag = TempCount(n);
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAtButton:)];
//        [label addGestureRecognizer:tap];
//        label.text = title;
//        label.textColor = [UIColor whiteColor];
//        [_titleScrollView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title
                forState:UIControlStateNormal];
        button.titleLabel.font = _font;
        [_titleScrollView addSubview:button];
        button.tag = TempCount(n);
        [button addTarget:self
                   action:@selector(clickAtButton:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:_headerTextColor
                     forState:UIControlStateNormal];
        [button setTitleColor:[_headerTextColor colorWithAlphaComponent:0.8]
                     forState:UIControlStateHighlighted];
        
        // set for next
        if (n == 0) {
            [_indexes addObject:[NSNumber numberWithFloat:0.0f]];
        }else {
            fv += size.width / 2 + _spacing + upper / 2;
            [_indexes addObject:[NSNumber numberWithFloat:fv]];
        }
        button.frame = CGRectMake(fv - size.width / 2 , 0, size.width, _headerHeight);
        upper = size.width;
    }
    
    _titleScrollView.contentSize = CGSizeMake(fv , 0);
}
         
- (void)clickAtButton:(UIButton*)sender
{
    [self setIndex:ShowCount(sender.tag)
          animated:YES];
}

- (void)setIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_index == index) {
        [self _setIndexAnimated:animated];
        return;
    }
    if (animated) {
        if (index == _index - 1) {
            [self prevPage];
        }else if (index == _index + 1) {
            [self nextPage];
        }else {
            //多图片动画
            [self moveToIndex:index];
        }
    }else {
        _index = index;
        [self _showAtPage];
    }
    [self _setIndexAnimated:animated];
}

- (void)moveToIndex:(NSInteger)index
{
    if (index == _index) {
        return;
    }else if (index > _index) {
        self.userInteractionEnabled = NO;
        NSMutableArray *array = [NSMutableArray array];
        CGRect rect = _contentView.bounds;
        for (int n = index; n > _index; n--) {
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){rect.size.width * (index - _index), 0, rect.size}];
            [label setUp];
            label.text = [_titles objectAtIndex:n];
            [array addObject:label];
            [_contentView addSubview:label];
        }
        [UIView animateWithDuration:0.5
                         animations:^
         {
             int count = [array count];
             for (int n = 0; n < count; n ++) {
                 UIView *view = [array objectAtIndex:n];
                 view.frame = (CGRect){-rect.size.width*n, 0, rect.size};
             }
             _nowView.frame = (CGRect){(CGFloat)(-rect.size.width*count),0,rect.size};
         } completion:^(BOOL finished) 
         {
             for (UIView *view in array) {
                 [view removeFromSuperview];
             }
             self.userInteractionEnabled = YES;
             [self _showAtPage];
         }];
        _index = index;
    }else {
        self.userInteractionEnabled = NO;
        NSMutableArray *array = [NSMutableArray array];
        CGRect rect = _contentView.bounds;
        for (int n = index; n < _index; n++) {
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){rect.size.width * (index - _index), 0, rect.size}];
            [label setUp];
            label.text = [_titles objectAtIndex:n];
            [array addObject:label];
            [_contentView addSubview:label];
        }
        [UIView animateWithDuration:0.5
                         animations:^
         {
             int count = [array count];
             for (int n = 0; n < count; n ++) {
                 UIView *view = [array objectAtIndex:n];
                 view.frame = (CGRect){rect.size.width*n, 0, rect.size};
             }
             _nowView.frame = (CGRect){(CGFloat)(rect.size.width*count),0,rect.size};
         } completion:^(BOOL finished) 
         {
             for (UIView *view in array) {
                 [view removeFromSuperview];
             }
             self.userInteractionEnabled = YES;
             [self _showAtPage];
         }];
        _index = index;
    }
}

- (void)_setIndexAnimated:(BOOL)animated
{
    CGFloat left = [[_indexes objectAtIndex:_index] floatValue];
    [self _setTitleScrollViewLeft:left :animated];
}

- (void)_setTitleScrollViewLeft:(CGFloat)f :(BOOL)animated
{
    [_titleScrollView setContentOffset:CGPointMake(f - _contentView.bounds.size.width/2, 0) animated:animated];
}

- (void)_showAtPage
{
    CATransition *animation = [CATransition animation];
    [_contentView.layer addAnimation:animation
                              forKey:@""];
    [_leftView removeFromSuperview];
    _leftView = nil;
    [_rightView removeFromSuperview];
    _rightView = nil;
    [_nowView removeFromSuperview];
    
    CGRect rect = _contentView.bounds;
    _nowView = [_delegate contentView:self contentAtIndex:_index];
    if ([_delegate respondsToSelector:@selector(contentView:willRollToIndex:)]) {
        [_delegate contentView:self willRollToIndex:_index];
    }
    _nowView.frame = (CGRect){0,0,rect.size};
    [_contentView addSubview:_nowView];
}

- (void)_checkBeside
{
    CGRect rect = _contentView.bounds;
    if (_index > 0) {
        _leftView = [_delegate contentView:self leftViewAt:_index - 1];
        if (!_leftView) _leftView = _whiteView1;
        _leftView.frame = (CGRect){-rect.size.width,0,rect.size};
        [_contentView addSubview:_leftView];
    }else _leftView = nil;
    if (_index < [_titles count] - 1) {
        _rightView = [_delegate contentView:self rightViewAt:_index + 1];
        if (!_rightView) _rightView = _whiteView2;
        _rightView.frame = (CGRect){rect.size.width,0,rect.size};
        [_contentView addSubview:_rightView];
    }else _rightView = nil;
}

- (void)_checkAndSet
{
    CGFloat left = _titleScrollView.contentOffset.x + self.bounds.size.width / 2;
    for (int n = 0, t = _indexes.count; n < t;n++) {
        NSNumber *num = [_indexes objectAtIndex:n];
        CGFloat f = [num floatValue];
        if (f>left) {
            if (n > 0) {
                CGFloat f2 = [[_indexes objectAtIndex:n - 1] floatValue];
                if (f - left > left - f2) {
                    [self setIndex:n - 1 animated:YES];
                }else {
                    [self setIndex:n animated:YES];
                }
            }else {
                [self setIndex:0 animated:YES];
            }
            break;
        }
        if (n == t - 1) {
            [self setIndex:t - 1 animated:YES];
        }
    }
}

#pragma mark - action

- (void)prevPage
{
    CGRect rect = _contentView.bounds;
    if (_index > 0) {
        _index --;
        [UIView animateWithDuration:0.3
                         animations:^
         {
             _leftView.frame = (CGRect){0,0,rect.size};
             _nowView.frame = (CGRect){rect.size.width,0,rect.size};
             _rightView.frame = (CGRect){2*rect.size.width,0,rect.size};
         } completion:^(BOOL finished) 
         {
             [self _showAtPage];
             [self _checkBeside];
         }];
    }else {
        [self turnBack];
    }
}

- (void)nextPage
{
    if (_index < [_titles count] - 1) {
        CGRect rect = _contentView.bounds;
        _index ++;
        [UIView animateWithDuration:0.3
                         animations:^
         {
             _leftView.frame = (CGRect){-2*rect.size.width,0,rect.size};
             _nowView.frame = (CGRect){-rect.size.width,0,rect.size};
             _rightView.frame = (CGRect){0,0,rect.size};
         } completion:^(BOOL finished) 
         {
             [self _showAtPage];
             [self _checkBeside];
         }];
    }else {
        [self turnBack];
    }
}

- (void)turnBack
{
    CGRect rect = _contentView.bounds;
    [UIView animateWithDuration:0.3
                     animations:^
     {
         _leftView.frame = (CGRect){-rect.size.width,0,rect.size};
         _nowView.frame = (CGRect){0,0,rect.size};
         _rightView.frame = (CGRect){rect.size.width,0,rect.size};
     } completion:^(BOOL finished) 
     {
         [self _showAtPage];
     }];
}

- (void)_setOLeft:(CGFloat)f
{
    CGRect rect = _contentView.bounds;
    _leftView.frame = (CGRect){f-rect.size.width,0,rect.size};
    _nowView.frame = (CGRect){f,0,rect.size};
    _rightView.frame = (CGRect){f+rect.size.width,0,rect.size};
}

#pragma mark - recongnizer

- (void)panedOn:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:_contentView];
    int state = sender.state;
    if ((_index > 0 || p.x < 0) && (_index < [_indexes count] - 1 || p.x > 0)) {
        CGFloat percent = p.x / _contentView.bounds.size.width;
        CGFloat f1,f2;
        if (percent < 0) {
            f1 = [[_indexes objectAtIndex:_index] floatValue];
            f2 = [[_indexes objectAtIndex:_index + 1] floatValue];
        }else {
            f1 = [[_indexes objectAtIndex:_index] floatValue];
            f2 = [[_indexes objectAtIndex:_index - 1] floatValue];
        }
        percent = percent<0?-percent:percent;
        [self _setTitleScrollViewLeft:f2*percent + f1*(1-percent) :NO];
        [self _setOLeft:p.x];
    }else {
        [self _setIndexAnimated:NO];
        [self _setOLeft:p.x / 2];
    }
    
    
    if (state == UIGestureRecognizerStateBegan) {
        [self _checkBeside];
        _startTime = [[sender valueForKey:@"_lastTouchTime"] floatValue];
    }else if (state == UIGestureRecognizerStateCancelled ||
              state == UIGestureRecognizerStateFailed ||
              state == UIGestureRecognizerStateEnded) {
        NSTimeInterval interval = [[sender valueForKey:@"_lastTouchTime"] floatValue] - _startTime;
        if ((interval < 0.2f && p.x > 0.0f) || p.x > 40.0f) {
            [self prevPage];
        }else if ((interval < 0.2f && p.x < 0.0f) || p.x < -40.0f) {
            [self nextPage];
        }else {
            [self turnBack];
        }
        [self _setIndexAnimated:YES];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self _checkAndSet];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _checkAndSet];
}

@end
