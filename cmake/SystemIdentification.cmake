#######################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
# 
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#######################################################################

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
