//
//  FontManager.h
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontManager : NSObject

// Gotham
+(UIFont*) bookFontOfSize:(CGFloat)pointSize;
+(UIFont*) lightFontOfSize:(CGFloat)pointSize;
+(UIFont*) thinFontOfSize:(CGFloat)pointSize;
+(UIFont*) extraLightFontOfSize:(CGFloat)pointSize;

//Lobster
+(UIFont *) regularLobster:(CGFloat)pointSize;
+(UIFont *) regularLobsterTwo:(CGFloat)pointSize;
+(UIFont *) italicLobsterTwo:(CGFloat)pointSize;

@end
