
// Abitrary integer constant because fuck string comparison
// Was previously a string constant; "some_magic_bullshit"
#define GLOBAL_PROC	0xBEEF

#define CALLBACK(arguments...) new /datum/callback(__FILE__, __LINE__, arguments)
#define INVOKE_ASYNC ImmediateInvokeAsync
