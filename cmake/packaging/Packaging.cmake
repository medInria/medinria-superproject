include (InstallRequiredSystemLibraries)

set(CPACK_PACKAGE_NAME ${PROJECT_NAME} CACHE STRING "Name of the package for medInria superproject")
set(CPACK_GENERATOR "DEB" CACHE STRING "Type of package to build")

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  #GET distribution id
  execute_process(COMMAND lsb_release -irs
    COMMAND sed "s/ //"
    COMMAND sed "s/Fedora/fc/"
    COMMAND tr -d '\n' 
    OUTPUT_VARIABLE DISTRIB
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process(COMMAND arch 
    OUTPUT_VARIABLE ARCH
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${DISTRIB}-${ARCH}")
  
  set (CPACK_PACKAGING_INSTALL_PREFIX /usr/local/medInria CACHE STRING "Prefix where the package be install on linux plateformes")  
  #Write a postinst and prerm script for Linux
  set( INSTALL_LIBS_DIRECTORIES_STRING \"${CPACK_PACKAGING_INSTALL_PREFIX}/lib\\n${CPACK_PACKAGING_INSTALL_PREFIX}/lib/InsightToolkit\\n${CPACK_PACKAGING_INSTALL_PREFIX}/lib/vtk-5.8\" )

  set(POSTINST_SCRIPT ${CMAKE_BINARY_DIR}/linux/postinst)
  file(WRITE ${POSTINST_SCRIPT} "\#!/bin/sh\n" )
  file(APPEND ${POSTINST_SCRIPT} "set -e\n")
  file(APPEND ${POSTINST_SCRIPT} "echo ${CPACK_PACKAGING_INSTALL_PREFIX}/lib>/etc/ld.so.conf.d/medInria.conf\n")
  file(APPEND ${POSTINST_SCRIPT} "echo ${CPACK_PACKAGING_INSTALL_PREFIX}/lib/InsightToolkit>>/etc/ld.so.conf.d/medInria.conf\n")
  file(APPEND ${POSTINST_SCRIPT} "echo ${CPACK_PACKAGING_INSTALL_PREFIX}/lib/vtk-5.8>>/etc/ld.so.conf.d/medInria.conf\n")
  file(APPEND ${POSTINST_SCRIPT} "ldconfig\n")
  file(APPEND ${POSTINST_SCRIPT} "ln -s ${CPACK_PACKAGING_INSTALL_PREFIX}/share/applications/medInria.desktop /usr/share/applications/medInria.desktop\n")
  file(APPEND ${POSTINST_SCRIPT} "ln -s ${CPACK_PACKAGING_INSTALL_PREFIX}/bin/medInria /usr/bin/medInria\n")

  set(PRERM_SCRIPT ${CMAKE_BINARY_DIR}/linux/prerm)
  file(WRITE ${PRERM_SCRIPT} "\#!/bin/sh\n" )
  file(APPEND ${PRERM_SCRIPT} "set -e\n")
  file(APPEND ${PRERM_SCRIPT} "[ -h /usr/share/applications/medInria.desktop ] && rm -f /usr/share/applications/medInria.desktop\n")
  file(APPEND ${PRERM_SCRIPT} "[ -h /usr/bin/medInria ]  && rm -f /usr/bin/medInria\n")
  file(APPEND ${PRERM_SCRIPT} "rm -f /etc/ld.so.conf.d/medInria.conf\n")

  set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${POSTINST_SCRIPT};${PRERM_SCRIPT}")
  set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE ${POSTINST_SCRIPT})
  set(CPACK_RPM_PRE_UNINSTALL_SCRIPT_FILE ${POSTINST_SCRIPT})
  
  
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libopenmpi1.3, libqt4-sql-sqlite, libboost-all-dev, nvidia-settings")
#set(CPACK_RPM_PACKAGE_REQUIRES "libopenmpi1.3, libqt4-sql-sqlite, libboost-all-dev, nvidia-settings")
  
else("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${CMAKE_SYSTEM_PROCESSOR}")
endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")


set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-src")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_NAME})
set(CPACK_PACKAGE_DESCRIPTION ${PROJECT_NAME})

set(CPACK_PACKAGE_VENDOR "http://www.inria.fr/")
set(CPACK_PACKAGE_CONTACT "medInria Team <medinria-userfeedback@inria.fr>")

set(CPACK_PACKAGE_VERSION_MAJOR ${${PROJECT_NAME}_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${${PROJECT_NAME}_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${${PROJECT_NAME}_VERSION_PATCH})

set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/cmake/packaging/Description.txt")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/cmake/packaging/License.txt")
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/cmake/packaging/Readme.txt")
set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_SOURCE_DIR}/cmake/packaging/Welcome.txt")

set(CPACK_BINARY_STGZ OFF)
set(CPACK_BINARY_TBZ2 OFF)
set(CPACK_BINARY_TGZ OFF)
set(CPACK_BINARY_TZ OFF)

set(CPACK_SOURCE_TBZ2 OFF)
set(CPACK_SOURCE_TGZ OFF)
set(CPACK_SOURCE_TZ OFF)
set(CPACK_SOURCE_ZIP OFF)


#Windows
IF(WIN32)
	MACRO( MAKE_NSIS_INSTALLER TARGET INPUT VERSION)
		FIND_FILE(MAKENSIS makensis.exe
			"C:/Program Files/NSIS/" 
            "C:/Program Files (x86)/NSIS/" 
			)    
        #MESSAGE("makensis found?: ${MAKENSIS}")
		IF( MAKENSIS )       
            #MESSAGE("makensis found")
			FILE(TO_CMAKE_PATH "$ENV{SYSTEMROOT}" SYSTEMROOT)
			IF(CMAKE_CL_64)
				SET(MSVC_ARCH x64)
                set(PROGFILES_DIR "$PROGRAMFILES64")
			ELSE(CMAKE_CL_64)
				SET(MSVC_ARCH x86)
                set(PROGFILES_DIR "$PROGRAMFILES")
			ENDIF(CMAKE_CL_64)
			SET(NSIS_OPTIONS
				${NSIS_OPTIONS}
				"/DmedInriaDIR=${EXECUTABLE_OUTPUT_PATH}"
				"/DmedInriaLIBDIR=${LIBRARY_OUTPUT_PATH}/release"
				"/DVERSION=${VERSION}"
				"/DSRCDIR=${PROJECT_SOURCE_DIR}"
				"/DINST_PREFIX=${CMAKE_INSTALL_PREFIX}"
				#must be changed but ${CMAKE_INSTALL_PREFIX} has slashes not backslashes...
				
                "/DPACK_INSTALLDIR=${PROGFILES_DIR}\\inria"
				"/DPROJECT_NAME=${PROJECT_NAME}"
				"/DMED_EXECUTABLE=${PROJECT_NAME}.exe"
                "/DMED_INSTALLER_EXE=${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-win32-${MSVC_ARCH}.exe"
				)
            #MESSAGE(${NSIS_OPTIONS})
			ADD_CUSTOM_COMMAND(
				TARGET ${TARGET} POST_BUILD
				COMMAND ${MAKENSIS} 
				ARGS ${NSIS_OPTIONS} ${INPUT}
				)
		ENDIF( MAKENSIS )
	ENDMACRO( MAKE_NSIS_INSTALLER )
	
	ADD_CUSTOM_TARGET(nsis  
		COMMENT "Create an installer for windows"
		DEPENDS install 
	)
    MAKE_NSIS_INSTALLER( nsis  ${PROJECT_SOURCE_DIR}/installerMedinria.nsi  ${${PROJECT_NAME}_VERSION})
ENDIF(WIN32)

foreach(package ${packages}) 
    if(NOT USE_SYSTEM_${package})
        ExternalProject_Get_Property(${package} binary_dir)
        set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${binary_dir};${package};ALL;${package}")
    endif()
endforeach()

include(CPack)

