#define GLOBAL_PROC	"some_magic_bullshit"

#define CALLBACK(arguments...) new /datum/callback(__FILE__, __LINE__, arguments)
#define INVOKE_ASYNC ImmediateInvokeAsync
