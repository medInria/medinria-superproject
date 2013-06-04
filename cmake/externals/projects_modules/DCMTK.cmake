function(DCMTK_project)

## #############################################################################
## Prepare the project
## ############################################################################# 

set(ep_name DCMTK)
string(TOUPPER "${ep_name}" EP_NAME)

EP_Initialisation(${ep_name}  
  USE_SYSTEM OFF 
  BUILD_SHARED_LIBS OFF
  REQUIERD_FOR_PLUGINS ON
  )

EP_SetDirectories("${ep_name} "
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

set(shared_libs_option ON)
if (WIN32)
  set(shared_libs_option OFF)
endif()

set(ep_project_include_arg)
if (CTEST_USE_LAUNCHERS)
  set(ep_project_include_arg
    "-DCMAKE_PROJECT_DCMTK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
endif()

set(cmake_args
  ${ep_common_cache_args}
  ${ep_project_include_arg}
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DBUILD_SHARED_LIBS:BOOL=${shared_libs_option}
  -DDCMTK_WITH_DOXYGEN:BOOL=OFF
  -DDCMTK_WITH_ZLIB:BOOL=OFF    
  -DDCMTK_WITH_OPENSSL:BOOL=OFF 
  -DDCMTK_WITH_PNG:BOOL=OFF     
  -DDCMTK_WITH_TIFF:BOOL=OFF    
  -DDCMTK_WITH_XML:BOOL=OFF     
  -DDCMTK_WITH_ICONV:BOOL=OFF   
  -DDCMTK_FORCE_FPIC_ON_UNIX:BOOL=ON
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
## Finalize
## #############################################################################

EP_ForceBuild(${ep_name})

ExternalProject_Get_Property(${ep_name} install_dir)
set(${EP_NAME}_DIR ${install_dir} PARENT_SCOPE)

endfunction()
