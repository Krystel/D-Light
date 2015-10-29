//
//  DessertCell.h
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DessertCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIView *fake_view;
@property (nonatomic, retain) IBOutlet UIImageView *dessert_image;
@property (nonatomic, retain) IBOutlet UILabel *dessert_title;
@property (nonatomic, retain) IBOutlet UILabel *prep_text;
@property (nonatomic, retain) IBOutlet UIImageView *prep_icon;
@property (nonatomic, retain) IBOutlet UILabel *cal_text;
@property (nonatomic, retain) IBOutlet UIImageView *cal_icon;

@end
