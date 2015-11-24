/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Main ViewController for SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           ViewController.h
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

#import <UIKit/UIKit.h>
#import "DeviceSelectTableViewController.h"
#import "bleGenericService.h"
#import "siOleAlertView.h"
#import "MQTTIBMQuickStart.h"

///@brief The ViewController class is the main class for the GUI, it also handles bluetooth services scan check and also
///delivery of data to the services it has under it.
@interface ViewController : UIViewController < bluetoothHandlerDelegate,deviceSelectTableViewControllerDelegate>

@property DeviceSelectTableViewController *deviceSelector;

@property NSMutableArray *services;
@property NSMutableArray *displayTiles;
@property bluetoothHandler *handler;
@property CAGradientLayer *gradient;
@property siOleAlertView *aV;

@property MQTTIBMQuickStart *cloudHandle;
@property NSString *MQTTStringLive;
@property NSString *MQTTStringTX;
@property NSTimer *MQTTTimer;
@property UIActivityViewController *aVC;
@property (weak, nonatomic) IBOutlet UIButton *cloudLinkButton;

- (IBAction)selectDeviceButtonTouched:(id)sender;
- (IBAction)cloudLinkButtonTouched:(id)sender;
@end


///@mainpage SensorTag2-Example
///A simplified application example for an iOS application that handles sensor input from a
/// \b Texas \b Instruments \b Inc. \n SensorTag2.0 Bluetooth Smart device.
/// It lets the developer have a simple project to start out from when developing applications for the
/// SensorTag 2.0\n\n
/// \b Screenshots :\n
///   \htmlonly <a href="../Main_Screen_empty.PNG"><img src="../Main_Screen_empty.PNG" width=300px></img></a> <a href="../Device_Selector.PNG"><img src="../Device_Selector.PNG" width=300px></img></img></a> <a href="../Main_Screen_Full.PNG"><img src="../Main_Screen_Full.PNG" width=300px></img></a> <a href="../Cloud_Link_Sharing.PNG"><img src="../Cloud_Link_Sharing.PNG" width=300px></img></a> <a href="../Cloud_Sourcing.PNG"><img src="../Cloud_Sourcing.PNG" width=300px></img></a><br> \endhtmlonly
///@author Ole Andreas Torvmark (o.a.torvmark@ti.com, torvmark@stalliance.no)





