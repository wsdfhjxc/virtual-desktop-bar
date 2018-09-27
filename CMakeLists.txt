cmake_minimum_required(VERSION 3.1)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(ECMInstallIcons)

set(REQUIRED_QT_VERSION 5.3.0)
set(KF5_MIN_VERSION 5.0.0)

find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Qml X11Extras)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma GlobalAccel XmlGui)

plasma_install_package(package org.kde.plasma.virtualdesktopbar)

set(vdb_SRCS
    plugin/vdbmodel.cpp
    plugin/vdbplugin.cpp
)

add_library(vdbplugin SHARED ${vdb_SRCS})

target_link_libraries(vdbplugin Qt5::Qml Qt5::X11Extras KF5::Plasma KF5::WindowSystem KF5::GlobalAccel KF5::XmlGui)

install(TARGETS vdbplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)
install(FILES plugin/qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/virtualdesktopbar)

ecm_install_icons(ICONS icons/sc-apps-vdb_plasma_applet.svg DESTINATION ${ICON_INSTALL_DIR})
