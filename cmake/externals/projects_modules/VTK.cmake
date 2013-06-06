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

function(VTK_project)

## #############################################################################
## Prepare the project
## #############################################################################

set(ep_name VTK)
set(EP_NAME VTK)

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
      URL "http://www.vtk.org/files/release/5.8/vtk-5.8.0.tar.gz"
      URL_MD5 "37b7297d02d647cc6ca95b38174cb41f"
      )
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

# set compilation flags
set(c_flag ${ep_common_c_flags})
set(cxx_flag ${ep_common_cxx_flags})

if (UNIX)
  set(c_flags "${c_flags} -Wall")
  set(cxx_flags "${cxx_flags} -Wall")
  # Add PIC flag if Static build on UNIX
  if (NOT BUILD_SHARED_LIBS_${ep_name})
    set(c_flags "${c_flags} -fPIC")
    set(cxx_flags "${cxx_flags} -fPIC")
  endif()
endif()

set(cmake_args
  ${ep_common_cache_args}
  -DCMAKE_C_FLAGS:STRING=${c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${cxx_flags}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>  
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
  -DVTK_USE_QT:BOOL=ON
  -DVTK_WRAP_TCL:BOOL=OFF
  )

# Activate nvidia optimisation ? (currently only for Linux)
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  execute_process(COMMAND lspci|grep VGA
    OUTPUT_VARIABLE PCI_VGA
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
  if(${PCI_VGA} MATCHES Nvidia|NVIDIA|nvidia)
    message(Nvidia !!!)
    set(cmake_args
      ${cmake_args}
      -DVTK_USE_NVCONTROL:BOOL=ON
      )
  endif()
endif()


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
  ${ep_build_dirs}
  ${location}
  UPDATE_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  DEPENDS ${VTK_dependencies}
  INSTALL_COMMAND ""
  )
  

## #############################################################################
## Finalize
## #############################################################################

EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
