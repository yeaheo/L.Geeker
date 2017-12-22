# Install Erlang and Elixir in CentOS 7
- In this tutorial, we will be discussing about how to install Erlang and Elixir in CentOS 7 minimal server. Before installing them, let us see a brief explanation of each.

## **About Erlang**
- **Erlang** is an open source programming language used to build massively scalable soft real-time systems with requirements on high availability. Some of its uses are in telecoms, banking, e-commerce, computer telephony and instant messaging. Erlang’s runtime system has built-in support for concurrency, distribution and fault tolerance. It is designed at the Ericsson Computer Science Laboratory.

## **About Elixir**
- **Elixir** is a dynamic, functional language designed for building scalable and maintainable applications. Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.

- Now, let us start to install Erlang and Elixir in CentOS 7 64bit minimal server.

## **Prerequisites**
- Before installing Erlang and Elixir, we need to install the following prerequisites.
  ``` bash
  yum update -y
  yum install epel-release -y
  yum install gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf git wget wxBase.x86_64
  ```
## **Install Erlang**
- The Erlang version in the official repositories might be older. So, let us download and install the latest Erlang version.
- Add Erlang official repository to install the latest Erlang.
- To do so, head over to the [Erlang repository page](https://packages.erlang-solutions.com/erlang/), and download the repository depending upon the distribution you use:
- Since, we are installing Erlang in CentOS 7, I am going to add the following repository.
  ``` bash
  cd /opt/soft
  wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
  rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
  yum makecache
  yum install erlang -y
  ```
- That’s it. The latest Erlang version has been installed.
- **Download speed is limited by bandwidth**

## **Verify Erlang**
- Run the following command to verify whether Erlang is installed or not.
  ``` bash
  erl   # 一般有这个命令表示安装完成
  ```
## **Install Elixir**
- Elixir is available in EPEL repository, but it is very outdated. So, in order to install latest version, we will compile and install it from source file.
- Please be mindful that before installing Elixir, you must install Erlang first.
- Git clone to the Elixir repository:
  ``` bash
  cd /usr/local
  git clone https://github.com/elixir-lang/elixir.git
  ```
- The above command will clone the latest version to a folder called elixir in the current working directory.
- Our intsall path is `/usr/local/elixir`

- Install elixir
  ```bash
  cd /usr/local/elixir/
  make clean test
  ```
- Now, It is highly recommended to add Elixir’s bin path to your PATH environment variable. Otherwise, Elixir will not work.
- To do so, run the following command:
  ``` bash
  export PATH="$PATH:/usr/local/elixir/bin"
  ```
- Here, I have installed elixir on `/usr/local/elixir/` location. You must replace this path with your actual Elixir installation path.

## **Verify Elixir**
- Run the following command to verify whether Elixir is installed or not.
  ``` bash
  iex  # 一般有这个命令表示安装完成
  ```
- To check Elixir’s version:
  ``` bash
  [root@lv-test-node elixir]# elixir --version
  Erlang/OTP 20 [erts-9.1] [source] [64-bit] [smp:1:1] [ds:1:1:10] [async-threads:10] [hipe] [kernel-poll:false]
  
  Elixir 1.6.0-dev (9941745) (compiled with OTP 20)
  ```
- That’s it. We have now successfully setup working Erlang and Elixir development environment in CentOS 7 server.

