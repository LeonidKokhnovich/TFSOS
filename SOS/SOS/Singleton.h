//
//  Singleton.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Signleton protocol.
 */
@protocol Singleton <NSObject>

@required
/**
 *  Shared by the app object.
 *
 *  @return Singleton object that is shared through the app.
 */
+ (instancetype)sharedInstance;

@end