/**
 * Copied and modified from: https://stackoverflow.com/questions/1490573/how-can-i-programmatically-check-whether-a-keyboard-is-present-in-ios-app
 * Credits: rpetrich, drawnonward
 */
@interface KeyboardStateListener : NSObject {
    BOOL _isVisible;
}

+ (KeyboardStateListener *)sharedInstance;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@end
