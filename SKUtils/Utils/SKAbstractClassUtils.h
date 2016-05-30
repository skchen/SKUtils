//
//  SKAbstractClassUtils.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#ifndef SKAbstractClassUtils_h
#define SKAbstractClassUtils_h

#define THROW_NOT_OVERRIDE_EXCEPTION @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                                reason:[NSString stringWithFormat:@"You must override %@ in %@", \
                                                NSStringFromSelector(_cmd), NSStringFromClass([self class])] \
                                                userInfo:nil];

#endif /* SKAbstractClassUtils_h */
