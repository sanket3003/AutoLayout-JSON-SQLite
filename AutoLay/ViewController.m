//
//  ViewController.m
//  AutoLay
//
//  Created by Sanket Bhavsar on 12/24/15.
//  Copyright (c) 2015 Sanket Bhavsar. All rights reserved.
//

#import "ViewController.h"
//#define kOFFSET_FOR_KEYBOARD 1.0

@interface ViewController ()
{
    int temp;
    NSString *strToken, *strMessage, *code, *exMessage;
}
@end

@implementation ViewController
@synthesize height,width,txtReg,txtFav,usename,passw,email,gender,address,user,pass;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //JSON
    dataFetchService = [[DataFetchService alloc]init];
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    [self.view addSubview:activityView];
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    [self loadData];
}

-(IBAction)registeruser:(id)sender
{
    [activityView startAnimating];
    NSString *wbsUrlName =@"http://pad.dweb.in/api/Security/Registration";

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:usename.text,@"AccountName",@"Sanket",@"FullName",gender.text,@"Gender",address.text,@"Address",@"1",@"RegionId",@"1,2,4",@"SelectedCenters",email.text,@"Email",passw.text,@"Password",@"9865466565",@"PhoneNumber",nil];
    
    [dataFetchService simplePostMethod:dict WebServiceName:wbsUrlName WithCompletionBlock:^(NSData *data,NSURLResponse *response,NSError *error)
     {
         if(!error)
         {
             NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&error];
             NSLog(@" Login JSON Response is: %@",jsonResponse);
             code = [jsonResponse valueForKey:@"Code"];
             if ([code  isEqual: @"1"]) {
                 strToken = [jsonResponse valueForKey:@"Token"];
                 strMessage = [jsonResponse valueForKey:@"Message"];
                 alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alert show];
                 [activityView stopAnimating];
                 
                 //Inserting data into the dataBase
                 // Prepare the query string.
                 NSString *query = [NSString stringWithFormat:@"insert into userInfo values(null, '%@', '%@','%@','%@','%@')", usename.text, email.text, passw.text, gender.text, address.text];
                 
                 // Execute the query.
                 [self.dbManager executeQuery:query];
                 
                 // If the query was successfully executed then pop the view controller.
                 if (self.dbManager.affectedRows != 0) {
                     NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
                     
                     // Pop the view controller.
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else{
                     NSLog(@"Could not execute the query.");
                 }
                 
                 [self loadData];
             }
             else
             {
                 exMessage = [jsonResponse valueForKey:@"ExceptionMessage"];
                 strMessage = [jsonResponse valueForKey:@"Message"];
                 if (exMessage) {
                     alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:exMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [alert show];
                 }
                 else {
                     alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:strMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [alert show];
                 }
                 [activityView stopAnimating];
             }
             
         }
         
     }];
    
    
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    height = MIN(keyboardSize.height,keyboardSize.width);
    width = MAX(keyboardSize.height,keyboardSize.width);
    NSLog(@"%d",height);
    [self.view layoutIfNeeded];
    temp = self.bottom.constant;
    [UIView animateWithDuration:0.5
                     animations:^{
                         if(txtFav.isEditing || txtReg.isEditing)
                         {
                             self.bottom.constant = height + 20;
                         }
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
}


-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2
                     animations:^{
                         // Called on parent view
                         self.bottom.constant =temp;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPeopleInfo.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    NSInteger indexOfuserName = [self.dbManager.arrColumnNames indexOfObject:@"userName"];
    NSInteger indexOfemailId = [self.dbManager.arrColumnNames indexOfObject:@"emailId"];
    NSInteger indexOfpassWord = [self.dbManager.arrColumnNames indexOfObject:@"passWord"];
    NSInteger indexOfgender = [self.dbManager.arrColumnNames indexOfObject:@"gender"];
    NSInteger indexOfaddress = [self.dbManager.arrColumnNames indexOfObject:@"address"];
    //NSInteger indexOfuserId = [self.dbManager.arrColumnNames indexOfObject:@"userId"];
    //cell.textLabel.text = [NSString stringWithFormat:@"UserName: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfuserName]];
    
    //self.userid = (UILabel *)[cell viewWithTag:10];
    //self.userid.text = [NSString stringWithFormat:@"UserID: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfuserId]];
    
    self.userid = (UILabel *)[cell viewWithTag:20];
    self.userid.text = [NSString stringWithFormat:@"UserName: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfuserName]];
    
    self.userid = (UILabel *)[cell viewWithTag:30];
    self.userid.text = [NSString stringWithFormat:@"Email: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfemailId]];
    
    self.userid = (UILabel *)[cell viewWithTag:40];
    self.userid.text = [NSString stringWithFormat:@"Password: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfpassWord]];
    self.userid = (UILabel *)[cell viewWithTag:50];
    self.userid.text = [NSString stringWithFormat:@"Address: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfaddress]];
    
    self.userid = (UILabel *)[cell viewWithTag:60];
    self.userid.text = [NSString stringWithFormat:@"Gender: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfgender]];
    
    return cell;
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from userInfo";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblUser reloadData];
}
@end
