#import <XCTest/XCTest.h>
#import "SpectacleShortcutRecorder.h"

@interface SpectacleShortcutRecorderSpec : XCTestCase
@end

@implementation SpectacleShortcutRecorderSpec
- (void)testOversizedDirtyRegionDoesNotPaintOutsideTheRecorder
{
  NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
    pixelsWide:320 pixelsHigh:200 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES
    isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
  memset(bitmap.bitmapData, 0, bitmap.bytesPerRow * bitmap.pixelsHigh);
  SpectacleShortcutRecorder *recorder = [[SpectacleShortcutRecorder alloc] initWithFrame:NSMakeRect(0, 0, 140, 21)];
  [NSGraphicsContext saveGraphicsState];
  NSGraphicsContext.currentContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:bitmap];
  NSAffineTransform *transform = [NSAffineTransform transform];
  [transform translateXBy:60 yBy:90];
  [transform concat];
  // AppKit 14+ can pass a dirty rectangle extending beyond the view bounds.
  [recorder drawRect:NSMakeRect(-60, -90, 320, 200)];
  [NSGraphicsContext restoreGraphicsState];
  XCTAssertGreaterThan([bitmap colorAtX:100 y:100].alphaComponent, 0.5);
  XCTAssertEqualWithAccuracy([bitmap colorAtX:250 y:100].alphaComponent, 0.0, 0.001);
}
@end
