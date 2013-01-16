#
# vtkinria3d
#

if(DEFINED vtkINRIA3D_DIR AND NOT EXISTS ${vtkINRIA3D_DIR})
  message(FATAL_ERROR "vtkINRIA3D_DIR variable is defined but corresponds to non-existing directory")
endif()

set(vtkINRIA3D_enabling_variable vtkINRIA3D_LIBRARIES)

set(proj vtkINRIA3D)
set(proj_DEPENDENCIES ITK VTK)

# list(APPEND CTK_DEPENDENCIES ${proj})

set(${vtkINRIA3D_enabling_variable}_LIBRARY_DIRS vtkINRIA3D_LIBRARY_DIRS)
set(${vtkINRIA3D_enabling_variable}_INCLUDE_DIRS vtkINRIA3D_INCLUDE_DIRS)
set(${vtkINRIA3D_enabling_variable}_FIND_PACKAGE_CMD vtkINRIA3D)

set(location_args GIT_REPOSITORY "git://dev-med.inria.fr/vtkinria3d/vtkinria3d.git" )
#set(location_args SVN_REPOSITORY "svn://scm.gforge.inria.fr/svnroot/vtkinria3d/trunk")

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
    -DvtkINRIA3D_USE_ITK:BOOL=ON
    -DvtkINRIA3D_BUILD_EXAMPLES:BOOL=OFF
    -DITK_DIR:FILEPATH=${ITK_DIR}
    -DVTK_DIR:FILEPATH=${VTK_DIR}
    -DvtkINRIA3D_INSTALL_NO_DEVELOPMENT:BOOL=ON
DEPENDS
     ${proj_DEPENDENCIES}
)

set(vtkINRIA3D_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
