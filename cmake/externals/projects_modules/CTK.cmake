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

function(CTK_project)
set(ep CTK)


## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies 
  Qt4 VTK
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

set(url ${GITHUB_PREFIX}commontk/CTK.git)
if (NOT DEFINED ${ep}_SOURCE_DIR)
  set(location GIT_REPOSITORY ${url})
endif()


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
  -DVTK_DIR:FILEPATH=${VTK_DIR}
  -DMEDINRIA_BUILD_TOOLS:BOOL=ON
  -DCTK_APP_ctkCommandLineModuleExplorer:BOOL=ON
  -DCTK_BUILD_QTDESIGNER_PLUGINS:BOOL=ON
  -DCTK_BUILD_SHARED_LIBS:BOOL=ON
  -DCTK_ENABLE_Widgets:BOOL=ON
  -DCTK_LIB_CommandLineModules/Backend/FunctionPointer:BOOL=ON
  -DCTK_LIB_CommandLineModules/Backend/LocalProcess:BOOL=ON
  -DCTK_LIB_CommandLineModules/Core:BOOL=ON
  -DCTK_LIB_CommandLineModules/Frontend/QtGui:BOOL=ON
  -DCTK_LIB_CommandLineModules/Frontend/QtWebKit:BOOL=ON
  -DCTK_LIB_Core:BOOL=ON
  -DCTK_LIB_Widgets:BOOL=ON
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
  DEPENDS ${${ep}_dependencies}
  INSTALL_COMMAND ""
  )

## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep} binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

## #############################################################################
## Add custom targets
## #############################################################################

EP_AddCustomTargets(${ep})


endif() #NOT USE_SYSTEM_ep

endfunction()
