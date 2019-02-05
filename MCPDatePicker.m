//  Created by Michael Kamphausen on 06.11.13.
//  Copyright (c) 2013 Michael Kamphausen. All rights reserved.
//  Contribution (c) 2014 Sebastien REMY
//  Contribution (c) 2015 Mario Chinchilla.
//

#import "MCPDatePicker.h"

#import "MCPPickerComponents.h"
#import "MCPDatePickerHelper.h"

@interface MCPDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
//! Objeto que contiene los índices de los componentes dependiendo del formato de la fecha
@property (nonatomic, strong) MCPPickerComponents *pickerComponents;
//! Objeto para obtener información sobre el propio picker
@property (nonatomic, strong) MCPDatePickerHelper *pickerHelper;
//! Variable que índica si es una primera carga o no. Esta variable cambiará cuando se seleccione cualquier fecha que no sea la fecha por defecto
@property (nonatomic, assign) BOOL dateModified;
@end


@implementation MCPDatePicker

@synthesize date = _date;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self prepareSettings];
    [self reloadAllComponents];

    self.date = _date; // Seteamos la fecha a la seteada en la variable interna, para que así el picker actualice su scroll
}

- (void)prepareSettings {
    self.dataSource = self;
    self.delegate = self;
    
    // Seteamos las variables internas para no llamar a los setter, dado que el picker se recargaría multiples veces y esto es inncesario
    if(!self.dateFormatTemplate || [self.dateFormatTemplate isEqualToString:@""])
        _dateFormatTemplate = @"yyyyMMMdjmm";
    if(self.minutesInterval == 0)
        _minutesInterval = 1;
    
    _minimumDate = [NSDate distantPast];
    _maximumDate = [NSDate distantFuture]; 
    _date = [NSDate date];
    
    self.pickerComponents = [[MCPPickerComponents alloc] initWithDateFormatSymbolsArray:[MCPDatePickerHelper obtainArrayOfSymbolsFromTemplate:self.dateFormatTemplate]];
    self.pickerHelper = [[MCPDatePickerHelper alloc]initWithTarget:self andComponentsOfPicker:self.pickerComponents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentLocale) name:NSCurrentLocaleDidChangeNotification object:nil];
}

#pragma mark - Picker methods

- (void)refreshCurrentLocale {
    self.dateFormatTemplate = self.dateFormatTemplate;
    [self.dateDelegate datePicker:self didSelectDate:self.date];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.pickerHelper obtainNumberOfComponentsEnabledFromCurrentTemplate];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickerHelper numberOfRowsForComponent:component];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.pickerHelper getStringFormattedDateForRow:row andComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [UILabel new];
        label.font = [UIFont fontWithName:self.fontName size:self.fontSize];
        label.textColor = self.enabledDateColor;
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.dateModified = YES;
    
    NSDate* date = self.date;
    if ([date timeIntervalSince1970] > [self.maximumDate timeIntervalSince1970]) {
        date = self.maximumDate;
    }
    [self reloadAllComponents];
    
    if(self.dateDelegate && [self.dateDelegate respondsToSelector:@selector(datePicker:didSelectDate:)])
        [self.dateDelegate datePicker:self didSelectDate:date];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == self.pickerComponents.dayComponent)
        return 30.;
    else if (component == self.pickerComponents.monthComponent)
        return 65.;
    else if (component == self.pickerComponents.yearComponent)
        return 60.;
    else if (component == self.pickerComponents.hourComponent)
        return 30.;
    else if (component == self.pickerComponents.minuteComponent)
        return 30.;
    return 0.;
}

#pragma mark - getter & setter

/**
 *  Método getter que obtiene la fecha seleccionada en el picker basándose en el índice de las filas. Si no se detecta una selección en el picker (Porque no se haya cargado este todavía)
 *  este método cogerá le fehaca
 *
 *  @return La fecha seleccionada en el picker
 */
- (NSDate *)date{
    if(!self.dateModified)
        return [NSDate date];
    
    return [self.pickerHelper obtainDateFromCurrentSelectedDate];
}

- (void)setDate:(NSDate *)newDate {
    [self setDate:newDate animated:NO];
}

- (void)setDate:(NSDate *)newDate animated:(BOOL)animated {
    _date = newDate;
    
    [self.pickerHelper updatePickerForDate:newDate withHandler:^(NSInteger row, NSInteger component) {
        [self selectRow:row inComponent:component animated:animated];
    }];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    [self reloadAllComponents];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    [self reloadAllComponents];
}

- (void)setDateFormatTemplate:(NSString *)dateFormatTemplate {
    _dateFormatTemplate = dateFormatTemplate;
    
    /**** Obtenemos el índice de los componentes a partir del formate de la fecha y el Locale del usuario ****/
    [self.pickerComponents fillWithDateFormatSimbolsArray:[MCPDatePickerHelper obtainArrayOfSymbolsFromTemplate:dateFormatTemplate]];
    [self reloadAllComponents];
}

@end
