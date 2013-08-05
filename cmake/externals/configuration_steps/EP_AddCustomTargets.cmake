macro(EP_AddCustomTargets ep
  TAG tag
  )


set(GIT_COMMAND git pull --ff-only)
set(SVN_COMMAND svn update)

if(NOT ${tag} STREQUAL "")
  set(GIT_COMMAND git fetch ${url} && git checkout ${tag})
  set(SVN_COMMAND svn checkout -r ${tag} ${url})
endif()


## #############################################################################
## Git update 
## #############################################################################


if (EXISTS ${source_dir}/.git)
  add_custom_target(update-${ep} 
    COMMAND ${GIT_COMMAND}
    WORKING_DIRECTORY ${source_dir}
    COMMENT "Updating '${ep}' with '${GIT_COMMAND}'"
    )
  set(update-${ep} ON PARENT_SCOPE)
  

## #############################################################################
## Svn update 
## #############################################################################

elseif(EXISTS ${source_dir}/.svn )
  add_custom_target(update-${ep} 
    COMMAND ${SVN_COMMAND}
    WORKING_DIRECTORY ${source_dir}
    COMMENT "Updating '${ep}' with '${SVN_COMMAND}'"
    )
  set(update-${ep} ON PARENT_SCOPE)
endif()

## #############################################################################
## build
## #############################################################################

foreach (dependency ${${ep}_dependencies})
    set(build-${ep}_dependences build-${dependency} ${build-${ep}_dependences})
endforeach()

add_custom_target(build-${ep} 
  COMMAND cmake --build . --config ${CMAKE_BUILD_TYPE}
  WORKING_DIRECTORY ${binary_dir}
  COMMENT "build '${ep}' with 'cmake --build . --config ${CMAKE_BUILD_TYPE}'"
  DEPENDS ${build-${ep}_dependences}
  )
set(build-${ep} ON PARENT_SCOPE)

endmacro()
