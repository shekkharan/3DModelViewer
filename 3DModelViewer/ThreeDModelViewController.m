//
//  3DModelViewController.m
//  3DModelViewer
//
//  Created by Shekhar on 19/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ThreeDModelViewController.h"
#import "Chair.h"
@interface ThreeDModelViewController ()

@property (strong, nonatomic) GLKBaseEffect *baseEffect;

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
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, ChairVerts);
  glDrawArrays(GL_TRIANGLES, 0, ChairNumVerts);
}

@end
