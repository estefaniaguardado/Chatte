//
//  xmppTests.m
//  xmppTests
//
//  Created by Estefania Chavez Guardado on 8/29/16.
//  Copyright © 2016 Estefania Chavez Guardado. All rights reserved.
//

#import "Kiwi.h"
#import "UpdateValuesHandler.h"

SPEC_BEGIN(UpdateValuesHandlerTest)

describe(@"UpdateValuesHandler", ^{
    UpdateValuesHandler * handler = [UpdateValuesHandler new];
    
    context(@"when don't exist new data of Contacts", ^{
        NSArray * oldContacts = @[
                                  @{
                                      @"jid" : @"3pfmzjffz9tm32viob36a0e5le@public.talk.google.com",
                                      @"name" : @"Estefania Guardado"
                                      },
                                  @{
                                      @"jid" : @"0z8d21t7wzim42ux8h14ol260e@public.talk.google.com",
                                      @"name" : @"Luis Alejandro Sánchez"
                                      },
                                  @{
                                      @"jid" : @"0070s1ke5udxn0rwrs568oc9e1@public.talk.google.com",
                                      @"name" : @"Rita Guardado"
                                      },
                                  @{
                                      @"jid" : @"1xnqzhessnhla3jv587c8qb9o9@public.talk.google.com",
                                      @"name" : @"Maria de Lourdes Pacheco"
                                      }
                                  ];
        [handler updateValues:oldContacts With:@[]];
        
        it(@"should return empty array for add", ^{
            NSArray * contacts = [handler getContactsForAdd];
            [[contacts should] beNil];
        });
        
        it(@"should return empty array for delete", ^{
            NSArray * contacts = [handler getContactsForAdd];
            [[contacts should] beNil];
        });
        
        it(@"should return empty array for delete", ^{
            NSArray * contacts = [handler getContactsForRefresh];
            [[contacts should] beNil];
        });
    });
});

SPEC_END
