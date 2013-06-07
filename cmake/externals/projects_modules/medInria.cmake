
##############################################################################
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
################################################################################

function(medInria_project)

set(ep_name medInria)
set(EP_NAME medInria)

## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep_name}_dependencies 
  Qt4 
  dtk 
  DCMTK 
  ITK 
  VTK 
  TTK 
  QtDcm 
  RPI
  )
  
set(MEDINRIA_TEST_DATA_ROOT 
  ${CMAKE_SOURCE_DIR}/medInria-testdata CACHE PATH
  "Root directory of the data used for the test of medInria")
mark_as_advanced(MEDINRIA_TEST_DATA_ROOT)  
  
## #############################################################################
## Prepare the project
## ############################################################################# 

EP_Initialisation(${ep_name}  
  CMAKE_VAR_EP_NAME ${EP_NAME}
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS ON
  )

if (NOT USE_SYSTEM_${ep_name})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
  ep_dirs
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
  -Ddtk_DIR:FILEPATH=${dtk_DIR}
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DQTDCM_DIR:FILEPATH=${QtDCM_DIR}
  -DRPI_DIR:FILEPATH=${RPI_DIR}
  -DTTK_DIR:FILEPATH=${TTK_DIR}
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  -DMEDINRIA_BUILD_TOOLS:BOOL=ON
  )
  
  
## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_dirs}
  ${location}
  UPDATE_COMMAND ${custom_update_cmd}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${${ep_name}_dependencies}
  INSTALL_COMMAND ""
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

ExternalProject_Get_Property(${ep_name} source_dir)
set(${EP_NAME}_SOURCE_DIR ${source_dir} PARENT_SCOPE)


if(APPLE)
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria.app/Contents/MacOS/medInria PARENT_SCOPE
    )

elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")    
  set(${EP_NAME}_EXE_PATH 
    ${binary_dir}/bin/medInria PARENT_SCOPE
    )
endif()

endif()

endfunction()
