cmake_minimum_required(VERSION 2.8)

IF(DEFINED CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING
   "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel.")
ELSE()
   SET(CMAKE_BUILD_TYPE Release CACHE STRING
   "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel.")
ENDIF()

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

foreach (package ${packages})
    OPTION(USE_SYSTEM_${package} "Use system installed version of ${package}" OFF)
    if (NOT USE_SYSTEM_${package})
        include(${package})
    endif()
endforeach()
