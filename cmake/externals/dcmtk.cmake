function(DCMTK_project)

    set(DCMTK-minvers 3.6.1 PARENT_SCOPE)
    set(DCMTK-package-name dcmtk-inria PARENT_SCOPE)

    PackageInit(dcmtk DCMTK DCMTK OFF)
    if (TARGET dcmtk)
        return()
    endif()

    ParseProjectArguments(dcmtk dcmtkp "" "" ${ARGN})

    set(extproj_revision_tag GIT_TAG "${dcmtkp_REVISION}")
    if ("${dcmtkp_REVISION}" STREQUAL "") 
        #set(extproj_revision_tag GIT_TAG "ae3b946f6e6231")
    endif()

    set(ep_project_include_arg)
    if (CTEST_USE_LAUNCHERS)
        set(ep_project_include_arg
            "-DCMAKE_PROJECT_DCMTK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
    endif()

    if (NOT DEFINED dcmtk_SOURCE_DIR)
        if (NOT dcmtkp_UPSTREAM)
            set(location GIT_REPOSITORY "git://github.com/medInria/dcmtk.git" ${extproj_revision_tag})
        else()
            set(location GIT_REPOSITORY "git://git.dcmtk.org/dcmtk.git" ${extproj_revision_tag})
        endif()
    endif()

    set(shared_libs_option ON)
    if (WIN32)
        set(shared_libs_option OFF)
    endif()

    SetExternalProjectsDirs(dcmtk ep_build_dirs)
    ExternalProject_Add(dcmtk
        ${ep_build_dirs}
        ${location}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            ${ep_project_include_arg}
            -DBUILD_SHARED_LIBS:BOOL=${shared_libs_option}
            -DDCMTK_WITH_DOXYGEN:BOOL=OFF
            -DDCMTK_WITH_ZLIB:BOOL=OFF    # see github issue #25
            -DDCMTK_WITH_OPENSSL:BOOL=OFF # see github issue #25
            -DDCMTK_WITH_PNG:BOOL=OFF     # see github issue #25
            -DDCMTK_WITH_TIFF:BOOL=OFF    # see github issue #25
            -DDCMTK_WITH_XML:BOOL=OFF     # see github issue #25
            -DDCMTK_WITH_ICONV:BOOL=OFF   # see github issue #178
            -DDCMTK_FORCE_FPIC_ON_UNIX:BOOL=ON
            -DDCMTK_OVERWRITE_WIN32_COMPILER_FLAGS:BOOL=OFF
    )
    ExternalForceBuild(dcmtk)

    ExternalProject_Get_Property(dcmtk install_dir)
    set(DCMTK_DIR ${install_dir} PARENT_SCOPE)

endfunction()
