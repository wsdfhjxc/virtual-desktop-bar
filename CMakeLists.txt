cmake_minimum_required(VERSION 3.1)
project(VirtualDesktopBar)

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

if(NOT CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "/usr")
endif()

file(STRINGS /etc/os-release distro REGEX "^NAME=.*$")
if(distro MATCHES ".*openSUSE.*")
    set(QML_INSTALL_DIR "/usr/lib64/qt5/qml")
endif()

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMInstallIcons)

set(REQUIRED_QT_VERSION 5.9.5)
set(KF5_MIN_VERSION 5.44.0)

find_package(Qt5 ${REQUIRED_QT_VERSION}
             CONFIG REQUIRED
             Qml
             X11Extras)

find_package(KF5 ${KF5_MIN_VERSION}
             REQUIRED COMPONENTS
             Plasma
             WindowSystem
             GlobalAccel
             XmlGui)

plasma_install_package(package org.kde.plasma.virtualdesktopbar)

set(virtualdesktopbar_SRCS
    plugin/DesktopInfo.cpp
    plugin/VirtualDesktopBar.cpp
    plugin/VirtualDesktopBarPlugin.cpp
)

add_library(virtualdesktopbar SHARED ${virtualdesktopbar_SRCS})

target_link_libraries(virtualdesktopbar
                      Qt5::Qml
                      Qt5::X11Extras
                      KF5::Plasma
                      KF5::WindowSystem
                      KF5::GlobalAccel
                      KF5::XmlGui)

install(TARGETS virtualdesktopbar DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)
install(FILES plugin/qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)

ecm_install_icons(ICONS icons/sc-apps-virtualdesktopbar.svg DESTINATION ${ICON_INSTALL_DIR})
