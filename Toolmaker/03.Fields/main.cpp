#include <Inventor/SoDB.h>
#include "MFDouble.h"
#include "SFDouble.h"

int
main(void)
{
  (void)fprintf(stdout, "\n\n** Just for compiling extension fields **\n\n\n");

  SoDB::init();
  SFDouble::initClass();
  MFDouble::initClass();

  return 0;
}
