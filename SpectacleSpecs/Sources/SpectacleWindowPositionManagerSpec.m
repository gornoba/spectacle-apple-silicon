#import <XCTest/XCTest.h>
#import "SpectacleAccessibilityElement.h"
#import "SpectacleScreenDetectionResult.h"
#import "SpectacleScreenDetector.h"
#import "SpectacleWindowPositionCalculationResult.h"
#import "SpectacleWindowPositionCalculator.h"
#import "SpectacleWindowPositionManager.h"
#import "SpectacleWindowMover.h"

@interface TestScreen : NSObject
@end
@implementation TestScreen
- (NSRect)frame { return NSMakeRect(0, 0, 1440, 900); }
- (NSRect)visibleFrame { return NSMakeRect(0, 4, 1440, 873); }
@end

@interface TestElement : SpectacleAccessibilityElement
@property CGRect testRect;
@property BOOL sheet;
@property BOOL dialog;
@property NSUInteger rectReads;
@property NSUInteger sheetReads;
@property NSUInteger dialogReads;
@property NSUInteger writes;
@end
@implementation TestElement
- (CGRect)rectOfElement { self.rectReads++; return self.testRect; }
- (BOOL)isSheet { self.sheetReads++; return self.sheet; }
- (BOOL)isSystemDialog { self.dialogReads++; return self.dialog; }
- (void)setRectOfElement:(CGRect)rect { self.writes++; self.testRect = rect; }
@end

@interface TestScreenDetector : NSObject
@property (strong) SpectacleScreenDetectionResult *result;
@property NSUInteger calls;
@end
@implementation TestScreenDetector
- (SpectacleScreenDetectionResult *)screenWithAction:(SpectacleWindowAction *)action
                              frontmostWindowElement:(SpectacleAccessibilityElement *)element
                                             screens:(NSArray *)screens mainScreen:(NSScreen *)mainScreen
{ self.calls++; return self.result; }
@end

@interface TestPositionCalculator : NSObject
@property (strong) SpectacleWindowPositionCalculationResult *result;
@property NSUInteger calls;
@end
@implementation TestPositionCalculator
- (SpectacleWindowPositionCalculationResult *)calculateWindowRect:(CGRect)rect
                                     visibleFrameOfSourceScreen:(CGRect)source
                                visibleFrameOfDestinationScreen:(CGRect)destination
                                                         action:(SpectacleWindowAction *)action
{ self.calls++; return self.result; }
@end

@interface TestApplication : NSObject
@end
@implementation TestApplication
- (NSString *)bundleIdentifier { return @"com.divisiblebyzero.SpectacleSpecs"; }
@end
@interface TestWorkspace : NSObject
@end
@implementation TestWorkspace
- (id)frontmostApplication { return [TestApplication new]; }
@end

@interface TestWindowMover : NSObject <SpectacleWindowMover>
@property NSUInteger calls;
@end
@implementation TestWindowMover
- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMover>)inner { return [super init]; }
+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMover>)inner { return [[self alloc] initWithInnerWindowMover:inner]; }
- (void)moveWindowRect:(CGRect)rect frameOfScreen:(CGRect)screen visibleFrameOfScreen:(CGRect)visible
frontmostWindowElement:(SpectacleAccessibilityElement *)element action:(SpectacleWindowAction *)action
{ self.calls++; }
@end

@interface SpectacleWindowPositionManagerSpec : XCTestCase
@property (strong) TestScreen *screen;
@property (strong) TestScreenDetector *detector;
@property (strong) TestPositionCalculator *calculator;
@property (strong) TestWindowMover *mover;
@property (strong) TestElement *element;
@property (strong) SpectacleWindowPositionManager *manager;
@property NSUInteger failures;
@end

@implementation SpectacleWindowPositionManagerSpec
- (void)setUp
{
  [super setUp];
  self.screen = [TestScreen new];
  self.detector = [TestScreenDetector new];
  self.detector.result = [SpectacleScreenDetectionResult resultWithSourceScreen:(NSScreen *)self.screen
                                                           destinationScreen:(NSScreen *)self.screen];
  self.calculator = [TestPositionCalculator new];
  self.element = [TestElement new];
  self.element.testRect = CGRectMake(165, 245, 564, 384);
  self.mover = [TestWindowMover new];
  self.failures = 0;
  __weak typeof(self) weakSelf = self;
  self.manager = [[SpectacleWindowPositionManager alloc] initWithScreenDetector:(SpectacleScreenDetector *)self.detector
                                                   windowPositionCalculator:(SpectacleWindowPositionCalculator *)self.calculator
                                                            sharedWorkspace:(NSWorkspace *)[TestWorkspace new]
                                                            failureFeedback:^{ weakSelf.failures++; }
                                                                windowMover:self.mover];
}
- (void)attemptMove
{
  [self.manager moveFrontmostWindowElement:self.element action:kSpectacleWindowActionCenter
                                 screens:@[(NSScreen *)self.screen] mainScreen:(NSScreen *)self.screen];
}
- (void)assertNoMove
{
  XCTAssertEqual(self.mover.calls, 0u);
  XCTAssertEqual(self.element.writes, 0u);
  XCTAssertEqual(self.failures, 1u);
}
- (void)testShouldDoNothingIfTheFrontmostWindowIsASheet
{
  self.element.sheet = YES;
  [self attemptMove];
  XCTAssertEqual(self.element.rectReads, 1u);
  XCTAssertEqual(self.element.sheetReads, 1u);
  XCTAssertEqual(self.element.dialogReads, 0u);
  XCTAssertEqual(self.calculator.calls, 0u);
  [self assertNoMove];
}
- (void)testShouldDoNothingIfTheFrontmostWindowIsASystemDialog
{
  self.element.dialog = YES;
  [self attemptMove];
  XCTAssertEqual(self.element.rectReads, 1u);
  XCTAssertEqual(self.element.sheetReads, 1u);
  XCTAssertEqual(self.element.dialogReads, 1u);
  XCTAssertEqual(self.calculator.calls, 0u);
  [self assertNoMove];
}
- (void)testShouldDoNothingIfTheFrontmostWindowRectIsUnavailable
{
  self.element.testRect = CGRectNull;
  [self attemptMove];
  XCTAssertEqual(self.element.sheetReads, 1u);
  XCTAssertEqual(self.element.dialogReads, 1u);
  XCTAssertEqual(self.calculator.calls, 0u);
  [self assertNoMove];
}
- (void)testShouldDoNothingIfScreenDetectionFails
{
  self.detector.result = nil;
  [self attemptMove];
  XCTAssertEqual(self.detector.calls, 1u);
  XCTAssertEqual(self.element.dialogReads, 1u);
  XCTAssertEqual(self.calculator.calls, 0u);
  [self assertNoMove];
}
- (void)testShouldDoNothingIfTheWindowPositionCalculationReturnsTheSameResults
{
  CGRect normalized = [SpectacleAccessibilityElement normalizeCoordinatesOfRect:self.element.testRect frameOfScreen:[self.screen frame]];
  self.calculator.result = [SpectacleWindowPositionCalculationResult resultWithAction:kSpectacleWindowActionCenter windowRect:normalized];
  [self attemptMove];
  XCTAssertEqual(self.calculator.calls, 1u);
  [self assertNoMove];
}
@end
