function(medInria_plugins_project)

    if (DEFINED medInria-plugins_DIR AND NOT EXISTS ${medInria-plugins_DIR})
        message(FATAL_ERROR "medInria-plugins_DIR variable is defined but corresponds to non-existing directory")
    endif()

    set(medInria-plugins_enabling_variable medInria-plugins_LIBRARIES)

    ParseProjectArguments(medInria-plugins medInriaPluginsp "TEST" "" ${ARGN})

    set(medInriaPluginsp_TESTING OFF)
    if (${medInriaPluginsp_TEST})
        set(medInriaPluginsp_TESTING ON)
    endif()

    set(${medInria-plugins_enabling_variable}_LIBRARY_DIRS medInria-plugins_LIBRARY_DIRS)
    set(${medInria-plugins_enabling_variable}_INCLUDE_DIRS medInria-plugins_INCLUDE_DIRS)
    set(${medInria-plugins_enabling_variable}_FIND_PACKAGE_CMD medInria-plugins)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://dev-med.inria.fr/medinria/medinria-plugins.git")
    endif()

    ExternalProject_Add(medInria-plugins
        PREFIX medInria-plugins
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DDCMTK_DIR:FILEPATH=${DCMTK_DIR}
            -DDCMTK_SOURCE_DIR:FILEPATH=${DCMTK_SOURCE_DIR}
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DQTDCM_DIR:FILEPATH=${QTDCM_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DTTK_DIR:FILEPATH=${TTK_DIR}
            -DvtkINRIA3D_DIR:FILEPATH=${vtkINRIA3D_DIR}
            -DmedInria_DIR:FILEPATH=${medInria_DIR}
            -DRPI_DIR:FILEPATH=${RPI_DIR}
        DEPENDS dtk medInria DCMTK vtkINRIA3D ITK VTK TTK QtDcm RPI
    )

    set(medInria-plugins_DIR ${CMAKE_BINARY_DIR}/medInria-plugins/src/medInria-plugins-build PARENT_SCOPE)

endfunction()
