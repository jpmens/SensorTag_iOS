/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Basic graphics element SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           displayTile.m
 */

/*
 * Copyright (c) 2015 Texas Instruments Incorporated
 *
 * All rights reserved not granted herein.
 * Limited License.
 *
 * Texas Instruments Incorporated grants a world-wide, royalty-free,
 * non-exclusive license under copyrights and patents it now or hereafter
 * owns or controls to make, have made, use, import, offer to sell and sell ("Utilize")
 * this software subject to the terms herein.  With respect to the foregoing patent
 *license, such license is granted  solely to the extent that any such patent is necessary
 * to Utilize the software alone.  The patent license shall not apply to any combinations which
 * include this software, other than combinations with devices manufactured by or for TI (“TI Devices”).
 * No hardware patent is licensed hereunder.
 *
 * Redistributions must preserve existing copyright notices and reproduce this license (including the
 * above copyright notice and the disclaimer and (if applicable) source code license limitations below)
 * in the documentation and/or other materials provided with the distribution
 *
 * Redistribution and use in binary form, without modification, are permitted provided that the following
 * conditions are met:
 *
 *   * No reverse engineering, decompilation, or disassembly of this software is permitted with respect to any
 *     software provided in binary form.
 *   * any redistribution and use are licensed by TI for use only with TI Devices.
 *   * Nothing shall obligate TI to provide you with source code for the software licensed and provided to you in object code.
 *
 * If software source code is provided to you, modification and redistribution of the source code are permitted
 * provided that the following conditions are met:
 *
 *   * any redistribution and use of the source code, including any resulting derivative works, are licensed by
 *     TI for use only with TI Devices.
 *   * any redistribution and use of any object code compiled from the source code and any resulting derivative
 *     works, are licensed by TI for use only with TI Devices.
 *
 * Neither the name of Texas Instruments Incorporated nor the names of its suppliers may be used to endorse or
 * promote products derived from this software without specific prior written permission.
 *
 * DISCLAIMER.
 *
 * THIS SOFTWARE IS PROVIDED BY TI AND TI’S LICENSORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL TI AND TI’S LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "displayTile.h"

@implementation autoSizeLabel

-(void) setText:(NSString *)text {
    self.font = [UIFont fontWithName:@"Menlo" size:[autoSizeLabel getSizeOfFontFromFrame:self.frame andString:text]];
    [super setText:text];
}

+(CGFloat) getSizeOfFontFromFrame:(CGRect) frame andString:(NSString *) string {
    CGFloat maxFontSize = 40;
    UILabel *fakeLabel = [[UILabel alloc] init];
    fakeLabel.text = string;
    //Width
    while ([fakeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:maxFontSize]}].width > frame.size.width)
    {
        maxFontSize -= 5;
    }
    //Height
    while ([fakeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:maxFontSize]}].height > frame.size.height)
    {
        maxFontSize -= 5;
    }
    return maxFontSize;
}

@end


@implementation displayTile

-(instancetype) initWithOrigin:(CGPoint) origin andSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.origin = origin;
        self.size = size;
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.title = [[autoSizeLabel alloc] init];
        self.title.text = @"Title";
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        [self setFrame:CGRectMake(0, 0, 0, 0)];
    }
    return self;
}

-(void) setFrame:(CGRect)frame {
    self.tileSize = (frame.size.width) / 8;
    if ((self.tileSize * 13) > frame.size.height) self.tileSize = (frame.size.height - 40) / 13;
    self.tileXOffset = (frame.size.width - (self.tileSize * 8)) / 2;
    NSLog(@"TileSize :%0.1f",self.tileSize);
    [super setFrame:CGRectMake((self.origin.x * self.tileSize + 3.0f) + self.tileXOffset, self.origin.y * self.tileSize + 3.0f, self.size.width * self.tileSize - 6.0f, self.size.height * self.tileSize - 6.0f)];
    self.title.frame = CGRectMake(8, 2, (self.size.width * self.tileSize) - 6.0 - 8, 30 - 4);
}

-(void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat titleHeight = 30.0f / (self.size.height * self.tileSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0,titleHeight,titleHeight, 1.0 };
    
    NSArray *colors = @[(__bridge id) [UIColor blackColor].CGColor, (__bridge id) [UIColor blackColor].CGColor, (__bridge id) [UIColor grayColor].CGColor , (__bridge id) [UIColor grayColor].CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
