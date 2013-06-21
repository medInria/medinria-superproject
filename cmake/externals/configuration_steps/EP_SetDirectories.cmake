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

function(EP_SetDirectories ep  
  CMAKE_VAR_EP_NAME EP
  ep_dirs
  )

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

set(DIR_NAMES     
  ""       
  build  
  stamp 
  install/${CMAKE_CFG_INTDIR} 
  tmp
  )

set(dirs PREFIX ${ep})
foreach(i RANGE 4)
  list(GET DIR_VAR_NAMES ${i} var)
  list(GET DIR_NAMES     ${i} dir)
  set(dirs ${dirs} ${var}_DIR ${ep}/${dir})
endforeach()

## #############################################################################
## Look for and define the source directory of the project 
## #############################################################################

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ep}/CMakeLists.txt 
OR EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${ep}/configure)
  set(${EP}_SOURCE_DIR SOURCE_DIR ${CMAKE_SOURCE_DIR}/${ep} PARENT_SCOPE)    
endif()

set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/${ep})
set(dirs ${dirs} SOURCE_DIR ${SOURCE_DIR})

set(SOURCE_DIR ${SOURCE_DIR} PARENT_SCOPE)
set(${ep_dirs} ${dirs} PARENT_SCOPE) 

endfunction()
