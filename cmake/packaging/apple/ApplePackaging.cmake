set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${CMAKE_SYSTEM_PROCESSOR}")

foreach(package ${packages}) 
	if(NOT USE_SYSTEM_${package})
		ExternalProject_Get_Property(${package} binary_dir)
		set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${binary_dir};${package};ALL;${package}")
	endif()
endforeach()
foreach(dir ${PRIVATE_PLUGINS_DIRS})
		set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${dir};${dir};ALL;${dir}")
endforeach()

set(CPACK_BINARY_TGZ ON)
set(CPACK_BINARY_STGZ OFF)
set(CPACK_BINARY_DRAGNDROP OFF)
set(CPACK_BINARY_PACKAGEMAKER OFF)


configure_file(${CMAKE_SOURCE_DIR}/cmake/packaging/apple/ApplePackScript.cmake.in ${PROJECT_BINARY_DIR}/tmp.in)
configure_file(${PROJECT_BINARY_DIR}/tmp.in ${PROJECT_BINARY_DIR}/ApplePackScript.cmake)
configure_file(${CMAKE_SOURCE_DIR}/cmake/packaging/apple/mac_packager.sh.in ${PROJECT_BINARY_DIR}/mac_packager.sh)

set(CPACK_INSTALL_SCRIPT ${PROJECT_BINARY_DIR}/ApplePackScript.cmake)
