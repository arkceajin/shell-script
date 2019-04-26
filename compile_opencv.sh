if ! [ -x "$(command -v cmake)" ]; then
  cd /opt && sudo wget https://github.com/Kitware/CMake/releases/download/v3.5.1/cmake-3.5.1-Linux-x86_64.sh
  sudo chmod a+x cmake-3.5.1-Linux-x86_64.sh
  sudo mkdir -p /opt/cmake-3.5.1-Linux-x86_64
  sudo bash /opt/cmake-3.5.1-Linux-x86_64.sh --skip-license --prefix=/opt/cmake-3.5.1-Linux-x86_64
  sudo ln -s /opt/cmake-3.5.1-Linux-x86_64/bin/* /usr/local/bin
fi

if [ ! -d "/opt/opencv-4.0.1" ]; then
  cd /opt && wget https://github.com/opencv/opencv/archive/4.0.1.zip
  sudo apt-get install unzip
  unzip 4.0.1.zip
  sudo sed -i 's/#ifndef CV__EXCEPTION_PTR/#undef CV__EXCEPTION_PTR\n#ifndef CV__EXCEPTION_PTR/' /opt/opencv-4.0.1/modules/core/src/parallel.cpp
  mkdir -p /opt/opencv-4.0.1/build
fi

cd /opt/opencv-4.0.1/build
cmake -DCMAKE_C_COMPILER=arm-linux-gnueabi-gcc-4.9 -DCMAKE_CXX_COMPILER=arm-linux-gnueabi-g++-4.9 -DBUILD_TIFF=ON -DCMAKE_INSTALL_PREFIX=/usr/arm-linux-gnueabi/opencv4 -DBUILD_SHARED_LIBS=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DBUILD_NEW_PYTHON_SUPPORT=OFF -DWITH_PROTOBUF=OFF -DWITH_ADE=OFF -DWITH_CUDA=OFF -DWITH_IPP=OFF -DWITH_QT=OFF -DWITH_GTK=OFF -DWITH_OPENEXR=OFF -DOPENCV_GENERATE_PKGCONFIG=ON ../
#cmake -DCMAKE_C_COMPILER=arm-linux-gnueabi-gcc-4.9 -DCMAKE_CXX_COMPILER=arm-linux-gnueabi-g++-4.9 -DCMAKE_INSTALL_PREFIX=/usr/opencv4 -DWITH_PROTOBUF=OFF -DWITH_ADE=OFF -DWITH_CUDA=OFF -DBUILD_TIFF=ON -DBUILD_SHARED_LIBS=OFF -DBUILD_WITH_STATIC_CRT=ON -DCMAKE_BUILD_TYPE=RELEASE -DOPENCV_GENERATE_PKGCONFIG=ON -DWITH_OPENEXR=OFF ../
make -j$(nproc) && make install
