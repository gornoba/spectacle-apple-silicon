#import "SpectacleLoginItemHelper.h"

@implementation SpectacleLoginItemHelper
+ (SMAppServiceStatus)loginItemStatus
{
  return SMAppService.mainAppService.status;
}

+ (BOOL)canManageLoginItemForBundleURL:(NSURL *)bundleURL
{
  return [bundleURL.URLByResolvingSymlinksInPath.path isEqualToString:@"/Applications/Spectacle.app"];
}

+ (BOOL)setLoginItemEnabled:(BOOL)enabled error:(NSError **)error
{
  if (![self canManageLoginItemForBundleURL:NSBundle.mainBundle.bundleURL]) {
    if (error) {
      *error = [NSError errorWithDomain:@"com.divisiblebyzero.Spectacle.LoginItem" code:1
                              userInfo:@{NSLocalizedDescriptionKey: @"Move Spectacle to Applications before changing launch at login."}];
    }
    return NO;
  }
  return [self setLoginItemEnabled:enabled
                          service:(id<SpectacleLoginItemService>)SMAppService.mainAppService error:error];
}

+ (BOOL)setLoginItemEnabled:(BOOL)enabled service:(id<SpectacleLoginItemService>)service error:(NSError **)error
{
  if (error) {
    *error = nil;
  }
  SMAppServiceStatus status = service.status;
  if (enabled) {
    if (status == SMAppServiceStatusEnabled || status == SMAppServiceStatusRequiresApproval) {
      return YES;
    }
    return [service registerAndReturnError:error];
  }
  if (status == SMAppServiceStatusNotRegistered || status == SMAppServiceStatusNotFound) {
    return YES;
  }
  return [service unregisterAndReturnError:error];
}

+ (NSControlStateValue)checkboxStateForStatus:(SMAppServiceStatus)status
{
  switch (status) {
    case SMAppServiceStatusEnabled: return NSControlStateValueOn;
    case SMAppServiceStatusRequiresApproval: return NSControlStateValueMixed;
    case SMAppServiceStatusNotRegistered:
    case SMAppServiceStatusNotFound: return NSControlStateValueOff;
  }
  return NSControlStateValueOff;
}
@end
