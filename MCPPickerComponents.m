//
//  MCPPickerComponents.m
//  LexusLoyalty
//
//  Created by Mario Chinchilla PlanetMedia on 20/11/15.
//  Copyright © 2015 Mario. All rights reserved.
//

#import "MCPPickerComponents.h"

@implementation MCPPickerComponents

-(id)initWithDateFormatSymbolsArray:(NSArray*)symbolsArray{
    
    self = [super init];
    if(!self) return nil;
    
    [self fillWithDateFormatSimbolsArray:symbolsArray];
    
    return self;
}

#pragma mark - Fill methods

-(void)fillWithDateFormatSimbolsArray:(NSArray*)symbolsArray{
    self.dayComponent   = [symbolsArray indexOfObject:@"d"];
    self.monthComponent = [symbolsArray indexOfObject:@"M"];
    self.yearComponent  = [symbolsArray indexOfObject:@"y"];
    self.minuteComponent = [symbolsArray indexOfObject:@"m"];
    self.hourComponent  = [symbolsArray indexOfObject:@"H"];
    if (self.hourComponent == NSNotFound)
        self.hourComponent = [symbolsArray indexOfObject:@"h"];
}

@end
