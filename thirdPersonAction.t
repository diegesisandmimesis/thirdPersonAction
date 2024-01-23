#charset "us-ascii"
//
// thirdPersonAction.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

// Module ID for the library
thirdPersonActionModuleID: ModuleID {
        name = 'Third Person Action Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

modify Thing
	basicExamine() {
		local b, o;
		if(gActor == gPlayerChar) {
			inherited();
			return;
		}

		b = described;
		o = gOutputCheck;
		gOutputOff;
		inherited();
		described = b;
		gOutputSet(o);
		"Foo\n ";
	}
;
