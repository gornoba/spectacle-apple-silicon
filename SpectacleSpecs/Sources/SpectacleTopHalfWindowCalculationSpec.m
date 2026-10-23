#import <XCTest/XCTest.h>
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"

@interface SpectacleTopHalfWindowCalculationSpec : XCTestCase
@end

@implementation SpectacleTopHalfWindowCalculationSpec

- (void)testShouldCalculateAWindowSCGRectInTheTopHalfOfTheScreen
{
  CGRect visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  CGRect visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  SpectacleWindowPositionCalculator *windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
  XCTFail(@"%@", message);
  } resourceBundle:[NSBundle bundleForClass:self.class]];

  SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(165.0f, 245.0f, 564.0f, 384.0f)
  visibleFrameOfSourceScreen:visibleFrameSourceScreen
  visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
  action:kSpectacleWindowActionTopHalf];
  XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 441.0f, 1440.0f, 436.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheTop23OfTheScreen
{
  CGRect visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  CGRect visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  SpectacleWindowPositionCalculator *windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
  XCTFail(@"%@", message);
  } resourceBundle:[NSBundle bundleForClass:self.class]];

  SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 441.0f, 1440.0f, 436.0f)
  visibleFrameOfSourceScreen:visibleFrameSourceScreen
  visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
  action:kSpectacleWindowActionTopHalf];
  XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 295.0f, 1440.0f, 582.0f)));
}

- (void)testShouldCalculateAWindowSCGRectInTheTop13OfTheScreen
{
  CGRect visibleFrameSourceScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  CGRect visibleFrameDestinationScreen = CGRectMake(0.0f, 4.0f, 1440.0f, 873.0f);
  SpectacleWindowPositionCalculator *windowPositionCalculator = [[SpectacleWindowPositionCalculator alloc] initWithErrorHandler:^(NSString *message) {
  XCTFail(@"%@", message);
  } resourceBundle:[NSBundle bundleForClass:self.class]];

  SpectacleWindowPositionCalculationResult *result = [windowPositionCalculator calculateWindowRect:CGRectMake(0.0f, 295.0f, 1440.0f, 582.0f)
  visibleFrameOfSourceScreen:visibleFrameSourceScreen
  visibleFrameOfDestinationScreen:visibleFrameDestinationScreen
  action:kSpectacleWindowActionTopHalf];
  XCTAssertTrue(CGRectEqualToRect(result.windowRect, CGRectMake(0.0f, 586.0f, 1440.0f, 291.0f)));
}

@end
