#include <Inventor/SoDB.h>
#include "TemperatureElement.h"

int
main(void)
{
  SoDB::init();
  TemperatureElement::initClass();

  return 0;
}
