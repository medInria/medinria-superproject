include(Call)
include(ExternalProject)
include(ExternalProjectConfig)
include(ParseProjectArgs)

file(GLOB projects RELATIVE ${CMAKE_SOURCE_DIR} "cmake/externals/*.cmake")
foreach(proj ${projects})
    include(${proj})
endforeach()
