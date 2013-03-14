function(Qt_project)

    set(Qt-minvers 4.8.4 PARENT_SCOPE)
    set(Qt-package-name qt PARENT_SCOPE)

    set(default ON)
    if (WIN32)
        #set(default OFF)
    endif()

    PackageInit(Qt Qt4 QT ${default})
    if (TARGET Qt)
        return()
    endif()

    ParseProjectArguments(QT qtp "NV_CONTROL" "GIT" ${ARGN})

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

    if (NOT DEFINED location)
        set(location ${location_args})
    endif()

    if (NOT USE_LOCAL_SOURCES)
        set(SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/Qt/src/)
    endif()

    set(ConfigCommand CONFIGURE_COMMAND ${SRC_DIR}/configure)
    set(ConfigCommonOptions --prefix=${CMAKE_CURRENT_BINARY_DIR}/QT/install
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

    SetExternalProjectsDirs(Qt ep_build_dirs)
    #set_target_properties(QT PROPERTIES _EP_BUILD_ARGS "-j 8")
    ExternalProject_Add(QT
        ${ep_build_dirs}
        ${location}
        ${ConfigCommand}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
    )
    ExternalForceBuild(QT)

    ExternalProject_Get_Property(QT binary_dir)
    set(QT_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
