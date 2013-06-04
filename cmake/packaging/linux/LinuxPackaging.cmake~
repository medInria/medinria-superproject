set(CPACK_GENERATOR "DEB" CACHE STRING "Type of package to build")

# Get distribution id
execute_process(COMMAND lsb_release -irs
COMMAND sed "s/ //"
COMMAND sed "s/Fedora/fc/"
COMMAND tr -d '\n' 
OUTPUT_VARIABLE DISTRIB
OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND arch OUTPUT_VARIABLE ARCH OUTPUT_STRIP_TRAILING_WHITESPACE)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${DISTRIB}-${ARCH}")


set (CPACK_LINUX_PACKAGING_INSTALL_PREFIX /usr/local/medInria CACHE STRING "Prefix where the will package be installed on linux plateforms")  

# Add a postinst and prerm script 
configure_file(${CMAKE_SOURCE_DIR}/cmake/packaging/linux/postinst.in ${CMAKE_BINARY_DIR}/Packaging/postinst)
configure_file(${CMAKE_SOURCE_DIR}/cmake/packaging/linux/prerm.in ${CMAKE_BINARY_DIR}/Packaging/prerm)

set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_BINARY_DIR}/Packaging/prerm;${CMAKE_BINARY_DIR}/Packaging/postinst")
set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE ${CMAKE_BINARY_DIR}/Packaging/postinst)
set(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE ${CMAKE_BINARY_DIR}/Packaging/prerm)

# Install a launcher for medInria with right environment variable
configure_file(${CMAKE_SOURCE_DIR}/cmake/packaging/linux/medInria_launcher.sh.in ${CMAKE_BINARY_DIR}/Packaging/medInria_launcher.sh)
install(PROGRAMS ${CMAKE_BINARY_DIR}/Packaging/medInria_launcher.sh DESTINATION bin)

message("Configure File !!!")

# Add project to package 
set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${CMAKE_BINARY_DIR};medInria-superProject;ALL;medInria-superProject") 
foreach(package ${packages}) 
	if(NOT USE_SYSTEM_${package})
		ExternalProject_Get_Property(${package} binary_dir)
		set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${binary_dir};${package};ALL;${package}")
	endif()
endforeach()
foreach(dir ${PRIVATE_PLUGINS_DIRS})
		set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${dir};${dir};ALL;${dir}")
endforeach()
