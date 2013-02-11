include(CMakeParseArguments)

macro(ParseProjectArguments PROJ prefix OPTIONS ONES)

    cmake_parse_arguments(${prefix} "TEST UPSTREAM ${OPTIONS}" "REVISION ${ONES}" "" ${ARGN})

    set(${prefix}_TESTING OFF)
    if (${${prefix}_TEST})
        set(${prefix}_TESTING ON)
    endif()

    list(LENGTH ${prefix}_UNPARSED_ARGUMENTS posarglen)
    if (${posarglen} GREATER 0)
        list(GET ${prefix}_UNPARSED_ARGUMENTS 0 SRC_DIR)
        if (IS_DIRECTORY ${SRC_DIR})
            set(location SOURCE_DIR ${SRC_DIR})
        endif()

        list(REMOVE_AT ${prefix}_UNPARSED_ARGUMENTS 0)
        if (NOT ${posarglen} EQUAL 1)
            MESSAGE("Warning ignoring supplementary args: ${${prefix}_UNPARSED_ARGUMENTS}")
        endif()
    endif()
endmacro()
