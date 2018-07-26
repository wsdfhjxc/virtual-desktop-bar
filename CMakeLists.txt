cmake_minimum_required(VERSION 3.1)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECompilerSettings)
include(KDECMakeSettings)
include(FeatureSummary)
include(ECMInstallIcons)

set(REQUIRED_QT_VERSION 5.3.0)
set(KF5_MIN_VERSION 5.0.0)

find_package(Qt5 ${REQUIRED_QT_VERSION} CONFIG REQUIRED Qml X11Extras)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS Plasma)

plasma_install_package(package org.kde.plasma.mds)

set(mds_SRCS
    plugin/mdsmodel.cpp
    plugin/mdsplugin.cpp
)

add_library(mdsplugin SHARED ${mds_SRCS})

target_link_libraries(mdsplugin Qt5::Qml Qt5::X11Extras KF5::Plasma KF5::WindowSystem)

install(TARGETS mdsplugin DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/mds)
install(FILES plugin/qmldir DESTINATION ${QML_INSTALL_DIR}/org/kde/plasma/private/mds)

ecm_install_icons(ICONS icons/sc-apps-mds_plasma_applet.svg DESTINATION ${ICON_INSTALL_DIR})
