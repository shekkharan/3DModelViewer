//
//  TransformationManager.m
//  3DModelViewer
//
//  Created by Shekhar on 20/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "TransformationManager.h"
#import <GLKit/GLKit.h>

@interface TransformationManager ()
{
  GLKVector3 horizontal; //Z Axis
  GLKVector3 vertical;   //Y Axis
  GLKVector3 lateral;    //X Axis
  
  GLKVector2 translationStartVector;
  GLKVector2 translationEndVector;
  GLKVector3 rotationStartVector;
  GLKQuaternion rotationEndQuaternion;
  
  float depthZ;
  float scaleStart;
  float scaleEnd;
}

@end

@implementation TransformationManager

- (id)initWithRotation:(GLKVector3)rotation translation:(GLKVector2)translation scale:(float)scale andDepth:(float)depth
{
  if(self = [super init])
  {
    lateral = GLKVector3Make(1.0f, 0.0f, 0.0f);
    vertical = GLKVector3Make(0.0f, 1.0f, 0.0f);
    horizontal = GLKVector3Make(0.0f, 0.0f, 1.0f);

    depthZ = depth;
    scaleEnd = scale;
    translationEndVector = translation;
    rotation.x = GLKMathDegreesToRadians(rotation.x);
    rotation.y = GLKMathDegreesToRadians(rotation.y);
    rotation.z = GLKMathDegreesToRadians(rotation.z);
    rotationEndQuaternion = GLKQuaternionIdentity;
    rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-rotation.x, lateral), rotationEndQuaternion);
    rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-rotation.y, vertical), rotationEndQuaternion);
    rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-rotation.z, horizontal), rotationEndQuaternion);
  }
  
  return self;
}

- (void)reset
{
  self.state = TransformationStateNew;
  scaleStart = scaleEnd;
  translationStartVector = GLKVector2Make(0.0f, 0.0f);
  rotationStartVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
}

- (void)scaleWith:(float)scale
{
  self.state = TransformationStateScale;
  
  scaleEnd = scale * scaleStart;
}

- (void)translateWith:(GLKVector2)translationVector andMultiplier:(float)multiplier {
  self.state = TransformationStateTranslation;
  
  translationVector = GLKVector2MultiplyScalar(translationVector, multiplier);
  
  float dx = translationEndVector.x + (translationVector.x - translationStartVector.x);
  float dy = translationEndVector.y - (translationVector.y - translationStartVector.y);
  
  translationEndVector = GLKVector2Make(dx, dy);
  translationStartVector = GLKVector2Make(translationVector.x, translationVector.y);
}

- (void)rotateWith:(GLKVector3)rotationVector andMultiplier:(float)multiplier
{
  self.state = TransformationStateRotation;
  
  float dx = rotationVector.x - rotationStartVector.x;
  float dy = rotationVector.y - rotationStartVector.y;
  float dz = rotationVector.z - rotationStartVector.z;
  
  rotationStartVector = GLKVector3Make(rotationVector.x, rotationVector.y, rotationVector.z);
  rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dx * multiplier, vertical), rotationEndQuaternion);
  rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(dy * multiplier, lateral), rotationEndQuaternion);
  rotationEndQuaternion = GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndVector3Axis(-dz, horizontal), rotationEndQuaternion);
}

- (GLKMatrix4)getModelViewMatrix
{
  GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
  GLKMatrix4 quaternionMatrix = GLKMatrix4MakeWithQuaternion(rotationEndQuaternion);
  modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, translationEndVector.x, translationEndVector.y, -depthZ);
  modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, quaternionMatrix);
  modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, scaleEnd, scaleEnd, scaleEnd);
  return modelViewMatrix;
}

@end

