/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Sensor Tag Key BLE Service for SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           sensorTagKeyService.m
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
#import "sensorTagKeyService.h"
#import "sensorFunctions.h"
#import "masterUUIDList.h"
#import "masterMQTTResourceList.h"

@implementation sensorTagKeyService

+(BOOL) isCorrectService:(CBService *)service {
    if ([service.UUID.UUIDString isEqualToString:TI_SIMPLE_KEYS_SERVICE]) {
        return YES;
    }
    return NO;
}


-(instancetype) initWithService:(CBService *)service {
    self = [super initWithService:service];
    if (self) {
        self.btHandle = [bluetoothHandler sharedInstance];
        self.service = service;
        
        for (CBCharacteristic *c in service.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:TI_SIMPLE_KEYS_KEY_PRESS_STATE]) {
                self.data = c;
            }
        }
        if (!(self.data)) {
            NSLog(@"Some characteristics are missing from this service, might not work correctly !");
        }
        
        self.tile.origin = CGPointMake(0, 7);
        self.tile.size = CGSizeMake(8, 2);
        self.tile.title.text = @"Key press state";
    }
    return self;
}

-(BOOL) configureService {
    if (self.data) {
        [self.btHandle setNotifyStateForCharacteristic:self.data enable:YES];
    }
    return YES;
}

-(BOOL) deconfigureService {
    if (self.data) {
        [self.btHandle setNotifyStateForCharacteristic:self.data enable:NO];
    }
    return YES;
}


-(BOOL) dataUpdate:(CBCharacteristic *)c {
    if ([self.data isEqual:c]) {
        NSLog(@"sensorTagKeyService: Recieved value : %@",c.value);
        oneValueCell *tile = (oneValueCell *)self.tile;
        tile.value.text = [NSString stringWithFormat:@"%@",[self calcValue:c.value]];
        return YES;
    }
    return NO;
}

-(NSArray *) getCloudData {
    NSArray *ar = [[NSArray alloc]initWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    //Value 1
                    [NSString stringWithFormat:@"%d",(self.key1) ? 1 : 0],@"value",
                    //Name 1
                    MQTT_RESOURCE_NAME_BUTTON_1,@"name", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    //Value 1
                    [NSString stringWithFormat:@"%d",(self.key2) ? 1 : 0],@"value",
                    //Name 1
                    MQTT_RESOURCE_NAME_BUTTON_2,@"name", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    //Value 1
                    [NSString stringWithFormat:@"%d",(self.reedRelay) ? 1 : 0],@"value",
                    //Name 1
                    MQTT_RESOURCE_NAME_REED_RELAY,@"name", nil],nil];
    return ar;
}

-(NSString *) calcValue:(NSData *) value {
    uint8_t dat[value.length];
    [value getBytes:dat length:value.length];
    if (dat[0] & 0x1) self.key1 = YES;
    else self.key1 = NO;
    if (dat[0] & 0x2) self.key2 = YES;
    else self.key2 = NO;
    if (dat[0] & 0x4) self.reedRelay = YES;
    else self.reedRelay = NO;
    return [NSString stringWithFormat:@"Key 1: %@, Key 2: %@, Reed Relay: %@",
            (self.key1) ? @"ON " : @"OFF",
            (self.key2) ? @"ON " : @"OFF",
            (self.reedRelay) ? @"ON " : @"OFF"];
}

@end
