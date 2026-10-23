#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>

@protocol SpectacleLoginItemService <NSObject>
@property (readonly) SMAppServiceStatus status;
- (BOOL)registerAndReturnError:(NSError **)error;
- (BOOL)unregisterAndReturnError:(NSError **)error;
@end

@interface SpectacleLoginItemHelper : NSObject
+ (SMAppServiceStatus)loginItemStatus;
+ (BOOL)canManageLoginItemForBundleURL:(NSURL *)bundleURL;
+ (BOOL)setLoginItemEnabled:(BOOL)enabled error:(NSError **)error;
// The service parameter lets tests exercise registration without touching macOS login items.
+ (BOOL)setLoginItemEnabled:(BOOL)enabled service:(id<SpectacleLoginItemService>)service error:(NSError **)error;
+ (NSControlStateValue)checkboxStateForStatus:(SMAppServiceStatus)status;
@end
