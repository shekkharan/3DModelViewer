//
//  3DModelViewController.m
//  3DModelViewer
//
//  Created by Shekhar on 19/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ThreeDModelViewController.h"
#import "ThreeDModel.h"
#import "TransformationManager.h"

@interface ThreeDModelViewController ()
{
  GLKVector3  rotationStartVector;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) ThreeDModel *threeDModel;
@property (strong, nonatomic) TransformationManager *transformationManager;
@end

@implementation ThreeDModelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  GLKView *glkView = (GLKView *)self.view;
  glkView.context = context;
  glClearColor(0.7f, 0.8f, 1.0f, 1.0f);
  glEnable(GL_CULL_FACE);
  [self setupBaseEffect];
  self.threeDModel = [[ThreeDModel alloc] initWithModel:kThreeDModelChair];
  self.transformationManager = [[TransformationManager alloc] initWithRotation:GLKVector3Make(0.0f, 0.0f, 0.0f) translation:GLKVector2Make(0.0f, 0.0f) scale:2.0f andDepth:3.0f];
}

- (void)setupBaseEffect
{
  self.baseEffect = [[GLKBaseEffect alloc] init];
  self.baseEffect.light0.enabled = GL_TRUE;
  self.baseEffect.light0.position = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
}

- (void)setupMatrices
{
  const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
  const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
  const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
  self.baseEffect.transform.projectionMatrix = projectionMatrix;

  GLKMatrix4 modelViewMatrix = [self.transformationManager getModelViewMatrix];
  self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  [self.baseEffect prepareToDraw];
  [self setupMatrices];
  [self.threeDModel renderModel];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.transformationManager reset];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
  if((sender.numberOfTouches == 1) &&
          ((self.transformationManager.state == TransformationStateNew) || (self.transformationManager.state == TransformationStateRotation)))
  {
    const float multipier = GLKMathDegreesToRadians(1.2f);
    CGPoint rotation = [sender translationInView:self.view];
    [self.transformationManager rotateWith:GLKVector3Make(rotation.x, rotation.y, 0.0f) andMultiplier:multipier];
    
  } else if((sender.numberOfTouches == 2) &&
     ((self.transformationManager.state == TransformationStateNew) || (self.transformationManager.state == TransformationStateTranslation)))
  {
    CGPoint translation = [sender translationInView:self.view];
    float x = translation.x/sender.view.frame.size.width;
    float y = translation.y/sender.view.frame.size.height;
    [self.transformationManager translateWith:GLKVector2Make(x, y) andMultiplier:5.0f];
  }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
  if((self.transformationManager.state == TransformationStateNew) || (self.transformationManager.state == TransformationStateScale))
  {
    float scale = [sender scale];
    [self.transformationManager scaleWith:scale];
  }
  
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender {
  if((self.transformationManager.state == TransformationStateNew) || (self.transformationManager.state == TransformationStateRotation))
  {
    float rotation = [sender rotation];
    [self.transformationManager rotateWith:GLKVector3Make(0.0f, 0.0f, rotation) andMultiplier:1.0f];
  }
}

@end
