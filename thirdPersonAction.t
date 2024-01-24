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

	basicExamineSmell(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		if(_thirdPersonRecursionFlag == nil)
			_thirdPersonSenseExamine(explicit, &thirdPersonSmell);
		else
			inherited(explicit);
	}

	basicExamineListen(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		if(_thirdPersonRecursionFlag == nil)
			_thirdPersonSenseExamine(explicit, &thirdPersonListen);
		else
			inherited(explicit);
	}

	// Generic sense wrapper method.
	_thirdPersonSenseExamine(explicit, prop) {
		local cls;

		// If we're being explicitly examined via a sense (other
		// than sight), we display a report that indicates that
		// an NPC is taking an action.  This will be
		// something like "Alice smells the flower."
		// The explicit flag WON'T be set if we're getting called
		// from something like a basic examine on an object with
		// a non-sight sense presence, e.g. >X FLOWER if
		// flower.smellPresence = true.
		if(explicit)
			defaultDescReport(prop, gActor, self);

		// Toggle our output off.
		_thirdPersonOutputOff();

		// Figure out what kind of Action the current gAction is,
		// and do a nested version of it.
		// Since we turned off all output this should be silent, but
		// it'll produce any side-effects the action might have
		// (like setting a revealed flag).
		if((cls = _getActionClass()) != nil)
			newActorActionClass(gActor, cls, self);

		// Turn output back on.
		_thirdPersonOutputOn();
	}

	// Figure out what action class gAction is an instance of.
	_getActionClass() {
		local i, l;

		// First, we need an action.
		if(gAction == nil)
			return(nil);

		l = gAction.getSuperclassList();

		// If there's only one class in the superclass list,
		// it's what we want.
		if(l.length == 1) {
			// We make sure it's a valid action class, but in
			// practice this check should never fail.
			if(_checkActionClass(l[1]))
				return(l[1]);

			return(nil);
		}

		// This is messier.  We have multiple classes in the
		// superclass list, so we just look for the first one that's
		// an TAction.
		for(i = 1; i <= l.length; i++) {
			if(_checkActionClass(l[i]))
				return(l[i]);
		}

		return(nil);
	}

	// Make sure we like the class.  We're doing this on an object,
	// so we only care about TAction subclasses.
	// FIXME:  Maybe we should also check for TIAction?
	_checkActionClass(cls) {
		if(cls == nil)
			return(nil);
		if(!cls.ofKind(Action))
			return(nil);
		if(!cls.ofKind(TAction))
			return(nil);
		return(cls);
	}
;
