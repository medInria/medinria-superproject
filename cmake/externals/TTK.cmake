function(TTK_project)

    set(TTK-minvers 1.4.0 PARENT_SCOPE)
    set(TTK-package-name ttk PARENT_SCOPE)

    PackageInit(TTK TTK TTK OFF OPTIONALLY_REQUIRED_FOR_PLUGINS)
    if (TARGET TTK)
        return()
    endif()

    ParseProjectArguments(TTK ttkp "TEST" "" ${ARGN})

    set(ttkp_TESTING OFF)
    if (${ttkp_TEST})
        set(ttkp_TESTING ON)
    endif()

    if (NOT DEFINED location)
        set(location SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/ttk/trunk")
    endif()

    SetExternalProjectsDirs(TTK ep_build_dirs)
    ExternalProject_Add(TTK
        ${ep_build_dirs}
        ${location}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            ${ep_common_cache_args}
            -DBUILD_TESTING:BOOL=${ttkp_TESTING}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
        DEPENDS ITK VTK
    )
    ExternalForceBuild(TTK)

    ExternalProject_Get_Property(TTK binary_dir)
    set(TTK_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
