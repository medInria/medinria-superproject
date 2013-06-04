function(EP_ForceBuild ep)

if (NOT USE_SYSTEM_${ep})
  # For some reason, it doesn't play well with MSBuild, so disable for WIN32
  if (NOT WIN32)
    ExternalProject_Get_Property(${ep} stamp_dir)
    ExternalProject_Add_Step(${ep} forcebuild
      COMMAND ${CMAKE_COMMAND} -E remove "${stamp_dir}/${CMAKE_CFG_INTDIR}/${ep}-build"
      COMMENT "Forcing build step for '${ep}'"
      DEPENDEES configure
      DEPENDERS build
      ALWAYS 1
    )
  endif ()
endif()

endfunction()
