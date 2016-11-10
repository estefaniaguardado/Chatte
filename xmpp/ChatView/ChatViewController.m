//
//  ChatViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "MessageTextView.h"
#import "TypingIndicatorView.h"
#import "Message.h"

#define DEBUG_CUSTOM_TYPING_INDICATOR 0

@interface ChatViewController ()

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSArray *searchResult;

@property (nonatomic, strong) UIWindow *textInputWindow;

@end

@implementation ChatViewController

- (instancetype)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDidMoveNotification object:nil];
    
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
    
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.chatBusinessController setJid:[self.dataRoster valueForKey:@"jid"]];
    [self.chatBusinessController setHandler:self];
    
    // Example's configuration
    [self configureActionItems];
    
    // SLKTVC's configuration
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
#if !DEBUG_CUSTOM_TYPING_INDICATOR
    self.typingIndicatorView.canResignByTouch = YES;
#endif
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];
    
    [self.autoCompletionView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
    [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":", @"+:", @"/"]];
    
    [self.textView registerMarkdownFormattingSymbol:@"*" withTitle:@"Bold"];
    [self.textView registerMarkdownFormattingSymbol:@"_" withTitle:@"Italics"];
    [self.textView registerMarkdownFormattingSymbol:@"~" withTitle:@"Strike"];
    [self.textView registerMarkdownFormattingSymbol:@"`" withTitle:@"Code"];
    [self.textView registerMarkdownFormattingSymbol:@"```" withTitle:@"Preformatted"];
    [self.textView registerMarkdownFormattingSymbol:@">" withTitle:@"Quote"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.messagesReceived = [[NSMutableArray alloc]
                             initWithArray: [self.chatBusinessController getMessages]];
    [self configureDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) from: (NSArray *) messages added: (NSDictionary *) message {
    // TODO: Update view model and refresh table
    NSLog(@"Added new message: %@", message);
    Message * newMessage = [Message new];
    newMessage.username = [self.dataRoster valueForKey:@"name"];
    newMessage.text = [message valueForKey:@"body"];
    [self updateView:newMessage];
}

#pragma mark - Example's Configuration

- (void)configureDataSource
{
    NSMutableArray *dataMessages = [[NSMutableArray alloc] init];
    
    [self.messagesReceived enumerateObjectsUsingBlock:^(id detailMessage,
                                                        NSUInteger idx,
                                                        BOOL * stop) {
        Message *message = [Message new];
        message.username = [self.dataRoster valueForKey:@"name"];
        message.text = [detailMessage valueForKey:@"body"];
        [dataMessages addObject:message];
    }];
    
    self.messages = [[NSMutableArray alloc] initWithArray:dataMessages];
}

- (void) updateView: (Message*) message{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;
    
    [self.tableView beginUpdates];
    [self.messages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)configureActionItems
{
    UIBarButtonItem *typeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_typing"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(simulateUserTyping:)];
    
    self.navigationItem.rightBarButtonItems = @[typeItem];
}


#pragma mark - Action Methods

- (void)simulateUserTyping:(id)sender
{
    if ([self canShowTypingIndicator]) {
        
#if DEBUG_CUSTOM_TYPING_INDICATOR
        __block TypingIndicatorView *view = (TypingIndicatorView *)self.typingIndicatorProxyView;
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize imgSize = CGSizeMake(kTypingIndicatorViewAvatarHeight*scale, kTypingIndicatorViewAvatarHeight*scale);
        
        // This will cause the typing indicator to show after a delay ¯\_(ツ)_/¯
        [LoremIpsum asyncPlaceholderImageWithSize:imgSize
                                       completion:^(UIImage *image) {
                                           UIImage *thumbnail = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
                                           [view presentIndicatorWithName:[LoremIpsum name] image:thumbnail];
                                       }];
#else
        [self.typingIndicatorView insertUsername:@"Estefania"];
#endif
    }
}

- (void)textInputbarDidMove:(NSNotification *)note
{
    if (!_textInputWindow) {
        return;
    }
    
    CGRect frame = self.textInputWindow.frame;
    frame.origin.y = [note.userInfo[@"origin"] CGPointValue].y - 60.0;
    
    self.textInputWindow.frame = frame;
}


#pragma mark - Overriden Methods

- (BOOL)ignoreTextInputbarAdjustment
{
    return [super ignoreTextInputbarAdjustment];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder
{
    if ([responder isKindOfClass:[UIAlertController class]]) {
        return YES;
    }
    
    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
    
    switch (status) {
        case SLKKeyboardStatusWillShow:     return NSLog(@"Will Show");
        case SLKKeyboardStatusDidShow:      return NSLog(@"Did Show");
        case SLKKeyboardStatusWillHide:     return NSLog(@"Will Hide");
        case SLKKeyboardStatusDidHide:      return NSLog(@"Did Hide");
    }
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.
    
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.
    
    [super textDidUpdate:animated];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    [self.chatBusinessController sendMessageOfUser:[self.textView.text copy]];
    
    Message *message = [Message new];
    message.username = @"Estefania";
    message.text = [self.textView.text copy];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;
    
    [self.tableView beginUpdates];
    [self.messages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    
    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [super didPressRightButton:sender];
}

- (void)didPressArrowKey:(UIKeyCommand *)keyCommand
{
    [super didPressArrowKey:keyCommand];
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

- (BOOL)canShowTypingIndicator
{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
}

- (BOOL)shouldProcessTextForAutoCompletion:(NSString *)text
{
    return [super shouldProcessTextForAutoCompletion:text];
}

- (CGFloat)heightForAutoCompletionView
{
    CGFloat cellHeight = [self.autoCompletionView.delegate tableView:self.autoCompletionView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cellHeight*self.searchResult.count;
}


#pragma mark - SLKTextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldOfferFormattingForSymbol:(NSString *)symbol
{
    if ([symbol isEqualToString:@">"]) {
        
        NSRange selection = textView.selectedRange;
        
        // The Quote formatting only applies new paragraphs
        if (selection.location == 0 && selection.length > 0) {
            return YES;
        }
        
        // or older paragraphs too
        NSString *prevString = [textView.text substringWithRange:NSMakeRange(selection.location-1, 1)];
        
        if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[prevString characterAtIndex:0]]) {
            return YES;
        }
        
        return NO;
    }
    
    return [super textView:textView shouldOfferFormattingForSymbol:symbol];
}

- (BOOL)textView:(SLKTextView *)textView shouldInsertSuffixForFormattingWithSymbol:(NSString *)symbol prefixRange:(NSRange)prefixRange
{
    if ([symbol isEqualToString:@">"]) {
        return NO;
    }
    
    return [super textView:textView shouldInsertSuffixForFormattingWithSymbol:symbol prefixRange:prefixRange];
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return self.messages.count;
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return [self messageCellForRowAtIndexPath:indexPath];
    }
    else {
        return [self autoCompletionCellForRowAtIndexPath:indexPath];
    }
}

- (ChatTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = (ChatTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
    
    Message *message = self.messages[indexPath.row];
    
    cell.titleLabel.text = message.username;
    cell.bodyLabel.text = message.text;
    
    cell.indexPath = indexPath;
    cell.usedForMessage = YES;
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}

- (ChatTableViewCell *)autoCompletionCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = (ChatTableViewCell *)[self.autoCompletionView dequeueReusableCellWithIdentifier:AutoCompletionCellIdentifier];
    cell.indexPath = indexPath;
    
    NSString *text = self.searchResult[indexPath.row];
    
    if ([self.foundPrefix isEqualToString:@"#"]) {
        text = [NSString stringWithFormat:@"# %@", text];
    }
    else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
        text = [NSString stringWithFormat:@":%@:", text];
    }
    
    cell.titleLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        Message *message = self.messages[indexPath.row];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        CGFloat pointSize = [ChatTableViewCell defaultFontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:pointSize],
                                     NSParagraphStyleAttributeName: paragraphStyle};
        
        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
        width -= 25.0;
        
        CGRect titleBounds = [message.username boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        
        if (message.text.length == 0) {
            return 0.0;
        }
        
        CGFloat height = CGRectGetHeight(titleBounds);
        height += CGRectGetHeight(bodyBounds);
        height += 40.0;
        
        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }
        
        return height;
    }
    else {
        return kMessageTableViewCellMinimumHeight;
    }
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.autoCompletionView]) {
        
        NSMutableString *item = [self.searchResult[indexPath.row] mutableCopy];
        
        if ([self.foundPrefix isEqualToString:@"@"] && self.foundPrefixRange.location == 0) {
            [item appendString:@":"];
        }
        else if (([self.foundPrefix isEqualToString:@":"] || [self.foundPrefix isEqualToString:@"+:"])) {
            [item appendString:@":"];
        }
        
        [item appendString:@" "];
        
        [self acceptAutoCompletionWithString:item keepPrefix:YES];
    }
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you override this method, to call super.
    [super scrollViewDidScroll:scrollView];
}



#pragma mark - Lifeterm

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
