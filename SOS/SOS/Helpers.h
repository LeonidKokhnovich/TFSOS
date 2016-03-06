//
//  Helpers.h
//  SOS
//
//  Created by Leonid Kokhnovych on 2016-03-05.
//  Copyright © 2016 Team14. All rights reserved.
//

#ifndef Helpers_h
#define Helpers_h


/**
 *  Simplified @weakify @strongify from https://github.com/jspahrsummers/libextobjc package. It makes easier to manage weak and strong references while using blocks. Here is an example how to use it:
 
 id object = ...; // Some object.
 weakify(self); // Makes a weak reference to self.
 [object performAsyncBlock:^() {
 strongify(self); // Makes a strong reference to self.
 
 [self doOtherTask]; // If self was deallocated from memory, you will just send the message to nil. If not - you can safely use self because you have a strong local variable (e.g. self) that holds the object.
 }];
 
 Why do we need it? You can get more details by the following URL: http://holko.pl/2015/05/31/weakify-strongify/
 Don't have time? Here is the main idea:
 
 Model *model = [Model new];
 
 __weak typeof(self) weakSelf = self;
 model.dataChanged = ^(NSString *title) {
 __strong typeof(self) strongSelf = weakSelf;
 strongSelf.label.text = title;
 };
 
 self.model = model;
 
 This so-called weak/strong dance can be found in most Objective-C codebases. It works fine, but it's error prone. When the new features are introduced and the block's definition gets bigger someone will eventually use self within it. We won't notice when it happens — the compiler helps only in the most simple cases. This is a part when weakify and strongify macros come in handy.
 */
#define weakify(var) __weak typeof(var) AHKWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = AHKWeak_##var; \
_Pragma("clang diagnostic pop")

/**
 *  Custom logger.
 */
#if defined(DEBUG) || defined(INTERNAL_DISTRIBUTION)
#define NSLog(args, ...) NSLog((@"%s[Line %d]: " args), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif /* Helpers_h */
