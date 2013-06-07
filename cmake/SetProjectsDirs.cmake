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

function(SetExternalProjectsDirs prefix varname)

    set(DIR_VAR_NAMES DOWNLOAD BINARY STAMP INSTALL                     TMP)
    set(DIR_NAMES     ""       build  stamp install/${CMAKE_CFG_INTDIR} tmp)

    set(dirs PREFIX ${prefix})
    foreach(i RANGE 4)
        list(GET DIR_VAR_NAMES ${i} var)
        list(GET DIR_NAMES     ${i} dir)

        set(dirs ${dirs} ${var}_DIR ${prefix}/${dir})
    endforeach()

    set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/${prefix})
    set(dirs ${dirs} SOURCE_DIR ${SOURCE_DIR})

    set(SOURCE_DIR ${SOURCE_DIR} PARENT_SCOPE)
    set(${varname} ${dirs} PARENT_SCOPE)
endfunction()
