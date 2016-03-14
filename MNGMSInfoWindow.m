//
//  MNGMSInfoWindow.m
//  iOS Google Maps Info Window Customisation
//
//  Created by Naresh Reddy M on 04/03/16.
//  Copyright © 2016 Naresh Reddy M. All rights reserved.
//

#import "MNGMSInfoWindow.h"
@implementation MNGMSInfoWindow
-(void)setContentView:(MNGMSInfoWindowContentView *)contentView
{
    _contentView = contentView;
    if([self.subviews containsObject:self.contentView] == false)
       [self addSubview:self.contentView];
}
+(instancetype)sharedInstance
{
    static MNGMSInfoWindow *sharedInstance = nil;
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        sharedInstance  = [MNGMSInfoWindow new];
    });
    return sharedInstance;
}
@end
@implementation MNGMSInfoWindowContentView
@end
