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
	// Boolean true if the current actor is an NPC.
	isThirdPerson = (gActor != gPlayerChar)

	// Flag used by nested action mechanism.
	_thirdPersonRecursionFlag = nil

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

	// Do everything we need to do to turn off output for our nested
	// action mechanism.
	_thirdPersonOutputOff() {
		// Flag to indicate we're going to do a nested action.
		_thirdPersonRecursionFlag = true;

		// Turn on our output filter.
		thirdPersonFilter.active = true;

		// Deactivate the transcript, to prevent queuing of
		// reports.
		gTranscript.deactivate();
	}

	// Turn output back on after a nested action.
	_thirdPersonOutputOn() {
		// Re-enable the transcript.
		gTranscript.activate();

		// Turn off our output filter.
		thirdPersonFilter.active = nil;

		// Mark that we're done with the nested action.
		_thirdPersonRecursionFlag = nil;
	}

/*
	basicExamineSmell(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}

		if(_thirdPersonRecursionFlag == nil)
			_thirdPersonSmell(explicit);
		else
			inherited(explicit);
	}
*/
	basicExamineSmell(explicit) {
		thirdPersonBasicExamineSense(explicit, &thirdPersonSmell);
	}

	basicExamineListen(explicit) {
		thirdPersonBasicExamineSense(explicit, &thirdPersonListen);
	}

	thirdPersonBasicExamineSense(explicit, prop) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}

		if(_thirdPersonRecursionFlag == nil)
			_thirdPersonSenseExamine(explicit, prop);
		else
			inherited(explicit);
	}

	_getActionClass() {
		local i, l;

		if(gAction == nil)
			return(nil);

		l = gAction.getSuperclassList();

		if(l.length == 1) {
			if(_checkActionClass(l[1]))
				return(l[1]);
			return(nil);
		}
		for(i = 1; i <= l.length; i++) {
			if(_checkActionClass(l[i]))
				return(l[i]);
		}
		return(nil);
	}

	_checkActionClass(cls) {
		if(cls == nil)
			return(nil);
		if(!cls.ofKind(Action))
			return(nil);
		if(!cls.ofKind(TAction))
			return(nil);
		return(cls);
	}

	_thirdPersonSenseExamine(explicit, prop) {
		local cls;

		if(explicit)
			defaultDescReport(prop, gActor, self);

		_thirdPersonOutputOff();

		if((cls = _getActionClass()) != nil) {
			newActorActionClass(gActor, cls, self);
		}

		_thirdPersonOutputOn();
	}

/*
	_thirdPersonSmell(explicit) {
		_thirdPersonSenseExamine(explicit, &thirdPersonSmell);
	}
*/
/*
	_thirdPersonSmell(explicit) {
		local cls;

		if(explicit)
			defaultDescReport(&thirdPersonSmell, gActor, self);

		_thirdPersonOutputOff();

		if((cls = _getActionClass()) != nil) {
			newActorActionClass(gActor, cls, self);
		}

		_thirdPersonOutputOn();
	}
*/

/*
	basicExamineListen(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		
		if(_thirdPersonRecursionFlag == nil)
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
*/
;
