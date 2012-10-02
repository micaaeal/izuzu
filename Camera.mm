//
//  Camera.m
//  DriftForever
//
//  Created by Adawat Chanchua on 10/1/55 BE.
//
//

#import "Camera.h"

Camera* _object = nil;

@interface Camera()

@property (assign) CCLayer*     _layer;

@end

@implementation Camera
@synthesize initX;
@synthesize initY;
@synthesize initZ;
@synthesize initEyeX;
@synthesize initEyeY;
@synthesize initEyeZ;
@synthesize _layer;

+ (Camera*) getObject
{
    if ( ! _object )
    {
        _object = [[Camera alloc] init];
    }
    
    return _object;
}

+ (void) initCameraWithLayer: (CCLayer*) layer
{
    Camera* object  = [Camera getObject];
    object._layer  = layer;
    
    // set init camera
    float x, y, z;
    float ex, ey, ez;
    [layer.camera centerX:&x centerY:&y centerZ:&z];
    [layer.camera eyeX:&ex eyeY:&ey eyeZ:&ez];
    
    object.initX    = x;
    object.initY    = y;
    object.initZ    = z;
    object.initEyeX    = ex;
    object.initEyeY    = ey;
    object.initEyeZ    = ez;
}

#pragma mark - PIMPL

- (void) moveCameraByPoint: (CGPoint) point
{
    Camera* object  = [Camera getObject];
    CCLayer* layer  = object._layer;
    
    float centerX, centerY, centerZ;
    float eyeX, eyeY, eyeZ;
    [layer.camera centerX:&centerX centerY:&centerY centerZ:&centerZ];
    [layer.camera eyeX:&eyeX eyeY:&eyeY eyeZ:&eyeZ];
    float moveX = point.x;
    float moveY = point.y;
    float moveZ = 0.0f;
    float newX  = centerX + moveX;
    float newY  = centerY + moveY;
    float newZ  = centerZ + moveZ;
    float newEyeX  = eyeX + moveX;
    float newEyeY  = eyeY + moveY;
    float newEyeZ  = eyeZ + 0.0f;
    [layer.camera setCenterX:newX centerY:newY centerZ:newZ];
    [layer.camera setEyeX:newEyeX eyeY:newEyeY eyeZ:newEyeZ];
}

- (void) setCameraToPoint: (CGPoint) point
{
    Camera* object  = [Camera getObject];
    CCLayer* layer  = object._layer;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float newX  = object.initX + point.x - (winSize.width * 0.5);
    float newY  = object.initY + point.y - (winSize.height * 0.5);
    float newZ  = object.initZ;
    float newEyeX  = object.initEyeX + point.x - (winSize.width * 0.5);
    float newEyeY  = object.initEyeY + point.y - (winSize.height * 0.5);
    float newEyeZ  = object.initEyeZ;
    [layer.camera setCenterX:newX centerY:newY centerZ:newZ];
    [layer.camera setEyeX:newEyeX eyeY:newEyeY eyeZ:newEyeZ];
}
@end
