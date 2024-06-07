# Topic 3 (Building and Packaging)

> Digital Egypt Pioneers Initiative - DevOps Track

A DevOps engineer needs to be aware of the software building/packaging processes and tools used by different organizations to deliver their products.

[TOC]

## Building Artifacts

Incremental software development is about the building, packaging, deployment, releasing, and publishing of versioned **Software Artifacts**

- **For desktop development:** artifact can be the binary (executable) file or a bundle (e.g., JAR, ZIP) that is obtained from the source code.
- **For mobile development:** artifact can be the installation package (e.g., APK, IPA)
- **For web development:** artifact can be the source library files after being translated/minified/compressed/obfuscated/...
    - Web applications with all their dependencies are typically provided as a Docker image that can be pulled, tested, and deployed quickly.


## Publishing Artifacts
An artifact is typically published/released to the public for usage after its built. It's generally included in the releases section of a GitHub repository or published on a registry.

**Popular build tools and registries for different technologies:**

| Technology | Build/Package Tool        | Artifact/Package Repository                                  |
| ---------- | ------------------------- | ------------------------------------------------------------ |
| Debian     | `dpkg`                    | [Debian Packages](https://packages.debian.org/index)         |
| Java       | `mvn`, `gradle`, `ant`    | [Maven Repository](https://mvnrepository.com/)               |
| JavaScript | `npm`, `yarn`, `webpack`  | [NPM Registry](https://www.npmjs.com/), [Yarn Packages](https://yarnpkg.com/search) |
| Python     | `pip`, `poetry`           | [PyPI](https://pypi.org/)                                    |
| C/C++      | `cmake`, `ninja`, `conan` | [Conan Center](https://conan.io/center)                      |
| C#         | `nuget.exe`               | [NuGet Gallery](https://www.nuget.org/packages)              |
| Go         | `go build`                | [Go packages](https://pkg.go.dev/)                           |
| Ruby       | `gem`                     | [Ruby Gems](https://rubygems.org/)                           |
| Rust       | `cargo`                   | [Crates.io](https://crates.io/)                              |
| Docker     | `buildx` (`docker build`) | [DockerHub](https://hub.docker.com/)                         |

**Generic artifact repositories** exist to help an organization manage all their artifacts in a single location.

- **Examples include** GitHub packages, Nexus, Jfrog, and cloud providers registries (AWS CodeArtifact, GCP Artifact Registry, Azure Artifacts)

**General steps for publishing and using artifacts:**

1. Create an account on the registry (artifact repository) and obtain access credentials.
2. Configure your build/package tool to connect to one or more registries by supplying credentials through config files or environment variables.
3. Use the push/publish command for your tool (manually or through a CI pipeline)
4. Use the HTTP API or the same build tool to retrieve packages when needed.

## Docker

Docker is the most popular containerization technology. Containerization addresses the problem of *"It works on my machine"* by packaging an **application** with its **environment** as an image.
> Environment includes the OS setup with all the needed tools/packages installed with their specific versions.

![](https://media.geeksforgeeks.org/wp-content/uploads/20221205115118/Architecture-of-Docker.png)

**How it works & common commands:**

- A `Dockerfile` inclues the recipe for building an image: `docker build -t <TAG> .`
- One or more containers are instantiated from a given image: `docker run <TAG>`
- You can check running containers using `docker ps` or use docker extensions for your IDE.
- An image is typically pushed to a container registry (e.g., DockerHub): `docker login`, `docker push`
- Images can then be pulled from the registry for usage: `docker pull`

### Docker Installation

**Recommended way:**

Follow the official installation steps at https://docs.docker.com/desktop/install/linux-install/ to install docker desktop for your distro with latest updates and supplementary tools.

**SysAdmins way**

```bash
# Install docker, buildx, and docker-compose (alert: may not install latest versions)
sudo apt install docker.io docker-compose docker-buildx

# Post installation steps: to run docker without sudo (you may need to restart/relogin for changes to take effect)
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Test installation
docker run hello-world
```

**Hadolint (Dockerfile linter) setup**

```bash
cd /tmp
export RELEASE=$(curl -s https://api.github.com/repos/hadolint/hadolint/releases/latest | jq -r '.tag_name')
wget "https://github.com/hadolint/hadolint/releases/download/$RELEASE/hadolint-Linux-x86_64"
sudo mv hadolint* /usr/local/bin/hadolint
sudo chmod +x /usr/local/bin/hadolint

# usage
hadolint /path/to/Dockerfile
```

### Demo

- Follow along with `docker_demos` to get familiar with docker commands while using it with popular technologies.
- Create dockerfiles for sample `apps` in C++, Java, nodejs, Python, and Go.

### Using docker-compose

- A `docker-compose.yaml` file can help you run multiple containers and connect them in one network.
- This is generally used to run the complete application infrastructure (e.g., web servers, application server, and used databases) in one command.
- The containers are declared as `services` that are instantiated from different images and deployed in a single network whenever the command `docker-compose up` is executed in the same directory
- Services in the same network can communicate with each other using the container names given to them.

## Task

- Follow along with https://play-with-docker.com/
  - Run `docker run -dp 80:80 docker/getting-started:pwd` to get started
  - Log steps taken in a markdown file

- Write a `Dockerfile` for your web apps.
  - [Bonus] Use docker-compose to run your app with an nginx webserver.

- Build and push the image to DockerHub.
- Add build and release instructions to the project README.
- [Extra] Self-host one or more services you're interested in from [Awesome Self-Hosted](https://github.com/awesome-selfhosted/awesome-selfhosted)

### Recommendations

- **Use a Dockerfile linter** (e.g., [hadolint](https://github.com/hadolint/hadolint)) as it helps build best practice Docker images.
- **Use a small base image** that does the job (e.g., alpine-based images) as it will make deployment faster while not taking much space.
- **Copy only the necessary files to the image** to make it smaller and faster, use `.dockerignore` to ignore unnecessary files and directories.
- **Use `EXPOSE`** to denote port-forwarding in your `Dockerfile`.
- **Push the image to a container registry** like DockerHub or the cloud-dedicated container registry for version control of app images and convenient deployment to the cloud.
- **Tag the images** with its version or the corresponding commit id from git to easily understand which version of the code is currently in the registry.

#### For Python apps

- Set environment variable `PYTHONUNBUFFERED` to a non-zero value to see container output from host in real-time.
- Use `--no-cache-dir` flag with `pip install` to prevent caching downloaded packages and make image size smaller.

#### For Node.js apps

- Set environment variable `NODE_ENV` to `production` to configure ExpressJS with production settings.

- Use `npm ci` instead of `npm install` ([see why](https://docs.npmjs.com/cli/v8/commands/npm-ci)).

  

## Recommended Watch

- Docker Crash Course: https://www.youtube.com/watch?v=3c-iBn73dDE
- Docker Networking: https://www.youtube.com/watch?v=OU6xOM0SE4o
- Portainer: https://www.youtube.com/watch?v=ljDI5jykjE8
