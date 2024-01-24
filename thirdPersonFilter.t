#charset "us-ascii"
//
// thirdPersonFilter.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

thirdPersonFilter: OutputFilter, PreinitObject
	active = nil
	filterText(str, val) { return(active ? '' : inherited(str, val)); }
	execute() { mainOutputStream.addOutputFilter(self); }
;
