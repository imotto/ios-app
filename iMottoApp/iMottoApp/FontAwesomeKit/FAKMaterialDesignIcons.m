//
//  FAKMaterialDesignIcons.m
//  iMottoApp
//
//  Created by sunht on 16/10/9.
//  Copyright © 2016年 imotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FAKMaterialDesignIcons.h"

@implementation FAKMaterialDesignIcons

+ (UIFont *)iconFontWithSize:(CGFloat)size
{
#ifndef DISABLE_MATERIAL_AUTO_REGISTRATION
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self registerIconFontWithURL:[[NSBundle bundleForClass:[FAKMaterialDesignIcons class]] URLForResource:@"materialdesignicons-webfont" withExtension:@"ttf"]];
    });
#endif
    
    
    UIFont *font = [UIFont fontWithName:@"Material Design Icons" size:size];
    NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    return font;
}

+ (instancetype)thumbDownIconWithSize:(CGFloat)size { return [self iconWithCode:@"\uf511" size:size]; }
+ (instancetype)thumbUpDownIconWithSize:(CGFloat)size { return [self iconWithCode:@"\uf515" size:size]; }
+ (instancetype)thumbUpIconWithSize:(CGFloat)size { return [self iconWithCode:@"\uf513" size:size]; }
+ (instancetype)thumbUpOutlineIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf514" size:size];}
+ (instancetype)thumbDownOutlineIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf512" size:size];}

+ (instancetype)heartIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf2d1" size:size]; }
+ (instancetype)heartOutlineIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf2d5" size:size]; }
+ (instancetype)heartBrokenIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf2d4" size:size]; }
+ (instancetype)heartPulseIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf5f6" size:size]; }
+ (instancetype)heartTagIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf68a" size:size]; }
+ (instancetype)heartBoxOutlineIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf2d3" size:size]; }

+ (instancetype)accountStarIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf017" size:size]; }
+ (instancetype)accountStarVariantIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf018" size:size]; }
+ (instancetype)accountAlertIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf005" size:size]; }

+ (instancetype)pollIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf41f" size:size]; }
+ (instancetype)pollBoxIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf420" size:size]; }


+ (instancetype)documentIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf21a" size:size]; }
+ (instancetype)libraryBooksIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf332" size:size]; }

+ (instancetype)shareVariantIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf497" size:size]; }
+ (instancetype)logoutVariantIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf5fd" size:size]; }

+ (instancetype)helpCircleIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf625" size:size]; }


+ (instancetype)emailIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf1f0" size:size]; }
+ (instancetype)emailOpenIconWithSize:(CGFloat)size{ return [self iconWithCode:@"\uf5ef" size:size]; }

@end
