function(EP_SetDirectories ep  
  CMAKE_VAR_EP_NAME EP
  build_dirs
  )

if (NOT USE_SYSTEM_${ep})  
## #############################################################################
## Define a directory for each target of the project
## #############################################################################
  
  set(DIR_VAR_NAMES 
    DOWNLOAD 
    BINARY 
    STAMP 
    INSTALL 
    TMP
    )
  
  if(NOT "${CMAKE_INSTALL_PREFIX}" STREQUAL "")
    set(DIR_NAMES 
      ""       
      build  
      stamp 
      ${CMAKE_INSTALL_PREFIX}/${CMAKE_CFG_INTDIR} 
      tmp
      )     
  else()
    set(DIR_NAMES     
      ""       
      build  
      stamp 
      install/${CMAKE_CFG_INTDIR} 
      tmp
      )
  endif()

  set(dirs PREFIX ${ep})
  foreach(i RANGE 4)
    list(GET DIR_VAR_NAMES ${i} var)
    list(GET DIR_NAMES     ${i} dir)

    set(dirs ${dirs} ${var}_DIR ${ep}/${dir})
  endforeach()

## #############################################################################
## Look for and define the source directory of the project 
## #############################################################################

  if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ep}/CMakeLists.txt OR 
    EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ep}/configure
    )
    set(${EP}_SOURCE_DIR SOURCE_DIR 
      ${CMAKE_CURRENT_SOURCE_DIR}/${ep}
      )    
  endif()
  
  set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/${ep})
  set(dirs ${dirs} SOURCE_DIR ${SOURCE_DIR})

  set(SOURCE_DIR ${SOURCE_DIR} PARENT_SCOPE)
  set(${build_dirs} ${dirs} PARENT_SCOPE) 

endif()    

endfunction()
