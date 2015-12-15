//
//  ViewController.m
//  sample
//
//  Created by Suparn Gupta on 11/12/15.
//  Copyright © 2015 Suparn Gupta. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *queryField;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *overlay;

@property (strong, nonatomic) NSArray<NSString*>* fullForms;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goTapped:(id)sender {
    NSString* query = self.queryField.text;
    [self search:query];
}

/**
 *  Triggers the search from the server
 *
 *  @param query the short form to be searched
 */
- (void)search: (NSString*) query {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.overlay.hidden = false;
    [[NetworkManager sharedInstance] fetchFullFormForShortForm:query completionHandler:^(NSError *error, NSArray<NSString *> *fullForms) {
        [self stopHUD];
        self.fullForms = fullForms;
        [self.tableView reloadData];
    }];
}

/**
 *  stop the animated HUD
 */
- (void) stopHUD {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.overlay.hidden = true;
        });
    });
}

/**
 *  End the editing to close keyboard
 *
 *  @param sender the top level view
 */
- (IBAction)viewTapped:(id)sender {
    NSLog(@"Tapped");
    [self.view endEditing:true];
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    if (self.fullForms){
        return self.fullForms.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.fullForms[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
