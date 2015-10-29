//
//  FontManager.m
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import "FontManager.h"

@implementation FontManager

#pragma mark - Gotham Fonts
#pragma mark

+(UIFont*) bookFontOfSize:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"Gotham-Book" size:pointSize];
}

+(UIFont*) lightFontOfSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Gotham-Light" size:pointSize];
}

+(UIFont*) thinFontOfSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Gotham-Thin" size:pointSize];
}

+(UIFont*) extraLightFontOfSize:(CGFloat)pointSize {
    return [UIFont fontWithName:@"Gotham-ExtraLight" size:pointSize];
}

#pragma mark - Lobster Fonts
#pragma mark


+(UIFont *) regularLobster:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"Lobster-Regular" size:pointSize];
}

+(UIFont *) regularLobsterTwo:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"LobsterTwo-Regular" size:pointSize];
}

+(UIFont *) italicLobsterTwo:(CGFloat)pointSize
{
    return [UIFont fontWithName:@"LobsterTwo-Italic" size:pointSize];
}


@end
