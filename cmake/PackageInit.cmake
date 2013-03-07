macro(PackageInit package package_name var sys_def)

    option(USE_SYSTEM_${package} "Use system installed version of ${package}" ${sys_def})
    if (USE_SYSTEM_${package})
        find_package(${package_name})
        if (${var}_FOUND)
            ExternalProject_Add(${package}
                CONFIGURE_COMMAND ""
                DOWNLOAD_COMMAND ""
                UPDATE_COMMAND ""
                BUILD_COMMAND ""
                INSTALL_COMMAND "")
            ExternalForceBuild(${package})
            include(${${var}_USE_FILE})
            return()
        endif()
    endif()

    if (DEFINED ${package}_DIR AND NOT EXISTS ${${package}_DIR})
        message(FATAL_ERROR "${package}_DIR variable is defined but corresponds to non-existing directory")
    endif()

    set(${package}_SOURCE_DIR)
    if (IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${package})
        set(USE_LOCAL_SOURCES TRUE)
        set(${package}_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${package})
        set(location SOURCE_DIR ${${package}_SOURCE_DIR})
    endif()

endmacro()
