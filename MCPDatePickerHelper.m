//
//  MCPDatePickerHelper.m
//  LexusLoyalty
//
//  Created by Mario Chinchilla PlanetMedia on 20/11/15.
//  Copyright © 2015 Mario. All rights reserved.
//

#import "MCPDatePickerHelper.h"
#import "MCPPickerComponents.h"

#import "MCPDatePicker.h"

static const NSCalendarUnit MCPPickerViewComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
static NSString * const kTargetFormatDateTemplate = @"dateFormatTemplate";

@implementation MCPDatePickerHelper

-(id)initWithTarget:(MCPDatePicker*)picker andComponentsOfPicker:(MCPPickerComponents*)components{
    
    self = [super init];
    if(!self || !picker || !components) return nil;
    
    self.targetPicker = picker;
    self.targetPickerComponents = components;
    
    return self;
}

#pragma mark - Date methods

-(NSDate*)obtainDateFromCurrentSelectedDate{
    
    // Creamos los componentes para rellenarlos con el calendario actual por defecto
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [currentCalendar components:MCPPickerViewComponents fromDate:[NSDate date]];
    [components setCalendar:currentCalendar];
    
    // Comprobamos y seteamos la fecha dependiendo de los componentes cargados en el picker
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.yearComponent]){   // Años
        NSInteger year = [self yearForRow:[self.targetPicker selectedRowInComponent:self.targetPickerComponents.yearComponent]];
        [components setYear:year];
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.monthComponent]){  // Meses
        NSInteger month = [self.targetPicker selectedRowInComponent:self.targetPickerComponents.monthComponent] + 1;
        [components setMonth:month];
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.dayComponent]){    // Días
        NSInteger day = [self.targetPicker selectedRowInComponent:self.targetPickerComponents.dayComponent] + 1;
        if(day > [self getNumberOfDaysInMonthForDate:[components date]])
            day = [self getNumberOfDaysInMonthForDate:[components date]];
        [components setDay:day];
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.hourComponent]){   // Horas
        NSInteger hour = [self.targetPicker selectedRowInComponent:self.targetPickerComponents.hourComponent];
        hour += self.targetPicker.minimumHour;
        [components setHour:hour];
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.minuteComponent]){ // Minutos
        NSInteger minutes = [self.targetPicker selectedRowInComponent:self.targetPickerComponents.minuteComponent];
        if(self.targetPicker.minutesInterval != 0)
            minutes *= self.targetPicker.minutesInterval;
        [components setMinute:minutes];
    }
    
    
    return [components date];
}

-(void)updatePickerForDate:(NSDate* _Nonnull)date withHandler:(void(^_Nonnull)(NSInteger row, NSInteger component))newDateHandler{
    if(!newDateHandler || !date) return; // Si no hay bloque o fecha, salimos del método
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:MCPPickerViewComponents fromDate:date];
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.yearComponent]){   // Años
        NSInteger yearRow = [self rowForYear:[components year]]-1;
        newDateHandler(yearRow, self.targetPickerComponents.yearComponent);
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.monthComponent]){  // Meses
        NSInteger monthRow = [components month]-1;
        newDateHandler(monthRow, self.targetPickerComponents.monthComponent);
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.dayComponent]){    // Días
        // Si el día seleccionado sobrepasa el total de días del mes, lo establecemos al máximo.
        // Esto pasa por ejemplo si estamos en el 31 de marzo y volvemos a febrero sin cambiar el día
        NSInteger dayRowIndex = [components day]-1;
        if([components day] > [self getNumberOfDaysInMonthForDate:date])
            dayRowIndex = [self getNumberOfDaysInMonthForDate:date];
        newDateHandler(dayRowIndex, self.targetPickerComponents.dayComponent);
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.hourComponent]){   // Horas
        newDateHandler([components hour], self.targetPickerComponents.hourComponent);
    }
    if ([self isComponentLoadedInPicker: self.targetPickerComponents.minuteComponent]){ // Minutos
        newDateHandler([components minute],self.targetPickerComponents.minuteComponent);
    }
}

- (NSInteger)numberOfRowsForComponent:(NSInteger)component {
    if (component == self.targetPickerComponents.yearComponent){        // Años
        NSInteger minimumYear = [[[NSCalendar currentCalendar] components:MCPPickerViewComponents fromDate:self.targetPicker.minimumDate] year];
        NSInteger maximumYear = [[[NSCalendar currentCalendar] components:MCPPickerViewComponents fromDate:self.targetPicker.maximumDate] year];
        return maximumYear - minimumYear + 1;
    }else if (component == self.targetPickerComponents.monthComponent){ // Meses
        return 12;
    }else if (component == self.targetPickerComponents.dayComponent){   // Días
        return [self getNumberOfDaysInMonthForDate: self.targetPicker.date];
    }else if (component == self.targetPickerComponents.hourComponent){  // Horas
        NSInteger numberOfHours = (self.targetPicker.maximumHour - self.targetPicker.minimumHour)+1;
        return numberOfHours;
    }else if (component == self.targetPickerComponents.minuteComponent){// Minutos
        if(self.targetPicker.minutesInterval == 0) return 60;
        return 60/self.targetPicker.minutesInterval;
    }
    return 0;
}

-(NSString*)getStringFormattedDateForRow:(NSInteger)row andComponent:(NSInteger)component{
    row = row % [self numberOfRowsForComponent:component];
    if (component == self.targetPickerComponents.dayComponent) {
        return [NSString stringWithFormat:@"%ld", (long)row+1];
    } else if (component == self.targetPickerComponents.monthComponent) {
        return [self returnArrayMonthsSymbols][row];
    } else if (component == self.targetPickerComponents.yearComponent) {
        return [NSString stringWithFormat:@"%li", (long)[self yearForRow:row]];
    } else if (component == self.targetPickerComponents.hourComponent) {
        NSInteger hour = self.targetPicker.minimumHour + row;
        return [NSString stringWithFormat:@"%02ld",(long)hour];
    } else if (component == self.targetPickerComponents.minuteComponent) {
        NSInteger minute = row;
        if(self.targetPicker.minutesInterval != 0)
            minute *= self.targetPicker.minutesInterval;
        return [NSString stringWithFormat:@"%02ld", (long)minute];
    }
    return @"";
}

- (NSInteger)rowForYear:(NSInteger)year {
    NSInteger minimumYear = [[[NSCalendar currentCalendar] components:MCPPickerViewComponents fromDate:self.targetPicker.minimumDate] year];
    return year - minimumYear + 1;
}

- (NSInteger)yearForRow:(NSInteger)row {
    NSInteger minimumYear = [[[NSCalendar currentCalendar] components:MCPPickerViewComponents fromDate:self.targetPicker.minimumDate] year];
    return row + minimumYear;
}

-(NSInteger)getNumberOfDaysInMonthForDate:(NSDate*)date{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

#pragma mark - Picker methods

+(NSArray*)obtainArrayOfSymbolsFromTemplate:(NSString*)dateTemplate{
    
    NSString* dateFormat = [NSDateFormatter dateFormatFromTemplate:dateTemplate options:0 locale:[NSLocale autoupdatingCurrentLocale]];
    NSCharacterSet *symbolsToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"yMdHhma"] invertedSet];
    NSString* symbols = [[dateFormat componentsSeparatedByCharactersInSet:symbolsToRemove] componentsJoinedByString:@""];
    NSMutableArray* uniqueSymbols = [NSMutableArray array];
    for (NSUInteger i = 0, maxI = [symbols length]; i < maxI; i++) {
        NSString* character = [symbols substringWithRange:NSMakeRange(i, 1)];
        if (![uniqueSymbols containsObject:character]) {
            [uniqueSymbols addObject:character];
        }
    }
    
    return uniqueSymbols;
}

-(NSInteger)obtainNumberOfComponentsEnabledFromCurrentTemplate{
    NSInteger componentsCount = 0;
    if([self isComponentLoadedInPicker:self.targetPickerComponents.yearComponent]) componentsCount++;
    if([self isComponentLoadedInPicker:self.targetPickerComponents.monthComponent]) componentsCount++;
    if([self isComponentLoadedInPicker:self.targetPickerComponents.dayComponent]) componentsCount++;
    if([self isComponentLoadedInPicker:self.targetPickerComponents.hourComponent]) componentsCount++;
    if([self isComponentLoadedInPicker:self.targetPickerComponents.minuteComponent]) componentsCount++;

    return componentsCount;
}

-(NSArray*)returnArrayMonthsSymbols{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:self.targetPicker.dateFormatTemplate options:0 locale:[NSLocale autoupdatingCurrentLocale]]];
    
    return formatter.shortMonthSymbols;
}

#pragma mark - Check methods

-(BOOL)isComponentLoadedInPicker:(NSInteger)component{
    return component != NSNotFound;
}

@end
