#
# medInria-plugins
#

if(DEFINED medInria-plugins_DIR AND NOT EXISTS ${medInria-plugins_DIR})
  message(FATAL_ERROR "medInria-plugins_DIR variable is defined but corresponds to non-existing directory")
endif()

set(medInria-plugins_enabling_variable medInria-plugins_LIBRARIES)

set(proj medInria-plugins)
set(proj_DEPENDENCIES DTK medInria DCMTK vtkINRIA3D ITK VTK TTK QTDCM RPI)

set(${medInria-plugins_enabling_variable}_LIBRARY_DIRS medInria-plugins_LIBRARY_DIRS)
set(${medInria-plugins_enabling_variable}_INCLUDE_DIRS medInria-plugins_INCLUDE_DIRS)
set(${medInria-plugins_enabling_variable}_FIND_PACKAGE_CMD medInria-plugins)

set(location_args GIT_REPOSITORY "git://dev-med.inria.fr/medinria/medinria-plugins.git" )

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
    -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
    -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
    -DITK_DIR:FILEPATH=${ITK_DIR}
    -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
    -DVTK_DIR:FILEPATH=${VTK_DIR}
    -DTTK_DIR:FILEPATH=${TTK_DIR}
    -DvtkINRIA3D_DIR:FILEPATH=${vtkINRIA3D_DIR}
    -DmedInria_DIR:FILEPATH=${medInria_DIR}
    -DRPI_DIR:FILEPATH=${RPI_DIR}
  DEPENDS
     ${proj_DEPENDENCIES}
)

set(medInria-plugins_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
