#   System identification

if (UNIX AND NOT APPLE)

    find_program(LSB_RELEASE_EXECUTABLE lsb_release)
    if (LSB_RELEASE_EXECUTABLE)
        execute_process(COMMAND ${LSB_RELEASE_EXECUTABLE} -is
                        OUTPUT_VARIABLE DISTRIB
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
    else()
        message(ERROR "Cannot determine distribution.")
    endif()

    find_program(ARCH_EXECUTABLE arch)
    if (ARCH_EXECUTABLE)
        execute_process(COMMAND ${ARCH_EXECUTABLE}
                        OUTPUT_VARIABLE ARCH
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
    else()
        message(ERROR "Cannot determine architecture.")
    endif()
endif()
