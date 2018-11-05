# Install script for directory: /home/flax/blobby/blobby-1.0/data

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/blobby" TYPE FILE FILES
    "/home/flax/blobby/blobby-1.0/data/gfx.zip"
    "/home/flax/blobby/blobby-1.0/data/sounds.zip"
    "/home/flax/blobby/blobby-1.0/data/scripts.zip"
    "/home/flax/blobby/blobby-1.0/data/backgrounds.zip"
    "/home/flax/blobby/blobby-1.0/data/rules.zip"
    "/home/flax/blobby/blobby-1.0/data/config.xml"
    "/home/flax/blobby/blobby-1.0/data/inputconfig.xml"
    "/home/flax/blobby/blobby-1.0/data/server/server.xml"
    "/home/flax/blobby/blobby-1.0/data/lang_de.xml"
    "/home/flax/blobby/blobby-1.0/data/lang_en.xml"
    "/home/flax/blobby/blobby-1.0/data/lang_fr.xml"
    )
endif()

