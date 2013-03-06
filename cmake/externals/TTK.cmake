function(TTK_project)

    set(TTK-minvers 1.4.0 PARENT_SCOPE)
    set(TTK-package-name ttk PARENT_SCOPE)

    if (DEFINED TTK_DIR AND NOT EXISTS ${TTK_DIR})
        message(FATAL_ERROR "TTK_DIR variable is defined but corresponds to non-existing directory")
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
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
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
