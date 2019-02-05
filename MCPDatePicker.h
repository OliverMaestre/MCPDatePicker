//  Created by Michael Kamphausen on 06.11.13.
//  Copyright (c) 2013 Michael Kamphausen. All rights reserved.
//  Contribution (c) 2014 Sebastien REMY
//  Contribution (c) 2015 Mario Chinchilla.
//

#import <UIKit/UIKit.h>

@class MCPDatePicker;

@protocol MCPDatePickerDelegate <NSObject>
- (void)datePicker:(MCPDatePicker*)datePicker didSelectDate:(NSDate*)date;
@end


@interface MCPDatePicker : UIPickerView

//! Booleana que nos dirá si el picker esta ya cargado con la fecha correspondiente
@property (nonatomic, assign) BOOL isPickerLoadedWithCurrentDate;

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSDate* maximumDate;
@property (nonatomic, strong) NSDate* minimumDate;
@property (nonatomic, strong) NSArray *arrayBlockedDates;
@property (nonatomic, strong, readonly) NSDateFormatter* dateFormatter;

//! String que contendra la plantilla de la fecha. Supported date symbols are yyyy, MMM, d, HH, h, mm, j, a. Default is 'yyyyMMMdjmm'. Order is determined by locale.
@property (nonatomic, strong) IBInspectable NSString *dateFormatTemplate;
//! Intervalo de minutos a mostrar por el componente de los minutos. Si esta valor se iguala a 0 el intervalo será de 1 minuto.
@property (nonatomic, assign) IBInspectable NSUInteger minutesInterval;
//! Hora mínima a mostrar por el picker (e.g 8:00). Este valor debe estar comprendido entre las 0 y las 23 horas. El valor por defecto será 0.
@property (nonatomic, assign) IBInspectable NSUInteger minimumHour;
//! Hora máxima a mostrar por el picker (e.g 20:00). Este valor debe estar comprendido entre las 0 y las 23 horas. Además este valor debe ser mayor que la hora mínima establecida, de otro modo este componente no será mostrado y puede tener comportamientos indeseados. El valor por defecto será 23.
@property (nonatomic, assign) IBInspectable NSUInteger maximumHour;
@property (nonatomic, strong) IBInspectable UIColor *enabledDateColor;
@property (nonatomic, strong) IBInspectable UIColor *blockedDateColor;
@property (nonatomic, strong) IBInspectable NSString *fontName;
@property (nonatomic, assign) IBInspectable CGFloat fontSize;

//! Use this delegate instead of inherited delegate and dataSource properties
@property (nonatomic, weak) IBOutlet id<MCPDatePickerDelegate> dateDelegate;

- (void)setDate:(NSDate*)date animated:(BOOL)animated;

@end
