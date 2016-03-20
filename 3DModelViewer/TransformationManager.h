//
//  TransformationManager.h
//  3DModelViewer
//
//  Created by Shekhar on 20/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef enum {
  TransformationStateNew,
  TransformationStateScale,
  TransformationStateTranslation,
  TransformationStateRotation
}TransformationState;

@interface TransformationManager : NSObject

@property (nonatomic,assign) TransformationState state;

- (id)initWithRotation:(GLKVector3)rotation translation:(GLKVector2)translation scale:(float)scale andDepth:(float)depth;
- (void)reset;
- (void)scaleWith:(float)scale;
- (void)translateWith:(GLKVector2)translationVector andMultiplier:(float)multiplier;
- (void)rotateWith:(GLKVector3)rotationVector andMultiplier:(float)multiplier;
- (GLKMatrix4)getModelViewMatrix;

@end
