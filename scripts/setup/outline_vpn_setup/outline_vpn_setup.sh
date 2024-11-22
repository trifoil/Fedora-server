sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=36255/tcp
sudo firewall-cmd --permanent --add-port=7893/tcp
sudo firewall-cmd --permanent --add-port=7893/udp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports


sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"

read -n 1 -s -r -p "Done. Press any key to continue..."