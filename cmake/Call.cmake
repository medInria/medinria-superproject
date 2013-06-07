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

macro(call func_name)
    string(REPLACE "-" "_" func ${func_name})
    file(WRITE tmp_call.cmake "${func}(${ARGN})")
    include(tmp_call.cmake OPTIONAL)
    file(REMOVE tmp_call.cmake)
endmacro()
