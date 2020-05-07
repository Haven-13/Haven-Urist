#if !defined(USING_MAP_DATUM)

  #include "tyclo-pluto_areas.dm"
  #include "tyclo-pluto_elevators.dm"
  #include "tyclo-pluto_jobs.dm"
  #include "tyclo-pluto_lobby.dm"
  #include "tyclo-pluto_overmap.dm"

  #include "objects/nerva_clothes.dm"
  #include "objects/nerva_ids.dm"
  #include "objects/nerva_items.dm"
  #include "objects/pluto_computers.dm"

  #include "shuttles/shuttle_cargo_define.dm"
  #include "shuttles/shuttle_eris_define.dm"
  #include "shuttles/shuttle_eris_overmap.dm"
  #include "shuttles/shuttle_styx_define.dm"
  #include "shuttles/shuttle_styx_overmap.dm"

  #include "Maps/tyclo-pluto_main.dmm"

  #include "tyclo-pluto_aways.dm"

  #define USING_MAP_DATUM /datum/map/tyclo_pluto
  #define URISTCODE 1

#elif !defined(MAP_OVERRIDE)

  #warn "A map has already been included, ignoring Tyclo-Pluto"

#endif
