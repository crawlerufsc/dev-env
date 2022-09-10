#! /bin/sh
#
# This script will install the minimum packages required to develop for the planner module in a x64 ubuntu-based linux.
#
# WARNING: this is designed to **MODIFY** your system
# if that's not what you intended, you can use one of the containers, particularly driveless-dev-cuda

sudo apt-get install -y git
sudo mkdir -p /tf
sudo cd /tf && git clone https://github.com/opencv/opencv.git
sudo cd /tf && git clone https://github.com/opencv/opencv_contrib.git
sudo mkdir -p /tf/opencv/build

sudo apt-get install -y build-essential cmake pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    sudo

sudo apt-get install -y libgtk2.0-dev

sudo cd /tf/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/tf/opencv_contrib/modules \
    -D BUILD_EXAMPLES=OFF .. \
    -D WITH_OPENMP=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_OPENCL=OFF \
    -D BUILD_ZLIB=ON \
    -D BUILD_TIFF=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_TBB=ON \
    -D BUILD_TBB=ON \
    -D BUILD_TESTS=OFF \
    -D WITH_EIGEN=OFF \
    -D WITH_GSTREAMER=ON \
    -D WITH_V4L=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_VTK=OFF \
    -D WITH_GTK=ON \
    -D WITH_QT=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.8/site-packages/ \
    -D OPENCV_GENERATE_PKGCONFIG=ON 

sudo cd /tf/opencv/build && make -j$(nproc)
sudo cd /tf/opencv/build && make install
sudo rm -rf /tf/

# BUGFIX warning
sudo apt-get install -y language-pack-en-base
sudo dpkg-reconfigure locales

# V4l2 (Video for linux utils, for debugging)
# try: $ v4l2-ctl -d /dev/video0 --list-formats
sudo apt-get install -y v4l-utils \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-good \
    ubuntu-restricted-extras
    
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev    
sudo apt-get install -y gir1.2-gst-rtsp-server-1.0

# OMPL
sudo curl -sSL https://ompl.kavrakilab.org/install-ompl-ubuntu.sh  > install-ompl-ubuntu.sh
sudo chmod a+x ./install-ompl-ubuntu.sh
sudo sudo ./install-ompl-ubuntu.sh --python
sudo rm ./install-ompl-ubuntu.sh

# ROS install
sudo apt-get install -y curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt-get update
ENV DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y ros-galactic-desktop


