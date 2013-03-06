function(ExternalForceBuild project)

    ExternalProject_Get_Property(${project} stamp_dir)
    ExternalProject_Add_Step(${project} forcebuild
        COMMAND ${CMAKE_COMMAND} -E touch_nocreate "${stamp_dir}/${project}-configure"
        COMMENT "Forcing build step for '${project}'"
        DEPENDEES configure
        DEPENDERS build
        ALWAYS 1
    )

endfunction()
