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
set(EP_NAME MEDINRIA)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS ON
  )

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
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

# set compilation flags
set(${ep_name}_c_flags "${ep_common_c_flags} ${${ep_name}_c_flags}")
set(${ep_name}_cxx_flags "${ep_common_cxx_flags} ${${ep_name}_cxx_flags}")
  
if (UNIX)
  set(${ep_name}_c_flags "${${ep_name}_c_flags} -Wall")
  set(${ep_name}_cxx_flags "${${ep_name}_cxx_flags} -Wall")
endif()

set(cmake_args
   ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep_name}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep_name}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
  -Ddtk_DIR:FILEPATH=${dtk_DIR}
  -DITK_DIR:FILEPATH=${ITK_DIR}
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

if(APPLE)
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria.app/Contents/MacOS/medInria PARENT_SCOPE
    )

elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")    
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria PARENT_SCOPE
    )
endif()

endfunction()
