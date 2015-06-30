##############################################################################
#
# medInria
#
# Copyright (c) INRIA 2013-2015. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
###############################################################################

function(dtk_project)
    set(ep dtk)

    ## #############################################################################
    ## List the dependencies of the project
    ## #############################################################################

    list(APPEND ${ep}_dependencies Qt5)
      
    ## #############################################################################
    ## Prepare the project
    ## ############################################################################# 

    EP_Initialisation(${ep}  
      USE_SYSTEM OFF 
      BUILD_SHARED_LIBS ON
      REQUIRED_FOR_PLUGINS ON
      )

    if (NOT USE_SYSTEM_${ep})
        ## #############################################################################
        ## Set directories
        ## #############################################################################
          
        EP_SetDirectories(${ep} 
          EP_DIRECTORIES ep_dirs
          )

        ## #############################################################################
        ## Define repository where get the sources
        ## #############################################################################

        set(url ${GITHUB_PREFIX}d-tk/dtk.git)
        if (NOT DEFINED ${ep}_SOURCE_DIR)
          set(location GIT_REPOSITORY ${url})
        endif()

        ## #############################################################################
        ## Add specific cmake arguments for configuration step of the project
        ## #############################################################################

        # set compilation flags
        if (UNIX)
          set(${ep}_c_flags "${${ep}_c_flags} -Wall")
          set(${ep}_cxx_flags "${${ep}_cxx_flags} -Wall")
        endif()

        # Disable the dtk composer if QtDeclarative is missing.
        include(CheckIncludeFileCXX)
        set(CMAKE_REQUIRED_INCLUDES ${QT_INCLUDES})
        Check_Include_File_CXX(QtDeclarative HasQtDeclarative)

        if (NOT HasQtDeclarative)
          set(BUILD_DTK_COMPOSER OFF)
        else()
          set(BUILD_DTK_COMPOSER ON)  
        endif()

        set(cmake_args
          ${ep_common_cache_args}
          -DCMAKE_C_FLAGS:STRING=${${ep}_c_flags}
          -DCMAKE_CXX_FLAGS:STRING=${${ep}_cxx_flags}   
          -DCMAKE_SHARED_LINKER_FLAGS:STRING=${${ep}_shared_linker_flags}  
          -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
          -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS_${ep}}
          -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE} 
          -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}         
          -DDTK_BUILD_COMPOSER:BOOL=${BUILD_DTK_COMPOSER}
          -DDTK_BUILD_DISTRIBUTED:BOOL=ON
          -DDTK_BUILD_SCRIPT:BOOL=ON
          -DDTK_BUILD_SUPPORT_CORE:BOOL=ON
          -DDTK_BUILD_SUPPORT_CONTAINER:BOOL=ON
          -DDTK_BUILD_SUPPORT_MATH:BOOL=ON
          -DDTK_BUILD_GUI:BOOL=ON
          -DDTK_BUILD_MATH:BOOL=ON
          -DDTK_BUILD_VR:BOOL=ON
          -DDTK_HAVE_NITE:BOOL=OFF
          )

        ## #############################################################################
        ## Add external-project
        ## #############################################################################

        ExternalProject_Add(${ep}
          ${location}
          ${ep_dirs}
          UPDATE_COMMAND ""
          CMAKE_GENERATOR ${gen}
          CMAKE_ARGS ${cmake_args}
          DEPENDS ${${ep}_dependencies}
          INSTALL_COMMAND ""      
          )

        ## #############################################################################
        ## Set variable to provide infos about the project
        ## #############################################################################

        ExternalProject_Get_Property(${ep} binary_dir)
        set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

        ## #############################################################################
        ## Add custom targets
        ## #############################################################################

        EP_AddCustomTargets(${ep})

    endif()
endfunction()
