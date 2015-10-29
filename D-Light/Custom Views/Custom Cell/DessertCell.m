//
//  DessertCell.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "DessertCell.h"

@implementation DessertCell
@synthesize fake_view, dessert_image, dessert_title, prep_icon, prep_text, cal_icon, cal_text;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView setBackgroundColor:[ColorTheme d_lightGrey]];
        
        fake_view = [[UIView alloc] init];
        [fake_view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [fake_view setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:fake_view];
        
        dessert_image = [[UIImageView alloc] init];
        [dessert_image setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dessert_image setBackgroundColor:[UIColor clearColor]];
        [dessert_image setContentMode:UIViewContentModeScaleAspectFit];
        [fake_view addSubview:dessert_image];
        
        dessert_title = [[UILabel alloc] init];
        [dessert_title setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dessert_title setTextAlignment:NSTextAlignmentLeft];
        [dessert_title setNumberOfLines:0];
        [dessert_title setLineBreakMode:NSLineBreakByWordWrapping];
        [dessert_title setTextColor:[ColorTheme d_darkGrey]];
        [dessert_title setBackgroundColor:[UIColor clearColor]];
        [dessert_title setFont:[FontManager bookFontOfSize:15]];
        [fake_view addSubview:dessert_title];
        
        prep_icon = [[UIImageView alloc] init];
        [prep_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [prep_icon setImage:[UIImage imageNamed:@"Time-Icon"]];
        [prep_icon setContentMode:UIViewContentModeScaleAspectFill];
        [fake_view addSubview:prep_icon];
        
        prep_text = [[UILabel alloc] init];
        [prep_text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [prep_text setTextAlignment:NSTextAlignmentLeft];
        [prep_text setNumberOfLines:0];
        [prep_text setLineBreakMode:NSLineBreakByWordWrapping];
        [prep_text setTextColor:[ColorTheme d_darkGrey]];
        [prep_text setBackgroundColor:[UIColor clearColor]];
        [prep_text setFont:[FontManager lightFontOfSize:12]];
        [fake_view addSubview:prep_text];
        
        cal_icon = [[UIImageView alloc] init];
        [cal_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cal_icon setImage:[UIImage imageNamed:@"Calories-Icon"]];
        [cal_icon setContentMode:UIViewContentModeScaleAspectFill];
        [fake_view addSubview:cal_icon];
        
        cal_text = [[UILabel alloc] init];
        [cal_text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cal_text setTextAlignment:NSTextAlignmentLeft];
        [cal_text setNumberOfLines:0];
        [cal_text setLineBreakMode:NSLineBreakByWordWrapping];
        [cal_text setTextColor:[ColorTheme d_darkGrey]];
        [cal_text setBackgroundColor:[UIColor clearColor]];
        [cal_text setFont:[FontManager lightFontOfSize:12]];
        [fake_view addSubview:cal_text];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:fake_view forKey:@"fake"];
        [dict setObject:dessert_image forKey:@"image"];
        [dict setObject:dessert_title forKey:@"title"];
        [dict setObject:prep_icon forKey:@"picon"];
        [dict setObject:prep_text forKey:@"ptext"];
        [dict setObject:cal_text forKey:@"ctext"];
        [dict setObject:cal_icon forKey:@"cicon"];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[fake]-10-|" options:0 metrics:nil views:dict]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[fake]-5-|" options:0 metrics:nil views:dict]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[image(85)]" options:0 metrics:nil views:dict]];
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[image(85)]" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:dessert_image attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.fake_view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-10-[title]-5-|" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:dessert_title attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:dessert_image attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-10-[cicon(15)]" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:cal_icon attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:dessert_image attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cicon]-10-[ctext]-5-|" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:cal_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cal_icon attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-10-[picon]" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:prep_icon attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cal_icon attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0]];
        
        [fake_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[picon]-10-[ptext]-5-|" options:0 metrics:nil views:dict]];
        [fake_view addConstraint:[NSLayoutConstraint constraintWithItem:prep_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:prep_icon attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
