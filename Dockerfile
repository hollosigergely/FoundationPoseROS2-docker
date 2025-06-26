FROM nvidia/cuda:12.4.0-devel-ubuntu22.04
WORKDIR /root

RUN apt update && \
        apt -y install python3-pip curl git wget


# ROS2
RUN apt update && \
        apt -y install software-properties-common

RUN add-apt-repository universe

RUN apt update && \
    export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME 
#"

ENV TZ=Europe/Budapest \
    DEBIAN_FRONTEND=noninteractive

RUN apt install /tmp/ros2-apt-source.deb && \
        apt update && \
        apt -y install ros-humble-desktop \
            ros-humble-librealsense2* \
            ros-humble-realsense2-* \
            python3-colcon-common-extensions && \
        rm -rf /var/lib/apt/lists/*

RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm ~/miniconda3/miniconda.sh

RUN echo ". ~/miniconda3/bin/activate" >> /root/.bashrc
RUN . ~/miniconda3/bin/activate && \
    conda install python=3.10

RUN git clone https://github.com/ammar-n-abbas/FoundationPoseROS2.git
WORKDIR /root/FoundationPoseROS2

# Install dependencies
RUN . ~/miniconda3/bin/activate && \
        pip install torchvision==0.16.0+cu121 torchaudio==2.1.0 torch==2.1.0+cu121 --index-url https://download.pytorch.org/whl/cu121 && \
        pip install "git+https://github.com/facebookresearch/pytorch3d.git@stable"

RUN . ~/miniconda3/bin/activate && \
        python -m pip install -r requirements.txt

# Clone source repository of FoundationPose
RUN git clone https://github.com/NVlabs/FoundationPose.git

# RUN apt-get --purge remove 'nvidia-*' && \
#     apt-get autoremove

# RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" | tee /etc/apt/sources.list.d/focal-security.list
# RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb && \
#     dpkg -i cuda-keyring_1.1-1_all.deb && \
#     apt-get update && \
#     apt-get -y install cuda-12-4 && \
#     rm -rf /var/lib/apt/lists/*

COPY build_all_conda.sh .
#RUN . ~/miniconda3/bin/activate && \
#        conda update --force conda && \
#        conda install -c conda-forge gcc
RUN . ~/miniconda3/bin/activate && \
        bash build_all_conda.sh
