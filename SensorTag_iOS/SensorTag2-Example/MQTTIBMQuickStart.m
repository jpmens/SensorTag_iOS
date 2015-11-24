/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Communication layer from app to MQTTKit library SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           MQTTIBMQuickStart.m
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




#import "MQTTIBMQuickStart.h"

@implementation MQTTIBMQuickStart

///Get MQTT Singleton
///@return Singleton Instance
+ (id)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}
///Initializer
///@return New instance
-(instancetype) init {
    self = [super init];
    if (self) {
    }
    return self;
}
///Connect to MQTT broker
///@param clientId - String containing some type of client id, in this case we use the UUID from iOS
///@param name - Name that will be sent as the myName tag
-(void) connect:(NSString *) clientId name:(NSString *)name {
    NSString *mqttClientID = [NSString stringWithFormat:@"d:quickstart:\"SensorTag2-Example-app\":%@",clientId];
    self.client = [[MQTTClient alloc]initWithClientId:mqttClientID];
    [self.client connectToHost:@"quickstart.messaging.internetofthings.ibmcloud.com" completionHandler:^(MQTTConnectionReturnCode er) {
        NSLog(@"MQTTClient connectToHost : %lu",(unsigned long)er);
        if (er ==  ConnectionAccepted) {
            self.isConnected = YES;
            NSLog(@"MQTT: Publishing");
            NSString *publish = [NSString stringWithFormat:@"%@%@%@",START_STRING,VARIABLE_STRING(@"myName", name),STOP_STRING];
            //NSLog(@"Publishing : %@",publish);
            [self.client publishString:publish
                               toTopic:@"iot-2/evt/status/fmt/json"
                               withQos: AtMostOnce
                                retain:NO
                     completionHandler:^(int mid) {
                
            }];
        }
    }];
}
///Disconnect from MQTT broker
-(void) disconnect {
    NSLog(@"MQTTIBMQuickStart: Disconnect");
    [self.client disconnectWithCompletionHandler:nil];
    self.isConnected = NO;
}
///Encode a single JSON string containing a "name" "value" pair
///@param name - Name of the resource in the cloud
///@param value - Value of the resource
///@return Encoded JSON string
+(NSString *) encodeJSONString:(NSString *)name value:(NSString *)value {
    return VARIABLE_STRING(name, value);
}
///Publishes all of the sensors in one go
///@param string - JSON encoded strings of single "name" "value" pairs
-(void)publishSensorStrings:(NSString *)string {
    NSString *publish = [NSString stringWithFormat:@"%@%@%@",START_STRING,string,STOP_STRING];
    if (self.client.connected) {
    //NSLog(@"Publishing : %@",publish);
    [self.client publishString:publish
                       toTopic:@"iot-2/evt/status/fmt/json"
                       withQos: AtMostOnce
                        retain:NO
             completionHandler:^(int mid) {
                 
             }];
    }
    else {
        NSLog(@"Not connected anymore, please reconnect !");
        self.isConnected = NO;
    }
}
///Publishes single sensor to cloud
///@param name - Resource name used in the cloud
///@param value - Value of the resource to post
-(void)publishSensor: (NSString *)name value:(NSNumber *)value {
    NSString *publish = [NSString stringWithFormat:@"%@%@%@",START_STRING,VARIABLE_STRING(name, [value stringValue]),STOP_STRING];
    if (self.client.connected) {
    //NSLog(@"Publishing : %@",publish);
        [self.client publishString:publish
                           toTopic:@"iot-2/evt/status/fmt/json"
                           withQos: AtMostOnce
                            retain:NO
                 completionHandler:^(int mid) {
                 
                 }];
    }
    else {
        NSLog(@"Not connected anymore, please reconnect !");
        self.isConnected = NO;
    }
}
///Encodes an NSUUID to NSString for use as device id
///@param ident - NSUUID to encode
///@return String with encoding result
+ (NSString *)cloudIdentifierFromUUID:(NSUUID *)ident {
    unsigned char uuidBytes[16];
    [ident getUUIDBytes:uuidBytes];
    return [NSString stringWithFormat:@"%02hhx%02hhx%02hhx%02hhx%02hhx%02hhx",uuidBytes[0],uuidBytes[1],uuidBytes[2],uuidBytes[3],uuidBytes[4],uuidBytes[5]];
}

@end
