/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

#import "CGView.h"

@implementation CGView

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  NSLog(@"Drawing on a device with a scale of %f", [[UIScreen mainScreen] scale]);
  if (context != nil) {
    CGRect rect = CGRectInset(self.bounds, 50, 50);

    [self drawBackgroundGridIn:context];
    [self drawBackgroundRectangle:rect in:context];
    [self strokeRectangle:rect in:context];
  }
}

// Draws a gingham cloth style grey-white grid with 1 point spacing
- (void)drawBackgroundGridIn:(CGContextRef)context {
  CGContextSaveGState(context);
  
  CGColorRef greyColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.5].CGColor;
  CGFloat minX = CGRectGetMinX(self.bounds);
  CGFloat maxX = CGRectGetMaxX(self.bounds);
  CGFloat minY = CGRectGetMinY(self.bounds);
  CGFloat maxY = CGRectGetMaxY(self.bounds);
  CGFloat height = CGRectGetHeight(self.bounds);
  CGFloat width = CGRectGetWidth(self.bounds);
  
  CGContextSetFillColorWithColor(context, greyColor);
  
  for (CGFloat i = minX; i < maxX; i=i+2) {
    CGRect verticalRect = CGRectMake(i, minY, 1, height);
    CGContextFillRect(context, verticalRect);
  }
  
  for (CGFloat i = minY; i < maxY; i=i+2) {
    CGRect horizontalRect = CGRectMake(minX, i, width, 1);
    CGContextFillRect(context, horizontalRect);
  }
  
  CGContextRestoreGState(context);
}

- (void)drawBackgroundRectangle:(CGRect)rect in:(CGContextRef)context {
  CGContextSaveGState(context);
  
  CGColorRef yellowColor = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.6].CGColor;
  
  CGContextSetFillColorWithColor(context, yellowColor);
  CGContextFillRect(context, rect);
  
  CGContextRestoreGState(context);
}

- (void)strokeRectangle:(CGRect)rect in:(CGContextRef)context {
  CGContextSaveGState(context);
  
  CGColorRef redColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.6].CGColor;
  
  // Change the stroke rect to align the stroke on the pixel boundary by insetting half a point
  // CGRect strokeRect = CGRectInset(rect, 0.5, 0.5);
  CGRect strokeRect = rect;
  
  CGContextSetStrokeColorWithColor(context, redColor);
  CGContextSetLineWidth(context, 1.0);
  CGContextStrokeRect(context, strokeRect);
  
  CGContextRestoreGState(context);
}

@end
