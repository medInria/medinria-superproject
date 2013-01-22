set(ep_common_c_flags "${CMAKE_C_FLAGS_INIT} ${ADDITIONAL_C_FLAGS}")
set(ep_common_cxx_flags "${CMAKE_CXX_FLAGS_INIT} ${ADDITIONAL_CXX_FLAGS} -fpermissive")

set(ep_common_cache_args
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
    -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
    -DBUILD_TESTING:BOOL=OFF
)

# Set CMake OSX variable to pass down the external projects

set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if (APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
         -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
         -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
         -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )
    list(APPEND ep_common_cache_args ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS})
endif()

# Compute -G arg for configuring external projects with the same CMake generator:

if (CMAKE_EXTRA_GENERATOR)
    set(gen "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
    set(gen "${CMAKE_GENERATOR}")
endif()
