# Create a container for exploring bluerov2 + ardusub
# Primarily based around https://github.com/patrickelectric/bluerov_ros_playground

ARG ROS_DISTRO=melodic
#ENV ROS_DISTRO=$ROS_DISTRO

FROM osrf/ros:$ROS_DISTRO-desktop

#RUN useradd -M tempuser
#RUN usermod -d /root

RUN apt-get update
#RUN apt-get upgrade -y
RUN apt-get install -y ros-$ROS_DISTRO-mavros \
    ros-$ROS_DISTRO-gazebo-ros-pkgs \
    ros-$ROS_DISTRO-gazebo-ros-control \
    python-gi \
    gstreamer1.0-tools \
    gir1.2-gstreamer-1.0 \
    gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav


# Install GeographicLib datasets for mavros
RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
RUN chmod +x ./install_geographiclib_datasets.sh
RUN ./install_geographiclib_datasets.sh
RUN rm ./install_geographiclib_datasets.sh

# Install Gazebo
#RUN curl -sSL http://get.gazebosim.org | sh
#RUN apt-get install ros-$ROS_DISTRO-gazebo-ros-pkgs ros-$ROS_DISTRO-ros-control

WORKDIR /root/bluerov2_ws/src

RUN git clone https://github.com/freefloating-gazebo/freefloating_gazebo.git
RUN git clone https://github.com/patrickelectric/bluerov_ros_playground.git
WORKDIR /root/bluerov2_ws
RUN rosdep install -y --from-paths . --ignore-src

#RUN source /opt/ros/$ROS_DISTRO/setup.bash
#RUN catkin_make
RUN /bin/bash -c ". /opt/ros/$ROS_DISTRO/setup.bash; catkin_make"

RUN echo "source /opt/ros-$ROS_DISTRO/setup.bash" > ~/.bashrc
RUN echo "source /root/bluerov2_ws/devel/setup.bash" > ~/.bashrc

## Set up Ardupilot
#WORKDIR /root
#RUN git clone https://github.com/ArduPilot/ardupilot.git
#WORKDIR /root/ardupilot
#RUN git submodule update --init --recursive
#RUN Tools/environment_install/install-prereqs-ubuntu.sh -y


