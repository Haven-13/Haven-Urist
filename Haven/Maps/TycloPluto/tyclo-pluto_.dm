#if !defined(USING_MAP_DATUM)

  #include "tyclo-pluto_define.dm"

  #include "tyclo-pluto_areas.dm"
  #include "tyclo-pluto_elevators.dm"
  #include "tyclo-pluto_jobs.dm"
  #include "tyclo-pluto_lobby.dm"
  #include "tyclo-pluto_overmap.dm"

  #include "shuttles/shuttle_cargo_define.dm"
  #include "shuttles/shuttle_eris_define.dm"
  #include "shuttles/shuttle_eris_overmap.dm"
  #include "shuttles/shuttle_styx_define.dm"
  #include "shuttles/shuttle_styx_overmap.dm"

#elif !defined(MAP_OVERRIDE)

  #warn "A map has already been included, ignoring Tyclo-Pluto"

#endif
