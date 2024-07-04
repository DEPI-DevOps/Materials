# ansible_vagrant_demo

## Installation

> Reference: <https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html>

- Ansible is a Python package.

- To get the latest stable and maintained version, you should have Python installed on the control node.

- They recommend using `pipx` to have Ansible CLI tools (`ansible`, `ansible-playbook`, etc.) available globally.

  ```bash
  pipx install --include-deps ansible
  ```

- You may also want to install the plugin for VSCode and `ansible-lint`

  ```bash
  pipx install ansible-lint
  ```

- Install Vagrant: <https://developer.hashicorp.com/vagrant/downloads?product_intent=vagrant>

  > - `Vagrantfile` is used to describe an **environment** (of **VMs/containers** with networking) as **declarative ruby code** that can be used to set **up** the environment, test scripts or configuration management tools (e.g., Chef, Ansible, or Puppet), then **halt** and **destroy** the environment or recreate it on the cloud.
  >
  > - A **box** (pulled from the **[cloud](https://vagrantcloud.com/boxes/search)**) is typically used as the starting point for running ready-to-use environments or as a template for creating custom ones.
  > - **Providers** allow writing `Vagrantfile`s for different types of virtualization systems. Support for **Virtualbox**, **Hyper-V**, and **Docker** works out-of-the-box. Other providers should be installed as **plugins**.

- Install VirtualBox: <https://www.virtualbox.org/wiki/Linux_Downloads>

## Steps

1. Use the commands to interact with the VM environment

   ```bash
   vagrant up       # Start and provision environment
   vagrant halt     # Stop the VMs
   vagrant destroy  # Destroy the environment.
   ```

2. Run the playbook to connect to the VM, install docker, then pull and run an image from DockerHub.

   ``` bash
   ansible-playbook main.yml
   ```

   - `main.yml ` contains the main playbook to be executed.
   - `hosts.ini` contains the inventory (connection parameters to the machines)
   - `ansible.cfg` contains global configuration for Ansible.
   - `roles/` contain the `docker` installation role being used by `main.yml`
