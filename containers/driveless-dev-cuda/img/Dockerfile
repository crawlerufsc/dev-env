#IMG-NAME: driveless-dev-cuda-img
FROM nvidia/cuda:11.6.2-runtime-ubuntu20.04
SHELL ["/bin/bash", "-c"]
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN rm /etc/apt/sources.list.d/*
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get dist-upgrade -y

# Python, Pytorch
RUN apt-get install -y python3-pip 
RUN apt-get install -y python3-tk
RUN pip3 install --no-cache-dir -q pandas --upgrade
RUN pip3 install --no-cache-dir -q sklearn  --upgrade
RUN pip3 install --no-cache-dir -q scikit-image  --upgrade
RUN pip3 install --no-cache-dir -q sympy --upgrade
RUN pip3 install --no-cache-dir -q autopep8 --upgrade
RUN pip3 install --no-cache-dir -q torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116
RUN pip3 install --no-cache-dir -q fastai --upgrade
RUN pip3 install --no-cache-dir -qr https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt
RUN pip3 install --no-cache-dir -q ipykernel --upgrade
RUN pip3 install --no-cache-dir -q av --upgrade
RUN pip3 install --no-cache-dir -q ipywidgets --upgrade
RUN pip3 install --no-cache-dir -q tensorboard --upgrade
RUN pip3 install --no-cache-dir -q opencv-python --upgrade


# ROS install
RUN apt-get install -y curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y ros-galactic-desktop

# Carla Simulator client
RUN pip install --upgrade pip
RUN pip3 install carla==0.9.13

## Install OpenCV
##-------------------------------
RUN apt-get install -y git
RUN mkdir -p /tf
RUN cd /tf && git clone https://github.com/opencv/opencv.git
RUN cd /tf && git clone https://github.com/opencv/opencv_contrib.git
RUN mkdir -p /tf/opencv/build

RUN apt-get install -y build-essential cmake pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    sudo

RUN apt-get install -y libgtk2.0-dev

# RUN cd /tf/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
#     -D CMAKE_INSTALL_PREFIX=/usr/local \
#     -D INSTALL_C_EXAMPLES=ON \
#     -D INSTALL_PYTHON_EXAMPLES=ON \
#     -D OPENCV_GENERATE_PKGCONFIG=ON \
#     -D OPENCV_EXTRA_MODULES_PATH=/tf/opencv_contrib/modules \
#     -D BUILD_EXAMPLES=ON .. \
#     -D WITH_GTK=ON

RUN cd /tf/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
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

RUN cd /tf/opencv/build && make -j$(nproc)
RUN cd /tf/opencv/build && make install

# BUGFIX warning
RUN apt-get install -y language-pack-en-base
RUN dpkg-reconfigure locales
##-------------------------------


# V4l2 (Video for linux utils, for debugging)
# try: $ v4l2-ctl -d /dev/video0 --list-formats
RUN apt-get install -y v4l-utils \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-good \
    ubuntu-restricted-extras
    
RUN apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev    
RUN apt-get install -y gir1.2-gst-rtsp-server-1.0


# OMPL
#RUN apt-get install -y libompl-dev ompl-demos
RUN curl -sSL https://ompl.kavrakilab.org/install-ompl-ubuntu.sh  > install-ompl-ubuntu.sh
RUN chmod a+x ./install-ompl-ubuntu.sh
#RUN sudo ./install-ompl-ubuntu.sh --python --app
RUN sudo ./install-ompl-ubuntu.sh --python
RUN rm ./install-ompl-ubuntu.sh

RUN adduser --force-badname --disabled-password --gecos '' --shell /bin/bash -u 1000 out0 && \ 
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \ 
	adduser out0 sudo && \ 
	adduser out0 audio && \ 
	adduser out0 video


ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo 'alias rs="source /opt/ros/galactic/setup.bash"' >> /home/out0/.bashrc

