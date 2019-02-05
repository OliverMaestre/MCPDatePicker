//
//  MCPDatePickerBaseHelper.h
//  Pods
//
//  Created by Mario Chinchilla PlanetMedia on 23/11/15.
//
//

#import <Foundation/Foundation.h>

@class MCPDatePicker;

@interface MCPDatePickerBaseHelper : NSObject

//! Picker sobe el cual calcular fechas y demás datos
@property (nonatomic, weak) MCPDatePicker *targetPicker;

@end
