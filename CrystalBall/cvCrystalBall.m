//
//  cvCrystalBall.m
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "cvCrystalBall.h"

@implementation cvCrystalBall


-(NSArray *) predictions{
    if(_predictions == nil){
        _predictions = [[NSArray alloc] initWithObjects:@"Pa mi! que tienes razon!!!",
                        @"WAIT!! Como diantres quieres que te conteste eso, Que me tienes cara de Adivino",
                        @"Verifica en Facebook a ver si ya alquien a postiado algo de eso",
                        @"Tu estas Loco!!",
                        @"Ni contestare eso, Enserio voy a pichar",
                        @"OK, www.google.com contestara tu pregunta",
                        @"Organiza tus pensamientos que no entendi ni PAPA lo que dijistes"
                        ,nil];
    }
    return _predictions;
    
}

- (NSString*) randomPrediction{
    int random = arc4random_uniform(self.predictions.count);
    return [self.predictions objectAtIndex:random];
}

@end
