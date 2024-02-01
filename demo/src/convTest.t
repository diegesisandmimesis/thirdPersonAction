#charset "us-ascii"
//
// convTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the thirdPersonAction library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f convTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

startRoom: Room 'Void'
	"This is a featureless void."
	north = otherRoom
;
+me: Person 'player' 'you';
+pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;
++AskTellTopic @pebble
	"This is the pebble topic. "
;
++InConversationState
	specialDesc = "Alice is here, talking with you. "
	stateDesc = "She's watching you as you talk. "
;
+++ConversationReadyState
	isInitState = true
	specialDesc = "This is the ConversationReadyState description. "
	stateDesc = "Alice is in ConversationReadyState. "
;
++++NPCTopicGroup otherActor = gPlayerChar;
+++++aliceHelloTopicPlayer: ActorHelloTopic, StopEventList
	[ 'This is Alice\'s hello topic for the player.' ]
;
++++NPCTopicGroup otherActor = bob;
+++++aliceHelloTopicBob: ActorHelloTopic, StopEventList
	[ 'This is Alice\'s hello topic for the Bob.' ]
;
++++aliceHelloTopicDefault: HelloTopic, StopEventList
	[
		'This is the first hello topic.',
		'This is the second hello topic.',
		'This is the third hello topic.'
	]
;
++++ByeTopic, StopEventList
	[ 'This is the bye topic.' ]
;
++++ImpByeTopic, StopEventList
	[ 'This is the implicit bye topic. ' ]
;
++++foo: ConvNode 'npc-greet'
	npcGreetingMsg = "This is the NPC greeting message. "
;
+bob: Person 'Bob' 'Bob'
	"He looks like Robert, only shorter. "
	isHim = true
	isProperName = true
;

otherRoom: Room 'Other Room'
	"This is the other room. "
	south = startRoom
;

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

DefineSystemAction(Foozle)
	execSystemAction() {
		//defaultReport(&thirdPersonTalkTo, gActor, alice);
		execCommandAs(alice, 'talk to player');
	}
;
VerbRule(Foozle) 'foozle': FoozleAction VerbPhrase = 'foozle/foozling';
