#include <iostream>
#include "fn.hpp"

void show_params (int& a, int& b, int& c)
{
  std::cout << "---------" << std::endl
	    << "x = " << a << std::endl
	    << "y = " << b << std::endl
	    << "z = " << c << std::endl;
  return;
}


void duplicate (int& a, int& b, int& c)
{
  const int multiplier = 2;
  a *= multiplier;
  b *= multiplier;
  c *= multiplier;
  return;
}
