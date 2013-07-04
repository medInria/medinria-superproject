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

function(ITK_project)
set(ep ITK)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  ""
  )
  
  
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
  set(location
    URL "http://sourceforge.net/projects/itk/files/itk/3.20/InsightToolkit-3.20.1.tar.gz"
    URL_MD5 "90342ffa78bd88ae48b3f62866fbf050"
    )
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

set(ep_optional_args)
if (CTEST_USE_LAUNCHERS)
  set(ep_optional_args
    "-DCMAKE_PROJECT_ITK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
endif()

# set compilation flags
if (UNIX)
  set(${ep}_c_flags "${${ep}_c_flags} -w")
  set(${ep}_cxx_flags "${${ep}_cxx_flags} -w -fpermissive")
endif()

set(cmake_args
  ${ep_common_cache_args}
  ${ep_optional_args}
  -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
  -DBUILD_EXAMPLES:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF
  -DITK_USE_REVIEW:BOOL=ON
  -DITK_USE_REVIEW_STATISTICS:BOOL=ON
  -DITK_USE_CONCEPT_CHECKING:BOOL=OFF
  )


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep}
  ${ep_dirs}
  ${location}
  UPDATE_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  INSTALL_COMMAND ""
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(ITK binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

endif()

endfunction()
