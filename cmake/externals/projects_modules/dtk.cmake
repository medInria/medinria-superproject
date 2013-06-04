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

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name dtk)
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
  set(location 
    GIT_REPOSITORY "git://dtk.inria.fr/+medinria/dtk/dtk-clone-medinria.git"
    )
endif()


## #############################################################################
## Disable the dtk composer if QtDeclarative is missing.
## #############################################################################

include(CheckIncludeFileCXX)
set(CMAKE_REQUIRED_INCLUDES ${QT_INCLUDES})
Check_Include_File_CXX(QtDeclarative HasQtDeclarative)

set(DISABLE_DTK_COMPOSER)
if (NOT HasQtDeclarative)
  set(DISABLE_DTK_COMPOSER -DDTK_BUILD_COMPOSER:BOOL=OFF)
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DDTK_HAVE_NITE:BOOL=OFF
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  ${DISABLE_DTK_COMPOSER}
  )


## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

list(APPEND dependencies 
  Qt4
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
  ${location}
  ${ep_build_dirs}
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
