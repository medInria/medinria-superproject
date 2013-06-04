include (InstallRequiredSystemLibraries)

set(CPACK_PACKAGE_NAME ${PROJECT_NAME} CACHE STRING "Name of the package for medInria superproject")

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_NAME} - medical image visualisation and processing tool")
set(CPACK_PACKAGE_DESCRIPTION "${PROJECT_NAME} is a medical image visualisation and processing tool developed at Inria by the teams Asclepios, Athena, Parietal and Visages.")

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

if (WIN32)
  include(WindowsPackaging)
endif()

if (APPLE)
  include(ApplePackaging)
endif()

if (LINUX)
  include(LinuxPackaging)
endif()

include(CPack)

