//
//  DataFetchService.h
//  MyMerchant
//
//  Created by Pranay Narvankar on 26/08/15.
//  Copyright (c) 2015 Pranay Narvankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataFetchService : NSObject<NSURLSessionDelegate>
{
NSURLConnection *connection;
NSMutableData *responseData;
}

-(void)simplePostMethod:(NSDictionary*)dict WebServiceName:(NSString*)WebserviceString WithCompletionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;
-(void)simpleGetMethod:(NSString*)WebserviceString WithCompletionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock;

@end
