#######################################################################
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
#######################################################################

function(Qt_project)

    set(Qt-minvers 4.8.4 PARENT_SCOPE)
    set(Qt-package-name qt PARENT_SCOPE)

    set(default ON)
    if (WIN32)
        #set(default OFF)
    endif()

    PackageInit(Qt Qt4 QT ${default} REQUIRED_FOR_PLUGINS)
    if (TARGET Qt)
        return()
    endif()

    ParseProjectArguments(Qt qtp "NV_CONTROL" "GIT" ${ARGN})

    if (${qtp_GIT})
        set(location_args GIT_REPOSITORY "git://gitorious.org/qt/qt.git")
        if (NOT "${revision}" STREQUAL "4.8")
            set(revision 4.8)
        endif()
        set(location_args ${location_args} GIT_TAG ${revision})
    else()
        set(location_args 
            URL "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.4.tar.gz"
            URL_MD5 "89c5ecba180cae74c66260ac732dc5cb")
    endif()

    if (NOT DEFINED Qt_SOURCE_DIR)
        set(location ${location_args})
    endif()

    SetExternalProjectsDirs(Qt ep_build_dirs) # Needed here for SOURCE_DIR

    set(ConfigCommand CONFIGURE_COMMAND ${SOURCE_DIR}/configure)
    set(ConfigCommonOptions --prefix=${CMAKE_CURRENT_BINARY_DIR}/Qt/install
        -confirm-license -opensource -optimized-qmake -release -largefile 
        -plugin-sql-mysql -plugin-sql-odbc -plugin-sql-psql -plugin-sql-sqlite
    )

    # Those do not work on linux. Check for other platforms.
    # -cups  -plugin-sql-ibase -plugin-sql-tds

    IF (WIN32)
        set(ConfigCommand "${ConfigCommand}.exe")
        set(QtPlatformOptions)
    else()
        # -icu 
        set(QtPlatformOptions -no-rpath -reduce-relocations -sm -xinput -xcursor -xfixes -xinerama -xshape -xrandr -xrender
            -xkb -glib -openssl-linked -xmlpatterns -dbus-linked -no-webkit)
        if (NOT APPLE)
            set(QtPlatformOptions ${QtPlatformOptions} -dbus-linked)
        endif()
    endif()
    set(ConfigCommand ${ConfigCommand} ${ConfigCommonOptions} ${QtPlatformOptions})

    ExternalProject_Add(Qt
        ${ep_build_dirs}
        ${location}
        ${ConfigCommand}
        UPDATE_COMMAND ""
    )
    ExternalForceBuild(Qt)

    ExternalProject_Get_Property(Qt binary_dir)
    set(QT_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
