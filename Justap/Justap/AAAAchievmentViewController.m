//
//  AAAAchievmentViewController.m
//  Gamify
//
//  Created by Håkon Bogen on 13.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import "AAAAchievmentViewController.h"
#define RGBA( r, g, b, a ) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha: a]
#define RGB( r, g, b ) RGBA( r, g, b, 1.0f )
@interface AAAAchievmentViewController ()

@property (nonatomic,strong ) UILabel *playerUnlockedAchievementLabel;
@property (nonatomic,strong ) UILabel *titleLabel;
@property (nonatomic,strong ) UILabel *descriptionLabel;
@property (nonatomic,strong ) UIImageView *imageView;
@end

@implementation AAAAchievmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(closeViewController) withObject:nil afterDelay:2.2];
    
    self.playerUnlockedAchievementLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.playerUnlockedAchievementLabel];
    self.playerUnlockedAchievementLabel.text = @"Achievement unlocked";
    [self.playerUnlockedAchievementLabel setTextColor:RGB(106, 105, 103)];
    [self.playerUnlockedAchievementLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerUnlockedAchievementLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:30.0]];
    
    [self.playerUnlockedAchievementLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.playerUnlockedAchievementLabel
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:250.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.playerUnlockedAchievementLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = self.achievement.titleText;
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:35]];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.playerUnlockedAchievementLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:10.0]];
    
    [self.titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:250.0]];
    
    [self.titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:100.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.titleLabel updateConstraintsIfNeeded];
    
    self.imageView = [[UIImageView alloc]initWithImage:self.achievement.image];
    [self.view addSubview:self.imageView];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:250.0]];
    
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:260.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.titleLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.0]];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.descriptionLabel];
    self.descriptionLabel.text = self.achievement.descriptionText;
    [self.descriptionLabel setNumberOfLines:0];
    [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.descriptionLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:250.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.imageView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:20.0]];

    
 


    

	// Do any additional setup after loading the view.
}

- (void)closeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
