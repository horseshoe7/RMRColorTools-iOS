//
//  RMRHexColor.h
//  RMRHexColorGen
//
//  Created by Roman Churkin on 18/03/15.
//  Copyright (c) 2015 RedMadRobot. All rights reserved.
//

@import Foundation;


@interface RMRHexColor : NSObject

@property (nonatomic, nonnull, copy) NSString *colorTitle;
@property (nonatomic, nonnull, copy) NSString *colorValue; // e.g. #AAFF22  or #AAFF2211, includes the # and is in RRGGBB or RRGGBBAA form
@property (nonatomic, nullable, copy) NSString *alternateColorValue;  // optional.  For example a dark-mode representation.
@property (nonatomic, assign) BOOL isAlias;
@property (nonatomic, nullable, copy) NSString *comments;

@end
