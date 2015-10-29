//
//  DetailsPage.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "DetailsPage.h"
#import "DessertObject.h"

@interface DetailsPage ()  <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}
@end

@implementation DetailsPage


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[ColorTheme d_lightGrey]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadInterface];
    });
}

-(void)loadInterface
{
    scrollView = [[UIScrollView alloc] init];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setScrollEnabled:YES];
    [scrollView setUserInteractionEnabled:YES];
    [self.view addSubview:scrollView];
    
    CSAnimationView *animate_subviews = [[CSAnimationView alloc] init];
    [animate_subviews setTranslatesAutoresizingMaskIntoConstraints:NO];
    [animate_subviews setType:CSAnimationTypeFadeIn];
    [animate_subviews setDelay:1.0];
    [animate_subviews setDuration:1.0];
    [animate_subviews setBackgroundColor:[UIColor clearColor]];
    [animate_subviews setUserInteractionEnabled:YES];
    [scrollView addSubview:animate_subviews];
   
    UILabel *title_label = [[UILabel alloc] init];
    [title_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [title_label setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] name] : [self.info_dict objectForKey:@"name"]];
    [title_label setTextAlignment:NSTextAlignmentCenter];
    [title_label setTextColor:[ColorTheme d_darkGrey]];
    [title_label setFont:[FontManager bookFontOfSize:16]];
    [title_label setBackgroundColor:[UIColor clearColor]];
    [title_label setNumberOfLines:0];
    [title_label setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:title_label];
    
    UILabel *category_label = [[UILabel alloc] init];
    [category_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [category_label setText:[self.info_dict objectForKey:@"Dessert"] ? [[(DessertObject *)[self.info_dict objectForKey:@"Dessert"] tags] uppercaseString] : [[self.info_dict objectForKey:@"tags"] uppercaseString]];
    [category_label setTextAlignment:NSTextAlignmentCenter];
    [category_label setTextColor:[ColorTheme d_darkGrey]];
    [category_label setFont:[FontManager thinFontOfSize:12]];
    [category_label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:category_label];
    
    UIButton *fake_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fake_btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fake_btn setBackgroundColor:[UIColor clearColor]];
    [fake_btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fake_btn];
    
    UIButton *back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [back_btn setBackgroundImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [fake_btn addSubview:back_btn];
    
    UIImageView *dessert_image = [[UIImageView alloc] init];
    [dessert_image setTranslatesAutoresizingMaskIntoConstraints:NO];
    [dessert_image sd_setImageWithURL:[NSURL URLWithString:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] image] : [self.info_dict objectForKey:@"image"]] placeholderImage:nil options:SDWebImageProgressiveDownload];
    [dessert_image setContentMode:UIViewContentModeScaleAspectFit];
    [dessert_image setBackgroundColor:[ColorTheme d_lightGrey]];
    [animate_subviews addSubview:dessert_image];
    [dessert_image layoutIfNeeded];
    
    UILabel *description_label = [[UILabel alloc] init];
    [description_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [description_label setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] desc] : [self.info_dict objectForKey:@"description"]];
    [description_label setTextAlignment:NSTextAlignmentLeft];
    [description_label setBackgroundColor:[UIColor clearColor]];
    [description_label setFont:[FontManager thinFontOfSize:12]];
    [description_label setTextColor:[ColorTheme d_darkGrey]];
    [description_label setNumberOfLines:0];
    [description_label setLineBreakMode:NSLineBreakByWordWrapping];
    [animate_subviews addSubview:description_label];
    [description_label layoutIfNeeded];
    
    UIImageView *time_icon = [[UIImageView alloc] init];
    [time_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [time_icon setImage:[UIImage imageNamed:@"Time-Icon"]];
    [time_icon setContentMode:UIViewContentModeScaleAspectFill];
    [animate_subviews addSubview:time_icon];
    [time_icon layoutIfNeeded];
    
    UILabel *time_text = [[UILabel alloc] init];
    [time_text setTranslatesAutoresizingMaskIntoConstraints:NO];
    [time_text setTextAlignment:NSTextAlignmentLeft];
    [time_text setNumberOfLines:0];
    [time_text setLineBreakMode:NSLineBreakByWordWrapping];
    [time_text setTextColor:[ColorTheme d_darkGrey]];
    [time_text setBackgroundColor:[UIColor clearColor]];
    [time_text setFont:[FontManager lightFontOfSize:12]];
    [time_text setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] total_time] : [self.info_dict objectForKey:@"total-time"]];
    [animate_subviews addSubview:time_text];
    [time_text layoutIfNeeded];
    
    UIImageView *calories_icon = [[UIImageView alloc] init];
    [calories_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [calories_icon setImage:[UIImage imageNamed:@"Calories-Icon"]];
    [calories_icon setContentMode:UIViewContentModeScaleAspectFill];
    [animate_subviews addSubview:calories_icon];
    [calories_icon layoutIfNeeded];
    
    UILabel *calories_text = [[UILabel alloc] init];
    [calories_text setTranslatesAutoresizingMaskIntoConstraints:NO];
    [calories_text setTextAlignment:NSTextAlignmentLeft];
    [calories_text setNumberOfLines:0];
    [calories_text setLineBreakMode:NSLineBreakByWordWrapping];
    [calories_text setTextColor:[ColorTheme d_darkGrey]];
    [calories_text setBackgroundColor:[UIColor clearColor]];
    [calories_text setFont:[FontManager lightFontOfSize:12]];
    [calories_text setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] calories] : [self.info_dict objectForKey:@"calories"]];
    [animate_subviews addSubview:calories_text];
    [calories_text layoutIfNeeded];
    
    UILabel *ingred_title = [[UILabel alloc] init];
    [ingred_title setTranslatesAutoresizingMaskIntoConstraints:NO];
    [ingred_title setText:@"Ingredients"];
    [ingred_title setTextAlignment:NSTextAlignmentLeft];
    [ingred_title setTextColor:[ColorTheme d_darkGrey]];
    [ingred_title setBackgroundColor:[UIColor clearColor]];
    [ingred_title setFont:[FontManager bookFontOfSize:14]];
    [animate_subviews addSubview:ingred_title];
    [ingred_title layoutIfNeeded];
    
    UITextView *ingred_text = [[UITextView alloc] init];
    [ingred_text setTranslatesAutoresizingMaskIntoConstraints:NO];
    [ingred_text setTextAlignment:NSTextAlignmentLeft];
    [ingred_text setTextColor:[ColorTheme d_darkGrey]];
    [ingred_text setFont:[FontManager lightFontOfSize:13]];
    [ingred_text setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] ingredients] : [self.info_dict objectForKey:@"ingredients"]];
    [ingred_text setUserInteractionEnabled:NO];
    [ingred_text setEditable:NO];
    [ingred_text setScrollEnabled:NO];
    [animate_subviews addSubview:ingred_text];
    [ingred_text layoutIfNeeded];
    
    UILabel *prep_title = [[UILabel alloc] init];
    [prep_title setTranslatesAutoresizingMaskIntoConstraints:NO];
    [prep_title setText:@"Preparation"];
    [prep_title setTextAlignment:NSTextAlignmentLeft];
    [prep_title setTextColor:[ColorTheme d_darkGrey]];
    [prep_title setBackgroundColor:[UIColor clearColor]];
    [prep_title setFont:[FontManager bookFontOfSize:14]];
    [animate_subviews addSubview:prep_title];
    [prep_title layoutIfNeeded];
    
    UITextView *prep_text = [[UITextView alloc] init];
    [prep_text setTranslatesAutoresizingMaskIntoConstraints:NO];
    [prep_text setTextAlignment:NSTextAlignmentLeft];
    [prep_text setTextColor:[ColorTheme d_darkGrey]];
    [prep_text setFont:[FontManager lightFontOfSize:13]];
    [prep_text setText:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] recipe] : [self.info_dict objectForKey:@"recipe"]];
    [prep_text setUserInteractionEnabled:NO];
    [prep_text setEditable:NO];
    [prep_text setScrollEnabled:NO];
    [animate_subviews addSubview:prep_text];
    [prep_text layoutIfNeeded];
    
    UIButton *more_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [more_btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [more_btn setBackgroundImage:[UIImage imageNamed:@"Details"] forState:UIControlStateNormal];
    [more_btn addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    [animate_subviews addSubview:more_btn];
    [more_btn layoutIfNeeded];
    
    [animate_subviews startCanvasAnimation];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:scrollView forKey:@"scroll"];
    [dict setObject:animate_subviews forKey:@"animate"];
    [dict setObject:self.view forKey:@"view"];

    [dict setObject:title_label forKey:@"title"];
    [dict setObject:category_label forKey:@"category"];
    [dict setObject:fake_btn forKey:@"fake"];
    [dict setObject:back_btn forKey:@"back"];
    
    [dict setObject:dessert_image forKey:@"image"];
    [dict setObject:description_label forKey:@"desc"];
    [dict setObject:time_icon forKey:@"picon"];
    [dict setObject:time_text forKey:@"ptext"];
    [dict setObject:calories_text forKey:@"ctext"];
    [dict setObject:calories_icon forKey:@"cicon"];
    [dict setObject:ingred_title forKey:@"ingtitle"];
    [dict setObject:ingred_text forKey:@"ingtext"];
    [dict setObject:prep_title forKey:@"preptitle"];
    [dict setObject:prep_text forKey:@"preptext"];
    [dict setObject:more_btn forKey:@"morebtn"];
    
    int width = [UIScreen mainScreen].bounds.size.width - 20;
    [dict setObject:[NSNumber numberWithInt:width] forKey:@"width"];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[fake(50)]" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[fake(50)]" options:0 metrics:nil views:dict]];
    
    [fake_btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[back]" options:0 metrics:nil views:dict]];
    [fake_btn addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[back]" options:0 metrics:nil views:dict]];
    [fake_btn addConstraint:[NSLayoutConstraint constraintWithItem:back_btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:fake_btn attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [fake_btn addConstraint:[NSLayoutConstraint constraintWithItem:back_btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:fake_btn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[fake]-0-[title]-5-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[title]" options:0 metrics:nil views:dict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:category_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:title_label attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-5-[category]" options:0 metrics:nil views:dict]];

    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[image(<=150)]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[image(<=150)]" options:0 metrics:nil views:dict]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-10-[desc]-5-|" options:0 metrics:dict views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:description_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:dessert_image attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[image]-5-[cicon(15)]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:calories_icon attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dessert_image attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cicon]-10-[ctext]-5-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:calories_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:calories_icon attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cicon]-5-[picon]" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:time_icon attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:dessert_image attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[picon]-10-[ptext]-5-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:time_text attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:time_icon attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[ingtitle]-10-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[picon]-20-[ingtitle]" options:0 metrics:nil views:dict]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[ingtext]-10-|" options:0 metrics:dict views:dict]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ingtitle]-10-[ingtext]" options:0 metrics:nil views:dict]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[preptitle]-10-|" options:0 metrics:nil views:dict]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ingtext]-20-[preptitle]" options:0 metrics:nil views:dict]];
    
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[preptext]-10-|" options:0 metrics:dict views:dict]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[preptitle]-10-[preptext]" options:0 metrics:nil views:dict]];
    
    [animate_subviews addConstraint:[NSLayoutConstraint constraintWithItem:more_btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:animate_subviews attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [animate_subviews addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[preptext]-10-[morebtn]-10-|" options:0 metrics:nil views:dict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[scroll]-10-|" options:0 metrics:nil views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[title]-5-[category]-5-[scroll]-10-|" options:0 metrics:nil views:dict]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[animate(==scroll)]-0-|" options:0 metrics:nil views:dict]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[animate]-0-|" options:0 metrics:nil views:dict]];
    

    [self viewDidLayoutSubviews];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [scrollView layoutIfNeeded];
    
    [scrollView setUserInteractionEnabled:YES];
}


#pragma mark - More Action
#pragma mark

-(IBAction)morePressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.info_dict objectForKey:@"Dessert"] ? [(DessertObject *)[self.info_dict objectForKey:@"Dessert"] source] : [self.info_dict objectForKey:@"source"]]];
}

-(void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
