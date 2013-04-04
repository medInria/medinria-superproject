function(medInria_project)

    set(medInria-minvers ${MEDINRIA_VERSION} PARENT_SCOPE)
    set(medInria-package-name medinria PARENT_SCOPE)

    PackageInit(medInria medInria medInria OFF REQUIRED_FOR_PLUGINS)
    if (TARGET medInria)
        return()
    endif()

    ParseProjectArguments(medInria medInriap "" "" ${ARGN})

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git@github.com:medInria/medInria-public.git")
    endif()
    
    SetExternalProjectsDirs(medInria ep_build_dirs)
    ExternalProject_Add(medInria
        ${ep_build_dirs}
        ${location}
        UPDATE_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
            -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
            -DRPI_DIR:FILEPATH=${RPI_DIR}
            -DTTK_DIR:FILEPATH=${TTK_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DMEDINRIA_BUILD_TOOLS:BOOL=ON
        DEPENDS dtk dcmtk ITK VTK TTK QtDcm RPI
    )
    ExternalForceBuild(medInria)

    ExternalProject_Get_Property(medInria binary_dir)
    set(medInria_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
