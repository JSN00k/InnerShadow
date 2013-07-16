//
//  JHSInnerShadowView.h
//  InnerShadow
//
//  Created by James Snook on 13/07/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSInnerShadowView : UIView

- (void)setOutsideShadowSize:(CGSize)outerShadowSize;
- (CGSize)outsideShadowSize;

- (void)setOutsideShadowCol:(CGColorRef)col;
- (CGColorRef)outsideShadowCol;

- (void)setOutsideShadowRadius:(CGFloat)outerShadowRadius;
- (CGFloat)outsideShadowRadius;

- (void)setInsideShadowSize:(CGSize)insideShadSize;
- (CGSize)insideShadowSize;

- (void)setInsideShadowColor:(CGColorRef)col;
-  (CGColorRef)insideShadowCol;

- (void)setInsideShadowRadius:(CGFloat)radius;
- (CGFloat)insideShadowRadius;

- (void)setCornerRadius:(CGFloat)cr;
- (CGFloat)cornerRadius;

@end
