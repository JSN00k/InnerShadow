//
//  JHSInnerShadowView.m
//  InnerShadow
//
//  Created by James Snook on 13/07/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JHSInnerShadowView.h"

@implementation JHSInnerShadowView
{
  NSValue *outsideShadowSizeVal;
  NSNumber *outsideShadowRadius;
  CGColorRef outsideShadowColor;
  
  NSValue *insideShadowSizeVal;
  NSNumber *insideShadowRadius;
  CGColorRef insideShadowColor;
  
  NSNumber *cornerRadiusVal;
}

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame]))
    [self setBackgroundColor:[UIColor clearColor]];
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super initWithCoder:aDecoder]))
    [self setBackgroundColor:[UIColor clearColor]];
  
  
  return self;
}

- (void)dealloc
{
  if (outsideShadowColor)
    CFRelease (outsideShadowColor);
  
  if (insideShadowColor)
    CFRelease (insideShadowColor);
}

- (CGSize)outsideShadowSize
{
  if (outsideShadowSizeVal) {
    CGSize result;
    [outsideShadowSizeVal getValue:&result];
    return result;
  }
  
  /* The default outside shadow value. */
  return CGSizeMake (0.0, 1.0);
}

- (void)setOutsideShadowSize:(CGSize)outerShadowSize
{
  outsideShadowSizeVal = [NSValue valueWithCGSize:outerShadowSize];
}

- (CGFloat)outsideShadowRadius
{
  if (outsideShadowRadius)
    return [outsideShadowRadius floatValue];
  
  return 1.0;
}

- (void)setOutsideShadowRadius:(CGFloat)osr;
{
  outsideShadowRadius = [NSNumber numberWithFloat:osr];
}

- (void)setOutsideShadowCol:(CGColorRef)col
{
  if (col == outsideShadowColor)
    return;
  
  if (outsideShadowColor) {
    CFRelease (outsideShadowColor);
    outsideShadowColor = nil;
  }
  
  if (col)
    outsideShadowColor = (CGColorRef)CFRetain (col);
}

- (CGColorRef)outsideShadowCol
{
  if (outsideShadowColor)
    return outsideShadowColor;
  
  CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray ();
  CGFloat blackCol[] = { 1.0, 0.8 };
  CGColorRef result = CGColorCreate (graySpace, blackCol);
  outsideShadowColor = result;
  CFRelease (graySpace);
  
  return outsideShadowColor;
}

- (void)setInsideShadowSize:(CGSize)insideShadSize
{
  insideShadowSizeVal = [NSValue valueWithCGSize:insideShadSize];
}

- (CGSize)insideShadowSize
{
  if (insideShadowSizeVal) {
    CGSize result;
    [insideShadowSizeVal getValue:&result];
    return result;
  }
  
  return CGSizeMake (0.0, 2.0);
}

- (void)setInsideShadowRadius:(CGFloat)radius
{
  insideShadowRadius = [NSNumber numberWithFloat:radius];
}

- (CGFloat)insideShadowRadius
{
  if (insideShadowRadius)
    return [insideShadowRadius floatValue];
  
  return 3.0;
}

- (CGColorRef)insideShadowCol
{
  if (!insideShadowColor) {
    CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray ();
    CGFloat shadowVals[] = { 0.0, 0.85 };
    insideShadowColor = CGColorCreate (graySpace, shadowVals);
    CFRelease (graySpace);
  }
  
  return insideShadowColor;
}

- (void)setInsideShadowColor:(CGColorRef)col
{
  if (col == insideShadowColor)
    return;
  
  if (insideShadowColor) {
    CFRelease (insideShadowColor);
    insideShadowColor = nil;
  }
  
  if (col)
    insideShadowColor = (CGColorRef)CFRetain (col);
}

- (CGFloat)cornerRadius
{
  if (cornerRadiusVal)
    return [cornerRadiusVal floatValue];
  
  return 5.0;
}

- (void)setCornerRadius:(CGFloat)cr
{
  cornerRadiusVal = [NSNumber numberWithFloat:cr];
}

- (void)drawRect:(CGRect)rect
{
  CGFloat cornerRadius = [self cornerRadius];
  CGFloat xMax = CGRectGetMaxX (rect);
  CGFloat yMax = CGRectGetMaxY (rect);
  CGFloat xMin = CGRectGetMinX (rect);
  CGFloat yMin = CGRectGetMinY (rect);
  CGContextRef ctx = UIGraphicsGetCurrentContext ();
  CGContextSaveGState (ctx);
  CGColorRef outsideShadowCol = [self outsideShadowCol];
  
  CGSize outerShadowSize = [self outsideShadowSize];
  float indent = outerShadowSize.height < outerShadowSize.width
    ? outerShadowSize.width : outerShadowSize.height;
  CGFloat outRadius = [self outsideShadowRadius];
  indent += outRadius;
  CGMutablePathRef shape = CGPathCreateMutable ();
  
  CGFloat leftEdge = xMin + indent;
  CGFloat rightEdge = xMax - indent;
  CGFloat topEdge = yMin + indent;
  CGFloat bottomEdge = yMax - indent;
  
  /* Draw the path for the rounded rect (or whatvever shape you like to be
   indented or embossed.) */
  CGPathMoveToPoint (shape, NULL, rightEdge - cornerRadius, topEdge);
  /* ArcToPoint probably requires a blog post of it's own with some pretty
   diagrams. */
  
  CGPathAddArcToPoint(shape, NULL,
                      leftEdge, topEdge,
                      leftEdge, topEdge + cornerRadius,
                      cornerRadius);
  CGPathAddArcToPoint (shape, NULL,
                       leftEdge, bottomEdge,
                       leftEdge + cornerRadius, bottomEdge,
                       cornerRadius);
  CGPathAddArcToPoint (shape, NULL,
                       rightEdge, bottomEdge,
                       rightEdge, bottomEdge - indent,
                       cornerRadius);
  CGPathAddArcToPoint (shape, NULL,
                       rightEdge, topEdge,
                       rightEdge - cornerRadius, topEdge,
                       cornerRadius);
  CGPathCloseSubpath (shape);
  
  CGContextSetShadowWithColor(ctx, outerShadowSize, outRadius,
                              outsideShadowCol);
  CGContextSetFillColorWithColor (ctx, outsideShadowCol);
  CGContextAddPath (ctx, shape);
  CGContextFillPath (ctx);

  /* To draw the inside shadow we are going to clip so we can only draw in the
     area inside the shape. Then we will draw around the outside of the shape
     with a shadow set. Only the shadow that is on the inside of the shape will
     appear. */
  CGContextAddPath (ctx, shape);
  CGContextClip (ctx);
  
  /* Really we should make a method to draw the content of the rounded rect at
     this point. It could work like the CALayer draw: method and try messaging
     a delegate as well. */
#if 1
  CGDataProviderRef pngData
    = CGDataProviderCreateWithFilename ([[[NSBundle mainBundle] pathForResource:@"harvey"
                                                                         ofType:@"png"]
                                         fileSystemRepresentation]);
  CGImageRef image = CGImageCreateWithPNGDataProvider(pngData,
                                                      NULL,
                                                      YES,
                                                      kCGRenderingIntentDefault);
   
  
  /* Carefully looking at the buttons on the keyboard reveals that they have
   a gradient from the top of the button to the bottom. */

  
  /* Draw the image the right way up. */
  CGContextSaveGState(ctx);
  CGContextConcatCTM (ctx, CGAffineTransformMake (1.0, 0.0, 0.0, -1.0,
                                                  0.0, rect.size.height));
  CGContextDrawImage (ctx, rect, image);
  CGContextRestoreGState (ctx);
  
  CFRelease (image);
  CFRelease (pngData);
#else
  
  CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB ();
  CGFloat gradVals[] = { 130.0 / 255.0, 140.0 / 255.0, 150.0 / 255.0, 1.0, 90.0 / 255.0, 100 / 255.0, 110.0 / 255.0, 1.0 };
  CGGradientRef grad = CGGradientCreateWithColorComponents (rgbSpace,
                                                            gradVals,
                                                            NULL,
                                                            2);
  
  CGContextDrawLinearGradient (ctx,
                               grad,
                               CGPointMake (0, topEdge),
                               CGPointMake (0, bottomEdge),
                               0);
  CFRelease (rgbSpace);
  CFRelease (grad);
#endif
  
  /* Now lets do the inside shadow! Draw a path just around the outside of the 
     area that we have just clipped. The shadow from the path will go into the
     clipped area, but the path won't so we only get the shadow. */

  CGFloat pathWidth = [self insideShadowRadius];
  CGSize shadowSize = [self insideShadowSize];
  CGFloat shadowWidthAbs = fabs (shadowSize.width);
  CGFloat shadowHeightAbs = fabs (shadowSize.height);
  pathWidth += shadowHeightAbs > shadowWidthAbs ? shadowHeightAbs : shadowWidthAbs;
  
  CGFloat halfPathWidth = 0.5 * pathWidth;
  CGContextSetLineWidth (ctx, pathWidth);
  cornerRadius += halfPathWidth;
  topEdge = yMin + indent - halfPathWidth;
  bottomEdge = yMax - indent + halfPathWidth;
  leftEdge = xMin + indent - halfPathWidth;
  rightEdge = xMax - indent + halfPathWidth;

  CGContextMoveToPoint (ctx, xMax - indent - cornerRadius,
                        topEdge);
  CGContextAddArcToPoint (ctx, leftEdge,
                          topEdge,
                          leftEdge,
                          topEdge + cornerRadius,
                          cornerRadius);
  CGContextAddArcToPoint (ctx, leftEdge,
                          bottomEdge,
                          leftEdge + cornerRadius,
                          bottomEdge,
                          cornerRadius);
  CGContextAddArcToPoint (ctx, rightEdge, bottomEdge, rightEdge,
                          bottomEdge - cornerRadius,
                          cornerRadius);
  CGContextAddArcToPoint (ctx, rightEdge, topEdge,
                          rightEdge - cornerRadius,
                          topEdge,
                          cornerRadius);
  CGContextClosePath (ctx);
  
  CGColorRef insideShadowCol = [self insideShadowCol];
  CGContextSetStrokeColorWithColor (ctx, insideShadowCol);
  CGContextSetShadowWithColor (ctx, shadowSize,
                               [self insideShadowRadius], insideShadowCol);
  CGContextStrokePath (ctx);
}

@end
