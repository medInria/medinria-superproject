function(medInria_plugins_project)

    if (DEFINED medInria-plugins_DIR AND NOT EXISTS ${medInria-plugins_DIR})
        message(FATAL_ERROR "medInria-plugins_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(medInria-plugins medInriaPluginsp "TEST" "" ${ARGN})

    set(medInriaPluginsp_TESTING OFF)
    if (${medInriaPluginsp_TEST})
        set(medInriaPluginsp_TESTING ON)
    endif()

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git@github.com:medInria/medInria-plugins.git")
    endif()

    ExternalProject_Add(medInria-plugins
        PREFIX medInria-plugins
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DTTK_DIR:FILEPATH=${TTK_DIR}
            -DmedInria_DIR:FILEPATH=${medInria_DIR}
            -DMEDINRIA_BUILD_TOOLS:BOOL=ON
            -DRPI_DIR:FILEPATH=${RPI_DIR}
        DEPENDS dtk medInria DCMTK ITK VTK TTK QtDcm RPI
    )

    set(medInria-plugins_DIR ${CMAKE_BINARY_DIR}/medInria-plugins/src/medInria-plugins-build PARENT_SCOPE)

endfunction()
