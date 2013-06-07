function(DCMTK_project)

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name DCMTK)
set(EP_NAME DCMTK)

# list here all the dependencies of the project
list(APPEND ${ep_name}_dependencies 
  ""
  )


EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS OFF
  REQUIERD_FOR_PLUGINS ON
  )

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
  ep_build_dirs
  )


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
  set(location 
  GIT_REPOSITORY "git://github.com/medInria/dcmtk.git"
  )
endif()


## #############################################################################
## Add specific cmake arguments for configuration step of the project
## #############################################################################

if (WIN32)
  set(BUILD_SHARED_LIBS_${ep_name} OFF)
endif()

set(ep_optional_args)
if (CTEST_USE_LAUNCHERS)
  set(ep_optional_args
    "-DCMAKE_PROJECT_DCMTK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake"
    )    
endif()

# set compilation flags
if (UNIX)
  set(${ep_name}_c_flags "${${ep_name}_c_flags} -w")
  set(${ep_name}_cxx_flags "${${ep_name}_cxx_flags} -w")
endif()

set(cmake_args
  ${ep_common_cache_args}
  ${ep_project_include_arg}
  -DCMAKE_C_FLAGS:STRING=${${ep_name}_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${${ep_name}_cxx_flags}  
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep_name}}
  -DDCMTK_WITH_DOXYGEN:BOOL=OFF
  -DDCMTK_WITH_ZLIB:BOOL=OFF    
  -DDCMTK_WITH_OPENSSL:BOOL=OFF 
  -DDCMTK_WITH_PNG:BOOL=OFF     
  -DDCMTK_WITH_TIFF:BOOL=OFF    
  -DDCMTK_WITH_XML:BOOL=OFF     
  -DDCMTK_OVERWRITE_WIN32_COMPILER_FLAGS:BOOL=OFF
  )

## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_build_dirs}
  ${location}
  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS ${cmake_args}
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep_name} install_dir)
set(${EP_NAME}_DIR ${install_dir} PARENT_SCOPE)

endfunction()
