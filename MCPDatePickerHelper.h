//
//  MCPDatePickerHelper.h
//  LexusLoyalty
//
//  Created by Mario Chinchilla PlanetMedia on 20/11/15.
//  Copyright © 2015 Mario. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPDatePickerBaseHelper.h"

@class MCPPickerComponents;

@interface MCPDatePickerHelper : MCPDatePickerBaseHelper

//! Información sobre los componentes del picker (Que no son públicos en esta clase)
@property (nonatomic, weak) MCPPickerComponents * _Nullable targetPickerComponents;

/**
 *  Método init que inicializa el handler con un picker y sus componentes. Estos métodos no deben ser nil, de lo contrario, este método init no hará nada
 *
 *  @param picker     Picker con el cual se quiere inicializar y asociar este helper
 *  @param components Componentes propios del picker con el que se va a inicializar el helper.
 *
 *  @return El propio objeto inicializado con los parámetros pasados.
 */
-(nullable id)initWithTarget:(MCPDatePicker* _Nonnull)picker andComponentsOfPicker:(MCPPickerComponents* _Nonnull)components;

#pragma mark - Date methods

/**
 *  Método que obtiene una fecha a partir de la seleccionada en el picker.
 *
 *  @return La fecha seleccionada en el picker
 */
-(nullable NSDate*)obtainDateFromCurrentSelectedDate;

/**
 *  Método que calcula que filas del picker deben ser actualizadas en el seteo de una nueva fecha y llama al handler pasado por parámetro cuando un componente debe ser cambiado de fila.
 *  Este método no hará nada si no recibe un bloque para manejar los cambios de fecha.
 *
 *  @param newDateHandler   Bloque que será ejecutado cada vez que un componente del picker deba ser cambiado de fila debido a la selección de una nueva fecha
 *                          Este bloque recibe dos parámetros:
 *  @param row              Fila a seleccionar por el picker para un componente determinado
 *  @param component        Componente del cual se debe actualizar una fila
 */
-(void)updatePickerForDate:(NSDate* _Nonnull)date withHandler:(void(^_Nonnull)(NSInteger row, NSInteger component))newDateHandler;

/**
 *  Método que obtiene el número de filas necesarias por el picker para un componente concreto
 *
 *  @param component Componente para el cuál se quiere obtener el número de filas
 *
 *  @return El número de filas para el componente
 */
- (NSInteger)numberOfRowsForComponent:(NSInteger)component;

/**
 *  Método que devuelve un componente (Un día, un año, un mes etc...) en formato string para la fila del componente pasado por parámtro
 *
 *  @param row       Fila de la cual se quiere obtener la fecha formateada como String
 *  @param component Componente del cual se quiere obtener la fila
 *
 *  @return String con la fecha obtenida
 */
-(nullable NSString*)getStringFormattedDateForRow:(NSInteger)row andComponent:(NSInteger)component;

#pragma mark - Picker methods

/**
 *  Método que obtiene un array de simbolos para la fecha con el template dado
 *
 *  @param dateTemplate Template a partir del cual se quieren obtener los símbolos
 *
 *  @return Array con los símbolos obtenidos
 */
+(nullable NSArray*)obtainArrayOfSymbolsFromTemplate:(NSString* _Nullable)dateTemplate;

/**
 *  Método que devuelve el número de componentes activados dependiendo de la plantilla establecida
 *
 *  @return Número de componentes a tener por el picker
 */
-(NSInteger)obtainNumberOfComponentsEnabledFromCurrentTemplate;

@end
