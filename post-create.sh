#!/bin/bash
set -e

echo "--- Running post-create.sh ---"

# Define paths
PX4_AUTOPILOT_DIR="${HOME}/PX4-Autopilot"
ROS2_PX4_WS="${HOME}/ros2_px4_ws"
ROS_DISTRO=${ROS_DISTRO:-humble}

# 1. Clone PX4-Autopilot (if not already present)
if [ ! -d "${PX4_AUTOPILOT_DIR}" ]; then
    echo "Cloning PX4-Autopilot..."
    git clone https://github.com/PX4/PX4-Autopilot.git "${PX4_AUTOPILOT_DIR}" --recursive
    cd "${PX4_AUTOPILOT_DIR}"
    bash ./Tools/setup/ubuntu.sh --no-sim-tools --no-system-wide
    echo "PX4-Autopilot cloned and setup script run."
else
    echo "PX4-Autopilot already exists. Skipping clone."
fi

# 2. Set up ROS 2 Workspace for PX4 communication
mkdir -p "${ROS2_PX4_WS}/src"
cd "${ROS2_PX4_WS}/src"

if [ ! -d "px4_msgs" ]; then
    echo "Cloning px4_msgs..."
    git clone https://github.com/PX4/px4_msgs.git
else
    echo "px4_msgs already exists. Skipping clone."
fi

if [ ! -d "px4_ros_com" ]; then
    echo "Cloning px4_ros_com..."
    git clone https://github.com/PX4/px4_ros_com.git
else
    echo "px4_ros_com already exists. Skipping clone."
fi

echo "Building ROS 2 workspace..."
cd "${ROS2_PX4_WS}"
source "/opt/ros/${ROS_DISTRO}/setup.bash"
colcon build --symlink-install

echo "Sourcing ROS 2 workspace..."
source "install/local_setup.bash"

echo "--- post-create.sh finished ---"
