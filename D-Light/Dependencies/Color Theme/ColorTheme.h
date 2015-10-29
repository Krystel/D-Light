//
//  ColorTheme.h
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *d_purple = @"#740E9A";
static NSString *d_darkGrey = @"#2E2E2E";
static NSString *d_lightGrey = @"#DFDFDF";

@interface ColorTheme : NSObject

//  convert hexadecimal colors to UIColor
+(UIColor *)colorFromHexString:(NSString *)hexString;

+(UIColor *)d_purple;
+(UIColor *)d_darkGrey;
+(UIColor *)d_lightGrey;


@end
