function(TTK_project)

    if (DEFINED TTK_DIR AND NOT EXISTS ${TTK_DIR})
        message(FATAL_ERROR "TTK_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(TTK ttkp "TEST" "" ${ARGN})

    set(ttkp_TESTING OFF)
    if (${ttkp_TEST})
        set(ttkp_TESTING ON)
    endif()

    set(TTK_enabling_variable TTK_LIBRARIES)

    set(${TTK_enabling_variable}_LIBRARY_DIRS TTK_LIBRARY_DIRS)
    set(${TTK_enabling_variable}_INCLUDE_DIRS TTK_INCLUDE_DIRS)
    set(${TTK_enabling_variable}_FIND_PACKAGE_CMD TTK)

    if (NOT DEFINED location)
        set(location SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/ttk/trunk")
    endif()

    ExternalProject_Add(TTK
        PREFIX     TTK
        ${location}
        #SOURCE_DIR ${ttkp_SRC_DIR}
        #SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/ttk/trunk"
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

    set(TTK_DIR ${CMAKE_BINARY_DIR}/TTK/src/TTK-build PARENT_SCOPE)

endfunction()
