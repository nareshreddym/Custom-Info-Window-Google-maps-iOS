//
//  MNGMSInfoWindow.h
//  iOS Google Maps Info Window Customisation
//
//  Created by Naresh Reddy M on 04/03/16.
//  Copyright © 2016 Naresh Reddy M. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNGMSInfoWindowContentView;
@interface MNGMSInfoWindow : UIView
@property (strong, nonatomic) MNGMSInfoWindowContentView *contentView;// frame of contentview should not exceed self bounds.
+(instancetype)sharedInstance;
+(instancetype)alloc NS_UNAVAILABLE; // use shared instance .
-(instancetype)init NS_UNAVAILABLE;  // use shared instance .
@end
@interface MNGMSInfoWindowContentView : UIView
@end