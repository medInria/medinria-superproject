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

macro(EP_Initialisation ep
  CMAKE_VAR_EP_NAME EP 
  USE_SYSTEM use_system_def 
  BUILD_SHARED_LIBS build_shared_libs_def
  REQUIRED_FOR_PLUGINS required_for_plugins
  )
## #############################################################################
## Add variable : do we want use the system version ?
## #############################################################################

option(USE_SYSTEM_${ep} 
  "Use system installed version of ${ep}" 
  ${use_system_def}
  )

if (USE_SYSTEM_${ep})
  find_package(${EP} REQUIRED)
else()

## #############################################################################
## Complete superProjectConfig.cmake
## #############################################################################

  if (${required_for_plugins})  
    #  provide path of project needeed for Asclepios and visages plugins 
    file(APPEND ${${PROJECT_NAME}_CONFIG_FILE}
      "find_package(${EP} REQUIRED
        PATHS \"${CMAKE_BINARY_DIR}/${ep}\" 
        PATH_SUFFIXES install build
        )\n"
      )
  endif()


## #############################################################################
## Add Variable : do we want a static or a dynamic build ?
## #############################################################################
  
  option(BUILD_SHARED_LIBS_${ep} 
    "Build shared libs for ${ep}" 
    ${build_shared_libs_def}
    )
  mark_as_advanced(BUILD_SHARED_LIBS_${ep})
  
  
## #############################################################################
## Set compilation flags
## #############################################################################
  
  set(${ep_name}_c_flags ${ep_common_c_flags})
  set(${ep_name}_cxx_flags ${ep_common_cxx_flags})
  
  # Add PIC flag if Static build on UNIX with amd64 arch
  if (UNIX)
    if (NOT BUILD_SHARED_LIBS_${ep} AND 
        "${CMAKE_SYSTEM_PROCESSOR}" MATCHES amd64|AMD64|x86_64|X86_64)
        
      set(${ep}_c_flags "${${ep}_c_flags} -fPIC")
      set(${ep}_cxx_flags "${${ep}_cxx_flags} -fPIC")
    endif()
  endif()  


## #############################################################################
## Resolve dependencies with other external-project
## #############################################################################

  foreach(dependence ${${ep}_dependencies})
   if (USE_SYSTEM_${dependence})
    list(REMOVE_ITEM ${ep}_dependencies ${dependence})
   endif()
  endforeach()


## #############################################################################
## Add target dependencies 
## #############################################################################

  # Add dependencies between the target of this project 
  # and the global target from the superproject
    foreach (target ${global_targets})
    add_dependencies(${target} ${ep}-${target})
  endforeach() 

endif()

endmacro()
