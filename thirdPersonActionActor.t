#charset "us-ascii"
//
// thirdPersonActionActor.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

#ifdef THIRD_PERSON_ACTION_TALK_TO

modify Actor
	dobjFor(TalkTo) {
		action() {
			if(gActor == gPlayerChar) {
				inherited();
				return;
			}
			gActor.thirdPersonInitiateConversation(gDobj, nil, nil);
		}
	}

	// Replacement for adv3's Actor.initiateConvesation(), modified to
	// work for NPCs talking to NPCs.
	thirdPersonInitiateConversation(actor, state, node) {
		if(state == nil)
			state = curState.getImpliedConvState;

		curState.handleTopic(self, actorHelloTopicObj, helloConvType,
			nil);

		if((state != nil) && (state != curState))
			setCurState(state);

		noteConversation(actor);

		setConvNodeReason(node, 'initiiateConversation');

		if(node != nil)
			curConvNode.npcInitiateConversation();
	}
;

#endif // THIRD_PERSON_ACTION_TALK_TO
