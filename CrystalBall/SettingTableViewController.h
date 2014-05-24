//
//  SettingTableViewController.h
//  CrystalBall
//
//  Created by Christian Vazquez on 5/23/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *downloadSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *useMatureSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *useMatureContentValueChanged;


- (IBAction)UseMatureValueChanged:(id)sender;
- (IBAction)DownloadContentValueChanged:(id)sender;
@end
