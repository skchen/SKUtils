//
//  SKLog.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#ifndef SKLog_h
#define SKLog_h

#define SKLog(__FORMAT__, ...) NSLog((@"%@ %s [Line %d] " __FORMAT__), (self), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#endif /* SKLog_h */
