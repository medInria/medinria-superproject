#######################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#######################################################################

function(dtk_project)

    set(dtk-minvers 0.6.1)
    set(dtk-package-name dtk)

    PackageInit(dtk dtk dtk OFF REQUIRED_FOR_PLUGINS)
    if (TARGET dtk)
        return()
    endif()

    ParseProjectArguments(dtk dtkp "" "" ${ARGN})

    if (NOT DEFINED dtk_SOURCE_DIR)
        set(location GIT_REPOSITORY "git://dtk.inria.fr/+medinria/dtk/dtk-clone-medinria.git")
    endif()

    #   Old ubuntu/fedora do not have QtDeclarative, disable the dtk composer for them.

    include(CheckIncludeFileCXX)
    set(CMAKE_REQUIRED_INCLUDES ${QT_INCLUDES})
    Check_Include_File_CXX(QtDeclarative HasQtDeclarative)

    set(DISABLE_DTK_COMPOSER)
    if (NOT HasQtDeclarative)
        set(DISABLE_DTK_COMPOSER -DDTK_BUILD_COMPOSER:BOOL=OFF)
    endif()

    SetExternalProjectsDirs(dtk ep_build_dirs)
    ExternalProject_Add(dtk
        ${location}
        ${ep_build_dirs}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            ${ep_common_cache_args}
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            -DDTK_HAVE_NITE:BOOL=OFF
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
            ${DISABLE_DTK_COMPOSER}
        INSTALL_COMMAND ""      
        DEPENDS Qt 
    )
    ExternalForceBuild(dtk)

    ExternalProject_Get_Property(dtk binary_dir)
    set(dtk_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
