function(RPI_project)

    if(DEFINED RPI_DIR AND NOT EXISTS ${RPI_DIR})
        message(FATAL_ERROR "RPI_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(RPI rpip "" "" ${ARGN})

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://scm.gforge.inria.fr/asclepiospublic/asclepiospublic.git")
    endif()

    SetExternalProjectsDirs(RPI ep_build_dirs)
    ExternalProject_Add(RPI
        ${ep_build_dirs}
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            -DRPI_BUILD_EXAMPLES:BOOL=OFF
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DITK_DIR:FILEPATH=${ITK_DIR}
        DEPENDS ITK
    )

    set(RPI_DIR ${CMAKE_BINARY_DIR}/RPI/build PARENT_SCOPE)

endfunction()
