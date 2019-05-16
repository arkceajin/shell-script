WORK_DIR="/opt"
OPENCV_VERSION="4.0.1"
OPENCV_PREFIX="/usr/opencv-${OPENCV_VERSION}"
OPENCV_SRC="${WORK_DIR}/opencv-${OPENCV_VERSION}"
BUILD_SHARED_LIBS=""
MACHINE_TYPE=""
if [ "$1" == 'static' ]; then
  BUILD_SHARED_LIBS="OFF"
  OPENCV_PREFIX=${OPENCV_PREFIX}-static
else
  BUILD_SHARED_LIBS="ON"
  OPENCV_PREFIX=${OPENCV_PREFIX}-dynamic
fi
if [ $(uname -m) == 'x86_64' ]; then
  # 64-bit
  MACHINE_TYPE="x86_64"
else
  # 32-bit
  MACHINE_TYPE="i386"
fi
CMAKE_VERSION="3.5.1"
CMAKE_PKG="cmake-${CMAKE_VERSION}-Linux-${MACHINE_TYPE}"

# install cmake
if ! [ -x "$(command -v cmake)" ]; then
  cd ${WORK_DIR} && sudo wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_PKG}.sh"
  sudo chmod a+x "${CMAKE_PKG}.sh"
  sudo mkdir -p "${WORK_DIR}/${CMAKE_PKG}"
  sudo bash "${WORK_DIR}/${CMAKE_PKG}.sh" --skip-license --prefix="${WORK_DIR}/${CMAKE_PKG}"
  sudo ln -s ${WORK_DIR}/${CMAKE_PKG}/bin/* /usr/local/bin
fi

# install opencv
if [ ! -d ${OPENCV_SRC} ]; then
  cd ${WORK_DIR} && sudo wget "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip"
  sudo apt-get install unzip
  sudo unzip "${OPENCV_VERSION}.zip"
  if [ $(uname -m) == 'x86_64' ]; then
    sudo sed -i 's/#ifndef CV__EXCEPTION_PTR/#undef CV__EXCEPTION_PTR\n#ifndef CV__EXCEPTION_PTR/' "${OPENCV_SRC}/modules/core/src/parallel.cpp"
  fi
  sudo mkdir -p "${OPENCV_SRC}/build"
fi

# start build opencv
cd "${OPENCV_SRC}/build"
if [ $(uname -m) == 'x86_64' ]; then
  # 64-bit 
  sudo cmake -DCMAKE_C_COMPILER=arm-linux-gnueabi-gcc-4.9 -DCMAKE_CXX_COMPILER=arm-linux-gnueabi-g++-4.9 -DBUILD_TIFF=ON -DCMAKE_INSTALL_PREFIX=${OPENCV_PREFIX} -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} -DINSTALL_PYTHON_EXAMPLES=OFF -DBUILD_NEW_PYTHON_SUPPORT=OFF -DWITH_PROTOBUF=OFF -DWITH_ADE=OFF -DWITH_CUDA=OFF -DWITH_IPP=OFF -DWITH_QT=OFF -DWITH_GTK=OFF -DWITH_OPENEXR=OFF -DOPENCV_GENERATE_PKGCONFIG=ON ../
else
  # 32-bit 
  sudo cmake -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/arm-gnueabi.toolchain.cmake -DCMAKE_INSTALL_PREFIX=${OPENCV_PREFIX} -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} -DBUILD_WITH_STATIC_CRT=ON -DCMAKE_BUILD_TYPE=RELEASE -DOPENCV_GENERATE_PKGCONFIG=ON -DWITH_OPENEXR=OFF ../
fi
sudo make -j$(nproc) 
sudo make install

# add pkg-config to path
PKG_PATH="export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${OPENCV_PREFIX}/lib/pkgconfig"
BASHRC="/etc/bash.bashrc"
if grep -q "${PKG_PATH}" "${BASHRC}"; then
    echo "${PKG_PATH} already added."
else
    sudo echo ${PKG_PATH} >> ${BASHRC}
    # source ${BASHRC}
    echo "${PKG_PATH} add into rcS."
fi

# Run source /etc/bash.bashrc after this script!
