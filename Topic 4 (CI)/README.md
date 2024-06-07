# Topic 4 (Continuous Integration)

## GitHub Actions

- A **workflow** (described as a YAML file) defines **jobs** that are triggered by some events (e.g., pushing to the remote repository).
- A job is described by a sequence of **steps** and **runs on** dedicated GitHub **runner** (**windows**/**ubuntu**/**macOS**).
- Jobs run in parallel unless they **need** other jobs as dependencies.
- A job can **run** scripts, **use** 3rd-party actions written by GitHub actions team or the community ([marketplace](https://github.com/marketplace?type=actions)).



## Jenkins

- A `Jenkinsfile` (typically declarative but can also use groovy script) is used to create a Jenkins **pipeline** which consists of **stages** (e.g., build, test and deploy).
- Each stage runs a sequence of **steps**, stages can be configured to run in **parallel** and a **post** stage can be configured to run after certain stages or steps are done (**always**, on **success**, or **failure**).
- Jenkins can utilize default or custom **environment** variables, can integrate with git repositories, can run stages conditionally based on **parameters** and **expressions**, and has several **plugins** for extending its functionality and integration with other tools.
- Jenkins server can be deployed as a container that exposes a web UI for configuration and checking build status.



## Task

- Write GitHub actions for your Python web application that runs when modification to the app logic (.py files) are pushed to the main branch
  - The action should run linter on source code and fail if the code is not formatted
  - It should also run autotests that you wrote earlier
  - Once tests pass, the action should build the docker container for the app and push the latest version to docker hub.
    - If the commit is tagged, publish a corresponding docker image with the given tag.
- [Extra] Run a security scan in CI on the built container using a tool like Snyk or SonarQube.



## Recommended Tutorials

- GitHub Actions: https://youtu.be/R8_veQiYBjI?si=5IL49Arwp0K5riq1
- Jenkins: https://www.youtube.com/playlist?list=PLy7NrYWoggjw_LIiDK1LXdNN82uYuuuiC
- GitLab CI/CD: https://youtu.be/qP8kir2GUgo?si=EaGDVwVf-UMdimfy
