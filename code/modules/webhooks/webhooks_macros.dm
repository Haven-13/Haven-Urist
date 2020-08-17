#ifndef WINDOWS_HTTP_POST_DLL_LOCATION
#define WINDOWS_HTTP_POST_DLL_LOCATION "lib/byhttp.dll"
#endif

#ifndef UNIX_HTTP_POST_DLL_LOCATION
#define UNIX_HTTP_POST_DLL_LOCATION "lib/libbyhttp.so"
#endif

#ifndef HTTP_POST_DLL_LOCATION
#define HTTP_POST_DLL_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_HTTP_POST_DLL_LOCATION : UNIX_HTTP_POST_DLL_LOCATION)
#endif

#define COLOR_WEBHOOK_DEFAULT 0x8bbbd5

// Please don't forget to update the WEBHOOKS section of README.md with your new webhook ID.
#define WEBHOOK_ROUNDEND          "webhook_roundend"
#define WEBHOOK_ROUNDSTART        "webhook_roundstart"
#define WEBHOOK_CUSTOM_EVENT      "webhook_custom_event"
