function(VTK_project)

    if (DEFINED VTK_DIR AND NOT EXISTS ${VTK_DIR})
        message(FATAL_ERROR "VTK_DIR variable is defined but corresponds to non-existing directory")
    endif()

    ParseProjectArguments(VTK vtkp "NV_CONTROL" "GIT" ${ARGN})

    if (${vtkp_GIT})
        set(location_args GIT_REPOSITORY "http://vtk.org/VTK.git")
        if (NOT "${revision}" STREQUAL "")
            set(revision v5.8.0)
        endif()
        set(location_args ${location_args} GIT_TAG ${revision})
    else()
        set(location_args 
            URL "http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz"
            URL_MD5 "264b0052e65bd6571a84727113508789")
    endif()

    find_package(Qt4 REQUIRED)

    set(VTK_enabling_variable VTK_LIBRARIES)

    set(${VTK_enabling_variable}_LIBRARY_DIRS VTK_LIBRARY_DIRS)
    set(${VTK_enabling_variable}_INCLUDE_DIRS VTK_INCLUDE_DIRS)
    set(${VTK_enabling_variable}_FIND_PACKAGE_CMD VTK)

    set(additional_vtk_cmakevars )
    if (MINGW)
        list(APPEND additional_vtk_cmakevars -DCMAKE_USE_PTHREADS:BOOL=OFF)
    endif()

    if (${vtkp_NV_CONTROL})
        list(APPEND additional_vtk_cmakevars -DVTK_USE_NVCONTROL:BOOL=ON)
    endif()

    if (NOT DEFINED location)
        set(location ${location_args})
    endif()

    ExternalProject_Add(VTK
        PREFIX VTK
        ${location}
        UPDATE_COMMAND ""
        INSTALL_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_CACHE_ARGS
            ${ep_common_cache_args}
             ${additional_vtk_cmakevars}
            -DVTK_WRAP_TCL:BOOL=OFF
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DDESIRED_QT_VERSION:STRING=4
            -DVTK_USE_QT:BOOL=ON
            -DVTK_INSTALL_NO_DEVELOPMENT:BOOL=ON
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
    )

    set(VTK_DIR ${CMAKE_BINARY_DIR}/VTK/src/VTK-build PARENT_SCOPE)

endfunction()
