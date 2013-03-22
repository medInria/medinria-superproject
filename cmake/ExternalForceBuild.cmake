function(ExternalForceBuild project)

# For some reason, it doesn't play well with MSBuild, so disable for WIN32
if (NOT WIN32)
    ExternalProject_Get_Property(${project} stamp_dir)
    ExternalProject_Add_Step(${project} forcebuild
        COMMAND ${CMAKE_COMMAND} -E remove "${stamp_dir}/${CMAKE_CFG_INTDIR}/${project}-build"
        COMMENT "Forcing build step for '${project}'"
        DEPENDEES configure
        DEPENDERS build
        ALWAYS 1
    )
endif ()

endfunction()
