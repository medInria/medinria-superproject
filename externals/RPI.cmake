#
# RPI

if(DEFINED RPI_DIR AND NOT EXISTS ${RPI_DIR})
    message(FATAL_ERROR "RPI_DIR variable is defined but corresponds to non-existing directory")
endif()

set(RPI_enabling_variable RPI_LIBRARIES)

set(proj RPI)
set(proj_DEPENDENCIES ITK)

set(${RPI_enabling_variable}_LIBRARY_DIRS RPI_LIBRARY_DIRS)
set(${RPI_enabling_variable}_INCLUDE_DIRS RPI_INCLUDE_DIRS)
set(${RPI_enabling_variable}_FIND_PACKAGE_CMD RPI)

set(location_args GIT_REPOSITORY "git://scm.gforge.inria.fr/asclepiospublic/asclepiospublic.git")


#     message(STATUS "Adding project:${proj}")
ExternalProject_Add(${proj}
SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
BINARY_DIR ${proj}-build
#PREFIX ${proj}${ep_suffix}
${location_args}
UPDATE_COMMAND ""
INSTALL_COMMAND ""
CMAKE_GENERATOR ${gen}
CMAKE_CACHE_ARGS
    ${ep_common_cache_args}
    -DRPI_BUILD_EXAMPLES:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DITK_DIR:FILEPATH=${ITK_DIR}
DEPENDS
    ${proj_DEPENDENCIES}
)
set(RPI_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

