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
/*
	thirdPersonTalkTo(actor) {
		//return('{You/He} consider{s} talking to <<actor.theName>>
			//but then change{s} {its/her} mind. ');
		return('Foozle');
	}
*/
;

