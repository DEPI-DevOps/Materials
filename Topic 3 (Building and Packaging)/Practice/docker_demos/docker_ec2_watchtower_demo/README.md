# docker_ec2_watchtower_demo

1. Create an EC2 Instance (t3.medium, ubuntu image, firewalll allows http from anywhere)

2. Login to the instance and install docker

   ```bash
   sudo apt update && sudo apt install docker.io
   sudo groupadd docker
   sudo usermod -aG docker $USER
   newgrp docker
   # Logout and relogin to the machine
   docker run hello-world # test docker installation
   ```

3. Run an application

   ```bash
   docker run -itd --name app_container -p80:8080 sh3b0/app_python
   ```

4. Check the status of the app on `http://<ec2_public_dns_name>`

5. Common Issue:

   > AppArmor may prevent watchtower from sending a SIGTERM signal to the containers. Either make a configuration for apparmor (at `/etc/apparmor.d/docker`) that allows such capability, or uninstall apparmor if you don't need it.
   >
   > ```bash
   > sudo apt-get purge --auto-remove apparmor
   > ```

6. Run a watchtower that watches the image every 30 seconds. If the image is private, additional volume `-v $HOME/.docker/config.json:/config.json`  can be used to allow watchtower to login and monitor the image.

   ```bash
   docker run -d \
     --name watchtower \
     -v /var/run/docker.sock:/var/run/docker.sock \
     containrrr/watchtower app_container --debug --interval 30
   ```

7. Check watchtower logs

   ```bash
   docker logs -f watchtower
   ```

8. Rebuild and publish the app

   ```bash
   docker build -t sh3b0/app_python .
   docker login
   docker push sh3b0/app_python --all-tags
   ```

9. Recheck the status of the app.

