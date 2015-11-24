/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Main ViewController for SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           ViewController.m
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

#import "ViewController.h"
#import "siOleAlertView.h"

#import "sensorTagAmbientTemperatureService.h"
#import "sensorTagAirPressureService.h"
#import "sensorTagHumidityService.h"
#import "sensorTagMovementService.h"
#import "sensorTagLightService.h"
#import "sensorTagKeyService.h"
#import "deviceInformationService.h"

#import "MQTTIBMQuickStart.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.handler = [bluetoothHandler sharedInstance];
    self.cloudHandle = [MQTTIBMQuickStart sharedInstance];
    self.handler.delegate = self;
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f] CGColor], nil];
    [self.view.layer insertSublayer:self.gradient atIndex:0];
    self.displayTiles = [[NSMutableArray alloc]init];
    
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


-(void) viewWillLayoutSubviews {
    self.gradient.frame = self.view.bounds;
    for (displayTile *t in self.displayTiles) {
        [t setFrame:self.view.frame];
        t.title.text = t.title.text;
    }

}

-(void) viewDidAppear:(BOOL)animated {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) deviceReady:(BOOL)ready peripheral:(CBPeripheral *)peripheral {
    if (ready) {
        if (self.aV.superview) {
            [self.aV dismissMessage];
        }
        for (int ii = 0; ii < self.displayTiles.count; ii++) {
            displayTile *t = [self.displayTiles objectAtIndex:ii];
            [t removeFromSuperview];
        }
        self.services = [[NSMutableArray alloc] init];
        for (CBService *s in peripheral.services) {
            
            if ([sensorTagAmbientTemperatureService isCorrectService:s]) {
                sensorTagAmbientTemperatureService *serv = [[sensorTagAmbientTemperatureService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([sensorTagAirPressureService isCorrectService:s]) {
                sensorTagAirPressureService *serv = [[sensorTagAirPressureService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([sensorTagHumidityService isCorrectService:s]) {
                sensorTagHumidityService *serv = [[sensorTagHumidityService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([sensorTagMovementService isCorrectService:s]) {
                sensorTagMovementService *serv = [[sensorTagMovementService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([sensorTagLightService isCorrectService:s]) {
                sensorTagLightService *serv = [[sensorTagLightService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([deviceInformationService isCorrectService:s]) {
                deviceInformationService *serv = [[deviceInformationService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
            if ([sensorTagKeyService isCorrectService:s]) {
                sensorTagKeyService *serv = [[sensorTagKeyService alloc] initWithService:s];
                [self.services addObject:serv];
                [serv configureService];
                displayTile *t = [serv getViewForPresentation];
                [t setFrame:self.view.frame];
                t.title.text = t.title.text;
                [self.displayTiles addObject:t];
                [self.view addSubview:t];
            }
        }
    }
    else {
        if (self.aV) [self.aV dismissMessage];
        self.aV = [[siOleAlertView alloc] initInView:self.view];
        [self.aV blinkMessage:@"Disconnected !"];
    }
}

-(void) didReadCharacteristic:(CBCharacteristic *)characteristic {
    for (int ii = 0; ii < self.services.count; ii++) {
        bleGenericService *s = [self.services objectAtIndex:ii];
        [s dataUpdate:characteristic];
    }
}
-(void) didGetNotificaitonOnCharacteristic:(CBCharacteristic *)characteristic {
    self.MQTTStringLive = [[NSString alloc] init];
    for (int ii = 0; ii < self.services.count; ii++) {
        bleGenericService *s = [self.services objectAtIndex:ii];
        [s dataUpdate:characteristic];
        NSArray *arr = [s getCloudData];
        if (arr != nil) {
            for (NSDictionary *dict in arr) {
                self.MQTTStringLive = [self.MQTTStringLive stringByAppendingString:[NSString stringWithFormat:@"%@,\n",[MQTTIBMQuickStart encodeJSONString:[dict objectForKey:@"name"] value:[dict objectForKey:@"value"]]]];
            }
        }
    }
    self.MQTTStringTX = self.MQTTStringLive;
}
-(void) didWriteCharacteristic:(CBCharacteristic *)characteristic error:(NSError *) error {
    for (int ii = 0; ii < self.services.count; ii++) {
        bleGenericService *s = [self.services objectAtIndex:ii];
        [s wroteValue:characteristic error:error];
    }
}


- (IBAction)selectDeviceButtonTouched:(id)sender {
    [self.aV dismissMessage];
    [self.handler disconnectCurrentDevice];
    if (!self.deviceSelector) {
        self.deviceSelector = [[DeviceSelectTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self.deviceSelector.devSelectDelegate = self;
    }
    [self showViewController:self.deviceSelector sender:nil];
}

- (IBAction)cloudLinkButtonTouched:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://quickstart.internetofthings.ibmcloud.com/#/device/%@",[MQTTIBMQuickStart cloudIdentifierFromUUID:self.handler.p.identifier]]];
    self.aVC = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
    self.aVC.popoverPresentationController.sourceView = self.cloudLinkButton;
    [self presentViewController:self.aVC animated:YES completion:nil];

}



-(void) newDeviceWasSelected:(NSUUID *)identifier {
    self.handler.connectToIdentifier = identifier;
    self.handler.shouldReconnect = YES;
    if (self.MQTTTimer.isValid) {
        [self.MQTTTimer invalidate];
    }
    [self.cloudHandle connect:[MQTTIBMQuickStart cloudIdentifierFromUUID:identifier] name:@"SensorTag2-Example App"];
    self.MQTTTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(MQTTTimerTick:) userInfo:nil repeats:YES];
    for (int ii = 0; ii < self.displayTiles.count; ii++) {
        displayTile *t = [self.displayTiles objectAtIndex:ii];
        [t removeFromSuperview];
    }
    self.displayTiles = [[NSMutableArray alloc] init];
    self.services = [[NSMutableArray alloc] init];
    NSLog(@"Cloud identifier for this device : %@",[MQTTIBMQuickStart cloudIdentifierFromUUID:identifier]);
}


#pragma mark -- MQTT routines below

-(void) MQTTTimerTick: (NSTimer *)timer {
    if (self.MQTTStringTX.length > 2) {
        self.MQTTStringTX = [self.MQTTStringTX substringToIndex:self.MQTTStringTX.length - 2];
    }
    NSLog(@"Posting : %@",self.MQTTStringTX);
    [self.cloudHandle publishSensorStrings:self.MQTTStringTX];
    if (self.cloudLinkButton.hidden) self.cloudLinkButton.hidden = NO;
}



@end
