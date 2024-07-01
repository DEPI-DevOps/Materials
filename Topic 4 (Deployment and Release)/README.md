# Topic 4 (Deployment and Release)

> Digital Egypt Pioneers Initiative - DevOps Track

DevOps culture promotes continuous SDLC practices (i.e., continuous development, testing, integration, delivery, deployment, ...).

- Due to the field being relatively new and rapidly emerging, different sources may use the same *buzzword* with different intended meanings. Standardization efforts are ongoing.

[TOC]

## Buzzwords (Theory)

Whenever a software artifact becomes in a stable state, decisions to *deploy* and *release* the artifact may be taken. DevOps practitioners try to make this process as smooth as possible by means of automation, CI/CD pipelines, infrastructure as code, configuration management, and related practices.

### Deployment vs. Release

Some sources refer to deployment as **"the loading of code onto the servers where it will run"** and release to mean **"the availability of code changes to users"**.

> Typical DevOps Cycle diagrams show "release" before "deploy" in the sense of "marking stable code as a release in VCS before deploying it".

An interesting analogy:

- **Deployment:** Delivering the product to the store and setting it up on the shelves (backend process).
- **Release:** Announcing the product launch to the public, making it available for purchase (user-facing event)

### CI/CD

**Continuous integration (CI)** is the practice of integrating source code changes frequently and ensuring that the integrated codebase is in a workable state.

> Typically, developers merge changes to an integration branch, and an automated system builds and tests the software system. Often, the automated process runs on each commit or runs on a schedule such as once a day.

**Continuous deployment** (**CD**) is a software engineering approach in which software functionalities are delivered frequently and through automated deployments.

> Continuous deployment contrasts with **continuous delivery** (also abbreviated CD), a similar approach in which software functionalities are also frequently delivered and deemed to be potentially capable of being deployed, but are actually not deployed. As such, continuous deployment can be viewed as a more complete form of automation than continuous delivery

**Example CI/CD Pipeline**

![CI/CD for AKS apps with GitHub Actions and GitFlow - Azure Example  Scenarios | Microsoft Learn](https://learn.microsoft.com/en-us/azure/architecture/guide/aks/media/ci-cd-gitops-github-actions-aks-pull.png)



### XaaS (Anything as a Service)

XaaS commonly refer to larger corporations providing smaller IT organizations with their needs (software, platform, infrastructure, ...) as paid services.

- Before XaaS and cloud services, companies had to buy their own hardware and software products and manage everything related to that (e.g., installation, configuration, maintenance, security, etc.).

  ![img](https://miro.medium.com/v2/resize:fit:828/format:webp/1*WwZcDYUVvEVUXAUzO4Volw.jpeg)

### X as Code (Anything as Code)

XaC is the trend that involves representing something other than application logic (e.g., VM/container infrastructure, configuration files, access policies, CI/CD or data pipelines) as code, with the goal of making it easier to create, maintain, and deploy.

> **GitOps** commonly refer to the practice of version-controlling that code

The most popular term is **Infrastructure as Code (IaC)**, which refers to the use of definition files (sometimes referred to as manifests) to **provision** application infrastructure.

![Infrastructure as code: What is it? Why is it important? - Next2IT](https://next2it.co.uk/wp-content/uploads/2020/09/infrastructure-as-code.png)

### Configuration Management

Configuration management is about establishing and maintaining consistency between a product state (current configuration) with an expected state (required configuration).

> Example:
>
> - **Current state:** an infrastructure (one or more networked servers) is provisioned.
> - **Expected state:** certain tools and dependencies are installed on these servers and the application executes on them with certain arguments.

## Technologies (Practice)

### YAML

YAML is a human-readable data serialization language.

- It is commonly used for configuration files and in applications where data are being stored or transmitted.

- YAML is used in many DevOps-related tools and technologies, including docker-compose, Ansible, Kubernetes manifests, Prometheus config, and Helm charts.

Example config written in XML, JSON, and YAML

![XML, JSON and YAML » cyberfella ltd, since 2012.](https://www.cyberfella.co.uk/wp-content/uploads/2020/04/xml-json-yaml-1024x273.png)

#### Sample YAML config

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

### GitHub Actions

![Using the visualization graph - GitHub Docs](https://docs.github.com/assets/cb-63715/images/help/actions/workflow-graph.png)

**GitHub actions** is a tool for automating developer workflows. Common workflows include:

- CI/CD pipeline to automate some application-related process (e.g., lint, build, test, scan, deploy, ...).
- Running custom automation when certain GitHub events (e.g., related to issues and pull requests) occur.

#### Overview

> Examples: https://docs.github.com/en/actions/examples

- A **workflow** (described as a YAML file) defines **jobs** that are triggered by some events (e.g., pushing to the remote repository).
- A job is described by a sequence of **steps** and **runs on** dedicated GitHub **runner** (**windows**/**ubuntu**/**macOS**).
- Jobs run in parallel unless they **need** other jobs as dependencies.
- A job can **run** scripts or **use** 3rd-party actions written by GitHub actions team or the community ([marketplace](https://github.com/marketplace?type=actions)).

#### Demo

Follow up with `actions_demo` to see GitHub actions *in action*.

#### Best Practices

- Use an IDE plugin for help with syntax highlighting and linting of YAML files
- Keep actions minimal and don’t install unnecessary dependencies.
- Use GitHub secrets when working with credentials or tokens.
- Refer to [GitHub actions’ default environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables) when working with the **runner** file system.
- With DockerHub, it’s more secure to use a generated-token with only the necessary permissions instead of using the password.
- Optimize workflow running time by [caching dependencies](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows).

- You may want to use a tool like [act](https://github.com/nektos/act) to run your actions locally rather than having to commit/push every time you want to test out the changes you are making to your `.github/workflows/` files 
- For complex workflows, develop and test your action in a separate branch and merge with main once finished. 

### Jenkins

![Introducing Blue Ocean: a new user experience for Jenkins](https://www.jenkins.io/images/post-images/blueocean/pipeline-run.png)

**Jenkins** is a dedicated build automation tool that is very popular. 

- The service with a web UI can be installed natively on a server, or as a docker container.
- Inside the server or the container, the tools needed for build has to be installed (e.g., docker, maven, npm, etc.)
- A job (project) has to be created (with the specific build stages), and a trigger is configured to automate job execution

#### Overview

> Examples: https://www.jenkins.io/doc/pipeline/examples/

- A `Jenkinsfile` (typically declarative but can also use groovy script) is used to create a Jenkins **pipeline** which consists of **stages** (e.g., build, test and deploy).
- Each stage runs a sequence of **steps**, stages can be configured to run in **parallel** and a **post** stage can be configured to run after certain stages or steps are done (**always**, on **success**, or **failure**).
- Jenkins can utilize default or custom **environment** variables, can integrate with git repositories, can run stages conditionally based on **parameters** and **expressions**, and has several **plugins** for extending its functionality and integration with other tools.
- Jenkins server can be deployed as a container that exposes a web UI for configuration and checking build status.

#### Demo

Follow up with `jenkins_demos` to see Jenkins in action.

#### Best Practices

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

### Ansible

![DevOps 101 : Introduction to Ansible - DEV Community](https://res.cloudinary.com/practicaldev/image/fetch/s--nW-BXXE7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/npb90i8qo6yknbw4mpxv.png)

Ansible is an open source IT automation engine that automates provisioning, configuration management, application deployment, orchestration, and many other IT processes.

#### Overview

- A **playbook** (written in YAML) defines one or more **plays** that will be executed on one or more remote machines (selected from **inventory**) through an SSH connection (no agent required).
- A **play** has a **name** (optional), **vars** (optional), target **hosts** (selected by **patterns**), a **remote_user** (e.g., root), one or more **tasks** to execute, and (optionally) one or more **handlers** to be **notified** to run when the play changes machine **state**.
- A task executes a [named] **module** (**[built-in](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html)** or [**3rd-party**](https://galaxy.ansible.com/)) against remote machines (default execution **strategy** is sequential).
- An **inventory** (YAML/INI file) contains [named groups of] IP addresses or hostnames of remote machines, it can also store **variables**.
- Ansible collects **return codes** from executed tasks, **facts** about remote machines and **magic variables** storing internal state.
- **Role:** the standard way to group related Ansible artifacts (vars, files, tasks, etc.) to share them so they can be loaded and reused.

#### Demo

Check `ansible_demos` directory to see Ansible in action.

#### Best Practices

- [Documentation Reference](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

- A module should be responsible for one small simple task.

- Use the recommended [directory structure](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-directory-structure) for roles.

- Use `ansible-playbook --check` to check actions before taking them (not all modules support this).

  - Or try changes on staging environment first.

- Give tasks meaningful names, separate them with empty lines for readability, use comments for extra explanation.

- Use `ansible-lint` to lint playbooks.

- Use dynamic inventory when working with cloud hosts to avoid manual IP/hostname configurations.

- Use `state` to specify the desired module state so that modules won’t execute twice unless needed.

### Terraform

![What is Terraform | Terraform | HashiCorp Developer](https://developer.hashicorp.com/_next/image?url=https%3A%2F%2Fcontent.hashicorp.com%2Fapi%2Fassets%3Fproduct%3Dterraform%26version%3Drefs%252Fheads%252Fv1.8%26asset%3Dwebsite%252Fimg%252Fdocs%252Fintro-terraform-apis.png%26width%3D2048%26height%3D644&w=3840&q=75)

Terraform is an infrastructure as code tool that enables you to safely and predictably provision and manage infrastructure in any cloud.

#### Overview

The core Terraform workflow consists of 3 stages:

1. **Write:** represent infrastructure as [HCL declarative code](https://www.terraform.io/language). The syntax is built around two constructs: **arguments** and **blocks** (i.e., line-separated arguments and blocks).
   - HCL supports common programming concepts such as **variables**, **types** (string, numeric), **functions** (built-in), and **expressions**.
   
   - An existing and supported infrastructure can be **import**ed into terraform to start managing it from code.
   
2. **Plan:** terraform creates an execution plan describing actions (e.g., create, modify, or destroy resources) that will be taken based on existing infrastructure **state** (stored in the **backend**) and current **workspace** configuration.

3. **Apply:** interact with the service/platform-specific API through their **providers** (published on [**registry**](https://registry.terraform.io/)) to execute the plan.

   - **Named values** are used for working with API keys or other configurations to allow re-usability and avoid hard-coding.

   - **Modules** are used to group resources that are used together as a reusable package.  

#### Demo

Check `terraform_demos` directory to see Ansible in action.

#### Best Practices

- Use an IDE plugin to help with syntax highlighting and auto completion ([official VSCode plugin](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)).

- Use built-in formatter and validator, check plan before applying changes.

- Sensitive information (state and secret variables) shouldn’t be pushed to the VCS; they can be stored locally and ignored by the VCS, or stored remotely and encrypted at rest ([.gitignore for terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore)).

- Recommended directory structure and file naming for a minimal module:

  ```
  .
  ├── README.md     # module description
  ├── main.tf       # entry point (resource definition)
  ├── variables.tf  # input variables and locals
  ├── outputs.tf    # output variables
  ```

- When using providers (for vagrant or terraform), be sure to pin their versions to ensure reproducibility.



## Tasks

1. Write a GitHub action for your web application (`.github/workflows/action.yml`) that runs when modification to the app logic are pushed to the main branch. The action should run linter/tester on your source code
   - Once tests pass, the action should build the docker container for the app and push the latest version to docker hub.
   - If the commit is tagged, publish a corresponding docker image with the given tag.

2. Write Ansible playbook that uses [Ansible docker module](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html) to run your application as a container (pulled from DockerHub).

   - Execute the playbook against your `localhost` for testing.

   - In the README, include any steps or configuration used to run the playbook.

   - [Bonus] run the playbook against multiple VMs or AWS EC2 instances and include the steps in README.

3. [Extra] Deploy Jenkins server in an EC2 instance and setup GitHub integration with hooks for your application to run linter/tester whenever new code is pushed to the main branch.

   

## Recommended Tutorials

- GitHub Actions: https://youtu.be/R8_veQiYBjI
- GitLab CI/CD: https://youtu.be/qP8kir2GUgo?si=EaGDVwVf-UMdimfy
- Jenkins: https://www.youtube.com/playlist?list=PLy7NrYWoggjw_LIiDK1LXdNN82uYuuuiC
- Ansible: https://www.youtube.com/watch?v=1id6ERvfozo
- Terraform: https://www.youtube.com/watch?v=l5k1ai_GBDE

