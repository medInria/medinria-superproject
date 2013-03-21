# This file checks that all dependencies are met, and it necessary sets up a few
# things, like adding the github.com signature to known_hosts.

# Assume Unix by default
set(HOME_PATH $ENV{HOME})

if (WIN32)
	# Check for Visual Studio 2010
	if (NOT MSVC10)
		message( SEND_ERROR "MedInria can only be compiled with Visual Studio 2010 at this time." )
	endif()

	# Check for DirectX SDK (for VTK)
	file(GLOB DIRECTX_SDK "C:/Program Files*/Microsoft DirectX SDK*")
	if ( NOT DIRECTX_SDK)
		message( SEND_ERROR "You need to install Microsoft DirectX SDK : http://www.microsoft.com/en-us/download/details.aspx?id=6812" )
	endif()

	# GitBash
	find_program(BASH_BIN NAMES bash)
	if (NOT BASH_BIN)
		message( SEND_ERROR "You need to install GitBash and add it to the PATH environment variable." )
	endif()
	
	set(HOME_PATH $ENV{HOMEPATH})
endif()

# Git
find_program(GIT_BIN NAMES git)
if (NOT GIT_BIN)
	message( SEND_ERROR "You need to install Git and add it to the PATH environment variable." )
endif()

# SSH
find_program(SSH_BIN NAMES ssh)
if (NOT SSH_BIN)
	message( SEND_ERROR "You need to install SSH and add it to the PATH environment variable." )
endif()

# Subversion
find_program(SVN_BIN NAMES svn)
if (NOT SVN_BIN)
	message( SEND_ERROR "You need to install Subversion and add it to the PATH environment variable." )
endif()

# Python
find_program(PYTHON_BIN NAMES python)
if (NOT PYTHON_BIN)
	message( SEND_WARNING "You need to install Python and add it to the PATH environment variable if you want to be able to generate packages." )
endif()

# Perl
find_program(PERL_BIN NAMES perl)
if (NOT PERL_BIN)
	message( SEND_WARNING "You need to install Perl and add it to the PATH environment variable if you want to be able to generate packages." )
endif()

set (SKIP_GITHUB_TESTS Off CACHE BOOL "Set this to On to skip GitHub access tests")
set_property(CACHE SKIP_GITHUB_TESTS PROPERTY ADVANCED True)

if (NOT ${SKIP_GITHUB_TESTS})

	# Add github.com's SSH signature to the .ssh/known_hosts file
	set(GITHUB_SIGN "github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==")
	file(TO_CMAKE_PATH ${HOME_PATH} HOME_PATH)
	set(SSH_KNOWN_HOSTS_PATH ${HOME_PATH}/.ssh/known_hosts)
	file(STRINGS ${SSH_KNOWN_HOSTS_PATH} KNOWN_HOSTS REGEX github\\.com)
	list(LENGTH KNOWN_HOSTS N)
	set (INDEX 0)
	while(INDEX LESS N)
		list(GET KNOWN_HOSTS ${INDEX} KNOWN_HOST)
		string(STRIP ${KNOWN_HOST} KNOWN_HOST)
		string(COMPARE EQUAL ${KNOWN_HOST} ${GITHUB_SIGN} GITHUB_FOUND)
		if (GITHUB_FOUND)
			message(STATUS "Found Github's SSH signature in ${SSH_KNOWN_HOSTS_PATH}")
			break()
		endif()
		math( EXPR INDEX "${INDEX} + 1" )
	endwhile()

	if ( NOT GITHUB_FOUND)
		message( STATUS "Could not find Github's SSH signature, appending to ${SSH_KNOWN_HOSTS_PATH}..." )
		file(APPEND ${SSH_KNOWN_HOSTS_PATH} "\n${GITHUB_SIGN}\n")
	endif()

	# Test for a SSH key
	set(SSH_PUB_KEY ${HOME_PATH}/.ssh/id_rsa.pub)
	if (NOT EXISTS ${SSH_PUB_KEY})
		message( FATAL_ERROR "Could not find a public SSH key, you need to generate one." )
	else()
		message( STATUS "Found the user's public SSH key..." )
	endif()

	# Make sure the user's key has been upload to GitHub
	message( STATUS "Testing user's access to GitHub..." )
	execute_process(COMMAND ${SSH_BIN} -T git@github.com
		            TIMEOUT 10
		            RESULT_VARIABLE SSH_TEST_RESULT
		            OUTPUT_QUIET
		            ERROR_QUIET
		           )

	if (SSH_TEST_RESULT EQUAL 255)
		file(READ ${SSH_PUB_KEY} SSH_PUB_KEY_VALUE)
		message( FATAL_ERROR "
Could not connect to GitHub using SSH public key (found here : ${SSH_PUB_KEY})
Add this key to your GitHub account ( https://github.com/settings/ssh ) :
${SSH_PUB_KEY_VALUE}" )

	else()
		message( STATUS "GitHub access successful !" )
	endif()

	set (SKIP_GITHUB_TESTS On CACHE BOOL "GitHub access tests were successful, set On to force re-evaluation" FORCE)
endif()


