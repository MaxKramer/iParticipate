//
//  IPMyConstituencyViewController.m
//  iParticipate
//
//  Created by Max Kramer on 16/11/2013.
//  Copyright (c) 2013 Max Kramer. All rights reserved.
//

#import "IPMyConstituencyViewController.h"
#import "IPChooseConstituencyViewController.h"

@interface IPMyConstituencyViewController ()

@end

@implementation IPMyConstituencyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
    IPChooseConstituencyViewController *chooseConstituency = [[IPChooseConstituencyViewController alloc] initWithNibName:NSStringFromClass([IPChooseConstituencyViewController class]) bundle:nil];
    [chooseConstituency setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:chooseConstituency animated:YES completion:nil];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
