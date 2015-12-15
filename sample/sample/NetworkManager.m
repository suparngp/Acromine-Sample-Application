//
//  NetworkManager.m
//  sample
//
//  Created by Suparn Gupta on 13/12/15.
//  Copyright © 2015 Suparn Gupta. All rights reserved.
//

/**
 *  Mae
 */
#import "NetworkManager.h"
#import "AFNetworking.h"

@implementation NetworkManager

+(NetworkManager*) sharedInstance {
    static dispatch_once_t token;
    static NetworkManager* sharedManager;
    dispatch_once(&token, ^ {
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

/**
 *  Creates a session Manager with JSON response serializer
 *
 *  @param url the url
 *
 *  @return the AFHTTPSessionManager
 */
- (AFHTTPSessionManager *) createJSONSessionManagerForURL:(NSURL*) url {
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    //for some reason the API is returning the header as text/html
    AFHTTPRequestSerializer *jsonRequestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/plain"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    sessionManager.requestSerializer = jsonRequestSerializer;
    sessionManager.responseSerializer = jsonResponseSerializer;
    return sessionManager;
}


- (void) fetchFullFormForShortForm:(NSString*) sf
                                 completionHandler: (void(^)(NSError *, NSArray<NSString*> *)) completionHandler{
    NSMutableArray <NSString*>* fullforms = [NSMutableArray arrayWithArray:@[]];
    
    NSURL *apiURL = [NSURL URLWithString:@"http://www.nactem.ac.uk/software/acromine/dictionary.py"];
    AFHTTPSessionManager *manager = [self createJSONSessionManagerForURL:apiURL];
    [manager GET:@"" parameters:@{@"sf":sf} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray* response = (NSArray *) responseObject;
        if(response.count < 1){
            NSLog(@"Empty dataset");
            [fullforms addObject:@"No Results found"];
        }
        else {
            NSDictionary* firstResult = response[0];
            NSArray *results = firstResult[@"lfs"];
            for(NSDictionary* result in results){
                NSString* fullForm = result[@"lf"];
                [fullforms addObject:fullForm];
            }
        }
        completionHandler(nil, fullforms);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [fullforms addObject:@"Error occurred"];
        completionHandler(error, fullforms);
    }];
}
@end
