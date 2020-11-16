//
//  NCRAutocompleteTextView.h
//  Dynamon
//
//  Created by Touch Duck on 2016/10/29.
//  Copyright © 2016年 Touch Duck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NCRAutocompleteTableViewDelegate <NSObject>
@optional
- (NSImage *)textView:(NSTextView *)textView imageForCompletion:(NSString *)word;

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index;
@end

@interface NCRAutocompleteTextView : NSTextView <NSTableViewDataSource, NSTableViewDelegate>

@property(atomic, weak) id <NCRAutocompleteTableViewDelegate> delegate;

@end
