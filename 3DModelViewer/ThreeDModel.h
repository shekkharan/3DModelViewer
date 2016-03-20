//
//  ThreeDModel.h
//  3DModelViewer
//
//  Created by Shekhar on 20/3/16.
//  Copyright © 2016 Myaango. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  kThreeDModelChair
}ThreeDModelNumber;

@interface ThreeDModel : NSObject

@property (assign,nonatomic) ThreeDModelNumber modelNumber;
- (id)initWithModel:(ThreeDModelNumber)modelNumber;
- (void)renderModel;

@end
