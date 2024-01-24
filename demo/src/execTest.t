#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the thirdPersonAction library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
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

startRoom: Room 'Void' "This is a featureless void.";
+me: Person;
+pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";
+flower: Thing 'smelly flower' 'flower'
	"A smelly flower with a tag labelled <<toString(foozle)>>. "
	smellPresence = true
	foozle = 0
	_fake() {
		foozle = 123;
		return('');
	}
	smellDesc = "It smells like a flower, only more so. <<_fake()>>"
;
+radio: Thing 'noisy radio' 'radio'
	"A noisy radio with a tag labelled <<toString(foozle)>>. "
	soundPresence = true
	foozle = 0
	_fake() {
		foozle = 123;
		return('');
	}
	soundDesc = "It sounds like a radio, only more so. <<_fake()>>"
;
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

DefineSystemAction(Foozle)
	execSystemAction() {
		aioSay('\n===START===\n ');
		_tryCommand(alice, 'x pebble');
		_tryCommand(alice, 'x flower');
		_tryCommand(alice, 'x radio');
		_tryCommand(alice, 'smell pebble');
		_tryCommand(alice, 'smell flower');
		_tryCommand(alice, 'listen to pebble');
		_tryCommand(alice, 'listen to radio');
		aioSay('\n===END===\n ');
	}
	_tryCommand(actor, cmd) {
		"\n<q><<toString(cmd)>></q> as <<actor.name>>:\n ";
		execCommandAs(actor, cmd);
		"\n==========\n ";
		"<.p>\n ";
	}
;
VerbRule(Foozle) 'foozle': FoozleAction VerbPhrase = 'foozle/foozling';

