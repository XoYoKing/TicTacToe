//
//  TTTGame.h
//  TicTacToe
//
//  Created by Max Luzuriaga on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTTView.h"
@class TTTView;

@interface TTTGame : NSDocument {
    TTTView *gameView;
    NSMutableArray *tiles;
    NSArray *possibleSolutions;
    NSUInteger roundsPlayed;
}

@property (nonatomic, retain) NSMutableArray *tiles;
@property (assign) IBOutlet TTTView *gameView;

- (void)didSelectTileAtIndex:(NSUInteger)index;
- (BOOL)solutionReached;
- (NSUInteger)moveForComputer;

@end
