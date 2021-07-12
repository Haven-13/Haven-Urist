//	Observer Pattern Implementation: Topic fired
//		Registration type: /datum
//
//		Raised when: A Topic() call has been fired for a datum or atom
//
//		Arguments that the called proc should expect:
//			/datum/source: Context of Topic
//          /datum/user: Invoker/user of the Topic
//          /list/href_list: hrefs submitted to the Topic context

GLOBAL_DATUM_INIT(topic_event, /decl/observ/topic, new)

/decl/observ/topic
	name = "Topic Fired"
	expected_type = /datum

/***********************
* Topic Fired Handling *
***********************/

/datum/Topic(href, href_list[])
	..()
	GLOB.topic_event.raise_event(src, usr, href_list)
