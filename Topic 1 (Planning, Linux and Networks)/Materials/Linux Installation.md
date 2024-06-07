 # Linux Installation

Installing Linux natively on your machine allows you to interact directly with your own hardware (unlike VMs) and is generally faster and more convenient to work with.

- You can also use Linux from a live USB, or install it alongside windows with WSL.

## General Steps

1. Download ISO image for your distro of choice.

   > Recommended distro: [Kubuntu](https://kubuntu.org/) ([Ubuntu](https://ubuntu.com/download/desktop)), [Kali](https://www.kali.org/get-kali/#kali-installer-images)

2. Burn the image to a Flash drive (Min: 4GB).

   > Recommended tools: [Rufus](https://rufus.ie/downloads/) (Windows only), [Etcher](https://www.balena.io/etcher/), [UNetbootin](https://unetbootin.github.io/)

3. Free a continuous segment on your disk (Min: 25GB of SSD/HDD storage).

   > Recommended tools: `diskmgmt.msc`, [EPM](https://www.easeus.com/partition-manager/epm-free.html), [Gparted](https://gparted.org/download.php) (Linux).

4. Restart your machine to boot into the installation media.

   > Hint: look for prompts or try hotkeys (Esc, Delete, F2, F9, F12, ...) to find the booting screen.

5. Follow the official installation guide ([Kubuntu](https://userbase.kde.org/Kubuntu/Installation), [Ubuntu](https://ubuntu.com/tutorials/install-ubuntu-desktop#5-installation-setup), [Kali](https://www.kali.org/docs/installation/hard-disk-install/)).

   > - To ensure your data is not lost, always select the custom option when choosing the installation location.
   > - The custom option is called `Something else` in Ubuntu installation, and `Manual` in Kali and Kubuntu installation.
   >
   > - Look for the the space you reserved earlier (an unallocated portion of a certain size), use it as `ext4` file system, and mount the filesystem root (`/`) there.
   > - You may skip creating a swap space now, it can be done later after installation.

## Dual boot

- When you install Linux alongside Windows, you want the GRand Unified Bootloader (GRUB) to take over Windows Boot Manager since the latter cannot detect Linux installations.
- This behavior typically happens by default. Check [this](https://unix.stackexchange.com/questions/374349/pc-boots-straight-into-windows-10-instead-of-launching-grub) answer if it's not the case for you.
- GRUB should detect all Linux and Windows installations on your machine and allow you to choose the system to boot into. Check [this](https://askubuntu.com/questions/197868/grub-does-not-detect-windows) answer if it's not the case for you.

## [Desktop Environment (DE)](https://en.wikipedia.org/wiki/Desktop_environment)

- A Linux distribution is independent from the desktop environment (GUI) used by it.
- Common desktop environments include [KDE Plasma](https://kde.org/plasma-desktop/), [GNOME](https://www.gnome.org/), and [XFCE](https://www.xfce.org/).
- Ubuntu uses GNOME by default, Kali lets you choose during installation.
- You can install multiple DEs on the same OS. A Display Manager (e.g., `lightdm`, `sddm`) allows you to switch between them from the lock screen.

## Software

- Ubuntu and Kali are based on Debian. Software for Debian is packaged as `deb` files and created using `dpkg` utility.

- Package managers (e.g., `apt`, `snap`, `flatpak`, `conda`, `pip`, `npm`) are used to manage software installation, dependencies, and updates on your system.

- In Linux, it's harder to keep track of what's installed on your system. Randomly installing packages that you may not use from different sources can clutter your system and fill disk space quickly.

- Containerization and Sandboxing technologies allow isolating apps from each others and the OS they run on, they can also be removed easily and leave no trace.

- Popular technologies and stores for Linux software: Flatpak ([Flathub](https://flathub.org/home)), Snap ([Snapcraft](https://snapcraft.io/store)), and AppImage ([AppImageHub](https://appimage.github.io/apps/)).

- Here is an example for how to setup flatpak then install Telegram Desktop.

  ```bash
  sudo apt update
  sudo apt install flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  
  flatpak install flathub org.telegram.desktop
  ```

## Recommended Tutorials

- https://ryanstutorials.net/linuxtutorial/
- https://www.youtube.com/playlist?list=PLTZYG7bZ1u6q6Vmq-WYItKfEZ9Drfl0XZ
- 

