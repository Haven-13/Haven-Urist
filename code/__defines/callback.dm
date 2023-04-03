#define GLOBAL_PROC	"global"

#define CALLBACK(arguments...) new /datum/callback(__FILE__, __LINE__, arguments)
#define INVOKE_ASYNC ImmediateInvokeAsync
