# ubuntu_20_docker_base
Base Dockerfile and scripts for Ubuntu Focal containers

# Simplest

1. Clone this repository.

    ```bash
    cd /home/me
    git clone https://github.com/mfschmidt/ubuntu_20_docker_base.git
    cd ubuntu_20_docker_base
    ```

2. Replace code/run.py with your own code.

3. Build your container.

    docker build . -t mytag:myversion

4. Run your container.

    mkdir data
    docker run -v /home/me/ubuntu_20_docker_base/data:/data mytag:myversion

# To run as yourself and avoid the root-owned output files

1. Do the same 1, 2, 3 from above.

2. Run as yourself (or any other user who should own docker-written files)

    mkdir data
    docker run -v /home/me/ubuntu_20_docker_base/data:/data mytag:myversion -u $(id -u) -g $(id -g) -n $(id -nu)

Only -u is required to change the user. If -g is not provided, it will assume the same gid as the uid provided. Ubuntu doesn't care about the name as permissions are handled by numeric ID, but if you are running code that determines the name and reports on it, this can be useful.

