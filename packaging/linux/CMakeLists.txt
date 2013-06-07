##############################################################################
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
################################################################################

project(medInria_launcher)

## #############################################################################
## Install a launcher for medInria with right environment variable
## #############################################################################

configure_file(${CMAKE_SOURCE_DIR}/packaging/linux/medInria_launcher.sh.in 
  ${CMAKE_BINARY_DIR}/packaging/linux/medInria_launcher.sh
  )

install(PROGRAMS ${CMAKE_BINARY_DIR}/packaging/linux/medInria_launcher.sh 
  DESTINATION bin
  )
