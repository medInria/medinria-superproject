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

function(ITK_project)

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name ITK)
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
  set(location
    URL "http://sourceforge.net/projects/itk/files/itk/3.20/InsightToolkit-3.20.1.tar.gz"
    URL_MD5 "90342ffa78bd88ae48b3f62866fbf050"
    )
endif()

## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(ep_project_include_arg)
if (CTEST_USE_LAUNCHERS)
  set(ep_project_include_arg
    "-DCMAKE_PROJECT_ITK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
endif()

set(cmake_args
  ${ep_common_cache_args}
  ${ep_project_include_arg}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  ${ep_common_cache_args}
  ${ep_project_include_arg}
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF
  -DBUILD_SHARED_LIBS:BOOL=ON
  -DITK_USE_REVIEW:BOOL=ON
  -DITK_USE_REVIEW_STATISTICS:BOOL=ON
  -DITK_USE_CONCEPT_CHECKING:BOOL=OFF
  )


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_build_dirs}
  ${location}
  UPDATE_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  INSTALL_COMMAND ""
  )
  


## #############################################################################
## Finalize
## #############################################################################
  
EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(ITK binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
