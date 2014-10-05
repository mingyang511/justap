//
//  AAAGamificationManager.h
//  Gamify
//
//  Created by Håkon Bogen on 12.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAAChievement.h"
#import "AAAScoreView.h"
@interface AAAGamificationManager : NSObject

@property (nonatomic,weak) AAAScoreView *scoreView;

+ (AAAGamificationManager *)sharedManager; 
/**
 *  Sets the scoreview to update whenever the main players score
 *  changes.
 *
 *  @param scoreview that should show the players score
 */
- (void)setScoreView:(AAAScoreView *)scoreView;
/**
 *  Sets score as the main players current score, 
 *  disregarding what the score was previously
 *  If main players score is 15, setMainPlayersScore is called with 5
 */
- (void)initialSetScoreNoAnimation;
/**
 *  Sets score as the main players current score, 
 *  disregarding what the score was previously
 *  If main players score is 15, setMainPlayersScore is called with 5
 *  main players score should be 5 after method is run
 *
 *  @param score to set as main players score
 */
- (void)setMainPlayersScore:(NSInteger)score;
/**
 *  Adds the score to the main players current score. 
 *  If main players score is 15, addToMainPlayersScore is called with 5
 *  main players score should be 20 after method is run
 *
 *  @param score to add to existing players score
 */
- (void)addToMainPlayerScore:(NSInteger)score;
/**
 *  Current score of the main player in the app, this
 *  score is automatically stored using nscoding.
 *
 *  @return the score of the player
 */
- (NSInteger)mainPlayerScore;

@end
