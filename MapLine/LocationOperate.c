//
//  LocationOperate.c
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#include "LocationOperate.h"

#define DEFAULT_MALLOC_NUM 20

MAMapPoint * _coordinates = NULL;
long _assignmentNum = 0; //赋值次数
long _distributionNum = 0;//分配内存次数

void freeCoordinates()
{
    _assignmentNum = 0;
    _distributionNum = 0;
    if(_coordinates){
        free(_coordinates);
    }
    if(_coordinates != NULL){
        _coordinates = NULL;
    }
}


MAMapPoint * getCoordinates(MAMapPoint coordinate2D)
{
    if (!_coordinates) {
        _coordinates = malloc(DEFAULT_MALLOC_NUM*sizeof(MAMapPoint));
    }
    if ((_assignmentNum+1) == (_distributionNum + 1)*DEFAULT_MALLOC_NUM) {
        MAMapPoint * tempCoorinates = _coordinates;
        _coordinates = realloc(tempCoorinates,DEFAULT_MALLOC_NUM*sizeof(MAMapPoint));
        tempCoorinates = NULL;
        _distributionNum ++;
    }
    _coordinates[_assignmentNum] = coordinate2D;
    _assignmentNum++;
    return _coordinates;
}

long getAssignmentNum()
{
    return _assignmentNum;
}

