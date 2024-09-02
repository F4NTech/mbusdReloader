Thanks to @github.com/3cky/mbusd

I created a script to restart mbusd, mbusd is open-source Modbus TCP to Modbus RTU (RS-232/485) gateway.
It presents a network of RTU slaves as single TCP slave.

That is a TCP-Slave (or server) which acts as a RTU-master to get data from Modbus RTU-slave devices..
At times, I encountered conversion failures, causing instability when reading via TCP.
Sometimes, this issue can be resolved by restarting mbusd.
To address this, I implemented an automatic check by monitoring the latest mbusd log entries using journalctl.

This script is intended to run as a systemctl service, enabling it to start automatically during boot.
To ensure this script functions correctly, several configurations are required. 
These include setting up the running Modbus service, specifying the locations for the service script and log script. 
However, if you review the script, you'll find the default locations for the log file and the Modbus service are already provided.
I am not an expert on the Linux kernel, 
so I will only explain how to run this script on the Linux kernel version I use (Ubuntu Server 22.04).

Here are the steps to run this tool:
Change the script's mode to make it executable with the following command: chmod +x mbusdReloader.sh
Move the service file to the appropriate service location (/etc/systemd/system/)."

Then run the script with the command:
systemctl daemon-reload
systemctl enable mbusdReloader.service
systemctl start mbusdReloader.service

make sure you use root user to run this script.
thanks

Muhammad Farhan
