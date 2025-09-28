#charset "us-ascii"
//
// thirdPersonActionMsg.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

modify playerActionMessages
	thirdPersonBasicExamine(actor, obj) {
		return('{You/He} examine{s} <<obj.theName>>. ');
	}
	thirdPersonSmell(actor, obj) {
		return('{You/He} smell{s} <<obj.theName>>. ');
	}
	thirdPersonListen(actor, obj) {
		return('{You/He} listen{s} to <<obj.theName>>. ');
	}
	thirdPersonTalkTo(obj) {
		return('{You/He} consider{s} talking to <<obj.theName>>
			but then change{s} {its/her} mind. ');
	}
	thirdPersonCantTalkToThat(obj) {
		return('{You/he} can\'t talk to {that/him dobj}');
	}
;

modify npcActionMessages
	cannotOpenLockedMsg = '{The actor/him} attempt{s} to open
		{the dobj/he} but it seem{s/ed} to be locked. '
;

