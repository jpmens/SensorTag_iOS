/**
 *  @author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  @brief          Top level Service class for SensorTag2-Example iOS application
 *  @copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  @file           bleGenericService.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "bluetoothHandler.h"
#import "oneValueCell.h"

typedef struct Point3D_ {
    CGFloat x,y,z;
} Point3D;


///@brief The bleGenericService class is the top level class for a bluetooth service in SensorTag2-example application.
/// It contains the basic functionality for enabling and disabling SensorTag services.\n\n
/// All the SensorTag 2 service abide to the following logic when it comes to characteristics:
/// - \b Config \b characteristic
///   - Turns the related sensor on/off and configures modes
/// - \b Period \b characteristic
///   - Sets the period in which the sensor value is refreshed and notified to host
/// - \b Data \b characteristic
///   - All data from sensor is transferred through the data characteristic
///
/// Configuration of a sensor is normally done in this way :
/// -# Write 0x01 (ON) to config characteristic
/// -# Write period 0x64 (100 * 10ms = 1000ms) register with desired period (1s for most sensors)
/// -# Enable notifications on data characteristic
///
/// Deconfiguration of a sensor is normally done in this way :
/// -# Enable notifications on data characteristic
/// -# Write 0x01 (ON) to config characteristic
///
/// \b MQTT \b support
/// All the services have a getCloudData function, this function retrieves an array with
/// dictionaries containing "name" and "value" pairs for the current data of the service.
/// The names used here are sourced from the masterMQTTResourceList.h file.
/// This value is then sourced to the IBM IoT quickstart cloud function once a second.
/// 


@interface bleGenericService : NSObject

///The service
@property CBService *service;
///The configuration characteristic for this service
@property CBCharacteristic *config;
///The data characteristic for this service
@property CBCharacteristic *data;
///The period characteristic for this service
@property CBCharacteristic *period;
///The shared instance bluetooth handler
@property bluetoothHandler *btHandle;
///The display tile containing the GUI for this service
@property displayTile *tile;

///Check if the service is correct for this class
+(BOOL) isCorrectService:(CBService *)service;


///Initialize with a fully scanned CBService
-(instancetype) initWithService:(CBService *)service;

///Return display tile for this service to GUI
-(displayTile *) getViewForPresentation;

///Returns array with dictionaries containing current cloud data
-(NSArray *) getCloudData;

///Called by main program when a data update is received from BLE
-(BOOL) dataUpdate:(CBCharacteristic *)c;

///Called when service is discovered to configure the characteristic
-(BOOL) configureService;

///Called when service is to deconfigure the characteristic
-(BOOL) deconfigureService;
///Called when a value was written to the device
-(void) wroteValue:(CBCharacteristic *)c error:(NSError *)error;

@end
