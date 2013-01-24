#
# ITK

if(DEFINED ITK_DIR AND NOT EXISTS ${ITK_DIR})
    message(FATAL_ERROR "ITK_DIR variable is defined but corresponds to non-existing directory")
endif()

set(ITK_enabling_variable ITK_LIBRARIES)

set(proj ITK)
set(proj_DEPENDENCIES)

set(${proj}_URL "http://sourceforge.net/projects/itk/files/itk/3.20/InsightToolkit-3.20.1.tar.gz")
set(${proj}_URL_MD5 "90342ffa78bd88ae48b3f62866fbf050")

set(git_protocol http)

set(${ITK_enabling_variable}_LIBRARY_DIRS ITK_LIBRARY_DIRS)
set(${ITK_enabling_variable}_INCLUDE_DIRS ITK_INCLUDE_DIRS)
set(${ITK_enabling_variable}_FIND_PACKAGE_CMD ITK)

set(revision_tag "v3.20.1")
if(${proj}_REVISION_TAG)
    set(revision_tag ${${proj}_REVISION_TAG})
endif()

if(${proj}_URL)
    set(location_args URL ${${proj}_URL})
elseif(${proj}_GIT_REPOSITORY)
    set(location_args GIT_REPOSITORY ${${proj}_GIT_REPOSITORY}
                      GIT_TAG ${revision_tag})
else()
    set(location_args GIT_REPOSITORY "${git_protocol}://itk.org/ITK.git"
                      GIT_TAG ${revision_tag})
endif()

set(ep_project_include_arg)
if(CTEST_USE_LAUNCHERS)
    set(ep_project_include_arg
        "-DCMAKE_PROJECT_ITK_INCLUDE:FILEPATH=${CMAKE_ROOT}/Modules/CTestUseLaunchers.cmake")
endif()

#     message(STATUS "Adding project:${proj}")
ExternalProject_Add(${proj}
SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
BINARY_DIR ${proj}-build
#PREFIX ${proj}${ep_suffix}
${location_args}
URL_MD5 ${${proj}_URL_MD5}
UPDATE_COMMAND ""
INSTALL_COMMAND ""
#CMAKE_GENERATOR ${gen}
CMAKE_CACHE_ARGS
    ${ep_common_cache_args}
    ${ep_project_include_arg}
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DITK_USE_REVIEW:BOOL=ON
    -DITK_USE_REVIEW_STATISTICS:BOOL=ON
    -DITK_INSTALL_NO_DEVELOPMENT:BOOL=ON
DEPENDS
     ${proj_DEPENDENCIES}
)
set(ITK_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

