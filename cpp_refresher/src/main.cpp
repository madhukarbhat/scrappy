// g++ -std=c++11 fn.cpp -o fn
//
// Example: Passing parameters by reference

#include <iostream>
#include "fn.hpp"

int main ()
{
  int x=1, y=3, z=7;
  duplicate (x, y, z);
  std::cout << "x = " << x << ", "
	    << "y = " << y << ", "
	    << "z = " << z
	    << std::endl;
  return 0;
}
