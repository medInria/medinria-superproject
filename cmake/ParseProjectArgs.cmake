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

include(CMakeParseArguments)

macro(ParseProjectArguments PROJ prefix OPTIONS ONES)

    cmake_parse_arguments(${prefix} "TEST UPSTREAM ${OPTIONS}" "REVISION ${ONES}" "" ${ARGN})

    set(${prefix}_TESTING OFF)
    if (${${prefix}_TEST})
        set(${prefix}_TESTING ON)
    endif()
endmacro()
