#import <XCTest/XCTest.h>
#import "SpectacleLoginItemHelper.h"

@interface TestLoginService : NSObject <SpectacleLoginItemService>
@property SMAppServiceStatus status;
@property NSUInteger registrations;
@property NSUInteger removals;
@property BOOL shouldFail;
@end
@implementation TestLoginService
- (BOOL)registerAndReturnError:(NSError **)error
{
  self.registrations++;
  if (self.shouldFail) {
    if (error) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:1 userInfo:nil];
    return NO;
  }
  self.status = SMAppServiceStatusEnabled;
  return YES;
}
- (BOOL)unregisterAndReturnError:(NSError **)error
{
  self.removals++;
  if (self.shouldFail) {
    if (error) *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:2 userInfo:nil];
    return NO;
  }
  self.status = SMAppServiceStatusNotRegistered;
  return YES;
}
@end

@interface SpectacleLoginItemHelperSpec : XCTestCase
@end
@implementation SpectacleLoginItemHelperSpec
- (void)testRegistrationAndRemovalUseTheService
{
  TestLoginService *service = [TestLoginService new];
  NSError *error = nil;
  XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:YES service:service error:&error]);
  XCTAssertEqual(service.registrations, 1u);
  XCTAssertEqual(service.status, SMAppServiceStatusEnabled);
  XCTAssertNil(error);
  XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:NO service:service error:&error]);
  XCTAssertEqual(service.removals, 1u);
  XCTAssertEqual(service.status, SMAppServiceStatusNotRegistered);
}
- (void)testEnabledRegistrationIsIdempotent
{
  TestLoginService *service = [TestLoginService new];
  service.status = SMAppServiceStatusEnabled;
  XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:YES service:service error:NULL]);
  XCTAssertEqual(service.registrations, 0u);
}
- (void)testApprovalPendingIsNotReportedAsEnabled
{
  TestLoginService *service = [TestLoginService new];
  service.status = SMAppServiceStatusRequiresApproval;
  XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:YES service:service error:NULL]);
  XCTAssertEqual(service.registrations, 0u);
  XCTAssertEqual([SpectacleLoginItemHelper checkboxStateForStatus:service.status], NSControlStateValueMixed);
  XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:NO service:service error:NULL]);
  XCTAssertEqual(service.removals, 1u);
}
- (void)testRegistrationFailurePreservesTheActualStatus
{
  TestLoginService *service = [TestLoginService new];
  service.shouldFail = YES;
  NSError *error = nil;
  XCTAssertFalse([SpectacleLoginItemHelper setLoginItemEnabled:YES service:service error:&error]);
  XCTAssertNotNil(error);
  XCTAssertEqual(service.status, SMAppServiceStatusNotRegistered);
  XCTAssertEqual([SpectacleLoginItemHelper checkboxStateForStatus:service.status], NSControlStateValueOff);
}
- (void)testRemovalFailureDoesNotPretendTheItemIsDisabled
{
  TestLoginService *service = [TestLoginService new];
  service.status = SMAppServiceStatusEnabled;
  service.shouldFail = YES;
  NSError *error = nil;
  XCTAssertFalse([SpectacleLoginItemHelper setLoginItemEnabled:NO service:service error:&error]);
  XCTAssertNotNil(error);
  XCTAssertEqual([SpectacleLoginItemHelper checkboxStateForStatus:service.status], NSControlStateValueOn);
}
- (void)testMissingAndUnregisteredItemsNeedNoRemoval
{
  TestLoginService *service = [TestLoginService new];
  for (NSNumber *status in @[@(SMAppServiceStatusNotRegistered), @(SMAppServiceStatusNotFound)]) {
    service.status = status.integerValue;
    XCTAssertTrue([SpectacleLoginItemHelper setLoginItemEnabled:NO service:service error:NULL]);
    XCTAssertEqual([SpectacleLoginItemHelper checkboxStateForStatus:service.status], NSControlStateValueOff);
  }
  XCTAssertEqual(service.removals, 0u);
}
- (void)testOnlyTheInstalledBundleCanChangeLoginItems
{
  XCTAssertTrue([SpectacleLoginItemHelper canManageLoginItemForBundleURL:[NSURL fileURLWithPath:@"/Applications/Spectacle.app"]]);
  XCTAssertFalse([SpectacleLoginItemHelper canManageLoginItemForBundleURL:[NSURL fileURLWithPath:@"/tmp/Spectacle.app"]]);
  XCTAssertFalse([SpectacleLoginItemHelper canManageLoginItemForBundleURL:[NSURL fileURLWithPath:@"/Applications/Spectacle Copy.app"]]);
}
@end
