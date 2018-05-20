## Docker-Install
- 本次安装的 docker 客户端是 CE 版本(g)
- 具体安装教程参考<https://docs.docker.com/glossary/?term=installation>

### Uninstall old versions
- 卸载可参考如下:
  
  ```bash
  yum remove docker docker-common docker-selinux docker-engine
  ```

### Install using the repository
- Install required packages. yum-utils provides the yum-config-manager utility, and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.
  
  ```bash
  yum install -y yum-utils device-mapper-persistent-data lvm2
  ```

- Use the following command to set up the stable repository. You always need the stable repository, even if you want to install builds from the edge or testing repositories as well.
  
  ```bash
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  ```

- Optional: Enable the edge and testing repositories. These repositories are included in the docker.repo file above but are disabled by default. You can enable them alongside the stable repository.
  
  ```bash
  yum-config-manager --enable docker-ce-edge
  yum-config-manager --enable docker-ce-testing
  ```

- You can disable the edge or testing repository by running the yum-config-manager command with the `--disable` flag. To re-enable it, use the `--enable` flag. The following command disables the edge repository.
  
  ```bash
  yum-config-manager --disable docker-ce-edge
  ```

### INSTALL DOCKER CE
- Update the yum package index.
  
  ```bash
  yum -y install docker-ce
  ```
- Install the latest version of Docker CE, or go to the next step to install a specific version.
  
  ```bash
  yum -y install docker-ce
  ```

- On production systems, you should install a specific version of Docker CE instead of always using the latest. List the available versions. This example uses the sort -r command to sort the results by version number, highest to lowest, and is truncated.
  
  ```bash
  yum list docker-ce.x86_64  --showduplicates | sort -r
  ```

  ```bash
  # yum list docker-ce.x86_64  --showduplicates | sort -r
  Loading mirror speeds from cached hostfile
  docker-ce.x86_64            17.06.0.ce-1.el7.centos            docker-ce-stable 
  docker-ce.x86_64            17.06.0.ce-1.el7.centos            @docker-ce-stable
  docker-ce.x86_64            17.03.2.ce-1.el7.centos            docker-ce-stable 
  docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable 
  docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable 
  ```

- The contents of the list depend upon which repositories are enabled, and will be specific to your version of CentOS (indicated by the .el7 suffix on the version, in this example). Choose a specific version to install. The second column is the version string. The third column is the repository name, which indicates which repository the package is from and by extension its stability level. To install a specific version, append the version string to the package name and separate them by a hyphen (-):
  
  ```bash
  yum install docker-ce-<VERSION>
  ```
- Start Docker.
  
  ```bash
  systemctl start docker
  ```
- Enable Docker service
  
  ```bash 
  systemctl enable docker
  ```

- Verify that docker is installed correctly by running the hello-world image.
  
  ```bash
  docker run hello-world
  ```
- This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

- Docker CE is installed and running. You need to use sudo to run Docker commands. Continue to Linux postinstall to allow non-privileged users to run Docker commands and for other optional configuration steps.

