FoundationPose with ROS2 using multi-object detection
-----------------------------------------------------

This docker image uses [FoundationPoseROS2](https://github.com/ammar-n-abbas/FoundationPoseROS2) repo to implement multi-object pose detection.

Build
-----
Just do
```
docker build -t fpmulti .
```
It'll take a while.

Usage
-----
The image requires GPU and X access. To run, do
```
docker run --rm --name fpmulti --env NVIDIA_DISABLE_REQUIRE=1 -it --network=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp:/tmp --ipc=host -e DISPLAY=${DISPLAY} -v $HOME/.Xauthority:/root/.Xauthority:rw --gpus=all fpmulti
```
You can put additional models int o `additional_models` directory in OBJ format which will be copied into the container.

Please, modify `config.yaml` before build to ensure the topic names of the color/depth cameras and the camera info topic. For further information, check [FoundationPoseROS2](https://github.com/ammar-n-abbas/FoundationPoseROS2).
