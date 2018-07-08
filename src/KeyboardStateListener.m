/**
 * Copied and modified from: https://stackoverflow.com/questions/1490573/how-can-i-programmatically-check-whether-a-keyboard-is-present-in-ios-app
 * Credits: rpetrich, drawnonward
 */
#import "includes/KeyboardStateListener.h"

static KeyboardStateListener *sharedInstance;

@implementation KeyboardStateListener

+ (KeyboardStateListener *)sharedInstance {
    return sharedInstance;
}

+ (void)load {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    sharedInstance = [[self alloc] init];
    [pool release];
}

- (BOOL)isVisible {
    return _isVisible;
}

- (void)didShow {
    _isVisible = YES;
}

- (void)didHide {
    _isVisible = NO;
}

- (id)init {
    if ((self = [super init])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didShow) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(didHide) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

@end
