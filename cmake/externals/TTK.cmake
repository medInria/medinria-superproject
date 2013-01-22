#
# TTK
#

if(DEFINED TTK_DIR AND NOT EXISTS ${TTK_DIR})
  message(FATAL_ERROR "TTK_DIR variable is defined but corresponds to non-existing directory")
endif()

set(TTK_enabling_variable TTK_LIBRARIES)

set(proj TTK)
set(proj_DEPENDENCIES ITK VTK)

# list(APPEND CTK_DEPENDENCIES ${proj})

set(${TTK_enabling_variable}_LIBRARY_DIRS TTK_LIBRARY_DIRS)
set(${TTK_enabling_variable}_INCLUDE_DIRS TTK_INCLUDE_DIRS)
set(${TTK_enabling_variable}_FIND_PACKAGE_CMD TTK)

set(location_args SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/ttk/trunk" )

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
     ${ep_common_cache_args}
#     ${additional_vtk_cmakevars}
    -DBUILD_TESTING:BOOL=OFF
    -DITK_DIR:FILEPATH=${ITK_DIR}
    -DVTK_DIR:FILEPATH=${VTK_DIR}
DEPENDS
     ${proj_DEPENDENCIES}
)

set(TTK_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
