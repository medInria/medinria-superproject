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
            -Ddtk_DIR:FILEPATH=${dtk_DIR}
            -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
        DEPENDS dtk
    )
    ExternalForceBuild(medInria)

    ExternalProject_Get_Property(medInria binary_dir)
    set(medInria_DIR ${binary_dir} PARENT_SCOPE)

endfunction()
