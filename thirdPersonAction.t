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
	isThirdPerson() { return(gActor != gPlayerChar); }
	basicExamine() {
		local b;

		if(!isThirdPerson()) {
			inherited();
			return;
		}

		// Remember the values for the described flag on the
		// object and the state of the output filter.
		b = described;

		gOutputOff;

		// Do a standard examine.
		inherited();

		gOutputOn;

		// Reset the state to where it was.
		described = b;

		defaultDescReport(&thirdPersonBasicExamine, gActor, self);
	}

	basicExamineSmell(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		defaultDescReport(&thirdPersonSmell, gActor, self);
	}
	basicExamineListen(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		defaultDescReport(&thirdPersonListen, gActor, self);
	}
;

thirdPersonFilter: OutputFilter, PreinitObject
	active = nil
	filterText(str, val) { return(active ? '' : inherited(str, val)); }
	execute() { mainOutputStream.addOutputFilter(self); }
;

class ThirdPersonTranscript: CommandTranscript
	addReport(report) {}
	filterText(ostr, txt)  { return(nil); }
	reports_ = static []
;

