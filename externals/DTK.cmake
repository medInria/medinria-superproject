#
# DTK
#

if(DEFINED dtk_DIR AND NOT EXISTS ${dtk_DIR})
  message(FATAL_ERROR "DTK_DIR variable is defined but corresponds to non-existing directory")
endif()

set(DTK_enabling_variable DTK_LIBRARIES)

set(proj DTK)
set(proj_DEPENDENCIES)

set(${DTK_enabling_variable}_LIBRARY_DIRS DTK_LIBRARY_DIRS)
set(${DTK_enabling_variable}_INCLUDE_DIRS DTK_INCLUDE_DIRS)
set(${DTK_enabling_variable}_FIND_PACKAGE_CMD DTK)

set(location_args GIT_REPOSITORY "git://dtk.inria.fr/+medinria/dtk/dtk-clone-medinria.git" )

#     message(STATUS "Adding project:${proj}")
ExternalProject_Add(${proj}
  SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
  BINARY_DIR ${proj}-build
  # PREFIX ${proj}${ep_suffix}
  ${location_args}
  UPDATE_COMMAND ""
  INSTALL_COMMAND ""
  CMAKE_GENERATOR ${gen}
  CMAKE_CACHE_ARGS
    -DDTK_HAVE_NITE:BOOL=OFF
  DEPENDS
     ${proj_DEPENDENCIES}
)

set(dtk_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
