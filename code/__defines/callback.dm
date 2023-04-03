#define GLOBAL_PROC	"some_magic_bullshit"

#define CALLBACK(arguments...) new /datum/callback(__FILE__, __LINE__, __TYPE__, __PROC__, arguments)
#define INVOKE_ASYNC ImmediateInvokeAsync
