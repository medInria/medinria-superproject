macro(PackageInit package package_name var sys_def)

    set(OtherParameters ${ARGN})
    set(NeededForPlugins FALSE)
    list(LENGTH OtherParameters N)
    if (${N} GREATER 0)
        set(NeededForPlugins TRUE)
        list(GET OtherParameters 0 parm)
        set(required)
        if ("${parm}" STREQUAL "REQUIRED_FOR_PLUGINS")
            set(required " REQUIRED")
        endif()
    endif()
        
    option(USE_SYSTEM_${package} "Use system installed version of ${package}" ${sys_def})
    if (USE_SYSTEM_${package})
        find_package(${package_name})
        if (${var}_FOUND)

            #   Create a dummy external project just to satisfy dependencies.

            SetExternalProjectsDirs(${package} ep_build_dirs)
            ExternalProject_Add(${package}
                ${ep_build_dirs}
                CONFIGURE_COMMAND ""
                DOWNLOAD_COMMAND ""
                UPDATE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND "")
            ExternalForceBuild(${package})
            include(${${var}_USE_FILE})
            if (${NeededForPlugins})
                file(APPEND ${MEDINRIA_SUPER_PROJECT_CONFIG_FILE}
                     "find_package(${package_name}${required})\n")
            endif()
            return()
        endif()
    endif()

    if (DEFINED ${package}_DIR AND NOT EXISTS ${${package}_DIR})
        message(FATAL_ERROR "${package}_DIR variable is defined but corresponds to non-existing directory")
    endif()

    set(${package}_SOURCE_DIR)
    if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${package}/CMakeLists.txt)
        set(location SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${package})
        set(${package}_SOURCE_DIR ${location})
    endif()

    if (${NeededForPlugins})
        file(APPEND ${MEDINRIA_SUPER_PROJECT_CONFIG_FILE}
             "find_package(${package_name}${required} PATHS \"${CMAKE_BINARY_DIR}/${package}\" PATH_SUFFIXES install build)\n")
    endif()

endmacro()
