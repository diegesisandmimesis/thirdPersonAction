#charset "us-ascii"
//
// thirdPersonAction.t
//
//	A TADS3/adv3 module that modifies stock actions whose default
//	behavior only works when the action is taken by the player.
//
//	For example, something like:
//
//		newActorAction(alice, Smell, flower);
//
//	...will by default output something like:
//
//		Alice smells nothing out of the ordinary.
//
//	...without any indication why the game is outputting this message.
//
//	With this module, the same action will instead produce:
//
//		Alice smells the flower.
//
//
//	Any side-effects of the default action _should_ be executed normally,
//	only without their normal output.  So if, for example, the flower
//	has something like:
//
//		smellDesc = "It smells like a flower.  <<someMethod()>>"
//
//	...then someMethod() will be executed just as if the smellDesc
//	was displayed.
//
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

	// Output lock.
	_thirdPersonOutputLock = nil

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
		// Set an output lock.  This will prevent output, and we'll
		// use it to check for nested actions.
		_thirdPersonOutputLock = gOutputLock;
	}

	// Turn output back on after a nested action.
	_thirdPersonOutputOn() {
		// Remove the output lock.
		gOutputUnlock(_thirdPersonOutputLock);
		_thirdPersonOutputLock = nil;
	}

	basicExamineSmell(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		if(_thirdPersonOutputLock == nil)
			_thirdPersonSenseExamine(explicit, &thirdPersonSmell);
		else
			inherited(explicit);
	}

	basicExamineListen(explicit) {
		if(!isThirdPerson()) {
			inherited(explicit);
			return;
		}
		if(_thirdPersonOutputLock == nil)
			_thirdPersonSenseExamine(explicit, &thirdPersonListen);
		else
			inherited(explicit);
	}

	// Generic sense wrapper method.
	_thirdPersonSenseExamine(explicit, prop) {
		local cls, t;

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
		if((cls = _getActionClass()) != nil) {
			// Remember the actor's next turn.
			t = gActor.nextRunTime;

			newActorActionClass(gActor, cls, self);

			// Reset the actor's next turn to be whatever it
			// was before our sneaky fake action.
			gActor.nextRunTime = t;
		}

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

/*
_newThirdPersonAction(transcriptClass, issuingActor, targetActor, actionClass, [objs]) {
	local action;

	action = actionClass.createActionInstance();
	action.actionTime = 0;
	return(newActionObj(transcriptClass, issuingActor, targetActor, action,
		objs...));
}
*/
