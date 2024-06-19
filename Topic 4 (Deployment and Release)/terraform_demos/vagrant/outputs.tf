output "ssh_ports" {
  value = [
    for id in range(length(vagrant_vm.vagrantbox.machine_names)) :
    format("%s : %d", vagrant_vm.vagrantbox.machine_names[id], vagrant_vm.vagrantbox.ports[id][0].host)
  ]
}
