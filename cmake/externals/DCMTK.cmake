function(DCMTK_project)

    if (DEFINED DCMTK_DIR AND NOT EXISTS ${DCMTK_DIR})
        message(FATAL_ERROR "DCMTK_DIR variable is defined but corresponds to non-existing directory")
    endif()

    set(DCMTK_enabling_variable DCMTK_LIBRARIES)

    set(${DCMTK_enabling_variable}_INCLUDE_DIRS DCMTK_INCLUDE_DIR)
    set(${DCMTK_enabling_variable}_FIND_PACKAGE_CMD DCMTK)

    ParseProjectArguments(dcmtk dcmtkp "" "" ${ARGN})

    set(extproj_revision_tag GIT_TAG "${dcmtkp_REVISION}")
    if ("${dcmtkp_REVISION}" STREQUAL "") 
        set(extproj_revision_tag GIT_TAG "ae3b946f6e6231")
    endif()

    set(ep_project_include_arg)
    if (CTEST_USE_LAUNCHERS)
        set(ep_project_include_arg
            "-DCMAKE_PROJECT_DCMTK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
    endif()

    if (NOT DEFINED location)
        set(SRC_DIR ${CMAKE_BINARY_DIR}/dcmtk/src/DCMTK)
        set(location GIT_REPOSITORY "git://dev-med.inria.fr/dcmtk/dcmtk.git" ${extproj_revision_tag})
    endif()

    ExternalProject_Add(DCMTK
        PREFIX dcmtk
        ${location}
        CMAKE_GENERATOR ${gen}
        UPDATE_COMMAND ""
        INSTALL_DIR dcmtk/install
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            ${ep_project_include_arg}
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DDCMTK_WITH_DOXYGEN:BOOL=OFF
            -DDCMTK_WITH_ZLIB:BOOL=OFF # see github issue #25
            -DDCMTK_WITH_OPENSSL:BOOL=OFF # see github issue #25
            -DDCMTK_WITH_PNG:BOOL=OFF # see github issue #25
            -DDCMTK_WITH_TIFF:BOOL=OFF  # see github issue #25
            -DDCMTK_WITH_XML:BOOL=OFF  # see github issue #25
            -DDCMTK_WITH_ICONV:BOOL=OFF  # see github issue #178
            -DDCMTK_FORCE_FPIC_ON_UNIX:BOOL=ON
            -DDCMTK_OVERWRITE_WIN32_COMPILER_FLAGS:BOOL=OFF
        )
        
    set(DCMTK_DIR ${CMAKE_BINARY_DIR}/dcmtk/install PARENT_SCOPE)
    #set(DCMTK_SOURCE_DIR ${SRC_DIR} PARENT_SCOPE)

endfunction()
