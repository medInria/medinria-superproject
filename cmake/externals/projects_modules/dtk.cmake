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
#######################################################################

function(dtk_project)

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name dtk)
set(EP_NAME dtk)

# list here all the dependencies of the project
list(APPEND ${ep_name}_dependencies 
  Qt4
  )

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
  set(location 
    GIT_REPOSITORY "git://dtk.inria.fr/+medinria/dtk/dtk-clone-medinria.git"
    )
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
 if (UNIX)
  set(${ep_name}_c_flags "${${ep_name}_c_flags} -Wall")
  set(${ep_name}_cxx_flags "${${ep_name}_cxx_flags} -Wall")
endif()

# Disable the dtk composer if QtDeclarative is missing.
include(CheckIncludeFileCXX)
set(CMAKE_REQUIRED_INCLUDES ${QT_INCLUDES})
Check_Include_File_CXX(QtDeclarative HasQtDeclarative)

if (NOT HasQtDeclarative)
  set(BUILD_DTK_COMPOSER OFF)
else()
  set(BUILD_DTK_COMPOSER ON)  
endif()

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep_name}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep_name}_cxx_flags}   
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DDTK_BUILD_COMPOSER:BOOL=${BUILD_DTK_COMPOSER}
  -DDTK_HAVE_NITE:BOOL=OFF
  )

## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${location}
  ${ep_build_dirs}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${${ep_name}_dependencies}
  INSTALL_COMMAND ""      
  )

## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${ep_name}_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
