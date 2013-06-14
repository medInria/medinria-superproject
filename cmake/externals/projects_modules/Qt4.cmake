##############################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
################################################################################

#TODO This module need test. Not sure it actually works.

function(Qt4_project)

set(ep_name Qt4)
set(EP_NAME Qt4)

## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep_name}_dependencies 
  ""
  )
  
  
## #############################################################################
## Prepare the project
## #############################################################################

EP_Initialisation(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
  USE_SYSTEM ON 
  BUILD_SHARED_LIBS ON
  REQUIRED_FOR_PLUGIN OFF
  )



if (NOT USE_SYSTEM_${ep_name})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep_name}
  CMAKE_VAR_EP_NAME ${EP_NAME}
  ep_dirs
  ) 


## #############################################################################
## Define repository where get the sources
## #############################################################################

if (NOT DEFINED ${EP_NAME}_SOURCE_DIR)
    set(location
      URL "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.4.tar.gz"
      URL_MD5 "89c5ecba180cae74c66260ac732dc5cb"
      )
endif()


## #############################################################################
## Define specific configuration command
## #############################################################################

set(ConfigCommand 
  CONFIGURE_COMMAND ${SOURCE_DIR}/configure
  )
  
set(ConfigCommonOptions 
  --prefix=${CMAKE_CURRENT_BINARY_DIR}/Qt4/install
  -confirm-license 
  -opensource 
  -optimized-qmake 
  -release 
  -largefile 
  -plugin-sql-mysql 
  -plugin-sql-odbc 
  -plugin-sql-psql 
  -plugin-sql-sqlite
)

IF (WIN32)
  set(ConfigCommand "${ConfigCommand}.exe")
  set(QtPlatformOptions)
else()
  set(QtPlatformOptions 
    -no-rpath 
    -reduce-relocations 
    -sm 
    -xinput 
    -xcursor 
    -xfixes 
    -xinerama 
    -xshape 
    -xrandr 
    -xrender
    -xkb 
    -glib 
    -openssl-linked 
    -xmlpatterns 
    -dbus-linked 
    -no-webkit
    )

  if (NOT APPLE)
      set(QtPlatformOptions 
        ${QtPlatformOptions} 
        -dbus-linked
        )
  endif()
endif()

set(ConfigCommand 
  ${ConfigCommand} 
  ${ConfigCommonOptions} 
  ${QtPlatformOptions}
  )

## #############################################################################
## Add external-project
## #############################################################################

ExternalProject_Add(${ep_name}
  ${ep_dirs}
  ${location}
  ${ConfigCommand}
  UPDATE_COMMAND ""
  )


## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep_name} binary_dir)
set(${EP_NAME}_DIR ${binary_dir} PARENT_SCOPE)

endif()

#TODO it si mark as advanced because not really tested yet.
mark_as_advanced(USE_SYSTEM_${ep_name})
endfunction()
