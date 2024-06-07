# Networks Survival Pack

> Refresh your theoretical knowledge in Computer Networks, focusing on topics relevant to a DevOps Engineer.

[TOC]

## TCP/IP Model

The TCP/IP model is a conceptual framework used for understanding internet protocols. It consists of five layers:

1. **Application Layer**: Handles high-level protocols like HTTP, FTP, and SMTP.

2. **Transport Layer**: Manages end-to-end communication and includes protocols like TCP and UDP.

3. **Internet Layer**: Handles IP addressing, routing, and packet forwarding.

4. **Link Layer**: Manages physical connections and includes protocols like Ethernet and Wi-Fi.

5. **Physical Layer**: Concerned with transmitting raw data bits over a physical medium.

   ![](https://i.imgur.com/6DWNq7h.png)

## Application Layer

### HTTP (Hypertext Transfer Protocol)

The Hyper-Text Transfer Protocol (HTTP) is an application layer protocol used for retrieving internet resources such as HTML web pages, images, and other media. Web pages consist of objects (HTML files, images, audio, etc.)

- The base HTML-file references all other objects.

- Each object is addressable by a URI. A Uniform Resource Identifier (URI) provides a simple and extensible way to identify any
  resource on World Wide Web using a unique sequence of characters.

- URI Example:

  ![](https://i.imgur.com/8E30SEX.png)

- More URI examples:
  - ldap://[2001:db8::7]/c=GB?objectClass?one
  - mailto:John.Doe@example.com
  - news:comp.infosystems.www.servers.unix
  - tel:+1-816-555-1212
  - telnet://192.0.2.16:80/
  - urn:oasis:names:specification:docbook:dtd:xml:4.1.2

**How browsing works:**

- User asks for a specific website (types its URL in the browser address bar).
- DNS protocol converts the domain name to the IP address of the website web server
- Client (browser) initiates a TCP connection (creates socket) with the web server at port 80.
- Server accepts TCP connection from client (responds with acknowledgement).
- Client sends an HTTP request to the web server, requesting a web page, the server sends back a response with the requested data.
  - The first request requests the base HTML file, after which the referenced files are requested.
  - HTTP is stateless (i.e., information about previous sessions is not stored).
  - HTTP versions: HTTP/0.9, HTTP/1.0, HTTP/1.1, HTTP/2.0, HTTP/3.0
- Client and server keep exchanging HTTP messages through the TCP connection.
- TCP connection is closed.

**HTTP Request/Response Structure**

![](https://i.imgur.com/4mOASJL.png)

**Common HTTP commands and response codes: **

![](https://i.imgur.com/37iwvTs.png)

**Web Cookies:**

- Small pieces of data stored on the user’s computer by a browser while browsing a website.
- Designed to make websites remember stateful information about the user, by storing the session-id (in webserver DB) at the first time the user enters a website. This id is then included in subsequent HTTP requests by the browser, which makes the server “remember” the user.
- Usages
  - Session management: Shopping carts (online stores) - Session state (whether the user is logged in).
  - Personalization: Authorization (remember me checkbox) - Memorizing user preferences.
  - Tracking: Track user activity and use it for recommendation ads or (sometimes) malicious purposes.

**Web Caching**

- Used to satisfy user requests quickly without involving user origin server, which reduces server lag/traffic and reduces response time for client requests.
- Frequently requested resources can be cached (in a proxy server for example) for quick retrieval.
- Web proxy server acts as an intermediary between a client and a server, it sends HTTP requests on behalf of the client, simplifying/controlling the process and potentially masking the request origin (less used today).
- Proxy is a general term for any intermediate server that communicates with other servers on behalf of a client, the concept is not bound to a specific implementation.

### DNS (Domain Name System)

DNS: a global naming system for computers, services, and other internet resources

- DNS database: a large distributed database storing resource records
- DNS protocol (port 53/udp): defines how the data in DNS database is stored and queried
- DNS server (name server): stores DNS records for the zone of authority
- DNS client (resolver): queries DNS servers for records
- DNS services:
  - Hostname to IP address resolution (translation)
  - Host aliasing (multiple names resolving to the same address)
  - Load distribution (same name resolving to multiple addresses)

- DNS is a globally distributed database with information about different network resources, stored as Resource Records (RRs)

  - **RR syntax:** `<NAME>, <CLASS>, <TYPE>, <TTL>, <RD Length>, <RDATA>`, some fields can be omitted, example `google.com IN A 216.239.38.120` (IN for Internet records)

- **DNS structure**
  - **DNS server = Name server:**
    - Storing RRs (e.g., Google 8.8.8.8, CloudFlare 1.1.1.1)
    - Answers queries from client (e.g., hostname to IP address), caches answers for performance, and communicates with other name servers to keep DNS data synchronized.
    - **Authoritative DNS server** has the latest, trustworthy records for a specific resource it's responsible for.
      - There can be one **master (primary)** authoritative server that propagate changes to many authoritative **slaves (secondary servers)**.
      - Or the RRs can be **distributed** among authoritative servers.
    - **Non-authoritative DNS server** <u>forwards</u> requests to authoritative servers, it may <u>cache</u> records to provide (non-authoritative) answers quickly later.
    - **A recursive DNS server** - when queried - will keep asking other servers -  possibly gets redirected - and returns the final results to the querier.
    - **A non-recursive DNS server** - when queried - will either provide the results directly to the querier, or will redirect him to another server to ask.
      - Non-recursive DNS servers should not be used in `resolv.conf` (see below) as they can simply answer "unknown" and it will be accepted.
  - **DNS client = resolver:** client side of the DNS, responsible for initiating and sequencing the appropriate queries to the name server, leading to the full hostname to IP translation.
    - DNS daemon at client communicates with DNS server through port 53, it uses udp for requests and tcp for zone transfer.

- **Questions:**
- **What DNS servers to use?**
    - Each host joining a network is provided (statically or through DHCP) with the IP address of a primary and secondary DNS server (if the primary fails).
  - Prioritized list of DNS nameservers to use is stored at `/etc/resolv.conf`
    
  - **How to use the DNS servers?**
  - The application requesting DNS will communicate with the recursive DNS resolver (through a stub resolver) which will query the DNS server and returns results.
  - **DNS tools**
      - `host`, `dig` ,`nslookup` are used for performing DNS lookups (hostnames to IP addresses)
      - `dig` is preferred for debugging (it has more options and output is a raw record), while `host` and `nslookup` are more user-friendly. 
      - Examples: `host example.com 8.8.8.8`. `dig @8.8.8.8 example.com in A`, `nslookup example.com`
    - `/etc/resolv.conf`
      - Nameservers under the file can be modified directly, although not recommended.
      - A `search <suffix>` entry can be added to the `resolv.conf`; Then, if the DNS can't resolve some request like `ping <host>`, it will try `ping <host><suffix>`
      - This is helpful if the LAN environment has it's own DNS server (e.g., querying `university` will automatically resolve to `university.innopolis.ru` if there is an entry `search innopolis.ru` in `resolv.conf`)
      - For changes to take effect, the DNS server should be restarted (e.g., `sudo service bind9 restart`)
  
  - **When to use DNS servers?**
  - For translation between hostnames and IP address, host/mail server aliasing, or load distribution.
  - [`/etc/nsswitch.conf`](https://en.wikipedia.org/wiki/Name_Service_Switch)
      - A file used by C and other applications to decide where to get **name-service information** (from which database/file, or whether to query DNS/NIS/LDAP) and in which order.
        - **Directory/name service** maps names of network resources to their respective network addresses (like a phonebook)
        - In other words, it tells the system to look for X in [Y] where
          - **X can be** a specific user/group name/password, hostname, network, protocol, service, etc. 
          - **Y may include (in any order):** local database, OS files, DNS, LDAP (check below), NIS with rules on what to do if the resource was not found.
      - **Example:** `hosts: dns [!NOTFOUND=return] files ` will try DNS lookup first to get RRs from hostnames, if not found, it will check files (e.g., `/etc/hosts`) 
  
  - **When to use /etc/hosts?**
- Hosts file stores (IP, hostname) pairs that <u>override</u> the ones provided by the DNS (unless configured otherwise in `/etc/nsswitch.conf`)

### SSL/TLS (Secure Sockets Layer/Transport Layer Security)

Protocols that provide secure communications over a computer network. They encrypt the data transmitted between clients and servers, ensuring confidentiality and integrity.

**Explanation in a form of Problem/Solution**

- **Problem #1**: Communication between client and server cannot happen in plaintext.

  - Intruder can see (eavesdrop), modify (intercept), or add its own messages to the connection (inject).

- **Solution #1:** use a <u>[symmetric key algorithm](https://en.wikipedia.org/wiki/Symmetric-key_algorithm)</u> to encrypt and decrypt data.

  - Think of the algorithm as two functions, everyone knows their implementation details.
    - `encrypt(plaintext, key) = ciphertext`
    - `decrypt(ciphertext, key) = plaintext`
  - **Block cipher** means that plaintext is firstly split into blocks of a certain length before encryption, in contrast with **stream ciphers**, that encrypt or decrypt one byte at a time.
  - Keys are just a sequence of bits, there are standards (**AES, DES)** for generating keys of different lengths.

- **Problem #2:** how can client and server know about the same key securely?

  - Key cannot be just sent through the network, since again it can be eavesdropped and used by intruders.

- **Solution #2: **use [asymmetric key algorithm](https://en.wikipedia.org/wiki/Public-key_cryptography) to share the symmetric key securely.

  - Think of the algorithm as two functions, everyone knows their implementation details.

    - `encrypt(plaintext, publicKey) = ciphertext`
    - `decrypt(ciphertext, privateKey) = plaintext`

  - **publicKey** and **privateKey**
    - A pair of keys of a certain length generated by a certain algorithm (e.g, RSA-4096)
    - A message encrypted with one of them **can only be decrypted** with the other, therefore, the following is also true:
      - `encrypt(plaintext, privateKey) = ciphertext`
      - `decrypt(ciphertext, publicKey) = plaintext`
    - The convention is that, public key can be shared with everyone (send on the network), while private key (identity) should not be shared with anyone at all.
    
  - **How it works:**
    1. Server has generated a pair of keys `publicKey`, `privateKey`
    2. Server sends `publicKey` to whoever wants to communicate with it (i.e., client)
    
    3. Client generates a symmetric key `k`
    4. Client sends `encrypt(k, publicKey)` to the server
    5. Only server can do `k = decrypt(k, privateKey)`
    6. Client and server then use `k` to communicate securely.
  
- **Problem #3**: intruder can act as a fake server

  - Intruder can send its own public key and communicate with client exactly as if it's the server.
  - Client can never know that the public key it received indeed belongs to the server.

- **Solution #3:** use digital certificates

  - A digital certificate is file with some attributes and values.
  - It proves that a certain entity owns a certain public key.
  - It's Issued by a certain Certification Authority (CA) that also has `CA_publicKey` that is shared with everyone and `CA_privateKey` that is only known by them.
  - **How it works:**
    - Server sends its `publicKey` to the client along with the `certificate` that verifies that it owns the public key.
      - `certificate = encrypt(publicKey, CA_privateKey)`
    - Everyone knows `CA_publicKey`, client can then verify
      - `publicKey == decrypt(certificate, CA_publicKey)`
      - If mismatch happened, server is fake.
      - Otherwise, client can use server's public key safely.

- **Problem #4:** how can the client knows that `CA_publicKey` indeed belongs to the CA?

  - There is no single CA in the world, there are many, intruder can claim to be a CA and fake all this process acting as the server.

- **Solution #4:** root CAs.

  - For a CA to be trusted, it should sign (encrypt) its public key using the private key of another higher-authority CA.

  - A client OS or web browser trusts only a certain number of hard-coded root CAs. 

    > As of 24 August 2020, 147 root certificates, representing 52 organizations, are trusted in the Mozilla Firefox web browser, 168 root certificates, representing 60 organizations, are trusted by macOS, and 255 root certificates, representing 101 organizations, are trusted by Microsoft Windows.

  - A client follows this chain of trust verification until it finds a root CA that it trusts by default, or produces an error saying that the user that the server certificate couldn't be trusted.

  - Root CAs are self-signed, meaning that the verification will always be true:

    - `root_ca_cert = encrypt(root_ca_public_key, root_ca_private_key)`

- **[Let's Encrypt](https://letsencrypt.org/how-it-works/)**

  - A nonprofit Certificate Authority providing TLS certificates to 260 million websites.
  - The objective is to make it possible to set up an HTTPS server and have it automatically obtain a browser-trusted certificate, without any human intervention. This is accomplished by running a certificate management agent on the web server.
  - First, the agent proves to the CA that the web server controls a domain. Then, the agent can request, renew, and revoke certificates for that domain.


### SSH (Secure Shell)

- A cryptographic network protocol used for secure communication between networked devices.
- It provides a secure channel over an unsecured network.
- SSH operates on port 22/tcp and uses TLS for security.
- The Secure Copy Protocol (SCP) uses SSH to transfer files between machines.

### DHCP (Dynamic Host Configuration Protocol)

A network management protocol used to automatically assign IP addresses and other network configuration parameters to devices on a network.

![](https://i.imgur.com/MpINoz7.png)

- DHCP is an application-layer protocol (port 67/UDP)
- DHCP assigns an IP addresses and other configuration information (e.g., subnet mask, gateway address, DNS server address, time server address) to hosts that recently joined/rejoined the network. It operates in 4 steps (DORA Process)
  - Discover: client probing DHCP servers
  - Offer: server proposing an address
  - Request: client asking to get a certain address
  - ACK: server acknowledging the assignment
- DHCP Implementation
  - DHCP logic can be implemented in routers or as a dedicated server
    - ISC DHCP server is a popular DHCP server implementation in Linux
    - A DHCP client (e.g., dhcpcd or dhclient) is typically shipped with the OS
  - DHCP address assignment strategy can be automatic, dynamic, or manual
    - Automatic: client gets a permanent address from a preconfigured pool
    - Dynamic: client gets an address with a lease from a preconfigured pool
    - Manual: administrator configures a table matching IPs to MAC addresses

### NAT (Network Address Translation)

A method of remapping one IP address space into another by modifying network address information in the IP header of packets while they are in transit across a traffic routing device.

![](https://i.imgur.com/1MHkJEE.png)

- NAT is a service implemented in routers that:
  - Helps compensate the lack of public IPv4 addresses by allowing multiple hosts in the same LAN to share a common public identity
  - Provides basic host security by hiding the source IP and port from the public
- The most common type of NAT is Port Address Translation (PAT)
  - A PAT-enabled gateway router modifies (translates) the private source IP addresses and port number for outgoing traffic to the router’s public IP and a certain port number
  - Address mapping is saved in the router’s NAT table to translate the address back for
    incoming (response) traffic
- **Issues with NAT**
  - NAT was designed as a temporary solution until the full adoption of IPv6
  - NAT hides the host identity, leading to the following issues:
    - Unsolicited connection to the host is not easy to establish (e.g., for P2P or VoIP)
    - The host can not easily run a publicly-accessible service
    - The exact source of a network attack is more difficult to identify and block
  - NAT traversal techniques overcome some of these issues. Such techniques include
  - NAT hole punching and the use of Universal Plug and Play Protocol (UPnP) to ask the Internet-facing router to forward packets destined to a certain port to the host

### VPN (Virtual Private Network)

A network technology that creates a secure connection over a public network such as the Internet. It allows users to securely access a private network and share data remotely through public networks.

- Virtual Private Networks allow communication between hosts over the internet as if they were in the same physical network, it accomplishes this by encrypting traffic by means of IPSec protocol suite or SSL/TLS.
- Site-to-Site VPN: Virtually connects two trusted networks, this is typically used to connect worldwide sites belonging to the same organization or establish a Virtual Private Cloud (VPC).
- Host-to-site (remote access) VPN: Allows a certain host to connect to a corporate network as if they were physically
  located in the corporate.
  - This achieved by installing a VPN client application (e.g., OpenVPN) that requests a VPN connection from the listening corporate VPN server.
  - After the VPN connection is established and the encryption parameters are agreed on, all (or some of) the traffic generated by the host are encrypted between the host and the corporate, after which the corporate may forward or block requests and send back encrypted responses
- Popular VPN Protocol and Client/Server: [Wireguard](https://www.wireguard.com/).

### Proxy

- Proxy is a general term for anything (e.g., server, host, or application) that acts as an intermediary between two parties.
- Proxy server is a server application that acts as an intermediary between a client requesting a resource and the server providing that resource, it allows clients to make indirect network connections to other network services
- Open proxy is a proxy server that is accessible by anyone on the internet, it forwards traffic and can cache webpages for faster retrieval.
- Reverse proxy appears to clients as a normal server, it forwards client requests to one or more ordinary servers (e.g., company's internal servers) to handle the client requests.
- This is typically used as the frontend server that may perform SSL/TLS negotiations, load balancing, serving static contents, compression, etc. and then relay requests to backend servers.
- Proxies do not perform encryption by definition, unlike VPNs.
- Popular Load Balancer, Web Server, & Reverse Proxy: [Nginx](https://www.nginx.com/)

## Transport Layer

### Transport Layer Services

- The transport layer is responsible for directing network traffic to the destination process running on a host and listening on a certain port

  - The protocol data unit (a data packet) in the transport layer is called a segment
  - Port: a 16-bit number representing an entrypoint to a process
  - System ports (0-1023):
    - Used by well-known services such as HTTP, FTP, DNS, and Email protocols
    - Require superuser privileges to be bound to processes
  - Registered ports (1024-49151): assigned by IANA to services that requested them
  - Dynamic ports (49152-65535): available for temporary and private usages

- **UNIX/POSIX/Berkley Sockets:** a software structure identifying a connection between two process using the tuple (src IP, dst IP, src port, dst port, protocol).

- Recall the difference between a socket and a port.

  ![](https://i.imgur.com/vdOPthj.png)

### User Datagram Protocol (UDP)

A connectionless protocol that provides a faster but less reliable transmission of data. It is suitable for applications that can tolerate some packet loss, such as real-time audio and video streaming.

- UDP is a transport-layer protocol for sending messages over an IP network
- UDP is connectionless, unreliable, and does not implement error recovery
- UDP segments are known as datagrams
- UDP is suitable for time-sensitive applications that prefer speed over reliability.
  - Examples include media streaming, video conferencing, and online gaming
- UDP uses checksums to verify data integrity
  - Checksum is the one’s complement sum of the packet data + metadata
  - Sender calculates checksum and sends it along with the data for the receiver to verify the data integrity and discard invalid packets

### TCP (Transmission Control Protocol)

TCP transports logically-related segments between processes as a stream of data.

- TCP guarantees data to arrive in-order, without errors, and without duplicates.ip

- TCP is connection-oriented, reliable, and implements error detection and correction.

- TCP connection is established using a 3-way handshake (SYN, SYN/ACK, ACK).

- TCP is suitable for applications that require reliability. Examples include file transfer,
  database transactions, and email delivery

- TCP flow control ensures that a fast sender does not overwhelm a slow receiver

- TCP congestion control ensures that the network will not be overwhelmed by data

- TCP uses multiple mechanisms to build a reliable data channel on top of IP since IP packets may be delayed, dropped, or delivered with bit-errors. Such mechanisms include:
  - **Acknowledgement (ACK)** signals a received intact packet
  - **Negative Acknowledgement (NAK)** signals a received erroneous packet
  - **Sequence numbers** are used to ensure packet ordering and avoid duplication
  - **Timeout and retransmission** are used to recover from packet loss

## Network Layer

The network layer functionality is divided into two planes: **data** and **control**

- The data plane is where the Internet Protocol (IP) is used to relay data
- The control plane is where routing and control protocols operate
  - **Control protocols** include: ICMP, IGMP
  - **Routing protocols** include: OSPF, BGP, RIP, IS-IS, EIGRP

### Router

- A router is a networking hardware responsible for **forwarding** and **routing**
  - **Forwarding** is a router-local action, in which the router processor examines its local forwarding table to choose the output link to redirect an incoming packet
  - **Routing** is a network-wide process, in which routing algorithms (running in every router) exchange routing information according to a routing protocol.
    - This information allows each router to build its own forwarding table
- **Router architecture:** input links, output links, router CPU, switching fabric.
- **Routing table entry:** `<route_type> <destination_net> via <next_hop> <interface>`
  - Common route types: **L**ocal, **C**onnected, **S**tatic, **R**IP, **O**SPF, **B**GP.

### Internet Control Message Protocol (ICMP)

- Used for communicating error or operational messages over IP
- Common ICMP messages and related Linux CLI tools:
  - ICMP echo request/reply (`ping`)
  - ICMP error message: time exceeded (`traceroute`)
  - ICMP timestamp request/reply (`hping3`)
  - ICMP router solicitation/advertisement (`icmpush`)

### Internet Protocol

- IP is the network layer protocol used by the Internet for transferring data packets between hosts across network boundaries
  - **Public IP addresses** are globally reachable (e.g., servers)
  - **Private IP addresses** are used for local communication within a LAN

- Hosts and network-aware devices (e.g., routers) may have one or more physical network interfaces (e.g., an Ethernet NIC and a Wi-Fi adapter)
- A virtual network interface is an OS abstraction that allows a host to interact with its physical interfaces. One or more IP addresses can be attached to a virtual interface
- IPv4 is the dominant version of IP. IPv6 is being slowly adopted since 2006
- Public IP addresses are globally reachable, while private addresses are used for local communication within a LAN. Servers typically have public IPs and clients don’t
- IPv4 is the dominant version of IP. IPv6 is being slowly adopted since 2006
  - **IPv4:** 32-bit addresses, dotted-decimal notation (`0.0.0.0`)
    - **Private IPv4 ranges:** 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
    - **Special IPv4 ranges:** 0.0.0.0/8, 127.0.0.0/8, 169.254.0.0/16
  - **IPv6:** 128-bit addresses, hex notation (`0000:0000:0000:0000:0000:0000:0000:0000`)

### Classless Inter-Domain Routing (CIDR)

- Classful addressing divided IP address ranges into classes from A to E
  - Classes A-C (unicast) provided large address spaces of 224, 216, and 28, respectively
  - Such organization made it difficult to construct small networks

- Classless addressing gives more flexibility through variable-length subnet masks
  - Subnet mask is a binary string of multiple consecutive ones followed by zeros
  - It divides an IP address into network prefix and host identifier as follows:
    - IP address & subnet mask = network prefix (bitwise “AND”)
    - IP address | subnet mask = host identifier (bitwise “OR”)

- CIDR implements routing based on the longest match of network prefix

### Subnetting

- Logically dividing a network into smaller networks for easier management, better performance and security, and to conserve addresses.

  - Example IP address and subnet mask in CIDR notation: 10.0.0.0/24
    - Network address is 10.0.0.0 and broadcast address is 10.0.0.255
    - Number of usable hosts is 254 (ranging from 10.0.0.1 to 10.0.0.254)
    - Such network can be divided into two subnets

  - 10.0.0.0/25 (from 0 to 127) and 10.0.0.128/25 (from 128 to 255)
    - Private IPv4 ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
    - Special IPv4 ranges: 0.0.0.0/8, 127.0.0.0/8 (loopback), 169.254.0.0/16 (link-local)

- Subnet mask is a binary string of `N` consecutive 1's followed by 0's

  - **CIDR (prefix) notation:** `IP/N`
  - Variable-length subnet masks (used by classless addressing) allows flexible subnetting

- **IPv4 subnetting algorithm (pseudo-code)**

  ```python
  ip = 'x.x.x.x'
  
  describe_net(ip, N):
      """Calculates interesting values about a network"""
      mask = N * '1' + (32 - N) * '0'
      wildcard_mask = !mask
      net_addr = binary(ip) & mask
      host_id = binary(ip) & wildcard_mask
      broadcast_addr = net_addr | wildcard_mask
      hosts_count = 2 ** (32 - N) - 2
      gateway_addr = net_addr + 1 # can be broadcast_addr-1
  
  split_net(ip, N):
      """Splits a network into two subnets"""
      N += 1
      new_mask = N * '1' + (32 - N) * '0'
      subnet_1 = binary(ip).update(N, '0') & new_mask
      subnet_2 = binary(ip).update(N, '1') & new_mask
  ```

## Link Layer

Link layer is concerned with the delivery of frames between nodes sharing a transmission medium

- **Ethernet** is the dominant family of standards for wired computer networks
- Link layer functionality is divided into two sublayers (lower and upper)
  - **Media Access Control (MAC)** is responsible for controlling access to the transmission medium
  - **Logical Link Control (LLC)** acts as the interface between network-layer protocols and MAC
- **Network Interface Card/Controller (NIC)** is the hardware that enables node networking
  - **MAC address:** a unique hardware address (4-bytes) assigned to an NIC by its vendor
- **Multiple access protocols** (channel access methods) operate in the MAC sublayer, they define the communication rules for nodes sharing a medium to avoid interference and collisions
  - **Examples:** (FDMA, TDMA, CDMA) - (ALOHA, CSMA/CA) - (Polling, Token-passing)

### Layer-2 Ethernet switch

- A link-layer device used for forwarding frames between devices directly connected to it
- **Self-learning behavior:**
  - Examine sender MAC and add it to the switching table if needed
  - Examine destination MAC and selectively forward the frame to the device having that MAC
  - If destination MAC is not in the table, forward to all interfaces except sender (flooding)
- Switches divide collision domains while routers divide broadcast domains
  - **Collision domain:** a group of hosts sharing the same physical medium (packets may collide)
  - **Broadcast domain:** a group of hosts sharing the same flooding (broadcast) channel

### Virtual Local Area Network (VLAN)

- VLAN splits one physical network into two isolated virtual networks
- It works by logically grouping switch ports into separate broadcast domains
- A switch port can be in `access` or `trunk` mode.
  - **Access mode:** the port is directly connected to a host
  - **Trunk mode:** the port is directly connected to another switch

### Address Resolution Protocol (ARP)

- Hosts in the same subnet broadcast ARP requests asking for the MAC address for a given IPv4 address.
- ARP responses are cache in the host OS for further communication.
- When communicating with the outer networks, hosts use ARP to identify the MAC address at the gateway router interface.
