# XCTest migration from e75c341

All 99 original examples are retained. The five position-manager examples use hand-written doubles; invalid-rectangle and failed-screen fixtures now reach their intended branches. Expected coordinates are preserved. One obsolete assertion is corrected: `containsModifiers:` compares the complete chord (as implemented since 0ffff07), not a subset; partial and extra-modifier rejection are now explicit. US-layout fixtures are process-local and do not select or modify the system keyboard layout.

| Original file | Original example | XCTest method |
|---|---|---|
| SpectacleBottomHalfWindowCalculationSpec.m | should calculate a window's CGRect in the bottom half of the screen | `testShouldCalculateAWindowSCGRectInTheBottomHalfOfTheScreen` |
| SpectacleBottomHalfWindowCalculationSpec.m | should calculate a window's CGRect in the bottom 2/3 of the screen | `testShouldCalculateAWindowSCGRectInTheBottom23OfTheScreen` |
| SpectacleBottomHalfWindowCalculationSpec.m | should calculate a window's CGRect in the bottom 1/3 of the screen | `testShouldCalculateAWindowSCGRectInTheBottom13OfTheScreen` |
| SpectacleCenterWindowCalculationSpec.m | should calculate a centered window's CGRect | `testShouldCalculateACenteredWindowSCGRect` |
| SpectacleFullscreenWindowCalculationSpec.m | should calculate a fullscreen window's CGRect | `testShouldCalculateAFullscreenWindowSCGRect` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when centered in the screen | `testShouldCalculateAWindowSLargerCGRectWhenCenteredInTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the top edge of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheTopEdgeOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the bottom edge of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheBottomEdgeOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the left edge of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheLeftEdgeOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the right edge of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheRightEdgeOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the top and left edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheTopAndLeftEdgesOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the top and right edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheTopAndRightEdgesOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the bottom and left edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheBottomAndLeftEdgesOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the bottom and right edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheBottomAndRightEdgesOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the top and bottom edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheTopAndBottomEdgesOfTheScreen` |
| SpectacleLargerWindowCalculationSpec.m | should calculate a window's larger CGRect when against the left and right edges of the screen | `testShouldCalculateAWindowSLargerCGRectWhenAgainstTheLeftAndRightEdgesOfTheScreen` |
| SpectacleLeftHalfWindowCalculationSpec.m | should calculate a window's CGRect in the left half of the screen | `testShouldCalculateAWindowSCGRectInTheLeftHalfOfTheScreen` |
| SpectacleLeftHalfWindowCalculationSpec.m | should calculate a window's CGRect in the left 2/3 of the screen | `testShouldCalculateAWindowSCGRectInTheLeft23OfTheScreen` |
| SpectacleLeftHalfWindowCalculationSpec.m | should calculate a window's CGRect in the left 1/3 of the screen | `testShouldCalculateAWindowSCGRectInTheLeft13OfTheScreen` |
| SpectacleLowerLeftWindowCalculationSpec.m | should calculate a window's CGRect in the lower left corner of the screen | `testShouldCalculateAWindowSCGRectInTheLowerLeftCornerOfTheScreen` |
| SpectacleLowerRightWindowCalculationSpec.m | should calculate a window's CGRect in the lower right corner of the screen | `testShouldCalculateAWindowSCGRectInTheLowerRightCornerOfTheScreen` |
| SpectacleNextDisplayWindowCalculationSpec.m | should calculate a centered window's CGRect in the next display | `testShouldCalculateACenteredWindowSCGRectInTheNextDisplay` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the first horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheFirstHorizontalThirdOfTheScreen` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the second horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheSecondHorizontalThirdOfTheScreen` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the last horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheLastHorizontalThirdOfTheScreen` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the first vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheFirstVerticalThirdOfTheScreen` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the second vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheSecondVerticalThirdOfTheScreen` |
| SpectacleNextThirdWindowCalculationSpec.m | should calculate a window's CGRect in the last vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheLastVerticalThirdOfTheScreen` |
| SpectaclePreviousDisplayWindowCalculationSpec.m | should calculate a centered window's CGRect in the previous display | `testShouldCalculateACenteredWindowSCGRectInThePreviousDisplay` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the first horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheFirstHorizontalThirdOfTheScreen` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the last vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheLastVerticalThirdOfTheScreen` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the second vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheSecondVerticalThirdOfTheScreen` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the first vertical third of the screen | `testShouldCalculateAWindowSCGRectInTheFirstVerticalThirdOfTheScreen` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the last horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheLastHorizontalThirdOfTheScreen` |
| SpectaclePreviousThirdWindowCalculationSpec.m | should calculate a window's CGRect in the second horizontal third of the screen | `testShouldCalculateAWindowSCGRectInTheSecondHorizontalThirdOfTheScreen` |
| SpectacleRightHalfWindowCalculationSpec.m | should calculate a window's CGRect in the right half of the screen | `testShouldCalculateAWindowSCGRectInTheRightHalfOfTheScreen` |
| SpectacleRightHalfWindowCalculationSpec.m | should calculate a window's CGRect in the right 2/3 of the screen | `testShouldCalculateAWindowSCGRectInTheRight23OfTheScreen` |
| SpectacleRightHalfWindowCalculationSpec.m | should calculate a window's CGRect in the right 1/3 of the screen | `testShouldCalculateAWindowSCGRectInTheRight13OfTheScreen` |
| SpectacleShortcutKeyBindingsSpec.m | should convert an empty or nil key binding to nil modifiers | `testShouldConvertAnEmptyOrNilKeyBindingToNilModifiers` |
| SpectacleShortcutKeyBindingsSpec.m | should convert key bindings to modifiers | `testShouldConvertKeyBindingsToModifiers` |
| SpectacleShortcutKeyBindingsSpec.m | should convert mixed case key bindings to modifiers | `testShouldConvertMixedCaseKeyBindingsToModifiers` |
| SpectacleShortcutKeyBindingsSpec.m | should convert key bindings with whitespace to modifiers | `testShouldConvertKeyBindingsWithWhitespaceToModifiers` |
| SpectacleShortcutKeyBindingsSpec.m | should convert an empty or nil key binding to nil key codes | `testShouldConvertAnEmptyOrNilKeyBindingToNilKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert lowercase alphabetical key bindings to key codes | `testShouldConvertLowercaseAlphabeticalKeyBindingsToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert uppercase alphabetical key bindings to key codes | `testShouldConvertUppercaseAlphabeticalKeyBindingsToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert numeric key bindings to key codes | `testShouldConvertNumericKeyBindingsToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert alphabetical key bindings with modifiers to key codes | `testShouldConvertAlphabeticalKeyBindingsWithModifiersToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert alphanumeric key bindings with whitespace to key codes | `testShouldConvertAlphanumericKeyBindingsWithWhitespaceToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert named key bindings to key codes | `testShouldConvertNamedKeyBindingsToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert mixed case named key bindings to key codes | `testShouldConvertMixedCaseNamedKeyBindingsToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert named key bindings with modifiers to key codes | `testShouldConvertNamedKeyBindingsWithModifiersToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert mixed case named key bindings with modifiers to key codes | `testShouldConvertMixedCaseNamedKeyBindingsWithModifiersToKeyCodes` |
| SpectacleShortcutKeyBindingsSpec.m | should convert empty shortcuts to nil key bindings | `testShouldConvertEmptyShortcutsToNilKeyBindings` |
| SpectacleShortcutKeyBindingsSpec.m | should convert shortcuts to key bindings | `testShouldConvertShortcutsToKeyBindings` |
| SpectacleShortcutSpec.m | should be initialized with a key binding | `testShouldBeInitializedWithAKeyBinding` |
| SpectacleShortcutSpec.m | should be copied with a new shortcut action | `testShouldBeCopiedWithANewShortcutAction` |
| SpectacleShortcutSpec.m | should trigger shortcut actions | `testShouldTriggerShortcutActions` |
| SpectacleShortcutSpec.m | should determine if the shortcut is cleared | `testShouldDetermineIfTheShortcutIsCleared` |
| SpectacleShortcutSpec.m | should provide a display string | `testShouldProvideADisplayString` |
| SpectacleShortcutSpec.m | should provide a key binding | `testShouldProvideAKeyBinding` |
| SpectacleShortcutSpec.m | should support equality | `testShouldSupportEquality` |
| SpectacleShortcutSpec.m | should determine if the shortcut is contains modifiers | `testShouldDetermineIfTheShortcutIsContainsModifiers` |
| SpectacleShortcutTranslationsSpec.m | should translate alphanumeric key codes | `testShouldTranslateAlphanumericKeyCodes` |
| SpectacleShortcutTranslationsSpec.m | should translate keyboard layout independent key codes | `testShouldTranslateKeyboardLayoutIndependentKeyCodes` |
| SpectacleShortcutTranslationsSpec.m | should translate empty modifiers | `testShouldTranslateEmptyModifiers` |
| SpectacleShortcutTranslationsSpec.m | should translate modifiers | `testShouldTranslateModifiers` |
| SpectacleShortcutTranslationsSpec.m | should translate shortcuts | `testShouldTranslateShortcuts` |
| SpectacleShortcutTranslationsSpec.m | should convert empty modifiers | `testShouldConvertEmptyModifiers` |
| SpectacleShortcutTranslationsSpec.m | should convert invalid modifiers | `testShouldConvertInvalidModifiers` |
| SpectacleShortcutTranslationsSpec.m | should convert Cocoa modifiers to Carbon modifiers | `testShouldConvertCocoaModifiersToCarbonModifiers` |
| SpectacleShortcutTranslationsSpec.m | should convert Carbon modifiers to Cocoa modifiers | `testShouldConvertCarbonModifiersToCocoaModifiers` |
| SpectacleShortcutTranslationsSpec.m | should convert modifiers to Carbon modifiers if necessary | `testShouldConvertModifiersToCarbonModifiersIfNecessary` |
| SpectacleShortcutTranslationsSpec.m | should convert modifiers to Cocoa modifiers if necessary | `testShouldConvertModifiersToCocoaModifiersIfNecessary` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when centered in the screen | `testShouldCalculateAWindowSSmallerCGRectWhenCenteredInTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the top edge of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheTopEdgeOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the bottom edge of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheBottomEdgeOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the left edge of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheLeftEdgeOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the right edge of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheRightEdgeOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the top and left edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheTopAndLeftEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the top and right edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheTopAndRightEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the bottom and left edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheBottomAndLeftEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the bottom and right edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheBottomAndRightEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the top and bottom edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheTopAndBottomEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against the left and right edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstTheLeftAndRightEdgesOfTheScreen` |
| SpectacleSmallerWindowCalculationSpec.m | should calculate a window's smaller CGRect when against all edges of the screen | `testShouldCalculateAWindowSSmallerCGRectWhenAgainstAllEdgesOfTheScreen` |
| SpectacleTopHalfWindowCalculationSpec.m | should calculate a window's CGRect in the top half of the screen | `testShouldCalculateAWindowSCGRectInTheTopHalfOfTheScreen` |
| SpectacleTopHalfWindowCalculationSpec.m | should calculate a window's CGRect in the top 2/3 of the screen | `testShouldCalculateAWindowSCGRectInTheTop23OfTheScreen` |
| SpectacleTopHalfWindowCalculationSpec.m | should calculate a window's CGRect in the top 1/3 of the screen | `testShouldCalculateAWindowSCGRectInTheTop13OfTheScreen` |
| SpectacleUpperLeftWindowCalculationSpec.m | should calculate a window's CGRect in the upper left corner of the screen | `testShouldCalculateAWindowSCGRectInTheUpperLeftCornerOfTheScreen` |
| SpectacleUpperLeftWindowCalculationSpec.m | should calculate a window's CGRect in the left 2/3 of the screen | `testShouldCalculateAWindowSCGRectInTheLeft23OfTheScreen` |
| SpectacleUpperLeftWindowCalculationSpec.m | should calculate a window's CGRect in the left 1/3 of the screen | `testShouldCalculateAWindowSCGRectInTheLeft13OfTheScreen` |
| SpectacleUpperRightWindowCalculationSpec.m | should calculate a window's CGRect in the upper right corner of the screen | `testShouldCalculateAWindowSCGRectInTheUpperRightCornerOfTheScreen` |
| SpectacleUpperRightWindowCalculationSpec.m | should calculate a window's CGRect in the upper right 2/3 corner of the screen | `testShouldCalculateAWindowSCGRectInTheUpperRight23CornerOfTheScreen` |
| SpectacleUpperRightWindowCalculationSpec.m | should calculate a window's CGRect in the upper right 1/3 corner of the screen | `testShouldCalculateAWindowSCGRectInTheUpperRight13CornerOfTheScreen` |
| SpectacleWindowPositionManagerSpec.m | should do nothing if the frontmost window is a sheet | `testShouldDoNothingIfTheFrontmostWindowIsASheet` |
| SpectacleWindowPositionManagerSpec.m | should do nothing if the frontmost window is a system dialog | `testShouldDoNothingIfTheFrontmostWindowIsASystemDialog` |
| SpectacleWindowPositionManagerSpec.m | should do nothing if the frontmost window rect is unavailable | `testShouldDoNothingIfTheFrontmostWindowRectIsUnavailable` |
| SpectacleWindowPositionManagerSpec.m | should do nothing if screen detection fails | `testShouldDoNothingIfScreenDetectionFails` |
| SpectacleWindowPositionManagerSpec.m | should do nothing if the window position calculation returns the same results | `testShouldDoNothingIfTheWindowPositionCalculationReturnsTheSameResults` |
