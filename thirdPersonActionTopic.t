#charset "us-ascii"
//
// thirdPersonActionActor.t
//
#include <adv3.h>
#include <en_us.h>

#include "thirdPersonAction.h"

class TopicGroupFor: TopicGroup
	isActive = ((gActor == getTopicOwner()) && (gDobj == otherActor))
	otherActor = nil
;

#ifdef THIRD_PERSON_ACTION_TALK_TO

modify TopicDatabase
	// Replacement for adv3's TopicDatabase.findTopicResponse(),
	// modified to work for NPCs initiating conversation via
	// >TALK TO
	findTopicResponse(fromActor, topic, convType, path) {
		local topicList, best, bestScore, score, winner;

		if((topicList = self.(convType.topicListProp)) == nil)
			return(nil);

		best = new Vector();
		bestScore = nil;
		topicList.forEach(function(cur) {
			score = cur.adjustScore(
				cur.matchTopic(fromActor, topic));
			if((score != nil) && cur.checkIsActive()
				&& ((bestScore == nil)
					|| (score >= bestScore))) {
				if((bestScore != nil) && (score > bestScore))
					best.setLength(0);
				best.append(cur);
				bestScore = score;
			}
		});
		if(best.length == 0) {
			best = nil;
		} else if(best.length == 1) {
			best = best[1];
		} else if(topic.topicProd != nil) {
			// The stock method doesn't check if topic.topicProd
			// is defined, and so will throw an exception if
			// we get here via execCommandAs().
			winner = disambigTopicResponse(fromActor, topic, best);
			best = (winner ? winner : best[1]);
		} else {
			best = best[1];
		}

		return(best);
	}

	// More or less identical to the logic buried in one stanza
	// of a conditional in adv3's TopicDatabase.findTopicResponse().
	// We break it out here just for general code cleanliness.
	disambigTopicResponse(fromActor, topic, best) {
		local m, ri, riCur, rWinner, toks, winner;

		toks = topic.topicProd.getOrigTokenList().mapAll(
			{ x: getTokVal(x) });

		winner = nil;

		best.forEach(function(t) {
			if((winner = t.breakTopicTie(best, topic,
				fromActor, toks)) != nil)
				return;
		});

		if(winner != nil)
			return(winner);

		rWinner = nil;

		best.forEach(function(t) {
			if((m = t.matchObj) == nil) {
				winner = nil;
				return;
			}
			if(m.ofKind(Collection)) {
				m.forEach(function(mm) {
					riCur = topic.getResolveInfo(mm);
					if(compareVocabMatch(riCur, ri) > 0)
						ri = riCur;
				});
			} else {
				ri = topic.getResolveInfo(m);
			}

			if(ri == nil) {
				winner = nil;
				return;
			}

			if(compareVocabMatch(ri, rWinner) > 0) {
				rWinner = ri;
				winner = t;
			}
		});

		return(winner);
	}
;

#endif // THIRD_PERSON_ACTION_TALK_TO
