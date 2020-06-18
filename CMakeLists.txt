cmake_minimum_required(VERSION 3.1)
project(virtualdesktopbar)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "" FORCE)
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "/usr" CACHE STRING "" FORCE)
endif()

file(STRINGS /etc/os-release distro REGEX "^NAME=.*$")
if(distro MATCHES ".*openSUSE.*")
    set(QML_INSTALL_DIR "/usr/lib64/qt5/qml" CACHE STRING "" FORCE)
endif()

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMInstallIcons)

set(REQUIRED_QT_VERSION 5.3.0)
set(KF5_MIN_VERSION 5.0.0)

find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Qml X11Extras)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma WindowSystem GlobalAccel XmlGui)

plasma_install_package(package org.kde.plasma.virtualdesktopbar)

set(virtualdesktopbar_SRCS
    plugin/virtualdesktopbar.cpp
    plugin/virtualdesktopbarplugin.cpp
)

add_library(virtualdesktopbarplugin SHARED ${virtualdesktopbar_SRCS})

target_link_libraries(virtualdesktopbarplugin Qt5::Qml Qt5::X11Extras KF5::Plasma KF5::WindowSystem KF5::GlobalAccel KF5::XmlGui)

install(TARGETS virtualdesktopbarplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)
install(FILES plugin/qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)

ecm_install_icons(ICONS icons/sc-apps-virtualdesktopbar_plasma_applet.svg DESTINATION ${ICON_INSTALL_DIR})
