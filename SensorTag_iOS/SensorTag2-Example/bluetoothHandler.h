/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Simple Bluetooth Handler SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           bluetoothHandler.h
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

///@brief The bluetoothHandlerDelegate is a protocol for communicating bluetooth events to the main viewcontroller

@protocol bluetoothHandlerDelegate <NSObject>
///Device has become ready, or not ready (connected and scanned / disconnected)
-(void) deviceReady:(BOOL)ready peripheral:(CBPeripheral *)peripheral;
///Characteristic was read
-(void) didReadCharacteristic:(CBCharacteristic *)characteristic;
///Received notification on characteristic
-(void) didGetNotificaitonOnCharacteristic:(CBCharacteristic *)characteristic;
///Wrote characteristic
-(void) didWriteCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end

///@brief Main CoreBluetooth interface of application

@interface bluetoothHandler : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

///CoreBluetooth Main handle
@property CBCentralManager *m;
///CoreBluetooth Peripheral in use
@property CBPeripheral *p;
///List containing all devices detected
@property NSMutableArray *deviceList;
///Should device reconnect if connection drops
@property BOOL shouldReconnect;
///UUID of the device to keep connection to
@property (nonatomic) NSUUID *connectToIdentifier;
///This bluetoothHandlers delegate
@property id<bluetoothHandlerDelegate> delegate;

///Initialize singleton
+(id)sharedInstance;
///Normal initializer
-(instancetype) init;
///Disconnect from the current device immediately
-(void) disconnectCurrentDevice;
///Write value to characteristic on currently connected device
-(void) writeValue:(NSData *)value toCharacteristic:(CBCharacteristic *)characteristic;
///Read value from characteristic on currently connected device
-(void) readValueFromCharacteristic:(CBCharacteristic *)characteristic;
///Turn on/off notification state of a characteristic
-(void) setNotifyStateForCharacteristic:(CBCharacteristic *)characteristic enable:(BOOL)enable;

@end
