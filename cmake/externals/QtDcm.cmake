function(QtDcm_project)

    if (DEFINED QTDCM_DIR AND NOT EXISTS ${QTDCM_DIR})
        message(FATAL_ERROR "QTDCM_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(QtDcm qtdcmp "TEST" "" "" ${ARGN})

    set(qtdcmp_TESTING OFF)
    if (${qtdcmp_TEST})
        set(qtdcmp_TESTING ON)
    endif()

    set(QTDCM_enabling_variable QTDCM_LIBRARIES)

    find_package(Qt4)
    if (QT4_FOUND)
        set(QT_USE_QTNETWORK true)
        include(${QT_USE_FILE})
    endif(QT4_FOUND)

    set(${QTDCM_enabling_variable}_LIBRARY_DIRS QTDCM_LIBRARY_DIRS)
    set(${QTDCM_enabling_variable}_INCLUDE_DIRS QTDCM_INCLUDE_DIRS)
    set(${QTDCM_enabling_variable}_FIND_PACKAGE_CMD QTDCM)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://scm.gforge.inria.fr/qtdcm/qtdcm.git")
    endif()

    ExternalProject_Add(QtDcm
        PREFIX QtDcm
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
        DEPENDS ITK DCMTK
    )

    set(QTDCM_DIR ${CMAKE_BINARY_DIR}/QtDcm/src/QtDcm-build PARENT_SCOPE)

endfunction()
