#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE)
#define QDEL_IN_CLIENT_TIME(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define QDEL_NULL(x) if(x) { qdel(x) ; x = null }
#define QDEL_LIST(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/______qdel_list_wrapper, L), time, TIMER_STOPPABLE)
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }

#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }
#define QDEL_NULL_ASSOC_LIST(x) if(x) { for(var/y in x) { qdel(x[y]); x[y] = null; qdel(y);} ; x = null }
#define QDEL_NULL_ASSOC_VAL_LIST(x) if(x) { for(var/y in x) { qdel(x[y]); x[y] = null;} ; x = null }

//the underscores are to encourage people not to use this directly.
/proc/______qdel_list_wrapper(list/L)
	QDEL_LIST(L)
