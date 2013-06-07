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

include(Call)
include(ExternalProject)
include(PackageInit)
include(ExternalProjectConfig)
include(ParseProjectArgs)
include(SetProjectsDirs)
include(ExternalForceBuild)

file(GLOB projects RELATIVE ${CMAKE_SOURCE_DIR} "cmake/externals/*.cmake")
foreach(proj ${projects})
    include(${proj})
endforeach()
