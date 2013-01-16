#
# QtDcm
#

if(DEFINED QTDCM_DIR AND NOT EXISTS ${QTDCM_DIR})
  message(FATAL_ERROR "QTDCM_DIR variable is defined but corresponds to non-existing directory")
endif()

set(QTDCM_enabling_variable QTDCM_LIBRARIES)

set(proj QTDCM)
set(proj_DEPENDENCIES ITK DCMTK)

find_package(Qt4)
if(QT4_FOUND)
  set(QT_USE_QTNETWORK true)
  include(${QT_USE_FILE})
endif(QT4_FOUND)

set(${QTDCM_enabling_variable}_LIBRARY_DIRS QTDCM_LIBRARY_DIRS)
set(${QTDCM_enabling_variable}_INCLUDE_DIRS QTDCM_INCLUDE_DIRS)
set(${QTDCM_enabling_variable}_FIND_PACKAGE_CMD QTDCM)

set(location_args GIT_REPOSITORY "git://scm.gforge.inria.fr/qtdcm/qtdcm.git" )

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
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DITK_DIR:FILEPATH=${ITK_DIR}
    -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
    -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
DEPENDS
     ${proj_DEPENDENCIES}
)

set(QTDCM_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
