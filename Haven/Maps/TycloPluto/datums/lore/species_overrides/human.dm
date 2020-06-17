/datum/species/human
  description = ""

  available_cultural_info = list(
    TAG_CULTURE = list(
      CULTURE_SPACER,
      CULTURE_RIMMER,
      CULTURE_AURSIAN,
      CULTURE_SOLARIAN,
      CULTURE_OCTAVIAN,
      CULTURE_OLD_EARTHER,
      CULTURE_OTHER
    ),
    TAG_HOMEWORLD = list(
      LOCATION_MARS,
      LOCATION_LUNA,
      LOCATION_VENUS,
      LOCATION_CERES,
      LOCATION_EROS,
      LOCATION_TITAN,
      LOCATION_PLUTO,
      LOCATION_TARANTULA,
      LOCATION_PORTA,
      LOCATION_MEDINA,
      LOCATION_KINGSTON,
      LOCATION_NAVADA,
      LOCATION_RYCLIES,
      LOCATION_READE,
      LOCATION_OTHER
    ),
    TAG_FACTION = list(
      FACTION_IND,
      FACTION_AUF,
      FACTION_ORA,
      FACTION_UHA,
      FACTION_SOU,
      FACTION_OTHER
    )
  )

  default_cultural_info = list(
    TAG_CULTURE = CULTURE_AURSIAN,
    TAG_HOMEWORLD = LOCATION_PORTA,
    TAG_FACTION = FACTION_IND
  )
