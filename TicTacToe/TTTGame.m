//
//  TTTGame.m
//  TicTacToe
//
//  Created by Max Luzuriaga on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTTGame.h"
#include <stdlib.h>

#define VERY_GOOD_MOVE_KEY @"VeryGoodMoveKey"
#define GOOD_MOVE_KEY @"GoodMoveKey"
#define OKAY_MOVE_KEY @"OkayMoveKey"

@implementation TTTGame

@synthesize gameView, tiles;

- (id)init
{
    self = [super init];
    if (self) {
        roundsPlayed = 0;
        
        tiles = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
        
        possibleSolutions = [[NSArray alloc] initWithObjects:
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:7], [NSNumber numberWithInt:8], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:3], [NSNumber numberWithInt:6], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:4], [NSNumber numberWithInt:7], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:5], [NSNumber numberWithInt:8], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:4], [NSNumber numberWithInt:8], nil],
                             [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:4], [NSNumber numberWithInt:6], nil],
                              nil];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"TTTGame";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (void)didSelectTileAtIndex:(NSUInteger)index
{
    roundsPlayed++;
    
    // Check to see if the tile is already in use
    if (!([tiles objectAtIndex:index] == @""))
        return;
    
    [tiles replaceObjectAtIndex:index withObject:@"X"];
    [gameView updateView];
    
    
    if (![self solutionReached]) {
        NSUInteger moveForComputer = [self moveForComputer];
        [tiles replaceObjectAtIndex:moveForComputer withObject:@"O"];
        
        [gameView updateView];
        [self solutionReached];
    }
}

- (BOOL)solutionReached
{
    for (NSArray *solution in possibleSolutions) {
        NSString *firstTile = [tiles objectAtIndex:[[solution objectAtIndex:0] intValue]];
        NSString *secondTile = [tiles objectAtIndex:[[solution objectAtIndex:1] intValue]];
        NSString *thirdTile = [tiles objectAtIndex:[[solution objectAtIndex:2] intValue]];
        
        BOOL userWon = ((firstTile == secondTile) && (secondTile == thirdTile) && (firstTile == @"X"));
        BOOL computerWon = ((firstTile == secondTile) && (secondTile == thirdTile) && (firstTile == @"O"));
        
        if (userWon) {
            gameView.frozen = YES;
            
            NSNumber *solutionIndex = [NSNumber numberWithInteger:[possibleSolutions indexOfObject:solution]];
            gameView.solutionIndex = solutionIndex;
                        
            [gameView updateView];
            
            NSAlert *alertView = [NSAlert alertWithMessageText:@"You Won!" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"I admit defeat. Machines indeed will never be as intellegent as our Human masters."];
            [alertView runModal];
            
            return YES;
        } else if (computerWon) {
            gameView.frozen = YES;
            
            NSNumber *solutionIndex = [NSNumber numberWithInteger:[possibleSolutions indexOfObject:solution]];
            gameView.solutionIndex = solutionIndex;
                        
            [gameView updateView];
            
            NSAlert *alertView = [NSAlert alertWithMessageText:@"I Won!" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Pitiful Human. Your kind will never beat the Machines."];
            [alertView runModal];
            
            return YES;
        }
    }
    
    BOOL draw = YES;
    for (NSString *tile in tiles) {
        if (tile == @"") {
            draw = NO;
            break;
        }
    }
    
    if (draw) {
        gameView.frozen = YES;
        
        NSAlert *alertView = [NSAlert alertWithMessageText:@"It's a draw!" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Truly we two races, Human and Machine, are equal."];
        [alertView runModal];
    }
    
    return draw;
}

- (NSUInteger)moveForComputer
{
    NSMutableDictionary *possibleTiles = [[NSMutableDictionary alloc] init];
    
    if (roundsPlayed == 1) {
        if ([tiles objectAtIndex:4] != @"") {
            // If center tile not available, choose one of the four corners
            NSArray *possibleCornerTiles = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:2], [NSNumber numberWithInt:6], [NSNumber numberWithInt:8], nil];
                        
            return [(NSNumber *)[possibleCornerTiles objectAtIndex:(arc4random() % 4)] intValue];
        } else {
            // Take the center tile if available on the first turn
            return 4;
        }
    } else {
        for (NSArray *solution in possibleSolutions) {
            NSNumber *firstIndex = [solution objectAtIndex:0];
            NSString *firstTile = [tiles objectAtIndex:[firstIndex intValue]];
            
            NSNumber *secondIndex = [solution objectAtIndex:1];
            NSString *secondTile = [tiles objectAtIndex:[secondIndex intValue]];
            
            NSNumber *thirdIndex = [solution objectAtIndex:2];
            NSString *thirdTile = [tiles objectAtIndex:[thirdIndex intValue]];
            
            // At first, try finishing off a solution
            if ((firstTile == @"") && (secondTile == @"O") && (thirdTile == @"O"))
                [possibleTiles setObject:firstIndex forKey:VERY_GOOD_MOVE_KEY];
            else if ((firstTile == @"O") && (secondTile == @"") && (thirdTile == @"O"))
                [possibleTiles setObject:secondIndex forKey:VERY_GOOD_MOVE_KEY];
            else if ((firstTile == @"O") && (secondTile== @"O") && (thirdTile == @""))
                [possibleTiles setObject:thirdIndex forKey:VERY_GOOD_MOVE_KEY];
            
            // If there is no open solution, try to stop the user from winning
            if ((firstTile == @"") && (secondTile == @"X") && (thirdTile == @"X"))
                [possibleTiles setObject:firstIndex forKey:GOOD_MOVE_KEY];
            else if ((firstTile == @"X") && (secondTile == @"") && (thirdTile == @"X"))
                [possibleTiles setObject:secondIndex forKey:GOOD_MOVE_KEY];
            else if ((firstTile == @"X") && (secondTile == @"X") && (thirdTile == @""))
                [possibleTiles setObject:thirdIndex forKey:GOOD_MOVE_KEY];
            
            // If none of those options are open, try filling in part of a solution with one O and nothing else
            else if ((firstTile == @"") && (secondTile == @"O") && (thirdTile == @""))
                [possibleTiles setObject:firstIndex forKey:OKAY_MOVE_KEY];
            else if ((firstTile == @"") && (secondTile == @"") && (thirdTile == @"O"))
                [possibleTiles setObject:secondIndex forKey:OKAY_MOVE_KEY];
            else if ((firstTile == @"O") && (secondTile == @"") && (thirdTile == @""))
                [possibleTiles setObject:thirdIndex forKey:OKAY_MOVE_KEY];
        }
    }
    
    // Decide which move is best
    NSUInteger selectedTile;
    
    if ([possibleTiles objectForKey:VERY_GOOD_MOVE_KEY] != nil)
        selectedTile = [(NSNumber *)[possibleTiles objectForKey:VERY_GOOD_MOVE_KEY] intValue];
    else if ([possibleTiles objectForKey:GOOD_MOVE_KEY] != nil)
        selectedTile = [(NSNumber *)[possibleTiles objectForKey:GOOD_MOVE_KEY] intValue];
    else if ([possibleTiles objectForKey:OKAY_MOVE_KEY] != nil)
        selectedTile = [(NSNumber *)[possibleTiles objectForKey:OKAY_MOVE_KEY] intValue];
    
    return selectedTile;
}

@end
