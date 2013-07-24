################################################################################
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
set(ep medInria)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  Qt4 
  dtk 
  DCMTK 
  ITK 
  VTK 
  TTK 
  QtDCM
  RPI
  )
  
set(MEDINRIA_TEST_DATA_ROOT 
  ${CMAKE_SOURCE_DIR}/medInria-testdata CACHE PATH
  "Root directory of the data used for the test of medInria")
mark_as_advanced(MEDINRIA_TEST_DATA_ROOT)  
  
  
## #############################################################################
## Prepare the project
## ############################################################################# 

EP_Initialisation(${ep}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGINS ON
  )


if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep}
  EP_DIRECTORIES ep_dirs
  )


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${ep}_SOURCE_DIR)
  set(location GIT_REPOSITORY "${GITHUB_PREFIX}medInria/medInria-public.git")
endif()

set(custom_update_cmd git pull --ff-only ALWAYS 1)


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
if (UNIX)
  set(${ep}_c_flags "${${ep}_c_flags} -Wall")
  set(${ep}_cxx_flags "${${ep}_cxx_flags} -Wall")
endif()

set(cmake_args
   ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  -Ddtk_DIR:FILEPATH=${dtk_DIR}
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DQTDCM_DIR:FILEPATH=${QtDCM_DIR}
  -DRPI_DIR:FILEPATH=${RPI_DIR}
  -DTTK_DIR:FILEPATH=${TTK_DIR}
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  -DMEDINRIA_BUILD_TOOLS:BOOL=ON
  -DmedInria_VERSION_MAJOR:STRING=${${PROJECT_NAME}_VERSION_MAJOR}
  -DmedInria_VERSION_MINOR:STRING=${${PROJECT_NAME}_VERSION_MINOR}
  -DmedInria_VERSION_PATCH:STRING=${${PROJECT_NAME}_VERSION_PATCH}
  -DmedInria_VERSION_TWEAK:STRING=${${PROJECT_NAME}_VERSION_TWEAK}
  )
  
  
## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep}
  ${ep_dirs}
  ${location}
  UPDATE_COMMAND ${default_update_cmd}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${${ep}_dependencies}
  INSTALL_COMMAND ""
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep} binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

ExternalProject_Get_Property(${ep} source_dir)
set(${ep}_SOURCE_DIR ${source_dir} PARENT_SCOPE)


if(APPLE)
  set(${ep}_EXE_PATH 
    ${binary_dir}/bin/medInria.app/Contents/MacOS/medInria PARENT_SCOPE
    )

elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")    
  set(${ep}_EXE_PATH 
    ${binary_dir}/bin/medInria PARENT_SCOPE
    )
endif()


## #############################################################################
## Add an update target
## #############################################################################

ExternalProject_Get_Property(${ep} source_dir)

add_custom_target(update-${ep} 
  COMMAND ${git_update_cmd}
  WORKING_DIRECTORY ${source_dir}
  COMMENT "Updating '${ep}' with '${git_update_cmd}'"
  )
set(update-${ep} ON PARENT_SCOPE)


endif() #NOT USE_SYSTEM_ep

endfunction()
