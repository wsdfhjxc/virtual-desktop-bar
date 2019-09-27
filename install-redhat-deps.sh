#!/bin/sh
BUILDDEPS='cmake extra-cmake-modules gcc-c++ qt5-qtbase-devel qt5-qtdeclarative-devel qt5-qtx11extras-devel kf5-plasma-devel kf5-kglobalaccel-devel kf5-kxmlgui-devel'
if dnf >/dev/null 2>&1 ; then 
  echo "Using dnf" && dnf install $BUILDDEPS;
else 
   echo "Using yum" && yum install $BUILDDEPS;
fi
