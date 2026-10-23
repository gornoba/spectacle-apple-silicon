#import "SpectacleShortcutTranslations.h"

// Read a known layout without selecting it or changing the user's keyboard settings.
static TISInputSourceRef SpectacleCopyUSKeyboardLayoutForTest(void)
{
  CFArrayRef sources = TISCreateInputSourceList((__bridge CFDictionaryRef)@{
    (__bridge NSString *)kTISPropertyInputSourceID: @"com.apple.keylayout.US"
  }, true);
  TISInputSourceRef source = NULL;
  if (sources && CFArrayGetCount(sources) > 0) {
    source = (TISInputSourceRef)CFRetain(CFArrayGetValueAtIndex(sources, 0));
  }
  if (sources) CFRelease(sources);
  return source;
}
