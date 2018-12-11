//
//  ContactsManager.m
//  HHPOChat
//
//  Created by Anthony on 8/9/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "ContactsManager.h"
//#import <APAddressBook/APAddressBook.h>
//#import <APAddressBook/APContact.h>
#import "NetworkLayer.h"

static ContactsManager *sharedInstance = nil;

@interface ContactsManager()
{
  //  APAddressBook *addressBook;
    dispatch_queue_t contactsSerialQueue;
    BOOL isAddressBokkChangeOccured;
    
}


@end
@implementation ContactsManager
@synthesize insertingProgress;





+(ContactsManager *) getInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}
/*
-(id) init
{
    self=[super init];
    if (self)
    {
        contactsSerialQueue = dispatch_queue_create("com.contacts.serial.queue", DISPATCH_QUEUE_SERIAL);
        //        addressBook = [[APAddressBook alloc] init];
        
        self.backgroundTask = UIBackgroundTaskInvalid;
        
        addressBook = [[APAddressBook alloc] init];
        addressBook.fieldsMask = APContactFieldAll;//APContactFieldPhonesOnly | APContactFieldName | APContactFieldThumbnail | APContactFieldPhonesWithLabels | APContactFieldDates | APContactFieldDates;
        
        // start observing
        [addressBook startObserveChangesWithCallback:^
         {
             if (insertingProgress==FALSE) {
                 isAddressBokkChangeOccured = FALSE;
                 [self loadContacts:^(BOOL success, NSString *message) {
                       [[FriendRequestManager sharedManager] sendingRequestToNonAppUser];
                 }];
                 
                 
             }
             else
             {
                 isAddressBokkChangeOccured = TRUE;
                 
             }
             // reload contacts
         }];
        
    }
    return self;
}
-(void)loadContacts:(void (^)(BOOL success,NSString *message))completion
{
    if (insertingProgress) {
        return;
    }
    _insertingCompleted = FALSE;

    switch([APAddressBook access])
    {
        case APAddressBookAccessUnknown:
            // Application didn't request address book access yet
            break;
            
        case APAddressBookAccessGranted:
            // Access granted
            break;
            
        case APAddressBookAccessDenied:
        {
            _insertingCompleted = TRUE;
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Sorry"
                                         message:@"Address Book access denied or restricted by the user !!"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Settings"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                            
                                            
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
                                       }];
            
            //Add your buttons to alert controller
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appdel.window.rootViewController presentViewController:alert animated:YES completion:nil];
            completion(FALSE,@"ACCESS DENIED");
            
        }
            // Access denied or restricted by privacy settings
            
            // completion(FALSE,@"Access denied or restricted by privacy settings");
            
            
            
            
            
            break;
    }
    
    
    insertingProgress = TRUE;
    
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        
        return contact.phones.count > 0;
    };
    
    
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
     {
         
         if (!error)
         {
             [self insertingContatcsArrayFromPhoneBook:contacts completion:^(BOOL success, NSString *message) {
                 completion(success,message);
             }];
             
                        
             
         }
         else
         {
             completion(FALSE,error.localizedDescription);
             
             [CommonFunction showAlert:error.localizedDescription];
             
         }
     }];
    
    
}
-(void)insertingContatcsArrayFromPhoneBook:(NSArray *)contactsArray completion:(void (^)(BOOL success,NSString *message))completion
{
 
    
        NSManagedObjectContext *backgroundMOC = [self managedObjectContextForBGThread];

        [backgroundMOC performBlock:^{
            
 
 
            NSMutableSet *changedContatcs=[[NSMutableSet alloc] init];
            NSMutableSet *allOldContacts=[[NSMutableSet alloc] init];
            NSMutableSet *allContacts=[[NSMutableSet alloc] init];
            
            NSArray *old=[[DataLayer getInstance] getAllContactRecordIDsMoc:backgroundMOC];
            for (NSDictionary *c in old)
            {
                [allOldContacts addObject:c[@"contact_local_reference_id"]];
                
            }
            
            NSMutableSet *newContacts=[[NSMutableSet alloc] init];
            NSMutableSet *registeredUsersBeforeUpdate=[[NSMutableSet alloc] init];
            __block BOOL shouldCallWs = TRUE;
            __block BOOL isANyChanges = FALSE;

            for (APContact *contact in contactsArray)
            {
                HHPOCHAT_Contacts *newContact=[[DataLayer getInstance] getContatctObject:[NSString stringWithFormat:@"%@",contact.recordID] shouldCreate:NO moc:backgroundMOC];
                  if (newContact)
                {
                    //newContact.unique_id_for_reference
                    //   contact.unique_id_for_contactsync = newContact.unique_id_for_reference;
                    
                    [allContacts addObject:[NSString stringWithFormat:@"%@",contact.recordID]];
                    
                    if ([contact.recordDate.modificationDate compare:newContact.contact_date_last_updated] == NSOrderedDescending)
                    {
                        isANyChanges = TRUE;

                        //  [CommonFunction insertAPContact:contact moc:backgroundMOC];
                        [changedContatcs addObject:contact.recordID];
                        //   [backgroundMOC deleteObject:newContact];
                        shouldCallWs = TRUE;
                        
                        [registeredUsersBeforeUpdate addObjectsFromArray:newContact.getRegisteredUsers];
                        
                        [self insertAPContact:contact moc:backgroundMOC isUpdated:TRUE];
                        
                        
                    }
                    
                }
                else
                {
                    isANyChanges = TRUE;

                    shouldCallWs = TRUE;
                    [self insertAPContact:contact moc:backgroundMOC isUpdated:FALSE];
                    [newContacts addObject:[NSString stringWithFormat:@"%@",contact.recordID]];
                    
                    ////
                }
                
                
                
                
                
                
            }
            for (HHPOCHAT_Phones *phone in registeredUsersBeforeUpdate) {
                if (![phone.contacts isKindOfClass:[NSSet class]] || phone.contacts.count==0) {
                    [[SingletonClass getInstance].deletedContactsArray addObject:phone.phone_formated_jid_number];
                    
                    
                }
            }
            
            [allOldContacts minusSet:allContacts];
            
            for (NSString *recordId in allOldContacts) {
                isANyChanges = TRUE;

                
                HHPOCHAT_Contacts *newContact=[[DataLayer getInstance] getContatctObject:[NSString stringWithFormat:@"%@",recordId] shouldCreate:NO moc:backgroundMOC];
                
                [[SingletonClass getInstance].deletedContactsArray addObjectsFromArray:[[newContact getRegisteredUsers] valueForKeyPath:@"phone_formated_jid_number"]];
                
                [backgroundMOC deleteObject:newContact];
                
             
                
                
            }
            if (isANyChanges) {
                [[DataLayer getInstance] saveContext:backgroundMOC];
                
                
                
                // save parent to disk asynchronously ////// Uncomment if anything is not working
                [[COREDATAHELPER managedObjectContext] performBlock:^{
                    NSError *error;
                    if (![[COREDATAHELPER managedObjectContext] save:&error])
                    {
                        // handle error
                    }
                    else
                        
                    {
                        
                    }
                }];////////////

            }
      
 
            dispatch_async( dispatch_get_main_queue(), ^{
                
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                insertingProgress=NO;
                completion(TRUE,@"");
                
                _insertingCompleted = TRUE;

                if (isAddressBokkChangeOccured) {
                    isAddressBokkChangeOccured =FALSE;
                    [self loadContacts:^(BOOL success, NSString *message) {
                        [[FriendRequestManager sharedManager] sendingRequestToNonAppUser];
                    }];
                }
                if ([[NSUserDefaults standardUserDefaults] boolForKey:IsProfileDetailsAdded] == TRUE)
                {
                    
                    //Call with [SingletonClass getInstance].deletedContactsArray
                    NSArray *del_ar_ = [[SingletonClass getInstance].deletedContactsArray allObjects];
                    NSString *final_str_ = @"";
                    for (NSString *num_str in del_ar_) {
                        if (num_str.length>0) {
                            final_str_ = [final_str_ stringByAppendingString:[NSString stringWithFormat:@"%@,", num_str]];
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] setValue:final_str_ forKey:kDeletedContacts];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NetworkLayer getInstance] deleteContactsFromServerWithCompletion:^(BOOL success, id responseObject, NSError *error) {
                        if (success) {
                            NSLog(@"update deleted contacts success");
                        }
                        else {
                            NSLog(@"update deleted contacts failed");
                        }
                    }];
                }
                NSLog(@"changedContatcs --->%@ \n\ndeletedContactsArray %@",changedContatcs,[SingletonClass getInstance].deletedContactsArray);
                
            });
        }];
    //});
    
}
-(void)insertAPContact:(APContact*)contact moc:(NSManagedObjectContext*)moc isUpdated:(BOOL)isUpdatedContact
{
    HHPOCHAT_Contacts *newContact=[[DataLayer getInstance] getContatctObject:[NSString stringWithFormat:@"%@",contact.recordID] shouldCreate:TRUE moc:moc];
    
    
    NSString *name=@"";
    if ([contact.name.compositeName isKindOfClass:[NSString class]] && contact.name.compositeName.length>0)
    {
        name = contact.name.compositeName;
    }
    else
    {
        if ([contact.name.firstName isKindOfClass:[NSString class]]) {
            
            if (contact.name.firstName.length>0) {
                
                name       =contact.name.firstName;
                
            }
            
        }
        
        
        if ([contact.name.middleName isKindOfClass:[NSString class]]) {
            if (contact.name.middleName.length>0) {
                if (name.length>0) {
                    name=[name stringByAppendingString:[NSString stringWithFormat:@" %@",contact.name.middleName]];
                }
                else{
                    name=[name stringByAppendingString:contact.name.middleName];
                    
                }
            }
            
            
        }
        if ([contact.name.lastName isKindOfClass:[NSString class]]) {
            if (contact.name.lastName.length>0) {
                if (name.length>0) {
                    name=[name stringByAppendingString:[NSString stringWithFormat:@" %@",contact.name.lastName]];
                }
                else{
                    name=[name stringByAppendingString:contact.name.lastName];
                    
                }
            }
            
            
        }
        
        
    }
    
    
    newContact.contact_name = name;
    //newContact.contact_uppercaseFirstLetter = [self getContactsGroupingKey:newContact.contact_name];
    NSString *imgName =[CommonFunction stringFromDate:contact.recordDate.creationDate Format:@"yyyyMMddHHmm"];
    newContact.contact_image_url =[NSString stringWithFormat:@"%@%@.png",imgName,newContact.contact_local_reference_id];
    
    NSString *imgPath=[CommonFunction getUserDPPathFromImagename:newContact.contact_image_url];
    NSError* error;
    
    [[NSFileManager defaultManager] removeItemAtPath:imgPath error:&error];
    
    if (contact.thumbnail != NULL) {
        
        NSData *imageData = UIImagePNGRepresentation(contact.thumbnail);
        
        
        if (imageData) {
            
            
            [imageData writeToFile:imgPath atomically:YES];
        
            
            
        }
        else
        {
            
            newContact.contact_image_url = @"";
        }
        
    }
    else{
        newContact.contact_image_url = @"";
    }
    
    //   newContact.sectionTitle     =  newContact.getSectionTitle;
    
    newContact.contact_date_last_updated     =  [NSDate date];
    
    if(isUpdatedContact)
        [newContact removePhones:newContact.phones];
    
    for (APPhone *phoneWithLabel in contact.phones)
    {
 
 
        
        //NSLog(@"phonenumber=%@ original=%@ localized=%@",phoneWithLabel.phone, phoneWithLabel.originalLabel,phoneWithLabel.localizedLabel);
        //   NSString *phoneNumber=[[phoneWithLabel.number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        if (![phoneWithLabel.number isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *phoneNumber=[CommonFunction removeAllCharactersOtherThanDigitFromString:phoneWithLabel.number];
        
        
        if (phoneNumber.length <8) {
            continue;
        }
        
        HHPOCHAT_Phones *phone=[[DataLayer getInstance] getPhoneObjectFromJid:phoneNumber shouldCreate:TRUE moc:moc];
        
        
//        phone.phone_is_inserted_via_phone = TRUE;
        phone.phone_type=phoneWithLabel.originalLabel;
        phone.phone_number = phoneWithLabel.number;
        
        [newContact addPhonesObject:phone];
        
        [phone addContactsObject:newContact];
        
        HHPOCHAT_Chats *chat =[[DataLayer getInstance] getChatObjectFromJid:[CommonFunction getCompleteJidFromFormatedPhoneNumber:phoneNumber] shouldCreate:NO moc:moc];
        
        if ([chat isKindOfClass:[HHPOCHAT_Chats class]])
        {
            chat.phone = phone;
            phone.chat = chat;
            chat.chat_user_last_updated_in_table     =  [NSDate date];
            
        }
        if([chat.chat_user_jid isEqualToString:[SingletonClass getInstance].myJID])
        {
            chat.chat_user_is_owner = TRUE;
        }
        
    }
    
    
    
    newContact.contact_date_last_updated=contact.recordDate.modificationDate;
    // NSLog(@"%@ %@ %@->%@ ", newContact.first_name,newContact.middle_name,newContact.last_name,newContact.address);
    
    
}
- (NSManagedObjectContext *)managedObjectContextForBGThread {
     return [COREDATAHELPER managedObjectContextForBGThread];
    
    
}


- (NSString *)getContactsGroupingKey:(NSString*)name
{
    
    
    if ([name length]>0) {
        NSString *first=[[name substringToIndex:1] uppercaseString];
        if ([self isCharaterIsAlphabet:first]) {
            return first;
        }
        
   //      unichar firstChar = [[[self.sectionTitle substringToIndex:1] uppercaseString] characterAtIndex:0];
      //   if (firstChar >= 'A' && firstChar <= 'Z') {
 
 
      //   return [[self.sectionTitle substringToIndex:1] uppercaseString];
 
      //   }
 
        
    }
    
    
    
    return @"#";
}
-(BOOL)isCharaterIsAlphabet:(NSString*)charatcer
{
    //0-9
    NSString *regEx = @"^([a-zA-Z\u0600-\u06ff](\\-|\\_|\\.|\\ )?)+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject: charatcer];
    //    if (!myStringMatchesRegEx)
    //        return NO;
    return myStringMatchesRegEx;
    
}*/
@end
