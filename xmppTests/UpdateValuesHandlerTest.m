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
    
    context(@"when exist data of Contacts", ^{
        UpdateValuesHandler * handler = [UpdateValuesHandler new];
        
        context(@"when don't have new data Contacts", ^{
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
            
            [handler calculateArrayIndexOfContacts:oldContacts And:@[]];
            
            it(@"should return empty array for add", ^{
                NSArray * contacts = [handler getContactsForAdd];
                [[contacts should] beEmpty];
            });
            
            it(@"should return empty array for delete", ^{
                NSArray * contacts = [handler getContactsForDelete];
                [[contacts should] beEmpty];
            });
            
            it(@"should return empty array for update", ^{
                NSArray * contacts = [handler getContactsForRefresh];
                [[contacts should] beEmpty];
            });
        });
    });
    
    context(@"when exist new data of Contacts", ^{
        UpdateValuesHandler * handler = [UpdateValuesHandler new];
        
        context(@"when exist new Contact ", ^{
            NSArray * oldContacts = @[
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
            
            NSArray * newContacts = @[
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
            
            [handler calculateArrayIndexOfContacts:oldContacts And:newContacts];
            
            it(@"should return empty array for add", ^{
                NSArray * contacts = [handler getContactsForAdd];
                [[contacts should] equal:@[ @4 ]];
            });
            
            it(@"should return empty array for delete", ^{
                NSArray * contacts = [handler getContactsForDelete];
                [[contacts should] beEmpty];
            });
            
            it(@"should return empty array for update", ^{
                NSArray * contacts = [handler getContactsForRefresh];
                [[contacts should] beEmpty];
            });
        });
    });
    
    context(@"when exist new data of Contacts", ^{
        UpdateValuesHandler * handler = [UpdateValuesHandler new];
        
        context(@"when exist update of Contact ", ^{
            NSArray * oldContacts = @[
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
            
            NSArray * newContacts = @[
                                      @{
                                          @"jid" : @"0070s1ke5udxn0rwrs568oc9e1@public.talk.google.com",
                                          @"name" : @"Rita Guardado"
                                          },
                                      @{
                                          @"jid" : @"0z8d21t7wzim42ux8h14ol260e@public.talk.google.com",
                                          @"name" : @"Luis Alejandro Rangel Sánchez"
                                          },
                                      @{
                                          @"jid" : @"1xnqzhessnhla3jv587c8qb9o9@public.talk.google.com",
                                          @"name" : @"Maria de Lourdes Pacheco"
                                          }
                                      ];
            
            [handler calculateArrayIndexOfContacts:oldContacts And:newContacts];
            
            it(@"should return empty array for add", ^{
                NSArray * contacts = [handler getContactsForAdd];
                [[contacts should] beEmpty];
            });
            
            it(@"should return empty array for delete", ^{
                NSArray * contacts = [handler getContactsForDelete];
                [[contacts should] beEmpty];
            });
            
            it(@"should return empty array for update", ^{
                NSArray * contacts = [handler getContactsForRefresh];
                [[contacts should] equal:@[ @0 ]];
            });
        });
    });
});

SPEC_END
