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
set(EP_NAME QTDCM)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS ON
  REQUIERD_FOR_PLUGINS OFF
  )

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
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

# set compilation flags
set(c_flags ${ep_common_c_flags})
set(cxx_flags ${ep_common_cxx_flags})

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
  -DITK_DIR:FILEPATH=${ITK_DIR}
  -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
  -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
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
