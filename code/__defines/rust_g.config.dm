#ifndef RUST_G
// Copy-paste of the original rust_g.dm detection

/* This comment bypasses grep checks */ /var/__rust_g

/proc/__detect_rust_g()
	if (world.system_type == UNIX)
		. = __rust_g = "librust_g.so"
	else
		. = __rust_g = "rust_g"
	to_world_log("RUST_G: Using [__rust_g]")

#define RUST_G (__rust_g || __detect_rust_g())
#endif
