function(RPI_project)

    set(RPI-minvers 1.0.0 PARENT_SCOPE)
    set(RPI-package-name rpi PARENT_SCOPE)

    PackageInit(RPI RPI RPI OFF)
    if (TARGET RPI)
        return()
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
    ExternalForceBuild(RPI)

    ExternalProject_Get_Property(RPI binary_dir)
    set(RPI_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
