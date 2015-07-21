################################################################################
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

cmake_minimum_required(VERSION 3.0.0)
cmake_policy(SET CMP0048 NEW)

## #############################################################################
## Set CMAKE_BUILD_TYPE to Release by default.
## #############################################################################

if (DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING 
    "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
    )
else()
  set(CMAKE_BUILD_TYPE Release CACHE STRING 
    "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
    )
endif()

## #############################################################################
## Add variables
## #############################################################################

set(medInria-superProject_VERSION_NUMBER "2.2.1.0" CACHE STRING
  "medInria version number."
  )
mark_as_advanced(medInria-superProject_VERSION_NUMBER)

project(medInria-superProject VERSION ${medInria-superProject_VERSION_NUMBER})

## #############################################################################
## Add packages
## #############################################################################

# There are three possibilities:
# - if the option USE_SYSTEM_${external_project} is set, then the system version  
#   will be used (not yet fully tested)
# - if the option USE_SYSTEM_${external_project} is not set:
#   * there is a subdir with the package name, in which case this subdir is used 
#     directly
#   * otherwise use download and compile locally the package as an external 
#     module.

list(APPEND external_projects 
  Qt4 
  dtk 
  VTK 
  ITK 
  DCMTK 
  TTK 
  QtDCM 
  RPI 
  medInria
  )

## #############################################################################
## Add modules
## #############################################################################

set(CMAKE_MODULE_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/environment
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/externals
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/externals/configuration_steps
  ${CMAKE_MODULE_PATH}
    )

set(GET_REVISIONS_MODULE_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/externals/get_revisions
  )

# Add CMAKE_MODULE_PATH to superProjectConfig.cmake, usefull for 
# Asclepios and visages plugins
set(${PROJECT_NAME}_CONFIG_FILE "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake")
file(WRITE ${${PROJECT_NAME}_CONFIG_FILE}
  "set(CMAKE_MODULE_PATH 
    ${CMAKE_MODULE_PATH}
    \${CMAKE_MODULE_PATH}
    )\n\n
    set(USE_GITHUB_SSH ${USE_GITHUB_SSH})\n"
  )
    
# Add path of the get_revisions module to superProjectConfig.cmake
file(APPEND ${${PROJECT_NAME}_CONFIG_FILE}
  "set(GET_REVISIONS_MODULE_PATH 
    ${GET_REVISIONS_MODULE_PATH}
    )\n\n"
  ) 

set(CMAKE_MODULE_PATH
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/externals/projects_modules
  ${CMAKE_CURRENT_SOURCE_DIR}/packaging
  ${CMAKE_MODULE_PATH}
  )

option(USE_GITHUB_SSH 
  "Use by default Git SSH addresses, requires public key set on github" OFF
  )
mark_as_advanced(USE_GITHUB_SSH)

set(PRIVATE_PLUGINS_DIRS "" CACHE PATH "Folders containing private plugins, separated by ';'")
mark_as_advanced(PRIVATE_PLUGINS_DIRS)

## #############################################################################
## Add Targets
## #############################################################################

set(global_targets 
  configure
  install
  )
  
# This adds targets that will be run in each external-projects
set_property(DIRECTORY PROPERTY EP_STEP_TARGETS ${global_targets})

foreach (target ${global_targets})
  add_custom_target(${target}-all)
endforeach()

## #############################################################################
## Check build environment
## #############################################################################

include(CheckEnvironment)

## #############################################################################
## Configure external-projects
## #############################################################################

include(ConfigureExternalProjects)

## #############################################################################
## Package
## #############################################################################

include(Packaging)
