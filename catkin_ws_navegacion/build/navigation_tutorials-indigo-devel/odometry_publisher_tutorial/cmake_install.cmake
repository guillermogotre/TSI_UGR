# Install script for directory: /home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/src/navigation_tutorials-indigo-devel/odometry_publisher_tutorial

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/install")
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
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/build/navigation_tutorials-indigo-devel/odometry_publisher_tutorial/catkin_generated/installspace/odometry_publisher_tutorial.pc")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/odometry_publisher_tutorial/cmake" TYPE FILE FILES
    "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/build/navigation_tutorials-indigo-devel/odometry_publisher_tutorial/catkin_generated/installspace/odometry_publisher_tutorialConfig.cmake"
    "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/build/navigation_tutorials-indigo-devel/odometry_publisher_tutorial/catkin_generated/installspace/odometry_publisher_tutorialConfig-version.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/odometry_publisher_tutorial" TYPE FILE FILES "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/src/navigation_tutorials-indigo-devel/odometry_publisher_tutorial/package.xml")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial" TYPE EXECUTABLE FILES "/home/guillermo/UGR/TSI/PRACTICA/catkin_ws_navegacion/devel/lib/odometry_publisher_tutorial/odometry_publisher")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher"
         OLD_RPATH "/opt/ros/kinetic/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/odometry_publisher_tutorial/odometry_publisher")
    endif()
  endif()
endif()

