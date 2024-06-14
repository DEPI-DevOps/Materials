# Topic 4 (Continuous Integration)

> Digital Egypt Pioneers Initiative - DevOps Track

Continuous integration (CI) is the practice of integrating source code changes frequently and ensuring that the integrated codebase is in a workable state.

Typically, developers merge changes to an integration branch, and an automated system builds and tests the software system. Often, the automated process runs on each commit or runs on a schedule such as once a day.

[TOC]

## Example CI/CD Pipeline

![CI/CD for AKS apps with GitHub Actions and GitFlow - Azure Example  Scenarios | Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/guide/aks/media/ci-cd-gitops-github-actions-aks-pull.png)

## YAML

YAML is a human-readable data serialization language.

- It is commonly used for configuration files and in applications where data are being stored or transmitted.

- YAML is used in many DevOps-related tools and technologies, including docker-compose, Ansible, Kubernetes manifests, Prometheus config, and Helm charts.

Example config written in XML, JSON, and YAML

![XML, JSON and YAML » cyberfella ltd, since 2012.](https://www.cyberfella.co.uk/wp-content/uploads/2020/04/xml-json-yaml-1024x273.png)

### Sample YAML config

> Official Spec: https://yaml.org/spec/1.2.2/

```yaml
---
object:
  key1: string-value
  key2: 1234
  key3: 1.2
  key4: true

list-1:
- item1
- item2

list-2:
  - member_key_1: "Hello world!\n"
  - member_key_2: off

list-3: [ 1, 'test', 1.1, no ]

list-4:
  - member_obj:
      key: value

lengthy_string: >
  The final string will have the endline character
  replaced with a single space.
  Check https://yaml-multiline.info for more info

config.ini: |
  [Config]
  Important: yes
  Description=Preserves line separations

---

# Define a named configuration with an alias (&)
server_config: &base_config
  host: my-server.com
  tls: true

# Use the alias (*) to reference the configuration in multiple places
web_server:
  <<: *base_config
  port: 443

database_server:
  <<: *base_config
  port: 5432
```



## GitHub Actions

![Using the visualization graph - GitHub Docs](https://docs.github.com/assets/cb-63715/images/help/actions/workflow-graph.png)

**GitHub actions** is a tool for automating developer workflows. Common workflows include:

- CI/CD pipeline to automate some application-related process (e.g., lint, build, test, scan, deploy, ...).
- Running custom automation when certain GitHub events (e.g., related to issues and pull requests) occur.

### Syntax

> Examples: https://docs.github.com/en/actions/examples

- A **workflow** (described as a YAML file) defines **jobs** that are triggered by some events (e.g., pushing to the remote repository).
- A job is described by a sequence of **steps** and **runs on** dedicated GitHub **runner** (**windows**/**ubuntu**/**macOS**).
- Jobs run in parallel unless they **need** other jobs as dependencies.
- A job can **run** scripts or **use** 3rd-party actions written by GitHub actions team or the community ([marketplace](https://github.com/marketplace?type=actions)).

### Demo

Follow up with `actions-demo` to see GitHub actions *in action*.

### Best Practices

- Use an IDE plugin for help with syntax highlighting and linting of YAML files
- Keep actions minimal and don’t install unnecessary dependencies.
- Use GitHub secrets when working with credentials or tokens.
- Refer to [GitHub actions’ default environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables) when working with the **runner** file system.
- With DockerHub, it’s more secure to use a generated-token with only the necessary permissions instead of using the password.
- Optimize workflow running time by [caching dependencies](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows).

### Recommendations

- You may use a tool like [act](https://github.com/nektos/act) to run your actions locally rather than having to commit/push every time you want to test out the changes you are making to your `.github/workflows/` files 
- For complex workflows, develop and test your action in a separate branch and merge with main once finished. 



## Jenkins

![Introducing Blue Ocean: a new user experience for Jenkins](https://www.jenkins.io/images/post-images/blueocean/pipeline-run.png)

**Jenkins** is a dedicated build automation tool that is very popular. 

- The service with a web UI can be installed natively on a server, or as a docker container.
- Inside the server or the container, the tools needed for build has to be installed (e.g., docker, maven, npm, etc.)
- A job (project) has to be created (with the specific build stages), and a trigger is configured to automate job execution

### Demo

Follow up with `jenkins_demo` to see jenkins in action.

### Syntax

> Examples: https://www.jenkins.io/doc/pipeline/examples/

- A `Jenkinsfile` (typically declarative but can also use groovy script) is used to create a Jenkins **pipeline** which consists of **stages** (e.g., build, test and deploy).
- Each stage runs a sequence of **steps**, stages can be configured to run in **parallel** and a **post** stage can be configured to run after certain stages or steps are done (**always**, on **success**, or **failure**).
- Jenkins can utilize default or custom **environment** variables, can integrate with git repositories, can run stages conditionally based on **parameters** and **expressions**, and has several **plugins** for extending its functionality and integration with other tools.
- Jenkins server can be deployed as a container that exposes a web UI for configuration and checking build status.

### Best Practices

- **Use an IDE plugin** for help with syntax highlighting and linting of `Jenkinsfile`.
- **When running Jenkins as a docker container**
  - Use the official and maintained image for Jenkins.
    - [Official Image](https://hub.docker.com/r/jenkins/jenkins) at the time of writing this.
    - Alpine-based images introduce issues with the NodeJS plugin at the time of writing this.
  - Use `Dockerfile` and `docker-compose.yaml` for Jenkins deployment instead of running a long, undocumented command in the terminal.
  - Pay attention to the base OS and the user under which the container is running since:
    - Using `sh` in `Jenkinsfile` runs commands under that user and that base OS.
    - Running docker commands (e.g., `docker push`) from Jenkinsfile can be problematic when Jenkins itself is running as a docker container [[solution](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)].
- **Use maintained plugins instead of shell scripts for:**
  - Setting up tools, environment and dependencies (it makes build faster and more portable).
  - Working with credentials for Jenkins and 3rd party integrations (it’s more secure and organized).
- **In production environments:**
  - Create users and configure access controls for them, not everyone should have access to the admin credentials.
  - Set up distributed builds as building on the built-in node can be a security issue.

## Task

- Write GitHub actions for your Python web application that runs when modification to the app logic (.py files) are pushed to the main branch
  - The action should run linter/tester on your source code
  - Once tests pass, the action should build the docker container for the app and push the latest version to docker hub.
    - If the commit is tagged, publish a corresponding docker image with the given tag.
- [Extra] Run a security scan in CI on the built container using a tool like Snyk or SonarQube.



## Recommended Tutorials

- GitHub Actions: https://youtu.be/R8_veQiYBjI
- GitLab CI/CD: https://youtu.be/qP8kir2GUgo?si=EaGDVwVf-UMdimfy
- Jenkins: https://www.youtube.com/playlist?list=PLy7NrYWoggjw_LIiDK1LXdNN82uYuuuiC
