# Linux Networking Exercises

> Follow up with these guided tutorials to refresh your Linux networking skills

[TOC]

## Exercise 1 - Local Network

- Open a terminal and run this command

  ```bash
  nc -lvnp 1234
  ```

  > As usual, do not settle for running the command, read about netcat tool and understand the [flags used](https://explainshell.com/explain?cmd=nc+-lvnp).

- Split your terminal and run

  ```bash
  telnet localhost 1234
  ```

- Write some stuff in one of the terminals and check the other one.

- Congrats, you have established a bidirectional communication channel over your local network on port 1234.

- Open up a terminal and run this command to check which processes are using port 1234. Understand the output.

  ```bash
  lsof -i :1234
  ```

- Run this command to monitor the traffic on the local interface and show human-readable decoded payload. You may use [Wireshark](https://www.wireshark.org/download.html) as well for a graphical feature-rich tool.

  ```bash
  tcpdump -ilo -X
  ```

- Send another message between the first two terminals and check the messages exchanged in tcpdump.

- The only thing stopping you now from communicating with any server is learning to speak their languages (i.e., protocols used).

## Exercise 2 - HTTP

- Open up a terminal and run

  ```bash
  while true; do echo -e "HTTP/1.1 200 OK\n\n<h1>Hello, World</h1>" | nc -l -k -p 8080 -q 1; done
  ```

- Open a browser and navigate to http://localhost:8080

- Now you have the smallest possible HTTP server running on your machine.

- Open another terminal and run:

  ```bash
  curl http://localhost:8080
  ```

  > **curl** is  a  tool for transferring data from or to a server. It supports many protocols, including HTTP and HTTPS

- This is what a real request might look like, captured with [Burp suite](https://portswigger.net/burp/communitydownload)

  ![](https://i.imgur.com/3m7Kh2v.png)

- Download an image over the internet

  ```bash
  wget https://http.cat/404
  ```

- Open the image (e.g., `gwenview 404` or from the GUI)

- **Extra challenge:**

  - Create an account on https://news.ycombinator.com/login (beware of nerds)
  - Using the terminal or an HTTP client (e.g., Insomnia, Postman, or Burp Suite), perform an HTTP POST request that logs into your account.
    - You may need to capture the login request using a network sniffer like Wireshark, then repeat it.

## Exercise 3 - SSH

- Install an SSH server on your machine

  ```bash
  sudo apt install openssh-server # or using your package manager
  ```

- Check the status of the installed service

  ```bash
  sudo systemctl status ssh
  ```

- Figure out your IP address using one of these commands

  ```bash
  ip address show # or `ip a` for short
  ifconfig        # requires net-tools to be installed, shows a more human-readable out
  hostname -I     # shows all addresses on all interfaces without much details (e.g., for usage in scripts)
  ```

- Open another device connected to the same network as your machine (e.g., same Wi-Fi access point)

  - You can use another laptop or PC (with Windows/Linux/MacOS installed) and open the terminal on that machine
  - You can even use your mobile device with a terminal app (e.g., Termux for Android, Termius for iOS)

- Using the terminal on the other device, run the ping command to check reachability. Understand the output.

  ```bash
  ping <your-ip-address>
  ```

- Using the terminal on the other device, run

  ```bash
  ssh <your-username>@<your-ip-address>
  ```

- Enter the password and you have a remote shell.

- **Important notes:**

  - It's recommended to setup `ssh` with [PKI](https://en.wikipedia.org/wiki/Public_key_infrastructure) authentication instead of password authentication, research [how to do that](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server).
  - Stop and disable SSH service using `systemctl` when you no longer need it.  

- Secure copy (`scp`) is another tool that uses SSH to transfer files over SSH.

- SSH File system (`sshfs`) allows you to easily access remote files over the network. There is [a windows port](https://github.com/winfsp/sshfs-win) available as well.

  - **Example usage:** `sudo sshfs -o allow_other <hostname>@<ip>:<remote-directory> <local-mount-directory>`
  - An alternative option is to deploy a [Web file browser](https://github.com/filebrowser/filebrowser) on the machine you want to remotely access.

- **Extra challenge**: try using SSH over a point-to-point network.

  - Connect your machine to another one directly using an Ethernet cable.
  - Use the commands similar to `ip addr add 10.0.0.1/24 dev eth0`  and ``ip addr add 10.0.0.2/24 dev eth0``, or the GUI (networks settings on your machine) to configure manual IP addresses for the hosts.
  - Establish SSH over that Ethernet cable.

## Exercise 4 - DNS

- Open up the terminal and run a nameserver lookup to get the IP address of the first website

  ```bash
  nslookup info.cern.ch
  ```

- Get more technical details using the `dig` command. 

- To clear local DNS cache. You may also need to research specific steps to clear browser DNS cache.

  ```
  systemd-resolve --flush-caches
  ```

- Inspect the involved DNS requests/responses in Wireshark/tcpdump and answer the following questions:

  - What is the IP address of the local DNS server?
  - What are the record types for the DNS request and response(s) involved?

- Do a reverse lookup (PTR) using the same address you obtained from the first step? Did you get the same URL as a result? Why or why not?

  ```
  nslookup <the-ip-you-got>
  ```

- Check the routing path to that IP using traceroute.

  ```
  traceroute <ip>
  ```

- Get more information about the domain name from [WHOIS ](https://www.nic.ch/whois/) database and more information about the IP using [Shodan.io](https://shodan.io/) database.

- Read about `/etc/resolv.conf` and `etc/hosts`

- **Extra reading**

  > Many people deploy and configure a DNS server in their local network, typically to implement network-level domain blocking (including ads and custom black/white lists). Such setup results in a faster internet speed and better browsing experience since DNS requests to such servers are blocked even before they leave the network, freeing your bandwidth for relevant data only. Moreover, such solutions can not be detected by JS adblocker detectors and are generally more difficult to bypass. Check [pi-hole.net](https://pi-hole.net/) for a quick-setup option or [BIND9](https://www.isc.org/bind/) for a highly configurable option.

## Exercise 5 - Firewalls

- Discover host machines on your network using nmap ICMP ping sweep

  ```
  nmap -sn <your-ip>/<subnet_mask>
  ```

- Machines were discoverable because they allow ping traffic. Try pinging your host

  ```
  ping 127.0.0.1
  ```

- Add a firewall rule to block outgoing ping traffic

  ```
  iptables -I INPUT -p icmp --icmp-type 8 -j REJECT
  ```

  > **Command Explanation:**
  >
  > - `-I INPUT` is equivalent to `-I INPUT 1` which will insert the rule into the beginning of the INPUT chain.
  > - `-p icmp` matches ICMP protocol (the ones used by ping requests).
  > - `--icmp-type 8` an extension that allows matching a specific type of ICMP requests, in this case, type 8 is the Echo (ping) request.
  > - `-j REJECT` specifies the action to take when rule matches, which is to reject the packet (same as DROP, but sends a reject response to the sender).

- List rules with `iptables -L`

- Try pinging again, you should see a "destination port unreachable" error.

  - If we used a DROP action instead of REJECT, ping messages will not be responded to.

- Add another rule for the `OUTPUT` chain instead of `INPUT` and try pinging again

  - You should see an "operation not permitted" error when trying to send an echo (ping) reply.

- Delete the rules by using `-D` flag instead of `-I` flag.

- **Note:** you may find the uncomplicated firewall (`ufw`) installed as well. It has commands to `enable`/`disable` and `allow`, `deny`, or `reject` traffic.

- **Extra:** Research how to implement IP forwarding using iptables.

## Exercise 6 - VPN

- Download Wireguard for Linux platform from https://www.wireguard.com/install/.

- Obtain a configuration file that contains keys for connecting to a VPN server.

  > Free temporary configs are available at [OpenTunnel](https://opentunnel.net/wireguard/), [FreeVPN](https://freevpn.us/wireguard/) and similar websites.

- Example client config may look like this. Check the [quickstart](https://www.wireguard.com/quickstart/) page to understand more about VPN tunnel configuration.

  ```bash
  [Interface]
  PrivateKey = <Key>
  Address = 10.7.0.143/32
  DNS = 1.1.1.1, 1.0.0.1
  
  [Peer]
  PublicKey = <Key>
  AllowedIPs = 0.0.0.0/0
  Endpoint = google.com.wg-fr-1.optnl.com:51820
  ```

- Follow along with these commands

  ```bash
  # Install required packages using the package manager for your distro
  sudo apt install wireguard resolvconf curl
  
  # Assign yourself as the owner of /etc/wireguard directory
  sudo chown $USER /etc/wireguard
  
  # Create the server configuration file using your favorite text editor
  nano /etc/wireguard/wg0.conf
  
  # Activate the VPN connection
  sudo wg-quick up wg0
  
  # Verify that your public IP has changed
  curl ifconfig.me
  
  # Deactivate the VPN connection
  sudo wg-quick down wg0
  ```

- **Extra:** research how to configure Wireguard VPN server.

## Exercise 7 - Extra Commands

- Show active network connections using netstat

  ```bash
  $ netstat -an
  Proto Recv-Q Send-Q Local Address           Foreign Address         State
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
  ```

- Display ARP cache (IP to MAC saved conversions)

  ```bash
  $ arp -a
  ? (192.168.1.1) at 00:11:22:33:44:55 [ether] on eth0
  ```

- View IP routing table

  ```bash
  $ route -n
  Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
  0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0
  ```

- Dump socket statistics

  ```bash
  $ ss -tuln
  State      Recv-Q Send-Q Local Address:Port               Peer Address:Port              
  LISTEN     0      128           *:22                       *:*                  
  LISTEN     0      128          :::80                      :::*     
  ```

- Configure network using [`netplan`](https://netplan.readthedocs.io/en/stable/)

  ```yaml
  $ nano /etc/netplan/01-network-manager-all.yaml
  
  # See example configs
  # https://github.com/canonical/netplan/tree/main/examples
  
  $ netplan try    # to test changes
  $ netplan apply  # to apply changes
  ```

  
