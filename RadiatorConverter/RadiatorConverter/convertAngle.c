#include <math.h>
#include "convertAngle.h"

double degToRad(double degrees){
  return degrees * (M_PI/180.0);
}

double radToDegrees(double radians){
  return radians / (M_PI / 180.0);
}

double pointerToRadians(double *degrees){
    return *degrees * (M_PI/180.0);
}
