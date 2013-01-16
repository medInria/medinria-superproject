cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

project(medinria-full)

include(FindPackage)

set(MEDINRIA_TEST_DATA_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/medInria-testdata)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/medInria/cmake" ${CMAKE_MODULE_PATH})

# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dtk)
#     subdirs(dtk)
# endif()
# 
# #if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dcmtk)
# #    subdirs(dcmtk)
# #    set(DCMTK_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dcmtk CACHE PATH "DCMTK install directory")
# #    set(DCMTK_DIR ${CMAKE_CURRENT_BINARY_DIR}/dcmtk CACHE PATH "DCMTK install directory")
# #    set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/dcmtk/CMake" ${CMAKE_MODULE_PATH})
# #endif()
# 
# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/VTK)
#     set(VTK_DIR ${CMAKE_CURRENT_BINARY_DIR}/VTK CACHE PATH "VTK install directory")
#     set(VTK_USE_GLSL_SHADERS ON CACHE PATH "Use the HWShading library with VTK")
#     set(VTK_USE_QT ON CACHE PATH "Use Qt with VTK library")
#     set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/VTK/CMake" ${CMAKE_MODULE_PATH})
#     subdirs(VTK)
# endif()
# 
# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/RPI)
#     set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/RPI/cmake" "${CMAKE_CURRENT_DIR}/RPI/" ${CMAKE_MODULE_PATH})
#     subdirs(RPI)
# endif()
# 
# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ttk)
#     subdirs(ttk)
# endif()

# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/vtkinria3d)
#     subdirs(vtkinria3d)
# endif()
# 
# if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/qtdcm)
#     set(QTDCM_DIR ${CMAKE_CURRENT_BINARY_DIR}/qtdcm CACHE PATH "QtDCM install directory")
#     subdirs(qtdcm)
# endif()
# 
# OPTION(vtkINRIA3D_USE_HWSHADING "If ON, compile the hardware shading (HWShading) extension of vtkINRIA3D. Requires VTK>=5.1." ON)
# OPTION(vtkINRIA3D_USE_ITK "If ON, Compile ITK extensions, like itkAddOn" ON)
# 
# include_directories(${PROJECT_BINARY_DIR})
# subdirs(medInria medInria-plugins)



include(ExternalProject)

set(CMAKE_BUILD_TYPE release)

set(packages
  VTK
  ITK
  DCMTK
  TTK
  vtkinria3d
  QtDcm
#  DTK
#  medInria
#  medInria-plugins
)

set(ep_common_c_flags "${CMAKE_C_FLAGS_INIT} ${ADDITIONAL_C_FLAGS}")
set(ep_common_cxx_flags "${CMAKE_CXX_FLAGS_INIT} ${ADDITIONAL_CXX_FLAGS} -fpermissive")

set(ep_common_cache_args
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
    -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
    -DBUILD_TESTING:BOOL=OFF
   )

# Set CMake OSX variable to pass down the external projects
set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if(APPLE)
  list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
       -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
       -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
       -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
      )
  list(APPEND ep_common_cache_args ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS})
endif()

# Compute -G arg for configuring external projects with the same CMake generator:
if(CMAKE_EXTRA_GENERATOR)
  set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(gen "${CMAKE_GENERATOR}")
endif()

foreach(p ${packages})
  include(externals/${p}.cmake)
endforeach()


