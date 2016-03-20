//
//  ThreeDModel.m
//  3DModelViewer
//
//  Created by Shekhar on 20/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import "ThreeDModel.h"
#import <GLKit/GLKit.h>
#import "Chair.h"

@implementation ThreeDModel

- (id)initWithModel:(ThreeDModelNumber)modelNumber
{
  if(self = [super init])
  {
    _modelNumber = modelNumber;
  }
  
  return self;
}

- (void)renderModel
{
  [self renderChair];
}

- (void)renderChair
{
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, ChairVerts);
  
  glEnableVertexAttribArray(GLKVertexAttribNormal);
  glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, ChairNormals);
  
  glDrawArrays(GL_TRIANGLES, 0, ChairNumVerts);
}

@end
