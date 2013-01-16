#
# medInria
#

if(DEFINED medInria_DIR AND NOT EXISTS ${medInria_DIR})
  message(FATAL_ERROR "medInria_DIR variable is defined but corresponds to non-existing directory")
endif()

set(medInria_enabling_variable medInria_LIBRARIES)

set(proj medInria)
set(proj_DEPENDENCIES DTK)

set(${medInria_enabling_variable}_LIBRARY_DIRS medInria_LIBRARY_DIRS)
set(${medInria_enabling_variable}_INCLUDE_DIRS medInria_INCLUDE_DIRS)
set(${medInria_enabling_variable}_FIND_PACKAGE_CMD medInria)

set(location_args GIT_REPOSITORY "git://dev-med.inria.fr/medinria/medinria.git" )

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
    -Ddtk_DIR:FILEPATH=${dtk_DIR}
  DEPENDS
     ${proj_DEPENDENCIES}
)

set(medInria_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
