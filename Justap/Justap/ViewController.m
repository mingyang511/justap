//
//  ViewController.m
//  Justap
//
//  Created by Lee on 10/4/14.
//  Copyright (c) 2014 Mingyang. All rights reserved.
//

#import "ViewController.h"

#import "RQShineLabel.h"

#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *tapButton;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor colorWithRed:254/255.0
//                                                green:234/255.0
//                                                 blue:132/255.0
//                                                alpha:1];
    
    self.shineLabel.numberOfLines = 0;
    self.shineLabel.text = @"JusTap";
    [self.shineLabel sizeToFit];
    self.shineLabel.textColor = [UIColor colorWithRed:9/255.0 green:112/255.0 blue:84/255.0 alpha:1];
    self.shineLabel.center = self.view.center;
    [self.view addSubview:self.shineLabel];
    
//    self.tapButton.clipsToBounds = YES;
//    [self.tapButton setImage:[UIImage imageNamed:@"green.jpg"] forState:UIControlStateNormal];
    
    self.tapButton.buttonColor = [UIColor turquoiseColor];
    self.tapButton.shadowColor = [UIColor greenSeaColor];
    self.tapButton.shadowHeight = 10.0f;
    self.tapButton.cornerRadius = self.tapButton.frame.size.height/2;
//    self.tapButton.layer.borderColor = [UIColor blackColor].CGColor;
//    self.tapButton.layer.borderWidth = 1;
    self.tapButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.tapButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.tapButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)tapAction:(id)sender {
}

@end
