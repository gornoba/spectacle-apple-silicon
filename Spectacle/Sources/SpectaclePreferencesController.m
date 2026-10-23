#import "SpectaclePreferencesController.h"

#import <QuartzCore/QuartzCore.h>

#import "SpectacleAccessibilityElement.h"
#import "SpectacleDefaultShortcutHelpers.h"
#import "SpectacleLoginItemHelper.h"
#import "SpectacleRegisteredShortcutValidator.h"
#import "SpectacleShortcut.h"
#import "SpectacleShortcutManager.h"
#import "SpectacleShortcutRecorder.h"
#import "SpectacleShortcutStorage.h"
#import "SpectacleShortcutValidation.h"
#import "SpectacleUtilities.h"
#import "SpectacleWindowPositionManager.h"

@implementation SpectaclePreferencesController
{
  SpectacleShortcutManager *_shortcutManager;
  SpectacleWindowPositionManager *_windowPositionManager;
  id<SpectacleShortcutStorage> _shortcutStorage;
  NSDictionary<NSString *, SpectacleShortcutRecorder *> *_shortcutRecorders;
}

- (instancetype)initWithShortcutManager:(SpectacleShortcutManager *)shortcutManager
                  windowPositionManager:(SpectacleWindowPositionManager *)windowPositionManager
                        shortcutStorage:(id<SpectacleShortcutStorage>)shortcutStorage
{
  if (self = [super initWithWindowNibName:@"SpectaclePreferencesWindow"]) {
    _shortcutManager = shortcutManager;
    _windowPositionManager = windowPositionManager;
    _shortcutStorage = shortcutStorage;
  }
  return self;
}

- (void)windowDidLoad
{
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  BOOL isStatusItemEnabled = [NSUserDefaults.standardUserDefaults boolForKey:@"StatusItemEnabled"];
  _shortcutRecorders = @{
                         @"MoveToCenter": _moveToCenterShortcutRecorder,
                         @"MoveToFullscreen": _moveToFullscreenShortcutRecorder,
                         @"MoveToLeftHalf": _moveToLeftShortcutRecorder,
                         @"MoveToRightHalf": _moveToRightShortcutRecorder,
                         @"MoveToTopHalf": _moveToTopShortcutRecorder,
                         @"MoveToBottomHalf": _moveToBottomShortcutRecorder,
                         @"MoveToUpperLeft": _moveToUpperLeftShortcutRecorder,
                         @"MoveToLowerLeft": _moveToLowerLeftShortcutRecorder,
                         @"MoveToUpperRight": _moveToUpperRightShortcutRecorder,
                         @"MoveToLowerRight": _moveToLowerRightShortcutRecorder,
                         @"MoveToNextDisplay": _moveToNextDisplayShortcutRecorder,
                         @"MoveToPreviousDisplay": _moveToPreviousDisplayShortcutRecorder,
                         @"MoveToNextThird": _moveToNextThirdShortcutRecorder,
                         @"MoveToPreviousThird": _moveToPreviousThirdShortcutRecorder,
                         @"MakeLarger": _makeLargerShortcutRecorder,
                         @"MakeSmaller": _makeSmallerShortcutRecorder,
                         @"UndoLastMove": _undoLastMoveShortcutRecorder,
                         @"RedoLastMove": _redoLastMoveShortcutRecorder,
                         };
  [self loadRegisteredShortcuts];
  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredShortcuts)
                             name:@"SpectacleShortcutChangedNotification"
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(loadRegisteredShortcuts)
                             name:@"SpectacleRestoreDefaultShortcutsNotification"
                           object:nil];
  [self refreshLoginItemState];
  [notificationCenter addObserver:self selector:@selector(refreshLoginItemState)
                             name:NSApplicationDidBecomeActiveNotification object:nil];
  [self.statusItemEnabled selectItemWithTag:isStatusItemEnabled ? 0 : 1];
  self.window.title = [@"Spectacle " stringByAppendingString:SpectacleUtilities.applicationVersion];
  self.footerView.wantsLayer = YES;
}

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
   didReceiveNewShortcut:(SpectacleShortcut *)shortcut
{
  [_shortcutManager updateShortcut:[shortcut copyWithShortcutAction:^(SpectacleShortcut *shortcut) {
    [self->_windowPositionManager moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                                                      action:shortcut.windowAction];
  }]];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleShortcutChangedNotification" object:self];
}

- (void)shortcutRecorder:(SpectacleShortcutRecorder *)shortcutRecorder
didClearExistingShortcut:(SpectacleShortcut *)shortcut
{
  [_shortcutManager clearShortcut:shortcut];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleShortcutChangedNotification" object:self];
}

- (void)loadRegisteredShortcuts
{
  for (NSString *shortcutName in _shortcutRecorders.allKeys) {
    SpectacleShortcutRecorder *shortcutRecorder = _shortcutRecorders[shortcutName];
    SpectacleShortcut *shortcut = [_shortcutManager shortcutForShortcutName:shortcutName];
    shortcutRecorder.shortcutName = shortcutName;
    shortcutRecorder.shortcut = shortcut;
    shortcutRecorder.delegate = self;
    shortcutRecorder.shortcutValidation =
    [[SpectacleShortcutValidation alloc] initWithShortcutManager:_shortcutManager
                                                      validators:@[
                                                                   [SpectacleRegisteredShortcutValidator new],
                                                                   ]];
  }
}

- (IBAction)swapFooterViews:(id)sender
{
  CATransition *transition = [CATransition animation];
  NSView *currentFooterView = self.footerView.subviews[0];
  NSView *nextFooterView = nil;
  transition.type = kCATransitionPush;
  if (currentFooterView == self.shortcutModifierLegendFooterView) {
    nextFooterView = self.optionsFooterView;
    transition.subtype = kCATransitionFromRight;
  } else {
    nextFooterView = self.shortcutModifierLegendFooterView;
    transition.subtype = kCATransitionFromLeft;
  }
  self.footerView.animations = @{@"subviews": transition};
  [self.footerView.animator replaceSubview:currentFooterView
                                      with:nextFooterView];
}

- (IBAction)restoreDefaults:(id)sender
{
  [SpectacleUtilities displayRestoreDefaultsAlertWithConfirmationCallback:^() {
    NSArray<SpectacleShortcut *> *shortcuts = SpectacleDefaultShortcutsWithAction(^(SpectacleShortcut *shortcut) {
      [self->_windowPositionManager moveFrontmostWindowElement:[SpectacleAccessibilityElement frontmostWindowElement]
                                                        action:shortcut.windowAction];
    });
    [self->_shortcutManager updateShortcuts:shortcuts];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SpectacleRestoreDefaultShortcutsNotification"
                                                        object:self];
  }];
}

- (void)refreshLoginItemState
{
  BOOL installed = [SpectacleLoginItemHelper canManageLoginItemForBundleURL:NSBundle.mainBundle.bundleURL];
  SMAppServiceStatus status = [SpectacleLoginItemHelper loginItemStatus];
  self.loginItemEnabled.enabled = installed;
  self.loginItemEnabled.allowsMixedState = status == SMAppServiceStatusRequiresApproval;
  self.loginItemEnabled.state = [SpectacleLoginItemHelper checkboxStateForStatus:status];
  self.loginItemEnabled.toolTip = !installed
    ? @"Move Spectacle to Applications before changing launch at login."
    : (status == SMAppServiceStatusRequiresApproval
       ? @"Allow Spectacle in System Settings > General > Login Items."
       : @"Launch Spectacle automatically when you log in.");
}

- (IBAction)toggleLoginItem:(id)sender
{
  BOOL enabled = self.loginItemEnabled.state != NSControlStateValueOff;
  NSError *error = nil;
  if (![SpectacleLoginItemHelper setLoginItemEnabled:enabled error:&error]) {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Unable to change launch at login";
    alert.informativeText = error.localizedDescription ?: @"Check the login item in System Settings and try again.";
    [alert runModal];
  } else if ([SpectacleLoginItemHelper loginItemStatus] == SMAppServiceStatusRequiresApproval) {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Allow Spectacle to launch at login";
    alert.informativeText = @"Your approval is required in System Settings > General > Login Items.";
    [alert addButtonWithTitle:@"Open System Settings"];
    [alert addButtonWithTitle:@"Later"];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
      [SMAppService openSystemSettingsLoginItems];
    }
  }
  [self refreshLoginItemState];
}

- (IBAction)toggleStatusItem:(id)sender
{
  NSString *notificationName = @"SpectacleStatusItemEnabledNotification";
  BOOL isStatusItemEnabled = YES;
  __block BOOL statusItemStateChanged = YES;
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  if ([userDefaults boolForKey:@"StatusItemEnabled"] == ([[sender selectedItem] tag] == 0)) {
    return;
  }
  if ([sender selectedItem].tag != 0) {
    notificationName = @"SpectacleStatusItemDisabledNotification";
    isStatusItemEnabled = NO;
    if (![userDefaults boolForKey:@"BackgroundAlertSuppressed"]) {
      [SpectacleUtilities displayRunningInBackgroundAlertWithCallback:^(BOOL isConfirmed, BOOL isSuppressed) {
        if (!isConfirmed) {
          statusItemStateChanged = NO;
          [sender selectItemWithTag:0];
        }
        [userDefaults setBool:isSuppressed forKey:@"BackgroundAlertSuppressed"];
      }];
    }
  }
  if (statusItemStateChanged) {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    [userDefaults setBool:isStatusItemEnabled forKey:@"StatusItemEnabled"];
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
