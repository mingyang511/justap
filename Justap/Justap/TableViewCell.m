//
//  TableViewCell.m
//  Justap
//
//  Created by Lee on 10/5/14.
//  Copyright (c) 2014 Mingyang. All rights reserved.
//

#import "TableViewCell.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.button.buttonColor = [UIColor turquoiseColor];
    self.button.shadowColor = [UIColor greenSeaColor];
    self.button.shadowHeight = 4.0f;
    self.button.cornerRadius = 5;
    self.button.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed Medium" size:17];
    [self.button setTitle:@"Challenge" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    self.button.hidden = NO;
    self.button.userInteractionEnabled = YES;
    
    self.image.layer.cornerRadius = 22.5;
    self.image.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapped
{
    [self.delegate cellTapped:self];
}

- (void)getImageWithId:(NSString *)string
{
    /* make the API call */
    NSString *path = [NSString stringWithFormat:@"/%@/picture?redirect=false", string];
//    [FBRequestConnection startWithGraphPath:path
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                              NSLog(@"%@",result);
//                          }];
    
    [FBRequestConnection startWithGraphPath:path
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  self.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[result objectForKey:@"data"]objectForKey:@"url"]]]];
                              }
                          }];
}

@end
