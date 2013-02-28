function(medInria_project)

    if (DEFINED medInria_DIR AND NOT EXISTS ${medInria_DIR})
        message(FATAL_ERROR "medInria_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(medInria medInriap "" "" ${ARGN})

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git@github.com:medInria/medInria-public.git")
    endif()

    ExternalProject_Add(medInria
        PREFIX medInria
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
        DEPENDS dtk
    )

    set(medInria_DIR ${CMAKE_BINARY_DIR}/medInria/src/medInria-build PARENT_SCOPE)

endfunction()
