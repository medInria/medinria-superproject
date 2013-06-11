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

function(RPI_project)

    set(RPI-minvers 1.0.0 PARENT_SCOPE)
    set(RPI-package-name rpi PARENT_SCOPE)

    PackageInit(RPI RPI RPI OFF OPTIONALLY_REQUIRED_FOR_PLUGINS)
    if (TARGET RPI)
        return()
    endif()

    ParseProjectArguments(RPI rpip "" "" ${ARGN})

    if (NOT DEFINED RPI_SOURCE_DIR)
	if(USE_GIT_SSH)
	    set(location GIT_REPOSITORY "git@github.com:Inria-Asclepios/RPI.git")
	else()
	    set(location GIT_REPOSITORY "https://github.com/Inria-Asclepios/RPI.git")
	endif()
    endif()

    SetExternalProjectsDirs(RPI ep_build_dirs)
    ExternalProject_Add(RPI
        ${ep_build_dirs}
        ${location}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            ${ep_common_cache_args}
            -DRPI_BUILD_EXAMPLES:BOOL=OFF
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DITK_DIR:FILEPATH=${ITK_DIR}
        INSTALL_COMMAND ""
        DEPENDS ITK
    )
    ExternalForceBuild(RPI)

    ExternalProject_Get_Property(RPI binary_dir)
    set(RPI_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
