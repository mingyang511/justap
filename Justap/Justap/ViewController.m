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

#import "AAAGamificationManager.h"
#import "TableViewCell.h"
#import "TTCounterLabel.h"

#import <Firebase/Firebase.h>
#import <POP/POP.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController () <FUIAlertViewDelegate, FBLoginViewDelegate, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, TTCounterLabelDelegate,TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *tapButton;
@property (weak, nonatomic) IBOutlet RQShineLabel *shineLabel;

@property (weak, nonatomic) IBOutlet FUIButton *startButton;
@property (weak, nonatomic) IBOutlet FUIButton *challengeButton;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreChangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchingLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchedLabel;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableVIew;
@property (weak, nonatomic) IBOutlet FUIButton *inviteButton;
@property (weak, nonatomic) IBOutlet TTCounterLabel *gameCountDownLabel;


@property (strong, nonatomic) NSArray *friends;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger score;

@property NSString *userId;
@property NSString *oppId;
@property (assign) NSInteger goodBit;
@property NSString *matchId;
@property (assign) NSInteger currentStatus;
@property Firebase *scoreRef;
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
    
    self.friends = [[NSArray alloc] init];
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
    self.friendsTableVIew.hidden = YES;
    self.score = 0;
    self.scoreLabel.text = @"Score: 0";
    self.scoreLabel.hidden = YES;
    self.scoreChangeLabel.text = @"";
    self.scoreChangeLabel.hidden = YES;
    
//    self.gameCountDownLabel.hidden = YES;
    self.gameCountDownLabel.countdownDelegate = self;
    [self.gameCountDownLabel setBoldFont:[UIFont fontWithName:@"Avenir Next Condensed Medium" size:24]];
    [self.gameCountDownLabel setRegularFont:[UIFont fontWithName:@"Avenir Next Condensed" size:24]];
    [self.gameCountDownLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed Medium" size:15]];
    self.gameCountDownLabel.textColor = [UIColor blackColor];
    self.gameCountDownLabel.startValue = 60000;
    self.gameCountDownLabel.displayMode = kDisplayModeFull;
    self.gameCountDownLabel.countDirection = kCountDirectionDown;
    self.gameCountDownLabel.hidden = YES;
    [self.gameCountDownLabel updateApperance];
    
    [self updateUiToNetural];
    self.tapButton.userInteractionEnabled = YES;
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
    [self.startButton setTitle:@"Play now" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.hidden = YES;
    
    self.challengeButton.buttonColor = [UIColor turquoiseColor];
    self.challengeButton.shadowColor = [UIColor greenSeaColor];
    self.challengeButton.shadowHeight = 4.0f;
    self.challengeButton.cornerRadius = 5;
    self.challengeButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed Medium" size:17];
    [self.challengeButton setTitle:@"Challenge a friend" forState:UIControlStateNormal];
    [self.challengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.challengeButton addTarget:self action:@selector(showChallenge) forControlEvents:UIControlEventTouchUpInside];
    self.challengeButton.hidden = YES;
    
    self.inviteButton.buttonColor = [UIColor colorFromHexCode:@"6495ED"];
    self.inviteButton.shadowColor = [UIColor colorFromHexCode:@"4169E1"];
    self.inviteButton.shadowHeight = 4.0f;
    self.inviteButton.cornerRadius = 5;
    self.inviteButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed Medium" size:17];
    [self.inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    [self.inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.inviteButton addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
    self.inviteButton.hidden = YES;

    self.loginView.hidden = YES;
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
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
    self.startButton.hidden = NO;
    self.challengeButton.hidden = NO;

    CGRect startButtonFrame = self.startButton.frame;
    self.startButton.frame =
    CGRectMake(startButtonFrame.origin.x + startButtonFrame.size.width/2,
               startButtonFrame.origin.y + startButtonFrame.size.height/2 , 0, 0);
   
    CGRect challengeButtonFrame = self.challengeButton.frame;
    self.challengeButton.frame =
    CGRectMake(challengeButtonFrame.origin.x + challengeButtonFrame.size.width/2,
               challengeButtonFrame.origin.y + challengeButtonFrame.size.height/2 , 0, 0);
    
    [self bounceAnimation:self.startButton
                     from:self.startButton.frame
                       to:startButtonFrame
                    begin:0.2
         springBounciness:10
              springSpeed:5];
    
    [self bounceAnimation:self.challengeButton
                     from:self.challengeButton.frame
                       to:challengeButtonFrame
                    begin:0.2
         springBounciness:10
              springSpeed:5];
}

- (void)startGame
{
    //Move out
    CGRect startButtonFrame = self.startButton.frame;
    CGRect startLabelFrame = self.startLabel.frame;
    CGRect challengeButtonFrame = self.challengeButton.frame;
    
    startButtonFrame.origin.x = -startButtonFrame.size.width*2;
    startLabelFrame.origin.x = -startLabelFrame.size.width*2;
    challengeButtonFrame.origin.x = -startLabelFrame.size.width*2;
    
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
    
    [self moveAnimation:self.challengeButton
                   from:self.challengeButton.frame
                     to:challengeButtonFrame
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
    
    // Create a reference to a Firebase location
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://shining-fire-3470.firebaseio.com/"];
    // Write data to Firebase
    Firebase *userRef = [[myRootRef childByAppendingPath:@"users"] childByAutoId];
    [userRef setValue:@{@"name": @"testing in progress!"}];
    self.userId = userRef.name;
    
    Firebase* statusRef = [userRef childByAppendingPath:@"state"];
    // Write a string when this client loses connection
    [statusRef onDisconnectSetValue:@"disconnect"];
    

    // Read data and react to changes
    [userRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value[@"state"] && [snapshot.value[@"state"] isEqualToString:@"match"]) {
            self.matchId = [snapshot.value[@"matches"] allKeys][0];
            self.goodBit = ((NSNumber *)(snapshot.value[@"matches"][self.matchId])).integerValue;
            Firebase * matchRef = [[myRootRef childByAppendingPath:@"matches"] childByAppendingPath:self.matchId];
            self.scoreRef = [[matchRef childByAppendingPath:self.userId] childByAppendingPath:@"score"];
            [self.scoreRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                [self updateScore:((NSNumber *)snapshot.value).integerValue];
            }];
            Firebase *statusRef = [matchRef childByAppendingPath:@"status"];
            [statusRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                [self statusChangeListener:((NSNumber *)snapshot.value).integerValue];
            }];
            
            [matchRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSDictionary *val = snapshot.value;
                NSArray *keys = [val allKeys];
                for (NSString *key in keys) {
                    if (!([key isEqualToString:@"status"] || [key isEqualToString:self.userId])) {
                        self.oppId = key;
                    }
                }
                [matchRef removeAllObservers];
                [[[[myRootRef childByAppendingPath:@"users"] childByAppendingPath:self.oppId] childByAppendingPath:@"state"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    if ([snapshot.value isEqualToString:@"disconnect"]) {
                        [self pauseGame];
                        [[[[myRootRef childByAppendingPath:@"users"] childByAppendingPath:self.oppId] childByAppendingPath:@"state"] setValue:@"match"];
                    } else {
                        [self resumeGame];
                    }
                }];
            }];
            
            [self matchedOpponent];
        }
    }];
    
    
}

- (void)statusChangeListener:(NSInteger)newStatus
{
    self.currentStatus = newStatus;
    NSLog(@"%d", self.currentStatus);
    if (newStatus != 0) {
        if (newStatus == self.goodBit) {
            [self updateUiToGood];
        } else {
            [self updateUiToBad];
        }
    } else {
        [self updateUiToNetural];
    }
}

-(void)pauseGame
{
    
}

-(void)resumeGame
{
    
}

- (void)updateUiToNetural
{
    self.tapButton.userInteractionEnabled = NO;
    self.tapButton.buttonColor = [UIColor colorFromHexCode:@"6495ED"];
    self.tapButton.shadowColor = [UIColor colorFromHexCode:@"4169E1"];
}

- (void)updateUiToGood
{
    self.tapButton.buttonColor = [UIColor colorFromHexCode:@"1ABC9C"];
    self.tapButton.shadowColor = [UIColor colorFromHexCode:@"16A085"];
}

- (void)updateUiToBad
{
    self.tapButton.buttonColor = [UIColor colorFromHexCode:@"FF6347"];
    self.tapButton.shadowColor = [UIColor colorFromHexCode:@"FF4500"];
}

- (void)updateScore:(NSInteger)score
{
    NSInteger difference = score - self.score;
    self.score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.scoreChangeLabel.alpha = 1;
    self.scoreChangeLabel.hidden = NO;
    
    if (difference > 0) {
        self.scoreChangeLabel.text = [@"+" stringByAppendingFormat:@"%d", difference];
        self.scoreChangeLabel.textColor =[UIColor colorFromHexCode:@"1ABC9C"];
        
        CGRect frame = self.scoreLabel.frame;
        frame.origin.y -= 20;
        [self moveAnimation:self.scoreChangeLabel
                       from:self.scoreLabel.frame
                         to:frame
                      begin:0
           springBounciness:0
                springSpeed:2];
    } else if (difference < 0) {
        self.scoreChangeLabel.text = [@"" stringByAppendingFormat:@"%d", difference];
        self.scoreChangeLabel.textColor =[UIColor colorFromHexCode:@"FF6347"];
        
        CGRect frame = self.scoreLabel.frame;
        frame.origin.y += 20;
        [self moveAnimation:self.scoreChangeLabel
                       from:self.scoreLabel.frame
                         to:frame
                      begin:0
           springBounciness:0
                springSpeed:2];
    }
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.beginTime = CACurrentMediaTime() + 0.5;
    anim.fromValue = @(1.0);
    anim.toValue = @(0.0);
    [self.scoreChangeLabel pop_addAnimation:anim forKey:@"fade"];
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
    [self.gameCountDownLabel start];
    self.scoreLabel.hidden = NO;
    self.gameCountDownLabel.hidden = NO;
    self.tapButton.userInteractionEnabled = YES;
    
    CGRect scoreLabelFrame = self.scoreLabel.frame;
    [self moveAnimation:self.scoreLabel
                   from:CGRectMake(320, scoreLabelFrame.origin.y,
                                   scoreLabelFrame.size.width, scoreLabelFrame.size.height)
                     to:self.scoreLabel.frame
                  begin:0
       springBounciness:10
            springSpeed:5];
    
    CGRect countLabelFrame = self.gameCountDownLabel.frame;
    [self moveAnimation:self.gameCountDownLabel
                   from:CGRectMake(-countLabelFrame.size.width, countLabelFrame.origin.y,
                                   countLabelFrame.size.width, countLabelFrame.size.height)
                     to:self.gameCountDownLabel.frame
                  begin:0
       springBounciness:10
            springSpeed:5];
    
    [self.tapButton addTarget:self
                       action:@selector(tapAction)
             forControlEvents:UIControlEventTouchUpInside];
    self.tapButton.hidden = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:0.3
                                     target:self
                                   selector:@selector(timeTick)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)timeTick
{
    NSInteger change = 0;
    if (self.currentStatus == self.goodBit) {
        change = 5;
    } else {
        change = -5;
    }
    [self.scoreRef setValue:[NSNumber numberWithInteger:(self.score + change)]];
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
    // Create a reference to a Firebase location
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://shining-fire-3470.firebaseio.com/"];
    
    Firebase *matchRef = [myRootRef childByAppendingPath:[@"matches/" stringByAppendingString:self.matchId]];
    Firebase *statusRef = [matchRef childByAppendingPath:@"status"];
    if (self.currentStatus == 0) {
        self.currentStatus = self.goodBit;
        [statusRef setValue:[NSNumber numberWithInteger:self.goodBit]];
    } else {
        [statusRef setValue:[NSNumber numberWithInteger:(-self.currentStatus)]];
    }
}

- (void)gameEnds
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"You Win It!"
                                                          message:@"This is an alert view"
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:@"Play again", nil];
    alertView.tag = 1;
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

//Challenge
- (void)countdownDidEndForSource:(TTCounterLabel *)source
{
    NSLog(@"ends");
}

- (void)showChallenge
{
    CGRect startButtonFrame = self.startButton.frame;
    CGRect challengeButtonFrame = self.challengeButton.frame;
    
    startButtonFrame.origin.x = -startButtonFrame.size.width*2;
    challengeButtonFrame.origin.x = -challengeButtonFrame.size.width*2;
    
    [self moveAnimation:self.startButton
                   from:self.startButton.frame
                     to:startButtonFrame
                  begin:0.2
       springBounciness:2
            springSpeed:4];
    
    [self moveAnimation:self.challengeButton
                   from:self.challengeButton.frame
                     to:challengeButtonFrame
                  begin:0.2
       springBounciness:10
            springSpeed:5];
    
    
    if (![self isFacebookLoggedIn]) {
        [self showFacebookLogin];
    } else {
//        CGRect startLabelFrame = self.startLabel.frame;
//        startLabelFrame.origin.x = -startLabelFrame.size.width*2;
//        [self moveAnimation:self.startLabel
//                       from:self.startLabel.frame
//                         to:startLabelFrame
//                      begin:0
//           springBounciness:10
//                springSpeed:5];
        
        CGRect frame = self.shineLabel.frame;
        frame.origin.y = 60;
        [self moveAnimation:self.shineLabel
                       from:self.shineLabel.frame
                         to:frame
                      begin:0.5
           springBounciness:5
                springSpeed:2];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadFacebookFriends) userInfo:nil repeats:NO];
    }
}

- (BOOL)isFacebookLoggedIn
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *session = [ud objectForKey:@"Facebook"];
    
    if (session && ![session isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (void)showFacebookLogin
{
    self.loginView.hidden = NO;
    CGRect toFrame = self.loginView.frame;
    CGRect fromFrame = self.loginView.frame;
    fromFrame.origin.x = 320;
    [self moveAnimation:self.loginView
                   from:fromFrame
                     to:toFrame
                  begin:0.5
       springBounciness:5
            springSpeed:2];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"123" forKey:@"Facebook"];
}

- (void)managedToLogin
{
    [self loadFacebookFriends];
}

- (void)failedToLogin
{
    
}

- (void)loadFacebookFriends
{
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              if (error) {
                                  [self failedToLoadFacebookFriends:error];
                              } else {
                                  [self managedToLoadFacebookFriends:result];
                              }
                          }];
}

- (void)managedToLoadFacebookFriends:(id)result
{
    NSLog(@"%@",result);
    self.friends = [result objectForKey:@"data"];
    self.friendsTableVIew.hidden = NO;
    [self.friendsTableVIew reloadData];
    
    self.inviteButton.hidden = NO;
    self.inviteButton.frame = CGRectMake(20,
                                         //self.friendsTableVIew.frame.origin.y + self.friends.count * 62 + 10,
                                         self.view.frame.size.height -60,
                                         280,
                                         40);
}

- (void)failedToLoadFacebookFriends:(NSError *)error
{
    
}

- (void)invite:(id)sender
{
    
}

- (void)showPause
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Resume"
                                                          message:@"This is an alert view"
                                                         delegate:self
                                                cancelButtonTitle:@"Stop"
                                                otherButtonTitles:@"Continue", nil];
    alertView.tag = 2;
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
    if (alertView.tag == 1) {//End
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
    } else if (alertView.tag == 2) {
        if (buttonIndex == 0) {//Stop
            [self.tapButton removeTarget:self
                                  action:@selector(tapButton)
                        forControlEvents:UIControlEventTouchUpInside];
            [self showGame];
        } else if (buttonIndex == 1) {//Resume
        }
    }
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCell";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSDictionary *dic = [self.friends objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.name.text =[dic objectForKey:@"name"];
    [cell getImageWithId:[dic objectForKey:@"id"]];
    
    return cell;
}

- (void)cellTapped:(TableViewCell *)cell
{
    
}

- (void)updateUIForState:(NSInteger)state withSource:(TTCounterLabel *)label {
    switch (state) {
//        case kTTCounterRunning:
//            [_startStopButton setTitle:NSLocalizedString(@"Stop", @"Stop") forState:UIControlStateNormal];
//            _resetButton.hidden = YES;
//            break;
//            
//        case kTTCounterStopped:
//            [_startStopButton setTitle:NSLocalizedString(@"Resume", @"Resume") forState:UIControlStateNormal];
//            _resetButton.hidden = NO;
//            break;
//            
//        case kTTCounterReset:
//            [_startStopButton setTitle:NSLocalizedString(@"Start", @"Start") forState:UIControlStateNormal];
//            _resetButton.hidden = YES;
//            _startStopButton.hidden = NO;
//            break;
//            
//        case kTTCounterEnded:
//            _startStopButton.hidden = YES;
//            _resetButton.hidden = NO;
//            break;
//            
//        default:
//            break;
    }
}

@end
