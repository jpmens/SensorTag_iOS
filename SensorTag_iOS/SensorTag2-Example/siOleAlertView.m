/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Custom View for diplay alerts for SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           siOleAlertView.m
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

#import "siOleAlertView.h"

@implementation siOleAlertView

-(instancetype) initInView:(UIView *)view {
    self = [super init];
    if (self) {
        self.alpha = 0.0f;
        self.layer.cornerRadius = 15.0f;
        self.clipsToBounds = YES;
        self.message = [[autoSizeLabel alloc]init];
        self.message.textColor = [UIColor whiteColor];
        self.message.textAlignment = NSTextAlignmentCenter;
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffect *vibranceEffect;
        vibranceEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.efView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        UIVisualEffectView *vib = [[UIVisualEffectView alloc] initWithEffect:vibranceEffect];
        [self.efView addSubview:vib];
        self.efView.frame = view.frame;
        [self addSubview:self.efView];
        [self addSubview:self.message];
        [view addSubview:self];
        [self setFrame:view.frame];
    }
    return self;
}



-(void) setFrame:(CGRect)frame {
#define STD_SIZE_X 300
#define STD_SIZE_Y 200
    [super setFrame:CGRectMake((frame.size.width - STD_SIZE_X) / 2, (frame.size.height - STD_SIZE_Y) / 2, STD_SIZE_X, STD_SIZE_Y)];
    self.efView.frame = self.bounds;
    self.message.frame = CGRectMake(20, 20, self.bounds.size.width - 40, self.bounds.size.height - 40);
    self.message.text = self.message.text;
}


-(void) blinkMessage:(NSString *) message {
    self.message.text = message;
    
    [UIView animateWithDuration:0.4f delay:0.0f options: UIViewAnimationOptionCurveEaseInOut animations:^{
    self.alpha = 1.0f;
    }completion:nil];
    
    [UIView animateWithDuration:0.6f delay:0.4f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationCurveEaseInOut animations:^{
        self.message.alpha = 0.0f;
    }completion:^(BOOL finished){
        
    }];
    
}

-(void) dismissMessage {
    [UIView animateWithDuration:0.1f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
