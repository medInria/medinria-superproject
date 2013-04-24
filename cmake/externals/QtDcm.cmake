function(QtDcm_project)

    set(QtDcm-minvers 2.0.2 PARENT_SCOPE)
    set(QtDcm-package-name qtdcm PARENT_SCOPE)

    PackageInit(QtDcm QtDcm QTDCM OFF)
    if (TARGET QtDcm)
        return()
    endif()

    ParseProjectArguments(QtDcm qtdcmp "TEST" "" "" ${ARGN})

    set(qtdcmp_TESTING OFF)
    if (${qtdcmp_TEST})
        set(qtdcmp_TESTING ON)
    endif()

    if (QT4_FOUND)
        set(QT_USE_QTNETWORK true)
        include(${QT_USE_FILE})
    endif(QT4_FOUND)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git@github.com:medInria/qtdcm.git")
    endif()

    SetExternalProjectsDirs(QtDcm ep_build_dirs)
    ExternalProject_Add(QtDcm
        ${ep_build_dirs}
        ${location}
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
            ${ep_common_cache_args}
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
        INSTALL_COMMAND ""
        DEPENDS ITK dcmtk
    )
    ExternalForceBuild(QtDcm)

    ExternalProject_Get_Property(QtDcm binary_dir)
    set(QTDCM_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
