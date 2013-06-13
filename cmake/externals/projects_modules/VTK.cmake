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

function(VTK_project)

set(ep_name VTK)
set(EP_NAME VTK)

## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep_name}_dependencies 
  Qt4
  )
  
  
## #############################################################################
## Prepare the project
## #############################################################################


EP_Initialisation(${ep_name} 
  CMAKE_VAR_EP_NAME ${EP_NAME}
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGINS ON
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
    set(location 
      URL "http://www.vtk.org/files/release/5.8/vtk-5.8.0.tar.gz"
      URL_MD5 "37b7297d02d647cc6ca95b38174cb41f"
      )
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
if (UNIX)
  set(${ep_name}_c_flags "${${ep_name}_c_flags} -w")
  set(${ep_name}_cxx_flags "${${ep_name}_cxx_flags} -w")
endif()

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${${ep_name}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep_name}_cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>  
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DVTK_USE_QT:BOOL=ON
  -DVTK_WRAP_TCL:BOOL=OFF
  -DBUILD_TESTING:BOOL=OFF 
  -DVTK_USE_NVCONTROL:BOOL=ON 
  )


## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_dirs}
  ${location}
  UPDATE_COMMAND ""
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

endif()

endfunction()
