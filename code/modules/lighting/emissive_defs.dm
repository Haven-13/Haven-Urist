
/// Uses vis_overlays to leverage caching so that very few new items need to be made for the overlay. For anything that doesn't change outline or opaque area much or at all.
// EMISSIVE_BLOCK_GENERIC 1
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
// EMISSIVE_BLOCK_UNIQUE 2
#if !defined(EMISSIVE_DEFS_DEFINED) // should be defined in __defines/lighting.dm
/var/const/EMISSIVE_BLOCK_GENERIC 1
/var/const/EMISSIVE_BLOCK_UNIQUE 2
#endif
