# Topic 2 (Development, Testing, and VCS)

> Digital Egypt Pioneers Initiative - DevOps Track

A DevOps engineer needs to be involved in the development process. While your tasks may not involve writing application logic, they will mostly revolve around the product(s) being developed/deployed.

This lab focuses on three essential skills for a DevOps engineer: Automation, Web Development, Testing, and Version Control.

[TOC]

## Automation

Being able to automate routine tasks is the most important skill for a DevOps engineer. Possessing automation skills gets you half-way there as a DevOps Engineer.

### Google Automation Specialization

Google offers a professional track and certification program dedicated to automation with Python. 

> Google IT Automation with Python Specialization: https://www.coursera.org/professional-certificates/google-it-automation

You can enroll or audit the course, the content is also available for free on Google Career Certificates YouTube channel. It's highly recommended to watch at least these courses.

- [Crash Course on Python](https://www.youtube.com/playlist?list=PLTZYG7bZ1u6pqki1CRuW4D4XwsBrRbUpg)
- [Using Python to Interact with the Operating System](https://www.youtube.com/playlist?list=PLTZYG7bZ1u6oJu7Imgx8FTOjyDNwesrm5)
- [Troubleshooting and Debugging Techniques](https://www.youtube.com/playlist?list=PLTZYG7bZ1u6o222uOM1MVDhUyfreEjuAb)

### Example Automation Tasks

Automation tasks may involve writing BASH/Python scripts that interact with the OS directly to

- Do regular data backups / clean-ups
  - Example 1: Write scripts to backup/restore postgres database content to/from a remote server. 
  - Example 2: Implement log rotation for a service that generates daily log files.
- Install and configure software or services on one or more servers
  - Example: Automate the installation of docker and other dependencies on a fleet of machines
- Run scheduled health checks and monitor service/application status
  - Example: Cron job to monitor CPU temperature and report to a web dashboard
- Setup triggers that activate on certain condition and send alerts
  - Example: Send telegram alerts in case CPU usage rises above a certain percentage

On top of scripts, an organization may use a dedicated automation tool (e.g., Apache Airflow) to handle sophisticated custom automation scenarios.

## Web Development

Almost all organization have one or more web application being maintained, therefore web development knowledge is essential.

### Starter pack

1. **An IDE**
- [VSCode](https://code.visualstudio.com/) (most-popular, free, open-source, lightweight)
  
- [JetBrains Products](https://www.jetbrains.com/) (paid IDEs, feature-rich, more resource-intensive)


2. **Basic knowledge in HTMl, CSS, and JavaScript**
   - No need to learn everything, focus on the essentials and fill knowledge gaps as you go through the project.
   
   - Plenty of tutorials online, choose what suits you from written materials (W3Schools, MDN, GeeksForGeeks), to online courses (Udemy, Coursera), to YouTube tutorials (FireShip, WebDevSimplified, ElZero Web School).
   
   - [Roadmaps](https://roadmap.sh/full-stack) can help you decide on what to learn and on which order.
   
3. **Web Framework**
- A framework helps you to quickly build apps without having to reinvent the wheel.
  
- Balance between ease of use and configurability. No-code website builders (e.g., WordPress) tend to be less configurable, hence, not suitable for custom needs.


### Building a Website

#### Frontend

Pure HTML/CSS is not enough to get a modern-looking website. Working with tags and properties can be very time-consuming when you just need to place common webpage items together (e.g., navbar, buttons, sliders, frames, ...).

Your options are:
- [Bootstrap](https://getbootstrap.com/docs/5.3/getting-started/introduction/): a quick and easy-to-learn option to build simple decent-looking UI.
- Sass or TailWind: tools to make working with CSS easier. 
- React, Angular, Vue, Svelte, etc.: professional frontend frameworks used in the industry.

#### Backend

1. **Web Server**

   To share your website with the world, you need a server. A server is a 24/7 running machine that hosts (serves) your website code and files for the public to access.

   - Dedicated software (web server) needs to be installed on such machines (e.g., Apache HTTP Server, Nginx, Trafik).
   - You may not need such software if the backend framework you use includes one that is production-ready.

2. **Backend Framework**

   - A back-end framework lets you write code for handling application logic (authentication, API endpoints, database interaction, and everything else). 

   - You may prefer the framework that uses a programming language you already know and like.

   - Popular options:

     - **JavaScript:** Node.js (with Express/Nest/Meteor/...)
     - **Python:** Flask or Django

     - **C#:** ASP .NET CORE

     - **PHP:** Laravel

     - **Java:** Spring

     - **Ruby:** Ruby on Rails

     - **Rust:** Rocket
     
     - **Go: **Echo

3. **Database**

   - Choosing the database depends on your application logic and functionality. It's generally advised to choose the database that integrates nicely with your chosen backend framework. Popular options include
     - **SQL-based:** SQLite, PostgreSQL, MySQL, MariaDB, SQL Server
     - **Document-based:** MongoDB, FireStore
     - **Key-Value store:** Redis

## Testing

> Reference article: https://www.geeksforgeeks.org/types-software-testing/

- Testing is a huge field in software development, dedicated testers and QA engineers may be part of the organization to help find and fix problems as early as possible during the SDLC.

  ![](https://media.geeksforgeeks.org/wp-content/uploads/20230808151753/Software-Testing-768.png)

- Notable types of manual tests

  - **Unit tests** verify the correctness of a single atomic functionality (unit)
  - **Integrations tests** verify that the component being tested works when integrated with other other components in the environment.
  - **System tests** verify the overall functionality of all components in the system working together.

- Testing is not a single stage in SDLC, it takes different forms during different stages.

  - **Before development:** Test-Driven Development (TDD) is the concept of tests being written before the actual code.
  - **During the development of a feature:** a developer may write a test for each implemented feature and commit both together.
  - **After building: **different types of functional tests (e.g., integration tests) and non-functional tests can be executed against the built artifact.
  - **After releasing: **more tests can be run in a staging environment that is should be synchronized with production.
  - **In production:** log collecting and reporting mechanisms should be in place in case an error was discovered by the application users.  

- A DevOps engineer may

  - Write or modify an existing test as part of automating and optimizing the overall testing process
  - Develop quality gates (e.g., automatic linters, test runners, security scanners) that run as part of the CI/CD process to ensure that non-conforming code does not get merged to the main branch in the first place.

### Testing in practice

- A **testing framework** is typically used by the developers to help write and run their tests. Examples include
  - Pytest for Python
  - Jest for Node.js
  - Standard testing package for Go.
- A **static analyzer (linter)** is used to check (and possibly fix) certain coding/configuration practices (e.g., indentation, variable naming, ordering of certain constructs, usage of single/double quotes, etc.).
  - Pylint, Black, Autopep8 for Python
  - ESLint, Prettier for Node.js
  - golangci-lint for Go
- **Git hooks** may be in place to help the developer do certain actions (e.g., run linter/tester/check commit message) before committing their code.
  - Popular examples include Husky and Pre-commit.
- For web applications. a **UI testing framework** can be used to run different types of pre-configured or random (monkey) testing for the UI.
  - Examples include Selenium and Playwright
- DevSecOps involves implementing different **security-related measures** in all stages of the SDLC.
  - **Static Application Security Testing (SAST):** static code analysis that focuses on security issues and bad coding practices
    - Tools include: SonarQube and Semgrep
  - **Dynamic Application Security Testing (DAST):** tools that interact with the running application to check for security-related issues
    - Tools include: OWASP ZAP and StackHawk
  - **Secret detection**: check for compromised tokens, passwords, API keys, etc. in source code.
    - Tools include: GitLeaks and GitGuardian
  - **Vulnerable dependency scanning:** tools that check for outdated or vulnerable dependencies used by an application.
    - Tools include: GitHub dependabot, Docker Scan, Snyk, NPM Audit, and Grype.
  - **Fuzz testing** involves feeding invalid or malformed input to the application to assess its behavior and error checking mechanisms
  - **Boundary Value Analysis (BVA): **involves feeding extreme (low/high) input data to the application to test for corner cases.
- **Testing in production** 
  - Google Lighthouse: browser-integrated tool to measure the quality of web-pages (measures performance, accessibility, and other metrics)
  - Sentry: collects and reports front-end and performance-related issues of an already-running web application.

## Version Control

Git is a version-control system for tracking changes in source code during software development. It is used by almost all software companies for coordinating work among programmers who are collaboratively working on a shared codebase.
![](https://hackmd.io/_uploads/BJYo-KWzT.png)

### Essential Terminology

- **Repository (repo):** a directory with project's files and their complete version history (hidden `.git` directory).
- **Commit:** a snapshot of project files at a certain point in time.
- **Branch:** a parallel version of the project for independent development.

### Workflow

- Untracked/Unstaged files are files that neither added nor committed to the current repository branch
- Tracked files are files that either added or committed to the current repository branch
- Staged Files are files that were only added (`git add`) to the current repository branch
- Committed Files are files that were added and committed (`git commit`) to the current repository branch
![](https://hackmd.io/_uploads/HylV4YWfp.png)

### Practice

Let's create a git repo. Do some changes, then push the changes to GitHub.
- Download Git: https://git-scm.com/downloads
- Create an account on [GitHub](https://github.com/)

Commands needed:
```bash
git init --initial-branch main
nano README.md # write some markdown
git add -A
git status
git commit -m "Initial commit"
git remote add origin https://github.com/<developer>/<project>.git
git branch -M main
git push -u origin main
```

### Useful resources
- Official documentation with videos, articles, and a book: [link](https://git-scm.com/doc)
- Recommended videos:
  - Git in 100 seconds: https://www.youtube.com/watch?v=ecK3EnyGD8o
  - Beginner tutorial: https://www.youtube.com/watch?v=HkdAHXoRtos
  - Advanced techniques: https://www.youtube.com/watch?v=ecK3EnyGD8o

- Interactive tutorials: https://learngitbranching.js.org/
- Messed Up? Check [ohshitgit.com](ohshitgit.com)

## Task

1. Create a single-page web application in Python to do a simple function. Ideas:

   > Focus on writing a minimal, yet effective code that you fully understand and polish.

   - Web page showing current time or weather condition

   - Text to QR code converter
   - Password generator
   - To-Do-List
   - Implement a UI around a [public API](https://github.com/public-apis/public-apis)

2. Write at least one manual application test (e.g., use `pytest`)

   > A functional test may try to access an HTTP endpoint and assert that expected HTML content is returned
   >
   > A unit test may validate the correctness of a certain function/procedure and report any logical errors

3. Push your code to GitHub. Make sure the repository is public and submit the link [here](https://docs.google.com/spreadsheets/d/1_xe6mEWpQJ8QwOQn1kSGxvwEm-8PnCLW-hENa5NkWl4/edit#gid=0) (use EUI email to have edit access)

   - Try to use branches for feature development / bug fixes.
   - And/or, complete the interactive tutorials at https://learngitbranching.js.org/

4. Report your work (steps taken and best practices followed) in the project README.md

5. [Extra] Create another version of the application using other technologies (e.g., Node.js and Go)

   - Develop different apps in different directories like (`app_python`, `app_nodejs`, and `app_go`)

