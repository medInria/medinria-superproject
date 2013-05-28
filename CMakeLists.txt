cmake_minimum_required(VERSION 2.8.9)

if (DEFINED CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
   "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel.")
else()
   set(CMAKE_BUILD_TYPE Release CACHE STRING
   "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel.")
endif()

set(CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/externals"
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/packaging"
    "${CMAKE_CURRENT_SOURCE_DIR}/medInria/cmake"
    ${CMAKE_MODULE_PATH})

project(medInria-superProject)

set(${PROJECT_NAME}_VERSION_MAJOR 2 CACHE STRING "medInria major version number." FORCE)
set(${PROJECT_NAME}_VERSION_MINOR 1 CACHE STRING "medInria minor version number." FORCE)
set(${PROJECT_NAME}_VERSION_PATCH 0 CACHE STRING "medInria build version number." FORCE)
set(${PROJECT_NAME}_VERSION_TWEAK git CACHE STRING "medInria development marker." FORCE)
set(${PROJECT_NAME}_VERSION ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH})

mark_as_advanced(${PROJECT_NAME}_VERSION_MAJOR)
mark_as_advanced(${PROJECT_NAME}_VERSION_MINOR)
mark_as_advanced(${PROJECT_NAME}_VERSION_PATCH)

include(ExternalProjects)
include(CheckEnvironment)

set(MEDINRIA_TEST_DATA_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/medInria-testdata)
set(packages Qt dtk VTK ITK dcmtk TTK QtDcm RPI medInria)

set(PRIVATE_PLUGINS_DIRS "" CACHE PATH "Folders containing private plugins")

# This adds global targets that run this step in every subproject
set(global_targets configure update build install)
set_property(DIRECTORY PROPERTY EP_STEP_TARGETS ${global_targets})

foreach (target ${global_targets})
    add_custom_target(${target})
endforeach()

#   There are three possibilities:
#       - if the option USE_SYSTEM_${PACKAGE} is set, then the system version will be used (not yet tested)
#       - if the option USE_SYSTEM_${PACKAGE} is not set:
#           o if there is a subdir with the package name, in which case this subdir is used directly
#           o otherwise use download and compile locally the package as an external module.

foreach (package ${packages})
    call(${package}_project)
	foreach (target ${global_targets})
        add_dependencies(${target} ${package}-${target})
	endforeach()
endforeach()

file(APPEND ${${PROJECT_NAME}_CONFIG_FILE}
    "set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)\n")

include(RunScripts)

if (APPLE)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/packaging/ApplePackScript.cmake.in
		 ${PROJECT_BINARY_DIR}/tmp.in)
  configure_file(${PROJECT_BINARY_DIR}/tmp.in
		 ${PROJECT_BINARY_DIR}/ApplePackScript.cmake)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/packaging/mac_packager.sh.in
                 ${PROJECT_BINARY_DIR}/mac_packager.sh)
endif()

include(Packaging)    

