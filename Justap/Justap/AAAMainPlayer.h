//
//  AAAMainPlayer.h
//  Gamify
//
//  Created by Håkon Bogen on 12.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAAMainPlayer : NSObject<NSCoding>
@property (nonatomic,strong) NSString *playerName;
@property (nonatomic) NSInteger playerScore;
@end
