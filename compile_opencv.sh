WORK_DIR="/opt"
OPENCV_PREFIX="/usr/opencv4-static"
OPENCV_VERSION="4.0.1"
OPENCV_SRC="${WORK_DIR}/opencv-${OPENCV_VERSION}"
MACHINE_TYPE=""
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
  sudo ln -s "${WORK_DIR}/${CMAKE_PKG}/bin/*" /usr/local/bin
fi

# install opencv
if [ ! -d ${OPENCV_SRC} ]; then
  cd ${WORK_DIR} && wget "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip"
  sudo apt-get install unzip
  unzip "${OPENCV_VERSION}.zip"
  if [ $(uname -m) == 'x86_64' ]; then
    sudo sed -i 's/#ifndef CV__EXCEPTION_PTR/#undef CV__EXCEPTION_PTR\n#ifndef CV__EXCEPTION_PTR/' "${OPENCV_SRC}/modules/core/src/parallel.cpp"
  fi
  mkdir -p "${OPENCV_SRC}/build"
fi

# start build opencv
cd "${OPENCV_SRC}/build"
if [ $(uname -m) == 'x86_64' ]; then
  # 64-bit 
  cmake -DCMAKE_C_COMPILER=arm-linux-gnueabi-gcc-4.9 -DCMAKE_CXX_COMPILER=arm-linux-gnueabi-g++-4.9 -DBUILD_TIFF=ON -DCMAKE_INSTALL_PREFIX=${OPENCV_PREFIX} -DBUILD_SHARED_LIBS=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DBUILD_NEW_PYTHON_SUPPORT=OFF -DWITH_PROTOBUF=OFF -DWITH_ADE=OFF -DWITH_CUDA=OFF -DWITH_IPP=OFF -DWITH_QT=OFF -DWITH_GTK=OFF -DWITH_OPENEXR=OFF -DOPENCV_GENERATE_PKGCONFIG=ON ../
else
  # 32-bit 
  cmake -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/arm-gnueabi.toolchain.cmake -DCMAKE_INSTALL_PREFIX=${OPENCV_PREFIX} -DBUILD_SHARED_LIBS=OFF -DBUILD_WITH_STATIC_CRT=ON -DCMAKE_BUILD_TYPE=RELEASE -DOPENCV_GENERATE_PKGCONFIG=ON -DWITH_OPENEXR=OFF ../
fi
make -j$(nproc) && make install
