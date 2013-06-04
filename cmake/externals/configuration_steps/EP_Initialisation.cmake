macro(EP_Initialisation 
  ep 
  USE_SYSTEM use_system_def 
  BUILD_SHARED_LIBS build_shared_libs_def
  REQUIERD_FOR_PLUGINS required_for_plugins
  )

## #############################################################################
## Complete superProjectConfig.cmake
## #############################################################################

if (${required_for_plugins})  
  #  provide path of project needeed for Asclepios and visages plugins 
  file(APPEND ${${PROJECT_NAME}_CONFIG_FILE}
    "find_package(${ep} REQUIRED
      PATHS \"${CMAKE_BINARY_DIR}/${ep}\" 
      PATH_SUFFIXES install build
      )\n"
    )
endif()

## #############################################################################
## Add variable : do we want use the system version ?
## #############################################################################

option(USE_SYSTEM_${ep} 
  "Use system installed version of ${ep}" 
  ${use_system_def}
  )

if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Add Variable : do we want a static or a dynamic build ?
## #############################################################################
  
  option(BUILD_SHARED_LIBS_${ep} 
    "Build shared libs for ${ep}" 
    ${build_shared_libs_def}
    )
  mark_as_advanced(BUILD_SHARED_LIBS_${ep})

## #############################################################################
## Add dependencies 
## #############################################################################

  # Add dependencies between the target of this package 
  # and the global target from the superproject
  
  foreach (target ${global_targets})
    add_dependencies(${target} ${ep}-${target})
  endforeach() 
endif()

endmacro()
