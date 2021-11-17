
#define STRINGS_EXISTS(x) (LAZY_IS_IN(SSstrings.string_list_by_name, x))
#define STRINGS_GET_LIST(x) (SSstrings.string_list_by_name[x])
#define STRINGS_TRY_GET_LIST(x) (LAZY_ACCESS_ASSOC(SSstrings.string_list_by_name, x))
#define STRINGS_PICK(x) (pick(SSstrings.string_list_by_name[x]))

#define STRINGS_FETCH_JSON(f, x) (SSstrings.fetch_strings_json(f, x))
#define STRINGS_FETCH(f, x) (SSstrings.fetch_strings(f, x))

#define STRINGS(v) (SSstrings.listing.##v)

#define STRINGS_DEFINE_JSON(v, x, f)\
/string_listing/var/list/##v;\
/string_listing/New() { src.##v = STRINGS_FETCH_JSON(f, x); . = ..(); }

#define STRINGS_DEFINE(v, f)\
/string_listing/var/list/##v;\
/string_listing/New() { src.##v = STRINGS_FETCH(f, #v); . = ..(); }

/string_listing/var/initialized = FALSE
/string_listing/New()
	initialized = TRUE

STRINGS_DEFINE(adjectives, "resources/strings/adjectives.txt")
STRINGS_DEFINE(verbs,      "resources/strings/verbs.txt")
