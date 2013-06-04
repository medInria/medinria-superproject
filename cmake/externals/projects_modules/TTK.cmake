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

function(TTK_project)

## #############################################################################
## Prepare the project
## #############################################################################

set(ep_name TTK)
string(TOUPPER "${ep_name}" EP_NAME)
  
EP_Initialisation(${ep_name} 
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS OFF
  )

EP_SetDirectories(${ep_name} 
  ep_build_dirs
  )

set(ttkp_TESTING OFF)
if (${ttkp_TEST})
  set(ttkp_TESTING ON)
endif()


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
  set(location SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/ttk/trunk")
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(cmake_args
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  ${ep_common_cache_args}
  -DBUILD_TESTING:BOOL=${ttkp_TESTING}
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  )
    

## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

list(APPEND dependencies 
  ITK 
  VTK
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
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  INSTALL_COMMAND ""    
  DEPENDS ${dependencies}
  )
  
## #############################################################################
## Finalize
## #############################################################################
  
EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(TTK binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
