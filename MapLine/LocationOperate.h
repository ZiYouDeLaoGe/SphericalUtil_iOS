//
//  LocationOperate.h
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#ifndef LocationOperate_h
#define LocationOperate_h

#include <stdio.h>
#include <stdlib.h>
#include <MAMapKit/MAMapKit.h>

extern void freeCoordinates();
extern MAMapPoint * getCoordinates(MAMapPoint coordinate2D);
extern long getAssignmentNum();

#endif /* LocationOperate_h */
