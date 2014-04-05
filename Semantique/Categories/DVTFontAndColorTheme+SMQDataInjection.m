//
//  DVTFontAndColorTheme+SMQDataInjection.m
//  Semantique
//
//  Created by Kolin Krewinkel on 4/4/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

#import "DVTFontAndColorTheme+SMQDataInjection.h"
#import "SMQSwizzling.h"

static IMP originalDataRepImp;

@implementation DVTFontAndColorTheme (SMQDataInjection)

+ (void)load
{
    originalDataRepImp = SMQPoseSwizzle(self, @selector(dataRepresentationWithError:), self, @selector(smq_dataRepresentationWithError:), YES);
}

- (id)smq_dataRepresentationWithError:(NSError **)arg1
{
    NSData *data = originalDataRepImp(self, @selector(dataRepresentationWithError:), arg1);

    if (data)
    {
        NSPropertyListFormat format = 0;
        NSString *error = nil;
        NSMutableDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:arg1];

        CGFloat saturation = [self smq_saturation];
        CGFloat brightness = [self smq_brightness];

        if (saturation == 0.f)
        {
            saturation = 0.5f;
        }

        if (brightness == 0.f)
        {
            brightness = 0.5f;
        }

        dict[@"SMQVarSaturation"] = @(saturation);
        dict[@"SMQVarBrightness"] = @(brightness);

        data = [NSPropertyListSerialization dataFromPropertyList:dict format:format errorDescription:&error];
    }

    return data;
}

- (void)smq_setSaturation:(CGFloat)saturation
{
    objc_setAssociatedObject(self, "smq_saturation", @(saturation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)smq_saturation
{
    return [objc_getAssociatedObject(self, "smq_saturation") floatValue];
}

- (void)smq_setBrightness:(CGFloat)brightness
{
    objc_setAssociatedObject(self, "smq_brightness", @(brightness), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)smq_brightness
{
    return [objc_getAssociatedObject(self, "smq_brightness") floatValue];
}

@end
