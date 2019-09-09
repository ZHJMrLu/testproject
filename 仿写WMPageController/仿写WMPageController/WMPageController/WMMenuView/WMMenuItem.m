//
//  WMMenuItem.m
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMMenuItem.h"
@interface WMMenuItem()
/** <#name#> */
@property(nonatomic,weak)UILabel * label;
/** <#name#> */
@property(nonatomic,weak)UIImageView * imageView;


@end
@implementation WMMenuItem {
    CGFloat _selectedRed, _selectedGreen, _selectedBlue, _selectedAlpha;
    CGFloat _normalRed, _normalGreen, _normalBlue, _normalAlpha;
    int     _sign;
    CGFloat _gap;
    CGFloat _step;
    __weak CADisplayLink *_link;
}

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.normalColor   = [UIColor blackColor];
        self.selectedColor = [UIColor blackColor];
        self.normalSize    = 15;
        self.selectedSize  = 18;
//        self.numberOfLines = 0;
        UILabel * label = [[UILabel alloc]init];
        [self addSubview:label];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        self.label = label;
        
        UIImageView * imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.hidden = YES;
        self.imageView = imageView;
        [self setupGestureRecognizer];
    }
    return self;
}

- (CGFloat)speedFactor {
    if (_speedFactor <= 0) {
        _speedFactor = 15.0;
    }
    return _speedFactor;
}

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInside:)];
    [self addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    _selected = selected;
    self.imageView.hidden = !_selected;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if (!animation) {
        self.rate = selected ? 1.0 : 0.0;
        return;
    }
    _sign = (selected == YES) ? 1 : -1;
    _gap  = (selected == YES) ? (1.0 - self.rate) : (self.rate - 0.0);
    _step = _gap / self.speedFactor;
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rateChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)rateChange {
    if (_gap > 0.000001) {
        _gap -= _step;
        if (_gap < 0.0) {
            self.rate = (int)(self.rate + _sign * _step + 0.5);
            return;
        }
        self.rate += _sign * _step;
    } else {
        self.rate = (int)(self.rate + 0.5);
        [_link invalidate];
        _link = nil;
    }
}

// 设置rate,并刷新标题状态
- (void)setRate:(CGFloat)rate {
    if (rate < 0.0 || rate > 1.0) { return; }
    _rate = rate;
    CGFloat r = _normalRed + (_selectedRed - _normalRed) * rate;
    CGFloat g = _normalGreen + (_selectedGreen - _normalGreen) * rate;
    CGFloat b = _normalBlue + (_selectedBlue - _normalBlue) * rate;
    CGFloat a = _normalAlpha + (_selectedAlpha - _normalAlpha) * rate;
    self.label.textColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGFloat minScale = self.normalSize / self.selectedSize;
    CGFloat trueScale = minScale + (1 - minScale)*rate;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_selectedRed green:&_selectedGreen blue:&_selectedBlue alpha:&_selectedAlpha];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [normalColor getRed:&_normalRed green:&_normalGreen blue:&_normalBlue alpha:&_normalAlpha];
}

- (void)touchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressedMenuItem:)]) {
        [self.delegate didPressedMenuItem:self];
    }
}
-(void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
}
-(void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
    self.label.attributedText = attributedText;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = font;
}
-(void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_image) {
        if (self.imageView.isHidden) {
            self.label.frame = self.bounds;
        }else{
            NSDictionary *attrs = @{NSFontAttributeName: self.font};
            CGFloat labelWidth = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size.width;
            labelWidth = ceilf(labelWidth);
            
            CGFloat imageX = (self.frame.size.width - _image.size.width - labelWidth - 3) * 0.5;
            CGFloat imageY = (self.frame.size.height - _image.size.height) * 0.5;
            CGRect imageFrame = CGRectMake(imageX, imageY, _image.size.width, _image.size.height);
            self.imageView.frame = imageFrame;
            
            CGRect labelFrame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 3, 0, labelWidth, self.frame.size.height);
            self.label.frame = labelFrame;
        }
        return;
    }
    self.label.frame = self.bounds;
    /** */
}
@end
