cd /opt && sudo wget https://github.com/Kitware/CMake/releases/download/v3.5.1/cmake-3.5.1-Linux-i386.sh
sudo chmod a+x cmake-3.5.1-Linux-i386.sh
sudo bash cmake-3.5.1-Linux-i386.sh
sudo ln -s /opt/cmake-3.5.1-Linux-i386/bin/* /usr/local/bin

cd ~ && wget https://github.com/opencv/opencv/archive/4.0.1.zip
sudo apt-get install unzip
unzip 4.0.1.zip
#sed -i 's/#define CV__EXCEPTION_PTR/#undef CV__EXCEPTION_PTR\n#define CV__EXCEPTION_PTR/' opencv-4.0.1/modules/core/src/parallel.cpp
cd opencv-4.0.1 && mkdir build && cd build

cmake -DCMAKE_TOOLCHAIN_FILE=../platforms/linux/arm-gnueabi.toolchain.cmake -DCMAKE_INSTALL_PREFIX=~/opencv4-static -DBUILD_SHARED_LIBS=OFF -DBUILD_WITH_STATIC_CRT=ON -DCMAKE_BUILD_TYPE=RELEASE -DOPENCV_GENERATE_PKGCONFIG=ON ../
make -j 4
