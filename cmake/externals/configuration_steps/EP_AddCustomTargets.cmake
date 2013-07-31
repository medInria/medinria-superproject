macro(EP_AddCustomTargets ep)

## #############################################################################
## Git update 
## #############################################################################

if (EXISTS ${source_dir}/.git)
  add_custom_target(update-${ep} 
    COMMAND git pull --ff-only
    WORKING_DIRECTORY ${source_dir}
    COMMENT "Updating '${ep}' with 'git pull --ff-only'"
    )
  set(update-${ep} ON PARENT_SCOPE)
  

## #############################################################################
## Svn update 
## #############################################################################

elseif(EXISTS ${source_dir}/.svn )
  add_custom_target(update-${ep} 
    COMMAND svn update
    WORKING_DIRECTORY ${source_dir}
    COMMENT "Updating '${ep}' with 'svn update'"
    )
  set(update-${ep} ON PARENT_SCOPE)
endif()

## #############################################################################
## build
## #############################################################################

foreach (dependece ${${ep}_dependencies})
    set(build-${ep}_dependences ${dependece} ${build-${ep}_dependences})
endforeach()

add_custom_target(build-${ep} 
  COMMAND cmake --build . --config ${CMAKE_BUILD_TYPE}
  WORKING_DIRECTORY ${binary_dir}
  COMMENT "build '${ep}' with 'cmake --build . --config ${CMAKE_BUILD_TYPE}'"
  DEPENDS ${build-${ep}_dependences}
  )
set(build-${ep} ON PARENT_SCOPE)

endmacro()
