if (UNIX)
  configure_file(${CMAKE_SOURCE_DIR}/medInria.sh.in medInria.sh @ONLY)
elseif (WIN32)
  set(WIN_TYPE x86)
  if (CMAKE_GENERATOR MATCHES "Win64")
    set(WIN_TYPE x64)
  endif()

  set(VS_TYPE "VS90COMNTOOLS")
  if (CMAKE_GENERATOR MATCHES "Visual Studio 10")
    set(VS_TYPE "VS100COMNTOOLS")
  endif()

    string(REPLACE ";" ":" WIN_PRIVATE_PLUGINS "${PRIVATE_PLUGINS_DIRS}")

    configure_file(${CMAKE_SOURCE_DIR}/medInria.bat.in medInria.bat @ONLY)
endif()
