/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          BT SIG Device Information Service handler for SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           deviceInformationService.m
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


#import "deviceInformationService.h"
#import "sensorFunctions.h"
#import "masterUUIDList.h"
#import "masterMQTTResourceList.h"
#import "math.h"

@implementation deviceInformationService

+(BOOL) isCorrectService:(CBService *)service {
    if ([service.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_SERVICE]) {
        return YES;
    }
    return NO;
}


-(instancetype) initWithService:(CBService *)service {
    self = [super initWithService:service];
    if (self) {
        self.btHandle = [bluetoothHandler sharedInstance];
        self.service = service;
        
        self.tile.origin = CGPointMake(0, 9);
        self.tile.size = CGSizeMake(8, 4);
        self.tile.title.text = @"Device Information Service";
        ((oneValueCell *) self.tile).value.numberOfLines = 10;
        ((oneValueCell *) self.tile).value.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

-(BOOL) configureService {
    for (CBCharacteristic *c in self.service.characteristics) {
        //Real all characteristics in the Device Information Service
        [self.btHandle readValueFromCharacteristic:c];
    }
    return YES;
}
-(BOOL) deconfigureService {
    return YES;
}

-(BOOL) dataUpdate:(CBCharacteristic *)c {
    uint8_t val[c.value.length];
    [c.value getBytes:val length:c.value.length];
    if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_SYSTEM_ID]) {
        self.deviceSystemID = [NSString stringWithFormat:@"%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",val[0],val[1],val[2],val[3],val[4],val[5],val[6],val[7]];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_MODEL_NR]) {
        self.deviceModelNumber = [[NSString alloc]initWithBytes:val length:c.value.length encoding:NSUTF8StringEncoding];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_SERIAL_NR]) {
        self.deviceSerialNumber = [[NSString alloc] initWithBytes:val length:c.value.length encoding:NSUTF8StringEncoding];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_FIRMWARE_REV]) {
        self.deviceFirmwareRevision = [[NSString alloc] initWithBytes:val length:c.value.length encoding:NSUTF8StringEncoding];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_HARDWARE_REV]) {
        self.deviceHardwareRevision = [[NSString alloc] initWithBytes:val length:c.value.length encoding:NSUTF8StringEncoding];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_SOFTWARE_REV]) {
        self.deviceSoftwareRevision = [[NSString alloc] initWithBytes:val length:c.value.length encoding:NSUTF8StringEncoding];
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_IEEE_11073]) {
        self.deviceIEEE11073Reg = @"N.A.";
        [self calcValue:nil];
    }
    else if ([c.UUID.UUIDString isEqualToString:BT_SIG_DEVICE_INFO_PNP_ID]) {
        self.devicePNPId = [NSString stringWithFormat:@"VIDSrc:%02hhx VID:%04x\n               PID:%04x Prod Ver: %04x",val[0],(val[1] | ((uint16_t)val[2] << 8)),
                            (val[3] | ((uint16_t)val[4] << 8)),
                            (val[5] | ((uint16_t)val[6] << 8))];
        [self calcValue:nil];
    }
    return YES;
}

-(NSArray *) getCloudData {
    //NSArray *ar = [[NSArray alloc]initWithObjects:
          //[NSDictionary dictionaryWithObjectsAndKeys:
           //Value 1
           //[NSString stringWithFormat:@"%0.1f",self.lightLevel],@"value",
           //Name 1
           //MQTT_RESOURCE_NAME_LIGHT_LEVEL,@"name", nil], nil];
    return nil;//ar;
}

-(NSString *) calcValue:(NSData *) value {
    NSString *val = [NSString stringWithFormat:
                     @"System ID    : %@\n"
                      "Model NR     : %@\n"
                      "Serial NR    : %@\n"
                      "Firmware rev : %@\n"
                      "Hardware rev : %@\n"
                      "Software rev : %@\n"
                      "PnP ID       : %@\n"
                      ,self.deviceSystemID,self.deviceModelNumber,self.deviceSerialNumber,self.deviceFirmwareRevision,self.deviceHardwareRevision,self.deviceSoftwareRevision,self.devicePNPId];
    ((oneValueCell *)self.tile).value.text = val;
    
    return val;
}


@end
