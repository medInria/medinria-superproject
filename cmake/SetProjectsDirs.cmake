function(SetExternalProjectsDirs prefix varname)

    set(DIR_VAR_NAMES DOWNLOAD BINARY STAMP INSTALL TMP)
    set(DIR_NAMES     ""       build  stamp install tmp)

    set(dirs PREFIX ${prefix})
    foreach(i RANGE 4)
        list(GET DIR_VAR_NAMES ${i} var)
        list(GET DIR_NAMES     ${i} dir)

        set(dirs ${dirs} ${var}_DIR ${prefix}/${dir})
    endforeach()

    if (NOT ${USE_LOCAL_SOURCES})
        set(dirs ${dirs} SOURCE_DIR ${prefix}/src)
    endif()

    set(${varname} ${dirs} PARENT_SCOPE)
endfunction()
