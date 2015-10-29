//
//  DessertObject.h
//  D-Light
//
//  Created by Krystel Chaccour on 10/29/15.
//  Copyright © 2015 Krystel Chaccour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DessertObject : RLMObject

@property (nonatomic, strong) NSString *dessert_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *prep_time;
@property (nonatomic, strong) NSString *cook_time;
@property (nonatomic, strong) NSString *total_time;
@property (nonatomic, strong) NSString *calories;
@property (nonatomic, strong) NSString *ingredients;
@property (nonatomic, strong) NSString *recipe;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *source;

@end
