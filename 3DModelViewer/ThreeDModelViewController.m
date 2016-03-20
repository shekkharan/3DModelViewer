//
//  3DModelViewController.m
//  3DModelViewer
//
//  Created by Shekhar on 19/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ThreeDModelViewController.h"
#import "ThreeDModel.h"
@interface ThreeDModelViewController ()
{
  GLKVector3  rotationStartVector;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) ThreeDModel *threeDModel;

@end

@implementation ThreeDModelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  GLKView *glkview = (GLKView *)self.view;
  glkview.context = context;
  glClearColor(0.7f, 0.8f, 1.0f, 1.0f);
  glEnable(GL_CULL_FACE);
  [self setupBaseEffect];
  self.threeDModel = [[ThreeDModel alloc] initWithModel:kThreeDModelChair];
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
  
  GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
  modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
  modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0f));
  self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClear(GL_COLOR_BUFFER_BIT);
  [self.baseEffect prepareToDraw];
  [self setupMatrices];
  [self.threeDModel renderModel];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
  CGPoint rotation = [sender translationInView:sender.view];
  NSLog(@"Rotation %f,%f", rotation.x, rotation.y);
}

@end
