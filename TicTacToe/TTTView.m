//
//  TTTView.m
//  TicTacToe
//
//  Created by Max Luzuriaga on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TTTView.h"

#define SOLUTION_IMAGE_NAME_KEY @"solutionImageNameKey"
#define SOLUTION_RECT_KEY @"solutionRectKey"

@implementation TTTView

@synthesize theGame, frozen, solutionIndex;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        solutionIndex = nil;
        
        // Rects that the user can click on
        NSString *tileOneRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(0, 215, 105, 105)));
        NSString *tileTwoRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 215, 90, 105)));
        NSString *tileThreeRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 215, 105, 105)));
        NSString *tileFourRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(0, 115, 105, 90)));
        NSString *tileFiveRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 115, 90, 90)));
        NSString *tileSixRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 115, 105, 90)));
        NSString *tileSevenRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(0, 0, 105, 105)));
        NSString *tileEightRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 0, 90, 105)));
        NSString *tileNineRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 0, 105, 105)));
        
        tileMouseRects = [[NSArray alloc] initWithObjects:tileOneRect, tileTwoRect, tileThreeRect, tileFourRect, tileFiveRect, tileSixRect, tileSevenRect, tileEightRect, tileNineRect, nil];
        
        // Rects to display Xs and Os
        tileOneRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 215, 90, 90)));
        tileTwoRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 215, 90, 90)));
        tileThreeRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 215, 90, 90)));
        tileFourRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 115, 90, 90)));
        tileFiveRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 115, 90, 90)));
        tileSixRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 115, 90, 90)));
        tileSevenRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 15, 90, 90)));
        tileEightRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 15, 90, 90)));
        tileNineRect = NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 15, 90, 90)));
        
        tileDrawRects = [[NSArray alloc] initWithObjects:tileOneRect, tileTwoRect, tileThreeRect, tileFourRect, tileFiveRect, tileSixRect, tileSevenRect, tileEightRect, tileNineRect, nil];
        
        // Array of possible solutions and how to display them        
        NSDictionary *solutionOne = [[NSDictionary alloc] initWithObjectsAndKeys:@"horizontalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 215, 305, 90))), SOLUTION_RECT_KEY, nil];
        NSDictionary *solutionTwo = [[NSDictionary alloc] initWithObjectsAndKeys:@"horizontalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 115, 305, 90))), SOLUTION_RECT_KEY, nil];
        NSDictionary *solutionThree = [[NSDictionary alloc] initWithObjectsAndKeys:@"horizontalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 15, 305, 90))), SOLUTION_RECT_KEY, nil];
        
        NSDictionary *solutionFour = [[NSDictionary alloc] initWithObjectsAndKeys:@"verticalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 15, 90, 305))), SOLUTION_RECT_KEY, nil];
        NSDictionary *solutionFive = [[NSDictionary alloc] initWithObjectsAndKeys:@"verticalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(115, 15, 90, 305))), SOLUTION_RECT_KEY, nil];
        NSDictionary *solutionSix = [[NSDictionary alloc] initWithObjectsAndKeys:@"verticalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(215, 15, 90, 305))), SOLUTION_RECT_KEY, nil];
        
        NSDictionary *solutionSeven = [[NSDictionary alloc] initWithObjectsAndKeys:@"leftDiagonalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 15, 290, 290))), SOLUTION_RECT_KEY, nil];
        NSDictionary *solutionEight = [[NSDictionary alloc] initWithObjectsAndKeys:@"rightDiagonalLine", SOLUTION_IMAGE_NAME_KEY, NSStringFromRect(NSRectFromCGRect(CGRectMake(15, 15, 290, 290))), SOLUTION_RECT_KEY, nil];
        
        solutions = [[NSArray alloc] initWithObjects:solutionOne, solutionTwo, solutionThree, solutionFour, solutionFive, solutionSix, solutionSeven, solutionEight, nil];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Place background image
    NSImage *backgroundImage = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"TTTBackground" withExtension:@"png"]];
    [backgroundImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    // Draw appropriate Xs and Os
    NSInteger indexCounter = 0;
    
    for (NSString *tile in [theGame tiles]) {
        if (tile == @"X") {
            NSRect targetRect = NSRectFromString([tileDrawRects objectAtIndex:indexCounter]);
            NSImage *xImage = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"TTTX" withExtension:@"png"]];
            
            [xImage drawInRect:targetRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        } else if (tile == @"O") {
            NSRect targetRect = NSRectFromString([tileDrawRects objectAtIndex:indexCounter]);
            NSImage *oImage = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"TTTO" withExtension:@"png"]];
            
            [oImage drawInRect:targetRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
        indexCounter++;
    }
    
    // Draw appropriate lines for win or lose
    if (solutionIndex == nil)
        return;
    
    NSDictionary *solution = [solutions objectAtIndex:[solutionIndex integerValue]];
    
    NSString *lineImageName = [solution objectForKey:SOLUTION_IMAGE_NAME_KEY];
    NSImage *lineImage = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:lineImageName withExtension:@"png"]];
    
    NSRect targetRect = NSRectFromString([solution objectForKey:SOLUTION_RECT_KEY]);
    
    [lineImage drawInRect:targetRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (!frozen) {
        NSPoint mouseDownPoint = [theEvent locationInWindow];
        mouseDownPoint = [self convertPoint:mouseDownPoint fromView:nil];
        
        for (NSString *tileString in tileMouseRects) {
            NSRect theRect = NSRectFromString(tileString);
            if (NSPointInRect(mouseDownPoint, theRect)) {
                mouseDownTile = [tileMouseRects indexOfObject:tileString];
                break;
            }
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (!frozen) {
        // Check to make sure the user didn't move the cursor since mousing down
        NSPoint mouseDownPoint = [theEvent locationInWindow];
        mouseDownPoint = [self convertPoint:mouseDownPoint fromView:nil];
        
        for (NSString *tileString in tileMouseRects) {
            NSRect theRect = NSRectFromString(tileString);
            if (NSPointInRect(mouseDownPoint, theRect)) {
                if (([tileMouseRects indexOfObject:tileString]) == mouseDownTile) {
                    [theGame didSelectTileAtIndex:mouseDownTile];
                }
                break;
            }
        }
    }
}

- (void)updateView
{
    [self setNeedsDisplay:YES];
}

@end
