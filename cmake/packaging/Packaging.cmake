include (InstallRequiredSystemLibraries)

set(CPACK_PACKAGE_NAME ${PROJECT_NAME} CACHE STRING "Name of the package for medInria superproject")

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
  set(CPACK_GENERATOR "DEB" CACHE STRING "Type of package to build")
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

set(CPACK_PACKAGE_VENDOR "http://med.inria.fr/")
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

if (NOT WIN32)
	foreach(package ${packages}) 
		if(NOT USE_SYSTEM_${package})
			ExternalProject_Get_Property(${package} binary_dir)
			set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${binary_dir};${package};ALL;${package}")
		endif()
	endforeach()
	foreach(dir ${PRIVATE_PLUGINS_DIRS})
			set(CPACK_INSTALL_CMAKE_PROJECTS "${CPACK_INSTALL_CMAKE_PROJECTS};${dir};${dir};ALL;${dir}")
	endforeach()
else (NOT WIN32)
	set(DISTRIB windows)
	set(CPACK_PACKAGE_TYPE NSIS)
	set(CPACK_PACKAGING_INSTALL_PREFIX "")
	set(CPACK_PACKAGE_INSTALL_DIRECTORY "medInria-${${PROJECT_NAME}_VERSION}")
	set(CPACK_MONOLITHIC_INSTALL 1)
	
	if(CMAKE_CL_64)
		SET(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
		#  - Text used in the installer GUI
		SET(CPACK_NSIS_PACKAGE_NAME "medInria (Win64)")
		#  - Registry key used to store info about the installation
		SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "medInria ${${PROJECT_NAME}_VERSION} (Win64)")
		SET(MSVC_ARCH x64)

	else(CMAKE_CL_64)
	    SET(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
		SET(CPACK_NSIS_PACKAGE_NAME "medInria")
		SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "medInria ${${PROJECT_NAME}_VERSION}")
		SET(MSVC_ARCH x86)
	endif(CMAKE_CL_64)

	set(CPACK_PACKAGE_FILE_NAME "medInria-${${PROJECT_NAME}_VERSION}-${MSVC_ARCH}")

	set(ICON_PATH "${PROJECT_SOURCE_DIR}/medInria/app/medInria/medInria.ico")

	# The icon to install the application.
	set(CPACK_NSIS_MUI_ICON ${ICON_PATH})

	# The icon to uninstall the application.
	set(CPACK_NSIS_MUI_UNIICON ${ICON_PATH})

	# Add a desktop shortcut
	set(CPACK_CREATE_DESKTOP_LINKS "medInria")

	# The icon in the Add/Remove control panel
	set(CPACK_NSIS_INSTALLED_ICON_NAME bin\\\\medInria.exe)

	# Add medinria to the PATH
	set(CPACK_NSIS_MODIFY_PATH "ON")

	# Add shortcut in the Startup menu
	set(CPACK_PACKAGE_EXECUTABLES "medInria" "medInria")

	# Add a link to the application website in the Startup menu.
	set(CPACK_NSIS_MENU_LINKS "http://med.inria.fr/" "Homepage for medInria") 

	# Run medInria after installation
	set(CPACK_NSIS_MUI_FINISHPAGE_RUN "medInria.exe")

	# Delete the Startup menu link after uninstallation
	set(CPACK_NSIS_DELETE_ICONS_EXTRA "
		Delete '\$SMPROGRAMS\\\\$MUI_TEMP\\\\*.*'
	")
	
	if (NOT PRIVATE_PLUGINS_DIRS STREQUAL "")
        message(WARNING "PRIVATE_PLUGINS_DIRS : Be careful to use '/' in your plugin paths and to end each path with '/' to copy the private plugins in the same level as the public plugins. Do no forget to separate each path with ';'")
        foreach(pluginpath ${PRIVATE_PLUGINS_DIRS}) 
            install(DIRECTORY ${pluginpath} DESTINATION plugins COMPONENT Runtime FILES_MATCHING PATTERN "*${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endforeach(pluginpath)
    else(NOT PRIVATE_PLUGINS_DIRS STREQUAL "")
        message(WARNING "PACKAGING : If you want to add private plugins to your package don't forget to set the PRIVATE_PLUGINS_DIRS variable in the cache.")
    endif()

	#${CMAKE_CFG_INTDIR}
    set(APP "\${CMAKE_INSTALL_PREFIX}/bin/medInria.exe")
	
    list(APPEND libSearchDirs ${QT_PLUGINS_DIR}/* ${QT_BINARY_DIR} ${ITK_DIR}/bin/Release ${DCMTK_DIR}/bin/Release ${VTK_DIR}/bin/Release ${QTDCM_DIR}/bin/Release ${TTK_DIR}/bin/Release ${dtk_DIR}/bin/Release ${RPI_DIR}/bin/Release ${CMAKE_INSTALL_PREFIX}/bin)
    set(PLUGINS "\${CMAKE_INSTALL_PREFIX}/plugins/")
	
	install(CODE "
	file(INSTALL ${medInria_DIR}/bin/Release/ DESTINATION \${CMAKE_INSTALL_PREFIX}/bin\)
	file(INSTALL ${medInria_DIR}/plugins/Release/ DESTINATION \${CMAKE_INSTALL_PREFIX}/plugins\)
    file(INSTALL ${QT_PLUGINS_DIR}/imageformats DESTINATION \${CMAKE_INSTALL_PREFIX}/bin)
    file(INSTALL \${PLUGINS} DESTINATION \${CMAKE_INSTALL_PREFIX}/plugins )
    file(INSTALL ${QT_PLUGINS_DIR}/sqldrivers/qsqlite4.dll DESTINATION \${CMAKE_INSTALL_PREFIX}/bin/sqldrivers\)
    file(INSTALL ${QT_BINARY_DIR}/QtSvg4.dll DESTINATION \${CMAKE_INSTALL_PREFIX}/bin)
    file(GLOB_RECURSE PLUGINS
      \${CMAKE_INSTALL_PREFIX}/plugins/*${CMAKE_SHARED_LIBRARY_SUFFIX}\)
    include(BundleUtilities)
    fixup_bundle(\"${APP}\"   \"\${PLUGINS}\"   \"${libSearchDirs}\")
    " COMPONENT Runtime)
endif()

if (APPLE)
	set(CPACK_BINARY_TGZ ON)
	set(CPACK_BINARY_STGZ OFF)
	set(CPACK_BINARY_DRAGNDROP OFF)
	set(CPACK_BINARY_PACKAGEMAKER OFF)

	set(CPACK_INSTALL_SCRIPT ${PROJECT_BINARY_DIR}/ApplePackScript.cmake)
endif()

include(CPack)

