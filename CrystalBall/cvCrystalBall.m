//
//  cvCrystalBall.m
//  CrystalBall
//
//  Created by Christian Vazquez on 4/27/14.
//  Copyright (c) 2014 Christian Vazquez. All rights reserved.
//

#import "cvCrystalBall.h"
#import "SyncTool.h"
@implementation cvCrystalBall

/*
-(NSArray *) predictions{
    
    SyncTool *sync = [[SyncTool alloc] init];
    NSArray *globalPredictions = [[NSArray alloc] initWithArray:sync.getPhrases];
    if([globalPredictions count]==0){
    
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
    }else{
        _predictions=globalPredictions;
    }
    
    return _predictions;
    
}*/


-(id)init {
    [self fillPredictions];
    return self;
}

-(void)fillPredictions{
    
    SyncTool *sync = [[SyncTool alloc] init];
    self.predictions = [[NSArray alloc] initWithArray:sync.getPhrases];
}
-(NSArray *)getPredictions{
    if(self.predictions.count == 0){
        self.predictions = [[NSArray alloc] initWithObjects:@"Pa mi! que tienes razon!!!",
                        @"WAIT!! Como diantres quieres que te conteste eso, Que me tienes cara de Adivino",
                        @"Verifica en Facebook a ver si ya alquien a postiado algo de eso",
                        @"Tu estas Loco!!",
                        @"Ni contestare eso, Enserio voy a pichar",
                        @"OK, www.google.com contestara tu pregunta",
                        @"Organiza tus pensamientos que no entendi ni PAPA lo que dijistes"
                        ,nil];
    }
    return self.predictions;
}


- (NSString*) randomPrediction{
    int random = arc4random_uniform((int)[self getPredictions].count);
    return [self.predictions objectAtIndex:random];
}

@end
