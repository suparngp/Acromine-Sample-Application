//
//  NetworkManager.h
//  sample
//
//  Created by Suparn Gupta on 13/12/15.
//  Copyright © 2015 Suparn Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
/**
 *  Returns a singleton instance of the network manager
 *
 *  @return singleton
 */
+(NetworkManager*) sharedInstance;

/**
 *  Fetches the full form for a short form from the server. Can be moved into another service layer if the application is complex.
 *
 *  @param shortForm                the shortform
 *  @param completionHandler the completion handler
 */
- (void) fetchFullFormForShortForm:(NSString*) shortForm
                 completionHandler: (void(^)(NSError *, NSArray<NSString*> *)) completionHandler;
@end
