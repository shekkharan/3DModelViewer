//
//  3DModelViewController.m
//  3DModelViewer
//
//  Created by Shekhar on 19/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ThreeDModelViewController.h"

@implementation ThreeDModelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  GLKView *glkview = (GLKView *)self.view;
  glkview.context = context;
  glClearColor(0.7f, 0.8f, 1.0f, 1.0f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClear(GL_COLOR_BUFFER_BIT);
}

@end
