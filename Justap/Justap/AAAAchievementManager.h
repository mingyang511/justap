//
//  AAAAchievementManager.h
//  Gamify
//
//  Created by Håkon Bogen on 04.03.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAAAChievement.h"

@protocol AAAAchievementManagerDataSource;

@interface AAAAchievementManager : NSObject

@property (nonatomic,strong) id<AAAAchievementManagerDataSource> dataSource;

+ (AAAAchievementManager *)sharedManager;
- (void)showAchievementViewControllerOnViewController:(UIViewController*)viewController achievementKey:(NSString *)key;

@end

@protocol AAAAchievementManagerDataSource <NSObject>
- (AAAAchievement*)achievementForKey:(NSString *)key;
@end