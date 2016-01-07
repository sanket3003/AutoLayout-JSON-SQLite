//
//  DataFetchService.m
//  MyMerchant
//
//  Created by Pranay Narvankar on 26/08/15.
//  Copyright (c) 2015 Pranay Narvankar. All rights reserved.
//

#import "DataFetchService.h"
#import "Reachability.h"
//#import "SVProgressHUD.h"
@interface DataFetchService ()

@end

@implementation DataFetchService
{
    NSURLSessionConfiguration *configuration;
    NSURLSession *session;
    NSMutableURLRequest *request;
    NSURL *url;
    BOOL isInternet;
}
- (BOOL) connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    { isInternet = TRUE;
        
    }
    return isInternet;
}

-(void)simplePostMethod:(NSDictionary*)dict WebServiceName:(NSString*)WebserviceString WithCompletionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock {
    
    BOOL connectivity = [self connectedToNetwork];
    if (! connectivity == YES) {
        UIAlertView *alertObj=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Check Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertObj show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI in main thread.
            
           // [SVProgressHUD dismiss];
        });
        return;
    }
    
    
   // NSLog(@"WebserviceString---%@",WebserviceString);
    //NSLog(@"dict::%@",dict);
    
    NSError *error;
    
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    url = [NSURL URLWithString:WebserviceString];
    request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"loginAuthToken"] forHTTPHeaderField:@"AuthToken"];
    //[request setValue:@"0d7a5cba-ab62-46bd-b856-80cd13f9870a" forHTTPHeaderField:@"AuthToken"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString;
    if (! postData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    }
    
    //NSLog(@"JSON STRING %@", jsonString);
    
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        completionBlock(data, response, error);
        
    }];
    
    [postDataTask resume];
    
}
-(void)simpleGetMethod:(NSString*)WebserviceString WithCompletionBlock:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionBlock
{
    
    
    //    NSLog(@"WebserviceString---%@",WebserviceString);
    //    url = [NSURL URLWithString:WebserviceString];
    //
    //
    //    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
    //                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //
    //                                             completionBlock(data, response, error);
    //
    //                                          }];
    //
    //    [downloadTask resume];
    
   // NSLog(@"WebserviceString---%@",WebserviceString);
    
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    url = [NSURL URLWithString:WebserviceString];
    request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"loginAuthToken"] forHTTPHeaderField:@"AuthToken"];
    //[request setValue:@"0d7a5cba-ab62-46bd-b856-80cd13f9870a" forHTTPHeaderField:@"AuthToken"];
    
    
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        completionBlock(data, response, error);
        
    }];
    
    [getDataTask resume];
}


@end
