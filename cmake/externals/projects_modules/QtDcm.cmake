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

function(QtDcm_project)

## #############################################################################
## Prepare the project
## #############################################################################

set(ep_name QtDcm)
string(TOUPPER "${ep_name}" EP_NAME)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS OFF
  )

EP_SetDirectories(${ep_name} 
  ep_build_dirs
  )

## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
  set(location GIT_REPOSITORY "git@github.com:medInria/qtdcm.git")
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(cmake_args
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  ${ep_common_cache_args}
  -DBUILD_SHARED_LIBS:BOOL=ON
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  )


## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

list(APPEND dependencies 
  Qt4 
  ITK 
  DCMTK
  )
  
foreach(dependence ${dependencies})
 if (USE_SYSTEM_${dependence})
  list(REMOVE_ITEM dependencies ${dependence})
 endif()
endforeach()

if (QT4_FOUND)
  set(QT_USE_QTNETWORK TRUE)
  include(${QT_USE_FILE})
endif(QT4_FOUND)


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_build_dirs}
  ${location}
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

endfunction()
