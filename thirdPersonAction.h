//
// thirdPersonAction.h
//

// Uncomment to enable debugging options.
//#define __DEBUG_THIRD_PERSON_ACTION

#include "outputToggle.h"
#ifndef OUTPUT_TOGGLE_H
#error "This module requires the outputToggle module."
#error "https://github.com/diegesisandmimesis/outputToggle"
#error "It should be in the same parent directory as this module.  So if"
#error "thirdPersonAction is in /home/user/tads/thirdPersonAction, then"
#error "outputToggle should be in /home/user/tads/outputToggle ."
#endif // OUTPUT_TOGGLE_H

#define newActorActionClass(actor, cls, objs...) \
	_newAction(CommandTranscript, nil, actor, cls, ##objs)

TopicGroupFor template @otherActor;

#define THIRD_PERSON_ACTION_H
