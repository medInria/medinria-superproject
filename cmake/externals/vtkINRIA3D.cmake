function(vtkinria3d_project)

    if (DEFINED vtkINRIA3D_DIR AND NOT EXISTS ${vtkINRIA3D_DIR})
        message(FATAL_ERROR "vtkINRIA3D_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(VtkINRIA3D vtki3dp "" "GIT" ${ARGN})

    set(vtkINRIA3D_enabling_variable vtkINRIA3D_LIBRARIES)

    set(${vtkINRIA3D_enabling_variable}_LIBRARY_DIRS vtkINRIA3D_LIBRARY_DIRS)
    set(${vtkINRIA3D_enabling_variable}_INCLUDE_DIRS vtkINRIA3D_INCLUDE_DIRS)
    set(${vtkINRIA3D_enabling_variable}_FIND_PACKAGE_CMD vtkINRIA3D)

    if (NOT DEFINED location)
        set(location GIT_REPOSITORY "git://dev-med.inria.fr/vtkinria3d/vtkinria3d.git")
    endif()

    ExternalProject_Add(vtkINRIA3D
        PREFIX vtkINRIA3D
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
             ${ep_common_cache_args}
            -DvtkINRIA3D_USE_ITK:BOOL=ON
            -DvtkINRIA3D_BUILD_EXAMPLES:BOOL=OFF
            -DITK_DIR:FILEPATH=${ITK_DIR}
            -DVTK_DIR:FILEPATH=${VTK_DIR}
            -DvtkINRIA3D_INSTALL_NO_DEVELOPMENT:BOOL=ON
        DEPENDS TTK VTK
    )

    set(vtkINRIA3D_DIR ${CMAKE_BINARY_DIR}/vtkINRIA3D/src/vtkINRIA3D-build PARENT_SCOPE)

endfunction()
