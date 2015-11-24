/*!
 *  \author         Ole A. Torvmark <o.a.torvmark@ti.com , torvmark@stalliance.no>
 *  \brief          Simple Bluetooth Device Selector SensorTag2-Example iOS application
 *  \copyright      Copyright (c) 2015 Texas Instruments Incorporated
 *  \file           DeviceSelectTableViewController.m
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

#import "DeviceSelectTableViewController.h"

@interface DeviceSelectTableViewController ()

@end

@implementation DeviceSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"F0005555-0451-4000-B000-000000000000"];
    NSDictionary *standard = [NSDictionary dictionaryWithObjectsAndKeys:uuid.UUIDString,@"selectedDevice", nil];
    [d registerDefaults:standard];
    [d synchronize];
    self.currentlySelectedDeviceIdentifier = [[NSUUID alloc] initWithUUIDString:[d objectForKey:@"selectedDevice"]];
    NSLog(@"Loaded selectedDevice : %@",self.currentlySelectedDeviceIdentifier.UUIDString);

    self.title = @"Please select BLE device";
}


-(void) viewWillAppear:(BOOL)animated {
    self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.discoveredDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld.%ld",(long)indexPath.row,(long)indexPath.section]];
    CBPeripheral *p = [self.discoveredDevices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.identifier.UUIDString;
    if ([p.identifier isEqual:self.currentlySelectedDeviceIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *p = [self.discoveredDevices objectAtIndex:indexPath.row];
    self.currentlySelectedDeviceIdentifier = p.identifier;
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.currentlySelectedDeviceIdentifier.UUIDString forKey:@"selectedDevice"];
    [d synchronize];
    [self.devSelectDelegate newDeviceWasSelected:self.currentlySelectedDeviceIdentifier];
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat: @"Discovered devices : %lu",(unsigned long)self.discoveredDevices.count];
}


-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil]];
    }
}


-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (!self.discoveredDevices) {
        self.discoveredDevices = [[NSMutableArray alloc]init];
    }
    
    for (CBPeripheral *p in self.discoveredDevices) {
        if ([p.identifier isEqual:peripheral.identifier]) return;
    }
    [self.discoveredDevices addObject:peripheral];
    [self.tableView reloadData];
    
}

-(void) backButtonPressed {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
