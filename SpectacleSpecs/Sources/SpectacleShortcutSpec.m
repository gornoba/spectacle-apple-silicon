#import "SpectacleTestKeyboardLayout.h"
#import <XCTest/XCTest.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

#import "SpectacleShortcut.h"
#import "SpectacleShortcutUserDefaultsStorage.h"

@interface SpectacleShortcutUserDefaultsStorage (LegacyArchiveTests)
- (NSArray<SpectacleShortcut *> *)shortcutsFromDictionary:(NSDictionary<NSString *, NSData *> *)dictionary
                                                  action:(SpectacleShortcutAction)action;
@end

@interface SpectacleShortcutSpec : XCTestCase
@end

@implementation SpectacleShortcutSpec

- (void)setUp
{
  [super setUp];
  SpectacleCopyKeyboardInputSourceForTesting = SpectacleCopyUSKeyboardLayoutForTest;
}
- (void)tearDown
{
  SpectacleCopyKeyboardInputSourceForTesting = NULL;
  [super tearDown];
}


- (void)testLegacyArchiveAliasesRemainReadableWithoutWritingUserDefaults
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter" shortcutKeyBinding:@"ctrl+cmd+c"];
  for (NSString *alias in @[@"SpectacleHotKey", @"ZeroKitHotKey", @"ZKHotKey"]) {
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    [archiver setClassName:alias forClass:SpectacleShortcut.class];
    [archiver encodeObject:shortcut forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];
    NSArray<SpectacleShortcut *> *decoded = [[SpectacleShortcutUserDefaultsStorage new]
      shortcutsFromDictionary:@{@"MoveToCenter": archiver.encodedData} action:nil];
    XCTAssertEqual(decoded.count, 1u);
    XCTAssertEqualObjects(decoded.firstObject.shortcutName, shortcut.shortcutName);
    XCTAssertEqualObjects(decoded.firstObject.shortcutKeyBinding, shortcut.shortcutKeyBinding);
  }
}

- (void)testShouldBeInitializedWithAKeyBinding
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyBinding:@"option+command+c"];
  XCTAssertEqual(shortcut.shortcutKeyCode, kVK_ANSI_C);
  XCTAssertEqual(shortcut.shortcutModifiers, optionKey | cmdKey);
}

- (void)testShouldBeCopiedWithANewShortcutAction
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  XCTAssertFalse((shortcut.shortcutAction) != 0);
  XCTAssertTrue(([shortcut copyWithShortcutAction:^(SpectacleShortcut *shortcut) {}].shortcutAction) != 0);
}

- (void)testShouldTriggerShortcutActions
{
  __block BOOL shortcutActionTriggered = NO;
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand
  shortcutAction:^(SpectacleShortcut *shortcut) {
  shortcutActionTriggered = YES;
  }];
  [shortcut triggerShortcutAction];
  XCTAssertTrue((shortcutActionTriggered) != 0);
}

- (void)testShouldDetermineIfTheShortcutIsCleared
{
  XCTAssertTrue(([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:nil] isClearedShortcut]) != 0);
  XCTAssertTrue(([[[SpectacleShortcut alloc] initWithShortcutName:nil shortcutKeyBinding:@""] isClearedShortcut]) != 0);
  XCTAssertTrue(([[[SpectacleShortcut alloc] initWithShortcutName:nil
  shortcutKeyCode:-1
  shortcutModifiers:0] isClearedShortcut]) != 0);
  XCTAssertTrue(([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:-1
  shortcutModifiers:0] isClearedShortcut]) != 0);
}

- (void)testShouldProvideADisplayString
{
  XCTAssertEqualObjects([[[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand] displayString], @"⌥⌘C");
}

- (void)testShouldProvideAKeyBinding
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyBinding:@"alt+cmd+c"];
  XCTAssertEqualObjects(shortcut.shortcutKeyBinding, @"alt+cmd+c");
}

- (void)testShouldSupportEquality
{
  SpectacleShortcut *shortcut1 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  SpectacleShortcut *shortcut2 = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  SpectacleShortcut *shortcut3 = [[SpectacleShortcut alloc] initWithShortcutName:nil
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  XCTAssertEqualObjects(shortcut1, shortcut2);
  XCTAssertEqualObjects(shortcut1, shortcut3);
  XCTAssertNotEqualObjects(shortcut1, [[SpectacleShortcut alloc] initWithShortcutName:nil
  shortcutKeyCode:-1
  shortcutModifiers:0]);
}

- (void)testShouldDetermineIfTheShortcutIsContainsModifiers
{
  SpectacleShortcut *shortcut = [[SpectacleShortcut alloc] initWithShortcutName:@"MoveToCenter"
  shortcutKeyCode:kVK_ANSI_C
  shortcutModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand];
  // Validation compares the entire modifier chord to avoid rejecting a different system shortcut.
  XCTAssertFalse([shortcut containsModifiers:NSEventModifierFlagOption]);
  XCTAssertFalse([shortcut containsModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand | NSEventModifierFlagShift]);
  XCTAssertTrue([shortcut containsModifiers:optionKey | cmdKey]);
  XCTAssertTrue(([shortcut containsModifiers:NSEventModifierFlagOption | NSEventModifierFlagCommand]) != 0);
  XCTAssertFalse(([shortcut containsModifiers:NSEventModifierFlagControl]) != 0);
}

@end
