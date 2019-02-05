//
//  MCPPickerComponents.h
//  LexusLoyalty
//
//  Created by Mario Chinchilla PlanetMedia on 20/11/15.
//  Copyright © 2015 Mario. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCPPickerComponents : NSObject

//! Índice del componente del día en el picker
@property (nonatomic, assign) NSInteger dayComponent;
//! Índice del componente del mes en el picker
@property (nonatomic, assign) NSInteger monthComponent;
//! Índice del componente del año en el picker
@property (nonatomic, assign) NSInteger yearComponent;
//! Índice del componente de la hora en el picker
@property (nonatomic, assign) NSInteger hourComponent;
//! Índice del componente de los minutos en el picker
@property (nonatomic, assign) NSInteger minuteComponent;

-(id)initWithDateFormatSymbolsArray:(NSArray*)symbolsArray;
-(void)fillWithDateFormatSimbolsArray:(NSArray*)symbolsArray;

@end
