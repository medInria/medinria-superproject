function(RPI_project)

    if(DEFINED RPI_DIR AND NOT EXISTS ${RPI_DIR})
        message(FATAL_ERROR "RPI_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(RPI rpip "" "" ${ARGN})

    set(RPI_enabling_variable RPI_LIBRARIES)

    set(${RPI_enabling_variable}_LIBRARY_DIRS RPI_LIBRARY_DIRS)
    set(${RPI_enabling_variable}_INCLUDE_DIRS RPI_INCLUDE_DIRS)
    set(${RPI_enabling_variable}_FIND_PACKAGE_CMD RPI)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://scm.gforge.inria.fr/asclepiospublic/asclepiospublic.git")
    endif()

    ExternalProject_Add(RPI
        PREFIX RPI
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

    set(RPI_DIR ${CMAKE_BINARY_DIR}/RPI/src/RPI-build PARENT_SCOPE)

endfunction()
