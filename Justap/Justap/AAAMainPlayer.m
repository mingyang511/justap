//
//  AAAMainPlayer.m
//  Gamify
//
//  Created by Håkon Bogen on 12.02.14.
//  Copyright (c) 2014 Haaakon Bogen. All rights reserved.
//

#import "AAAMainPlayer.h"

@implementation AAAMainPlayer

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_playerName forKey:@"playerName"];
    [aCoder encodeInteger:_playerScore forKey:@"playerScore"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.playerName = [aDecoder decodeObjectForKey:@"playerName"];
        self.playerScore = [aDecoder decodeIntegerForKey:@"playerScore"];
    }
    
    return self;
}
@end
