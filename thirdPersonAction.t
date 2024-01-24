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
	isThirdPerson = (gActor != gPlayerChar)

	_thirdPersonFlag = nil

	basicExamine() {
		local b, f;

		if(!isThirdPerson()) {
			inherited();
			return;
		}

		// Remember the values for the described flag on the
		// object and the state of the output filter.
		b = described;

		// Add an output lock.
		f = gOutputLock;

		// Do a standard examine.
		inherited();

		// Release the output lock.
		gOutputUnlock(f);

		// Reset the state to where it was.
		described = b;

		defaultDescReport(&thirdPersonBasicExamine, gActor, self);
	}

	_thirdPersonOutputOff() {
		_thirdPersonFlag = true;
		thirdPersonFilter.active = true;
		gTranscript.deactivate();
	}

	_thirdPersonOutputOn() {
		gTranscript.activate();
		thirdPersonFilter.active = nil;
		_thirdPersonFlag = nil;
	}

	basicExamineSmell(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}

		if(_thirdPersonFlag == nil)
			_thirdPersonSmell(explicit);
		else
			inherited(explicit);
	}

	_thirdPersonSmell(explicit) {
		if(explicit)
			defaultDescReport(&thirdPersonSmell, gActor, self);

		_thirdPersonOutputOff();
		if(gAction.ofKind(SmellAction))
			newActorAction(gActor, Smell, self);
		else if(gAction.ofKind(ExamineAction))
			newActorAction(gActor, Examine, self);
		_thirdPersonOutputOn();
	}

	basicExamineListen(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		
		if(_thirdPersonFlag == nil)
			_thirdPersonListen(explicit);
		else
			inherited(explicit);
	}

	_thirdPersonListen(explicit) {
		if(explicit)
			defaultDescReport(&thirdPersonListen, gActor, self);
		_thirdPersonOutputOff();
		if(gAction.ofKind(ListenToAction))
			newActorAction(gActor, ListenTo, self);
		else if(gAction.ofKind(ExamineAction))
			newActorAction(gActor, Examine, self);
		_thirdPersonOutputOn();
	}
;
