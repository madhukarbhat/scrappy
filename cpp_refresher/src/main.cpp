// g++ -std=c++11 fn.cpp -o fn
//
// Example: Passing parameters by reference

#include "main.hpp"

// ------------------------------------------------------------------------

int show_menu_return_choice ()
{
  int choice = 0;

  std::cout << "Available options:" << std::endl
	    << FILLER_SPACE << CODE_EXIT << ". Exit" << std::endl
	    << FILLER_SPACE << CODE_FN   << ". Execute fn()" << std::endl
	    << FILLER_SPACE << CODE_BLAH << ". Execute blah ()" << std::endl
	    << "Enter choice: ";

  std::string usr_input;
  getline (std::cin,usr_input);
  std::stringstream (usr_input) >> choice;
  return choice;
}

// ------------------------------------------------------------------------

void call_fn ()
{
  int x = 1, y = 3, z = 7;
  std::cout << "Initial Values:" << std::endl;
  show_params (x, y, z);

  duplicate (x, y, z);

  std::cout << "After function call:" << std::endl;
  show_params (x, y, z);
  return;
}

// ------------------------------------------------------------------------

int main (int argc, char* argv[])
{
  int command = 99;
  if (argc == 2) {
    std::string input (argv[1]);
    std::stringstream(input) >> command;
  } else {
    command = show_menu_return_choice();
  }

  for (;;) {
    std::cout << "--------------------------------------------------"
	      << std::endl;
    switch (command) {
    case CODE_EXIT:
      std::cout << "Bye!" << std::endl;
      break;
    case CODE_FN:
      call_fn();
      break;
    case CODE_BLAH:
      std::cout << command << " : command not implemented, sorry!"
		<< std::endl;
      break;
    default:
      std::cout << command << " : Not a recognized option, try again."
		<< std::endl;
    }
    if (command != CODE_EXIT) {
      command = show_menu_return_choice();
    } else {
      break;
    }
  }
  return 0;
}

// ------------------------------------------------------------------------
