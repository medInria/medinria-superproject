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

function(medInria_project)

    set(medInria-minvers ${MEDINRIA_VERSION} PARENT_SCOPE)
    set(medInria-package-name medinria PARENT_SCOPE)

    PackageInit(medInria medInria medInria OFF REQUIRED_FOR_PLUGINS)
    if (TARGET medInria)
        return()
    endif()

    ParseProjectArguments(medInria medInriap "" "" ${ARGN})

    if (NOT DEFINED medInria_SOURCE_DIR)
	if(USE_GIT_SSH)
	    set(location GIT_REPOSITORY "git@github.com:medInria/medInria-public.git")
	else()
	    set(location GIT_REPOSITORY "https://github.com/medInria/medInria-public.git")
	endif()
    endif()
    
    set(custom_update_cmd git pull --ff-only ALWAYS 1)

    SetExternalProjectsDirs(medInria ep_build_dirs)
    ExternalProject_Add(medInria
        ${ep_build_dirs}
        ${location}
        UPDATE_COMMAND ${custom_update_cmd}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            ${ep_common_cache_args}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
            -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
            -DRPI_DIR:FILEPATH=${RPI_DIR}
            -DTTK_DIR:FILEPATH=${TTK_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DMEDINRIA_BUILD_TOOLS:BOOL=ON
        INSTALL_COMMAND ""
        DEPENDS dtk dcmtk ITK VTK TTK QtDcm RPI
    )
    ExternalForceBuild(medInria)

    ExternalProject_Get_Property(medInria binary_dir)
    set(medInria_DIR ${binary_dir} PARENT_SCOPE)

    ExternalProject_Get_Property(medInria source_dir)
    set(medInria_SOURCE_DIR ${source_dir} PARENT_SCOPE)

if(APPLE)
    set(medInria_exe_PATH ${binary_dir}/bin/medInria.app/Contents/MacOS/medInria PARENT_SCOPE)
elseif(UNIX)    
    set(medInria_exe_PATH ${binary_dir}/bin/medInria PARENT_SCOPE)
endif()

endfunction()
