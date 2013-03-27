function(VTK_project)

    set(VTK-minvers 5.8.0 PARENT_SCOPE)
    set(VTK-package-name vtk-inria PARENT_SCOPE)

    PackageInit(VTK VTK VTK OFF OPTIONALLY_REQUIRED_FOR_PLUGINS)
    if (TARGET VTK)
        return()
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
            URL "http://www.vtk.org/files/release/5.8/vtk-5.8.0.tar.gz"
            URL_MD5 "37b7297d02d647cc6ca95b38174cb41f")
    endif()

    find_package(Qt4 REQUIRED)

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

    SetExternalProjectsDirs(VTK ep_build_dirs)
    ExternalProject_Add(VTK
        ${ep_build_dirs}
        ${location}
        UPDATE_COMMAND ""
        CMAKE_GENERATOR ${gen}
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
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
    ExternalForceBuild(VTK)

    ExternalProject_Get_Property(VTK binary_dir)
    set(VTK_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
