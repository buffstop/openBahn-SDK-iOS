
//
//  Created by Uli Luckas on 7/31/12.
//  Copyright (c) 2012 SinnerSchrader UMEile. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMErrorHandler <NSObject>
-(void)handleError:(NSError*)error;
@end
