function(QtDcm_project)

    if (DEFINED QTDCM_DIR AND NOT EXISTS ${QTDCM_DIR})
        message(FATAL_ERROR "QTDCM_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(QtDcm qtdcmp "TEST" "" "" ${ARGN})

    set(qtdcmp_TESTING OFF)
    if (${qtdcmp_TEST})
        set(qtdcmp_TESTING ON)
    endif()

    find_package(Qt4)
    if (QT4_FOUND)
        set(QT_USE_QTNETWORK true)
        include(${QT_USE_FILE})
    endif(QT4_FOUND)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://scm.gforge.inria.fr/qtdcm/qtdcm.git")
    endif()

    SetExternalProjectsDirs(QtDcm ep_build_dirs)
    ExternalProject_Add(QtDcm
        ${ep_build_dirs}
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
             ${ep_common_cache_args}
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
        DEPENDS ITK DCMTK
    )

    ExternalProject_Get_Property(QtDcm binary_dir)
    set(QTDCM_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
