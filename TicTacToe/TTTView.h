//
//  TTTView.h
//  TicTacToe
//
//  Created by Max Luzuriaga on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTTGame.h"
@class TTTGame;

@interface TTTView : NSView {
    TTTGame *theGame;
    
    NSUInteger mouseDownTile;
    NSNumber *solutionIndex;
    
    NSArray *tileMouseRects;
    NSArray *tileDrawRects;
    NSArray *solutions;
    
    BOOL frozen;
}

@property (assign) IBOutlet TTTGame *theGame;
@property (nonatomic) BOOL frozen;
@property (nonatomic, retain) NSNumber *solutionIndex;

- (void)updateView;

@end
