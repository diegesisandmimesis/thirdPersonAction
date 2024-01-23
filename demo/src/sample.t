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
+alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isHer = true
	isProperName = true
;

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

DefineSystemAction(Foozle)
	execSystemAction() {
		_tryCommand(alice, 'x pebble');
	}
	_tryCommand(actor, cmd) {
		"\nexecuting <q><<toString(cmd)>></q> as <<actor.name>>:\n ";
		"\n===START COMMAND===\n ";
		execCommandAs(actor, cmd);
		"\n===END COMMAND===\n ";
	}
;
VerbRule(Foozle) 'foozle': FoozleAction VerbPhrase = 'foozle/foozling';

