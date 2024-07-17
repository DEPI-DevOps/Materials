# Jenkins

- Jenkins native Installation

    > Docs: <https://www.jenkins.io/doc/book/installing/linux>

    ```bash
    # Installing jenkins and dependencies
    sudo apt-get update && sudo apt-get install -y fontconfig openjdk-17-jre
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]"   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update && sudo apt-get install -y jenkins
    
    # Verify installation
    sudo systemctl status jenkins
    
    # Get admin password
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

- Or use the provided compose file

    ```basic
    docker compose up
    ```

- Follow the initialization steps at `http://<JENKINS_HOME>:8080`

## Build prerequisites

To use build tools in Jenkins CI, you may use plugins or install the needed tools on the CI server manually.

### Option 1: Plugins

Lookup the list of plugins at <http://JENKINS-HOME/manage/pluginManager/available> and check if there is a maintained one that works and suits your needs (e.g., a maintained plugin for NodeJS exists at the time of writing)

- Sample Jenkinsfile that uses the NodeJS Plugin

    ```groovy
    pipeline {
        agent any
    
        stages {
            stage('Test') {
                steps {
                    nodejs('node-16.14.0') {
                        sh '''
                        npm ci
                        npm test
                        '''
                    }
                }
            }
        }    
    }
    ```

### Option 2: Manual installation

If a plugin does not exist or is deprecated (e.g., no maintained Python plugin at the time of writing), then you have no option but manually install the needed dependencies in your jenkins agent. You may use scripts to automate the process.

- Exec into the container to install any needed build tools in your server

    ```bash
    docker exec -it --user 0 jenkins /bin/bash
    ```

- BASH script to install Python tools

    ```bash
    apt-get update \
    && apt-get install --no-install-recommends python3 python3-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*
    ```

- Sample Jenkinsfile to run Pytest

    ```groovy
    pipeline {
        agent any
    
        stages {
            stage('Test') {
                steps {
                    sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                    pytest
                    '''
                }
            }
        }    
    }
    ```

## Docker build/push in Dockerized Jenkins

- Running `docker` commands like `build` and `push` inside jenkins (that runs as a docker container) can be tricky. Many approaches are possible.

- A popular recommended approach is to bind-mount the docker socket from host into the container. But then the default `jenkins` user (the one executing pipelines) will not have the necessary permissions to interact with the socket.

- BASH script to install docker CLI (modify version if necessary).
    > The script also installs `sudo` and grants the `jenkins` user a passwordless access to run docker commands. A better approach would be to supply the password with jenkins credentials.

    ```bash
    export DOCKERVERSION=26.1.4
    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
        && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
        && rm docker-${DOCKERVERSION}.tgz \
        && apt-get update \
        && apt-get install --no-install-recommends -y procps sudo \
        && echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
        && rm -rf /var/lib/apt/lists/*
    ```

- You may as well use [Docker HTTP API](https://docs.docker.com/engine/api/latest/) to interact with the socket instead of installing docker CLI.
- Alternatively, the Docker Pipeline ([docker-workflow](https://docs.cloudbees.com/docs/cloudbees-ci/latest/pipelines/docker-workflow)) plugin provides a global `docker` variable that is accessible inside `Jenkinsfile` and can be used to interact with docker from the pipeline.
