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
#import "FUIAlertView.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

#import <POP/POP.h>

@interface ViewController () <FUIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *tapButton;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;

@property (weak, nonatomic) IBOutlet FUIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchingLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchedLabel;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (assign, nonatomic) NSInteger count;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.count = 5;
    self.shineLabel.hidden = NO;
    self.shineLabel.numberOfLines = 0;
    self.shineLabel.text = @"Tap";
    [self.shineLabel sizeToFit];
    self.shineLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.shineLabel.center = self.view.center;
    [self.view addSubview:self.shineLabel];
    
    [self prepareViews];
    
    CGRect frame = self.shineLabel.frame;
    frame.origin.y = 180;
    [self moveAnimation:self.shineLabel
                   from:self.shineLabel.frame
                     to:frame
                  begin:1.5
       springBounciness:5
            springSpeed:2];
    
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(startGuide)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shineLabel shine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)prepareViews
{
    self.tapButton.buttonColor = [UIColor turquoiseColor];
    self.tapButton.shadowColor = [UIColor greenSeaColor];
    self.tapButton.shadowHeight = 10.0f;
    self.tapButton.cornerRadius = self.tapButton.frame.size.height/2;
    self.tapButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.tapButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.tapButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.tapButton.hidden = YES;
    
    self.startButton.buttonColor = [UIColor turquoiseColor];
    self.startButton.shadowColor = [UIColor greenSeaColor];
    self.startButton.shadowHeight = 4.0f;
    self.startButton.cornerRadius = 5;
    self.startButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed Medium" size:17];
    [self.startButton setTitle:@"Start to tap" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.hidden = YES;
    
    self.countdownLabel.hidden = YES;
    self.countdownLabel.layer.cornerRadius = 30;
    self.countdownLabel.clipsToBounds = YES;
    
    self.startLabel.text = @"You won't regret it!";
    self.startLabel.hidden = YES;
    
    self.matchLabel.hidden = YES;
    self.matchLabel.text = @"Hold your horses, friendly opponent";
    
    self.matchingLabel.hidden = YES;
    self.matchingLabel.text = @"Opponent Loading ...";
    
    self.matchedLabel.hidden = YES;
    self.matchedLabel.text = @"Opponent Found!";
}

- (void)startGuide
{
//    self.startLabel.hidden = NO;
    self.startButton.hidden = NO;

    CGRect startButtonFrame = self.startButton.frame;
    self.startButton.frame =
    CGRectMake(startButtonFrame.origin.x + startButtonFrame.size.width/2,
               startButtonFrame.origin.y + startButtonFrame.size.height/2 , 0, 0);
    
//    CGRect startLabelFrame = self.startLabel.frame;
//    self.startLabel.frame =
//    CGRectMake(startLabelFrame.origin.x + startLabelFrame.size.width/2,
//               startLabelFrame.origin.y + startLabelFrame.size.height/2 , 0, 0);
    
    [self bounceAnimation:self.startButton
                     from:self.startButton.frame
                       to:startButtonFrame
                    begin:0.2
         springBounciness:10
              springSpeed:5];
}

- (void)startGame
{
    //Move out
    CGRect startButtonFrame = self.startButton.frame;
    CGRect startLabelFrame = self.startLabel.frame;
    
    startButtonFrame.origin.x = -startButtonFrame.size.width*2;
    startLabelFrame.origin.x = -startLabelFrame.size.width*2;
    
    [self moveAnimation:self.startButton
                   from:self.startButton.frame
                     to:startButtonFrame
                  begin:0.2
       springBounciness:2
            springSpeed:4];
    
    [self moveAnimation:self.startLabel
                   from:self.startLabel.frame
                     to:startLabelFrame
                  begin:0.2
       springBounciness:10
            springSpeed:5];
    
    [self showGame];
}

- (void)showGame
{
    CGRect frame = self.shineLabel.frame;
    frame.origin.y = 60;
    [self moveAnimation:self.shineLabel
                   from:self.shineLabel.frame
                     to:frame
                  begin:0.5
       springBounciness:5
            springSpeed:2];
    
    //Move in
    self.matchLabel.text = @"Hold your horses, friendly opponent";
    self.matchLabel.hidden = NO;
    
    [self.tapButton addTarget:self
                       action:@selector(matchOpponent)
             forControlEvents:UIControlEventTouchUpInside];
    self.tapButton.hidden = NO;
    
    CGRect tapButtonFrame = self.tapButton.frame;
    [self moveAnimation:self.tapButton
                   from:CGRectMake(320, tapButtonFrame.origin.y, tapButtonFrame.size.width, tapButtonFrame.size.height)
                     to:self.tapButton.frame
                  begin:1.0
       springBounciness:10
            springSpeed:5];
    
    CGRect matchLabelFrame = self.matchLabel.frame;
    matchLabelFrame.origin.x = 43;
    
    [self moveAnimation:self.matchLabel
                   from:CGRectMake(320, matchLabelFrame.origin.y, matchLabelFrame.size.width, matchLabelFrame.size.height)
                     to:matchLabelFrame
                  begin:1.0
       springBounciness:10
            springSpeed:5];
}

- (void)matchOpponent
{
    //Move out
    CGRect labelFrame = self.matchLabel.frame;
    labelFrame.origin.x = -labelFrame.size.width*2;
    [self moveAnimation:self.matchLabel
                   from:self.matchLabel.frame
                     to:labelFrame
                  begin:0.2
       springBounciness:10
            springSpeed:5];
    
    
    //Move in
    self.matchingLabel.hidden = NO;
    self.matchingLabel.text = @"Opponent Loading ...";
    
    [self.tapButton removeTarget:self
                          action:@selector(matchOpponent)
                forControlEvents:UIControlEventTouchUpInside];
    
    labelFrame = self.matchingLabel.frame;
    labelFrame.origin.x = 43;
    
    [self moveAnimation:self.matchingLabel
                   from:CGRectMake(320, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height)
                     to:labelFrame
                  begin:0.8
       springBounciness:10
            springSpeed:5];
    
    
    //For testing
    [NSTimer scheduledTimerWithTimeInterval:4
                                     target:self
                                   selector:@selector(matchedOpponent)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)matchedOpponent
{
    //Move out
    CGRect labelFrame = self.matchingLabel.frame;
    labelFrame.origin.x = -labelFrame.size.width*2;
    
    [self moveAnimation:self.matchingLabel
                   from:self.matchingLabel.frame
                     to:labelFrame
                  begin:0.2
       springBounciness:10
            springSpeed:5];
    
    
    //Move in
    self.matchedLabel.hidden = NO;
    self.matchedLabel.text = @"Opponent Found!";
    
    labelFrame = self.matchedLabel.frame;
    labelFrame.origin.x = 43;
    
    [self moveAnimation:self.matchedLabel
                   from:CGRectMake(320, labelFrame.origin.y, labelFrame.size.width, labelFrame.size.height)
                     to:labelFrame
                  begin:0.8
       springBounciness:10
            springSpeed:5];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(gameReady)
                                   userInfo:nil
                                    repeats:NO];
    

}

- (void)gameReady
{
    CGRect labelFrame = self.matchedLabel.frame;
    labelFrame.origin.x = -labelFrame.size.width*2;
    
    [self moveAnimation:self.matchedLabel
                   from:self.matchedLabel.frame
                     to:labelFrame
                  begin:0
       springBounciness:10
            springSpeed:5];
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(countdown:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)gameStarts
{
    self.scoreLabel.text = @"Score: 0";
    self.scoreLabel.hidden = NO;
    
    CGRect scoreLabelFrame = self.scoreLabel.frame;
    [self moveAnimation:self.scoreLabel
                   from:CGRectMake(320, scoreLabelFrame.origin.y, scoreLabelFrame.size.width, scoreLabelFrame.size.height)
                     to:self.scoreLabel.frame
                  begin:0
       springBounciness:10
            springSpeed:5];
    
    
    [self.tapButton addTarget:self
                       action:@selector(tapAction)
             forControlEvents:UIControlEventTouchUpInside];
    self.tapButton.hidden = NO;
}

- (void)countdown:(NSTimer *)timer
{
    if (--self.count < 0) {
        [timer invalidate];
        [self gameStarts];
        self.count = 5;
        self.countdownLabel.hidden = YES;
        return;
    } else {
        self.countdownLabel.hidden = NO;
    }
    self.countdownLabel.text =
    [NSString stringWithFormat:@"%ld", (long)self.count];
}

- (void)tapAction
{
    [self gameEnds];
}

- (void)gameEnds
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"You Win It!"
                                                          message:@"This is an alert view"
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:@"Play again", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.scoreLabel.hidden = YES;
    if (buttonIndex == 0) {
        [self.tapButton removeTarget:self
                              action:@selector(tapButton)
                    forControlEvents:UIControlEventTouchUpInside];
        [self showGame];
    } else if (buttonIndex == 1) {
        [self.tapButton removeTarget:self
                              action:@selector(tapButton)
                    forControlEvents:UIControlEventTouchUpInside];
        [self matchOpponent];
    }
}

- (void)winScore
{
    
}

- (void)looseScore
{
    
}

- (void)bounceAnimation:(UIView *)object
                   from:(CGRect)from
                     to:(CGRect)to
                  begin:(CGFloat)b
       springBounciness:(CGFloat)sb
            springSpeed:(CGFloat)ss
{
    object.frame = from;
    POPSpringAnimation *buttonBounceAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    buttonBounceAnimation.beginTime = CACurrentMediaTime() + b;
    buttonBounceAnimation.toValue = [NSValue valueWithCGRect:to];
    buttonBounceAnimation.springBounciness = sb;
    buttonBounceAnimation.springSpeed =ss;
    [object.layer pop_addAnimation:buttonBounceAnimation forKey:@"bounceAnimation"];
}

- (void)moveAnimation:(UIView *)object
                 from:(CGRect)from
                   to:(CGRect)to
                begin:(CGFloat)b
     springBounciness:(CGFloat)sb
          springSpeed:(CGFloat)ss
{
    object.frame = from;
    POPSpringAnimation *buttonBounceAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    buttonBounceAnimation.beginTime = CACurrentMediaTime() + b;
    buttonBounceAnimation.toValue = [NSValue valueWithCGRect:to];
    buttonBounceAnimation.springBounciness = sb;
    buttonBounceAnimation.springSpeed = ss;
    [object.layer pop_addAnimation:buttonBounceAnimation forKey:@"moveAnimation"];
}


@end
