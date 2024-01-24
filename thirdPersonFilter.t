#charset "us-ascii"
//
// thirdPersonFilter.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

thirdPersonFilter: OutputFilter, PreinitObject
	active = nil
	filterText(str, val) { return(active ? '' : inherited(str, val)); }
	execute() { mainOutputStream.addOutputFilter(self); }
;

class ThirdPersonTranscript: CommandTranscript
	addReport(report) {}
	filterText(ostr, txt)  { return(nil); }
	reports_ = static []
;

modify mainOutputStream
	enabled = true
	writeFromStream(txt) {
		inputManager.inputEventEnd();
		if(enabled == true)
			aioSay(txt);
	}
;
