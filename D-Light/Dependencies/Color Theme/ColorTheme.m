//
//  ColorTheme.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "ColorTheme.h"

@implementation ColorTheme

#pragma mark - Function Hex to UIColor
#pragma mark


+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Colors
#pragma mark

+(UIColor *)d_purple
{
    return [self colorFromHexString:d_purple];
}

+(UIColor *)d_lightGrey
{
    return [self colorFromHexString:d_lightGrey];
}

+(UIColor *)d_darkGrey
{
    return [self colorFromHexString:d_darkGrey];
}
@end
