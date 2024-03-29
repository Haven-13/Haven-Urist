#define RECOMMENDED_VERSION 514

// The default value for all uses of set background. Set background can cause gradual lag and is
// recommended you only turn this on if necessary.
//		1 will enable set background.
//		0 will disable set background.
#define BACKGROUND_ENABLED 0

// A reasonable number of maximum overlays an object needs
// If you think you need more, rethink it
#define MAX_ATOM_OVERLAYS 100

// Toggle whether the Baystation's callbacks system shall be wrapped in a try-catch block,
// to suppliment more debug information to the runtime messages.
//		1 will enable this feature
//		0 will disable this feature
#define TRY_CATCH_CALLBACKS 1

// Toggle whether we shall compile in the function to call the prof.so slash prof.dll
// to use the tracy profiler (via https://github.com/mafemergency/byond-tracy)
// Keep in mind that at point of commenting this, byond-tracy is not made for production use
// and it won't be shipped or added to this git. Please follow the guide available at the README
// in the Github repository linked above on how to compile it.
//		1 will enable this feature
// 		0 will disable this feature
#define USE_BYOND_TRACY 0

#ifdef CIBUILDING
#define UNIT_TEST
#endif

#ifdef TGS
// TGS performs its own build of dm.exe, but includes a prepended TGS define.
#define CBT
#endif

#if defined(UNIT_TESTS)
// Hard del testing defines
#define FIND_REF_NO_CHECK_TICK

// The callbacks system is wrapped in try-catch to suppliment more debug information to messages
#define TRY_CATCH_CALLBACKS 1
#endif

#if !defined(CBT) && !defined(SPACEMAN_DMM)
#warn Building with Dream Maker is no longer supported and will result in errors.
#warn In order to build, run BUILD.bat in the root directory.
#warn Consider switching to VSCode editor instead, where you can press Ctrl+Shift+B to build.
#endif
