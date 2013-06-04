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

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name medInria)
string(TOUPPER "${ep_name}" EP_NAME)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS ON
  )

EP_SetDirectories(${ep_name} 
  ep_build_dirs
  )


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
  set(location GIT_REPOSITORY "git@github.com:medInria/medInria-public.git")
endif()

set(custom_update_cmd git pull --ff-only ALWAYS 1)


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(cmake_args
   ${ep_common_cache_args}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
  -DDTK_DIR:FILEPATH=${DTK_DIR}
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
  -DRPI_DIR:FILEPATH=${RPI_DIR}
  -DTTK_DIR:FILEPATH=${TTK_DIR}
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  -DMEDINRIA_BUILD_TOOLS:BOOL=ON
  )
  
  
## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

list(APPEND dependencies 
  Qt4 
  dtk 
  DCMTK 
  ITK 
  VTK 
  TTK 
  QtDcm 
  RPI
  )
  
foreach(dependence ${dependencies})
 if (USE_SYSTEM_${dependence})
  list(REMOVE_ITEM dependencies ${dependence})
 endif()
endforeach()


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_build_dirs}
  ${location}
  UPDATE_COMMAND ${custom_update_cmd}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  INSTALL_COMMAND ""
  DEPENDS ${dependencies}
  )


## #############################################################################
## Finalize
## #############################################################################
  
EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

ExternalProject_Get_Property(${ep_name} source_dir)
set(${EP_NAME}_SOURCE_DIR ${source_dir} PARENT_SCOPE)

if(APPLE)
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria.app/Contents/MacOS/medInria PARENT_SCOPE
    )

elseif(LINUX)    
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria PARENT_SCOPE
    )
endif()

endfunction()
