#import <Foundation/Foundation.h>

#if SPECTACLE_TESTING
#import <Carbon/Carbon.h>
// Present only in the independent test target; never changes the system input source.
extern TISInputSourceRef (*SpectacleCopyKeyboardInputSourceForTesting)(void);
#endif

@class SpectacleShortcut;

NSString *SpectacleTranslateKeyCode(NSInteger keyCode);
NSString *SpectacleTranslateModifiers(NSUInteger modifiers);
NSString *SpectacleTranslateShortcut(SpectacleShortcut *shortcut);

NSUInteger SpectacleConvertCocoaModifiersToCarbon(NSUInteger modifiers);
NSUInteger SpectacleConvertCarbonModifiersToCocoa(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCarbonIfNecessary(NSUInteger modifiers);
NSUInteger SpectacleConvertModifiersToCocoaIfNecessary(NSUInteger modifiers);
