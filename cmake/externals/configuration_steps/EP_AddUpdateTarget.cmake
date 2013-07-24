macro(EP_AddUpdateTarget ep)

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

endmacro()
