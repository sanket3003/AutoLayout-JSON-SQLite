//
//  ViewController.h
//  AutoLay
//
//  Created by Sanket Bhavsar on 12/24/15.
//  Copyright (c) 2015 Sanket Bhavsar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetchService.h"
#import "DBManager.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
{
    
    NSMutableDictionary *maindict;
    DataFetchService *dataFetchService;
    UIAlertView *alert;
    UIActivityIndicatorView *activityView;
}
@property(nonatomic,strong) IBOutlet UIButton *btn;
@property(nonatomic,strong) IBOutlet UITextField *txtFav;
@property(nonatomic,strong) IBOutlet UITextField *txtReg;
@property(nonatomic,strong) IBOutlet UITextField *email;
@property(nonatomic,strong) IBOutlet UITextField *passw;
@property(nonatomic,strong) IBOutlet UITextField *usename;
@property(nonatomic,strong) IBOutlet UITextField *gender;
@property(nonatomic,strong) IBOutlet UITextField *address;
@property int height;
@property int width;
@property(nonatomic,strong) NSString *token,*user,*pass;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet UITableView *tblUser;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
-(void)loadData;
@property(nonatomic,strong) IBOutlet UILabel *userid;
@property(nonatomic,strong) IBOutlet UILabel *username;
@property(nonatomic,strong) IBOutlet UILabel *emailid;
@property(nonatomic,strong) IBOutlet UILabel *password;
@property(nonatomic,strong) IBOutlet UILabel *add;
@property(nonatomic,strong) IBOutlet UILabel *gend;


-(IBAction)registeruser:(id)sender;
@end

