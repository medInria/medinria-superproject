cmake_minimum_required(VERSION 2.8)

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
    "${CMAKE_CURRENT_SOURCE_DIR}/medInria/cmake"
    ${CMAKE_MODULE_PATH})

project(medinria-full)

include(ExternalProject)
include(ExternalProjectConfig)

set(MEDINRIA_TEST_DATA_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/medInria-testdata)
set(packages VTK ITK DCMTK TTK vtkinria3d QtDcm DTK RPI medInria medInria-plugins)

#   There are three possibilities:
#       - there is a subdir with the package name, in which case this subdir is used directly
#       - there is no such subdir:
#           o if the option USE_SYSTEM_${PACKAGE} is set, then the system version will be used (not yet done)
#           o otherwise use download and compile locally the package as an external module.

foreach (package ${packages})
    if (NOT IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${package})
        option(USE_SYSTEM_${package} "Use system installed version of ${package}" OFF)
        if (NOT USE_SYSTEM_${package})
            include(${package})
        endif()
    else()
        subdirs(${package})
    endif()
endforeach()
