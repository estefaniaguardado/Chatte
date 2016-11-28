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
                                          @"jid" : @"CONTACT_ID1@public.talk.google.com",
                                          @"name" : @"NAME_ID1"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID2@public.talk.google.com",
                                          @"name" : @"NAME_ID2"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID3@public.talk.google.com",
                                          @"name" : @"NAME_ID3"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID4@public.talk.google.com",
                                          @"name" : @"NAME_ID4"
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
                                          @"jid" : @"CONTACT_ID1@public.talk.google.com",
                                          @"name" : @"NAME_ID1"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID2@public.talk.google.com",
                                          @"name" : @"NAME_ID2"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID3@public.talk.google.com",
                                          @"name" : @"NAME_ID3"
                                          }
                                      ];
            
            NSArray * newContacts = @[
                                      @{
                                          @"jid" : @"CONTACT_ID1@public.talk.google.com",
                                          @"name" : @"NAME_ID1"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID2@public.talk.google.com",
                                          @"name" : @"NAME_ID2"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID3@public.talk.google.com",
                                          @"name" : @"NAME_ID3"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID4@public.talk.google.com",
                                          @"name" : @"NAME_ID4"
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
                                          @"jid" : @"CONTACT_ID1@public.talk.google.com",
                                          @"name" : @"NAME_ID1"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID2@public.talk.google.com",
                                          @"name" : @"NAME_ID2"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID3@public.talk.google.com",
                                          @"name" : @"NAME_ID3"
                                          }
                                      ];
            
            NSArray * newContacts = @[
                                      @{
                                          @"jid" : @"CONTACT_ID1@public.talk.google.com",
                                          @"name" : @"NAME_ID1"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID2@public.talk.google.com",
                                          @"name" : @"NAME_ID2"
                                          },
                                      @{
                                          @"jid" : @"CONTACT_ID3@public.talk.google.com",
                                          @"name" : @"NAME_UPDATE_ID3"
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
                [[contacts should] equal:@[ @2 ]];
            });
        });
    });
});

SPEC_END
