function(dtk_project)

    if (DEFINED dtk_DIR AND NOT EXISTS ${dtk_DIR})
        message(FATAL_ERROR "DTK_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(dtk dtkp "" "" ${ARGN})

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://dtk.inria.fr/+medinria/dtk/dtk-clone-medinria.git")
    endif()

    #   Old ubuntu/fedora do not have QtDeclarative, disable the dtk composer for them.

    find_package(Qt4 4.6.0 REQUIRED)
    include(${QT_USE_FILE})

    include(CheckIncludeFileCXX)
    set(CMAKE_REQUIRED_INCLUDES ${QT_INCLUDES})
    Check_Include_File_CXX(QtDeclarative HasQtDeclarative)

    set(DISABLE_DTK_COMPOSER)
    if (NOT HasQtDeclarative)
        set(DISABLE_DTK_COMPOSER -DDTK_BUILD_COMPOSER:BOOL=OFF)
        set(location ${location} GIT_TAG MergeBranch)
    endif()

    SetExternalProjectsDirs(dtk ep_build_dirs)
    ExternalProject_Add(dtk
      ${location}
      ${ep_build_dirs}
      UPDATE_COMMAND ""
      INSTALL_COMMAND ""
      CMAKE_GENERATOR ${gen}
      CMAKE_CACHE_ARGS
          ${ep_common_cache_args}
          -DDTK_HAVE_NITE:BOOL=OFF
          ${DISABLE_DTK_COMPOSER}
    )

    set(dtk_DIR ${CMAKE_BINARY_DIR}/dtk/build PARENT_SCOPE)

endfunction()
