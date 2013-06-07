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
