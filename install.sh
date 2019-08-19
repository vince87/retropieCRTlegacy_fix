#!/bin/bash
########################################################
## Vincenzo Bini 19/08/2019
## Versione 0.1
#########################################################

cd ~
sudo apt-get update
git clone https://github.com/vince87/JammaPi.git
cd ~/JammaPi
git reset --hard origin/master
git pull



  ##Modify Config.txt to Default
	printf "\033[1;31m Modifico il config.txt per la JammaPi \033[0m\n"
	sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo sh -c "echo 'dtparam=i2c_vc=on' >> /boot/config.txt"
	echo "Config.txt modificato!"
	fi
	sleep 2

##install jammapi led driver
	printf "\033[1;31m Installo led \033[0m\n"
	sudo grep 'dtoverlay=pi3-act-led,gpio=27' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo sh -c "echo 'dtoverlay=pi3-act-led,gpio=27' >> /boot/config.txt"
	sudo sh -c "echo 'gpio=26=op,dl' >> /boot/config.txt"
	echo "Modulo impostato!"
	fi
	sleep 2

	
	printf "\033[1;31m Installo driver Joystick \033[0m\n"
	cd ~/JammaPi/joypi/
	make
	sudo make install
	sudo insmod joypi.ko
	sudo grep 'i2c-dev' /etc/modules > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	sudo perl -p -i -e 's/mk_arcade_joystick_rpi/jpypi/g' /etc/modules
	echo "Già modificato!"
	else
	sudo sh -c "echo 'i2c-dev' >> /etc/modules"
	sudo sed -i -e "s/^exit 0/modprobe joypi \&\n&/g" /etc/rc.local
	echo "Modulo impostato!"
	fi
	
	sleep 2
    
    		printf "\033[0;32m !!!INSTALLAZIONE COMPLETATA!!! \033[0m\n"
		printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
  		sleep 5
		
sudo reboot
