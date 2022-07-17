# Development Environment for SAE driveless
<br/>
This is a dev-env for testing/developing code for the driveless project in a docker container.<br/>
This container contains:<br/>
    - The SAE simulator<br/>
    - ROS2 Galactic<br/>
    - CUDA enabled OS<br/>
<br/>
##  Intel version
<br/>
This will create a Intel based version container for running the SAE simulator in docker<br/>
<br/>
<br/>
##  Files
<br/>
- build.sh  - builds the docker image<br/>
- run.sh    - starts the simulator<br/>
<br/>
In the container you will find that:<br/>
<br/>
- fsdssim_user is the simulator user<br/>
- fsdssim_user is in sudoers<br/>
- /home/fsdssim_user will contain the simulator files<br/>
- /home/fsdssim_user/FSDS.sh will run the simulator.<br/>
<br/>
<br/>
##  Run in Visual Studio Code<br/>
<br/>
It is possible to use this container as a dev enviroment by opening it in VSCode with the remote containers extension<br/>
"ms-vscode-remote.remote-containers"<br/>
<br/>
Just open SAE-cuda/ and chose "reopen in container".<br/>
<br/>
Please check the .devcontainer/devcontainer.json  file<br/>


