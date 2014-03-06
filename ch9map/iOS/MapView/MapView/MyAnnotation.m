#import "MyAnnotation.h"

@implementation MyAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D) aCoordinate
{
    self = [super init];
    if (self) {
        self.coordinate = aCoordinate;
    }
    return self;
}

@end
