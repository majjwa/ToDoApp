//
//  TodoNotesViewController.m
//  toDoApplication
//
//  Created by marwa maky on 12/08/2024.
//

#import "TodoNotesViewController.h"

@interface TodoNotesViewController ()

@end

@implementation TodoNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addEditButton:(UIBarButtonItem *)sender {
    UIViewController *detailsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}


@end
