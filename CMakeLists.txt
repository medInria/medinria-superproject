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

include(ExternalProjects)

set(MEDINRIA_TEST_DATA_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/medInria-testdata)
set(packages dtk VTK ITK DCMTK TTK QtDcm RPI medInria medInria-plugins)

#   There are three possibilities:
#       - if the option USE_SYSTEM_${PACKAGE} is set, then the system version will be used (not yet tested)
#       - if the option USE_SYSTEM_${PACKAGE} is not set:
#           o if there is a subdir with the package name, in which case this subdir is used directly
#           o otherwise use download and compile locally the package as an external module.

foreach (package ${packages})

    option(USE_SYSTEM_${package} "Use system installed version of ${package}" OFF)
    if (USE_SYSTEM_${package})
        find_package(${package})
    endif()
    
    if (NOT USE_SYSTEM_${package} OR NOT ${package}_FOUND)
        set(${package}_SOURCE_DIR)
        if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${package})
            set(${package}_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${package})
        endif()
        call(${package}_project "${${package}_SOURCE_DIR}")
    endif()

endforeach()
