#!/bin/bash

clear
menu() {
  read -p "CONFIRM INSTALLATION OF MY LAPTOP CONFIG!!!! [y/n] " ans
  echo ""
  read -p "Provide the user name that you used :> " usr
  if [ $ans = "y" ]; then
    install
  elif [ $ans = "n" ]; then
    exit
  else
    menu
  fi
}

install() {
  xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
  xbps-install -S xorg mesa-vulkan-intel dbus pipewire alsa-pipewire wireplumber NetworkManager network-manager-applet sway swaybg swayidle swaylock SwayNotificationCenter i3status wmenu brightnessctl elogind vim firefox xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk io.elementary.files mpv glfw pavucontrol tlp alacritty clang gcc git fastfetch Thunar

  rm /var/service/dhcpcd
  rm /var/service/acpid
  rm /var/service/wpa_supplicant

  ln -s /etc/sv/NetworkManager /var/service/
  ln -s /etc/sv/polkitd /var/service/
  ln -s /etc/sv/dbus /var/service/
  ln -s /etc/sv/tlp /var/service/
  ln -s /etc/sv/elogind /var/service/

  mkdir -p /etc/alsa/conf.d
  ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
  ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

  cd home
  cp -r .config /home/$usr/
  cp .bashrc /home/$usr/
  cp .vimrc /home/$usr/
  cp swa.sh /home/$usr/
  cp voidwall.png /home/$usr/

  echo "$usr ALL=(root) NOPASSWD: /usr/bin/brightnessctl *" >> /etc/sudoers
}
menu
