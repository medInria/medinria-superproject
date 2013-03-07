include(CMakeParseArguments)

macro(ParseProjectArguments PROJ prefix OPTIONS ONES)

    cmake_parse_arguments(${prefix} "TEST UPSTREAM ${OPTIONS}" "REVISION ${ONES}" "" ${ARGN})

    set(${prefix}_TESTING OFF)
    if (${${prefix}_TEST})
        set(${prefix}_TESTING ON)
    endif()
endmacro()
