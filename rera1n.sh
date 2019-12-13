#!/bin/bash
# Over WiFi or USB
main_menu() {
    echo "[*] Which of the following option sets would you like to use: "
    echo "[*] Recovery options (1)"
    echo "[*] Tool options - W.I.P (2)"
    echo "[*] SSH Window (3)"
    echo "[*] Exit (X)"
    read -p "[*] Select an option using the shortened option names: " option
    if [ $option = 1 ]
    then
        recovery_options
    elif [ $option = 2 ]
    then
        tool_options
    elif [ $option = 3 ]
    then
        ssh_window
    elif [ $option = C ]
    then
        echo "[*] Developer: a_i_da_n"
        echo "[*] Usefull components libimobiledevice"
        echo "[*] Usefull components rcg4u"
        echo "[*] Original idea ConsoleLogLuke"
        main_menu
    elif [ $option = X ]
    then
        echo "[-] Exiting program"
        exit
    else
        echo "[-] Unexpected input exiting program"
        exit
    fi
}

recovery_options() {
    echo "[*] Which of the following options would you like to use: "
    echo  "[*] Respring - SpringBoard (1)"
    echo  "[*] Respring - backboardd (2)"
    echo  "[*] Reboot (3)"
    echo  "[*] Respring - Loop Fix (4)"
    echo "[*] Kill specified process (5)"
    echo "[*] Restore/Update to signed firmwares (6)"
    echo "[*] Back to main menu (<)"
    read -p "[*] Select an option using the shortened option names: " option
    if [ $option = "1" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 SpringBoard
        main_menu
    elif [ $option = "2" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 backboardd
        main_menu
    elif [ $option = "3" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport reboot
        main_menu
    elif [ $option = "4" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -8 SpringBoard
        main_menu
    elif [ $option = "5" ]
    then
        read -p "[*] Please enter the Proccess name to kill: " processname
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport killall -9 $processname
        main_menu
    elif [ $option = "6" ]
    then
        idevicerestore -l
        main_menu
    elif [ $option = "<" ]
    then
        main_menu
    else
        echo "Unknown or Unrecognised command number"
    fi
}

tool_options() {
    echo "[*] Which of the following options would you like to use: "
    echo  "[*] UiCache (1)"
   # echo  "[*] iDevice Info V1.2 (2)"
    echo "[*] Install Packages - bundle indetifier required (3)"
    echo "[*] Remove Packages - bundle identifier required (4)"
    echo "[*] Backup entire drive (This takes absoutely forever please do not use, 5)"
    echo "[*] "
    echo "[*] Back to main menu (<)"
    read -p "[*] Select and option using the shortened option names: " option
    if [ $option = 3 ]
    then
        read -p "[*] Enter the bundle identifier of the package: " idevicebundleidentifier
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport apt-get install $idevicebundleidentifier
        main_menu
    elif [ $option = 4 ]
    then
        read -p "[*] Enter the bundle identifier of the package: " idevicebundleidentifier
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport apt-get remove $idevicebundleidentifier
        main_menu
    elif [ $option = "1" ]
    then
        sshpass -p$idevicepassword ssh mobile@$ideviceip -p $ideviceport uicache
        main_menu
    elif [ $option = "2" ]
    then
        ideviceinfo > ideviceinfo.txt
        grep ActivationState: ideviceinfo.txt
        grep BasebandVersion: ideviceinfo.txt
        grep BluetoothAddress: ideviceinfo.txt
        grep BuildVersion: ideviceinfo.txt
        grep CPUArchitecture: ideviceinfo.txt
        grep DeviceClass: ideviceinfo.txt
        grep DeviceColor: ideviceinfo.txt
        grep EthernetAddress: ideviceinfo.txt
        grep FirmwareVersion: ideviceinfo.txt
        grep HardwareModel: ideviceinfo.txt
        grep HardwarePlatform: ideviceinfo.txt
        grep PasswordProtected: ideviceinfo.txt
        grep ProductType: ideviceinfo.txt
        grep ProductVersion: ideviceinfo.txt
        grep -w SerialNumber: ideviceinfo.txt
        grep WiFiAddress: ideviceinfo.txt
        main_menu
    elif [ $option = "5" ]
    then
        scp -p -R 2222 root$ideviceip:/* .
    elif [ $option = "6" ]
    then
        sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport psswd 
    elif [ $option = "<" ]
    then
        main_menu
    else
        echo "[-] Unexpected option selected"
        exit
    fi
}

ssh_window() {
    echo "[*] Connecting to iDevice"
    sshpass -p$idevicepassword ssh root@$ideviceip -p $ideviceport
    echo "[*] Sucessfully exited SSH window"
    main_menu
}

# Defining function
function none_menu {
    # Informing the user of requirements
    echo "[*] These functions require USB access"
    echo "[*] Each function will say its individual iDevice mode requiremnts"
    # Informing the user of what to do
    echo "[*] Please selected an option: "
    # Listing options and there requirments
    echo "[*] Restore/Update - (1) [DFU/RESTORE/USERLAND]"
    echo "[*] Reboot - (2) [DFU/RESTORE/USERLAND]"
    echo "[*] iDeviceInfo - (3) [DFU/RESTORE/UNLOCKED-USERLAND]"
    echo "[*] iDeviceVerbose - (4) [UNLOCKED-USERLAND]"
    echo "[*] Exit script - (X)"
    # Promting user with a select menu
    read -p "[*] Select and option using the single characters: " option
    # Checking if the user selected option number 1
    if [ $option = "1" ] ; then
        # Running external idevicerestore script
        idevicerestore -l
        # Looping back to beggining of menu
        none_menu
    # Checking if the user selected option number 2
    elif [ $option = "2" ] ; then
        # Prompting user whether device is in DFU/RESTORE or USERLAND
        read -p "[*] Is your iDevice in DFU/RESTORE (1) or USERLAND (2): " userlandbro
        # Checking if device is in recovery/dfu
        if [ $userlandbro = 1 ]; then
            # Running external irecovery script with -c reboot arguement
            irecovery -c Reboot
        elif [ $userlandbro = 2 ]; then
            # Running external idevicediagnostics script with restard arguement
            idevicediagnostics restart
        fi 
        # Informing the user their device is rebooting
        echo "[*] iDevice rebooting"
        # Looping back to beggining of menu
        none_menu
    # Checking if the user selected option number 3
    elif [ $option = "3" ]; then
        # Running external ideviceinfo script and logging its output to ideviceinfo.txt
        ideviceinfo > ideviceinfo.txt
        # Outputting only certain parts of the logged file
        grep ActivationState: ideviceinfo.txt
        grep BasebandVersion: ideviceinfo.txt
        grep BluetoothAddres: ideviceinfo.txt
        grep BuildVersion: ideviceinfo.txt
        grep CPUArchitecture: ideviceinfo.txt
        grep DeviceClass: ideviceinfo.txt
        grep DeviceColor: ideviceinfo.txt
        grep EthernetAddress: ideviceinfo.txt
        grep FirmwareVersion: ideviceinfo.txt
        grep HardwareModel: ideviceinfo.txt
        grep HardwarePlatform: ideviceinfo.txt
        grep PasswordProtected: ideviceinfo.txt
        grep ProductType: ideviceinfo.txt
        grep ProductVersion: ideviceinfo.txt
        grep -w SerialNumber: ideviceinfo.txt
        grep WiFiAddress: ideviceinfo.txt
        # Deleting ideviceinfo.txt file
        rm -f ideviceinfo.txt
        # Looping back to beggining of menu
        none_menu
    # Checking if the user selected option 4
    elif [ $option = "4" ]; then
        # Warning the user
        echo "[-] Warning this may cause lag"
        echo "[-] Warning this is very fast and will be outputed to a file called \"device_logs.txt\""
        echo "[-] Output will not be shown on screen"
        # Waiting 2 seconds
        sleep 2
        # Informing the user it is starting
        echo "[*] Starting, enter CTRL + C to stop "
        # Waiting one second
        sleep 1
        # Informing the user its started
        echo "[*] Started"
        # Running it
        idevicesyslog > device_logs.txt
    # Checking if the user selected option X (exit)
    elif [ $option = "X" ] ; then
        # Informing the user they are exiting the script
        echo "[-] Exiting script"
        # Exiting script
        exit
    # Checking if none of the valid options were selected
    else 
        # Informing the user they selected an invalid option
        echo "[*] Invalid option selected"
        # Looping back to begginging of menu
        none_menu
    # Closing if statements
    fi
# Closing function
}

# Welcoming the user
echo "[*] Welcome to ReRa1n"
# Checking for dependencies
echo "[*] Checking for dependencies"
if [ ! -e .installed ]; then
    # Informing the user that the dependencies were not found
    echo "[-] Dependencies not found."
    # Prompting the user if they would like to install the dependencies manually or automatically
    read -p "[*] Would you like to install dependencies manually or automatically (M/A): " install
    # Checking if the user would like automatic dependency install
    if [ $install = A ]; then
        # Informing the user that they have selected automatic install
        echo "[*] Automatically installing dependencies"
        # Running the install script, outputting the log to .installed
        ./install.sh > .installed
        # Informing the user the install script is finished
        echo "[*] Finished, if you encounter errors or bugs please read the .installed file"
    # Checking if the user wants to manually install the dependencies
    elif [ $install = M ]; then
        # Making sure the user is Linux-Ready 
        echo "[-] This is recommended for daily linux users only"
        # Informing the users of instructions
        echo "[*] Please run the install-no-deb.sh file"
        echo "[*] After create a file with the name \".installed\""
    # Else statement
    else 
        # Informing the user that the response was inadequate 
        echo "[-] Unknown response"
        # Informing the user of the next action (Exit)
        echo "[-] Exiting"
        # Exiting
        exit
    # Closing the if statments
    fi
# Closing the if statements
fi 
# Informing the user that the dependency check is complete and that it was sucsessfull
echo "[*] Dependencies found"
read -p "[*] SSH over WiFi, USB or NONE (CaSeSeNsItIvE): " wifiorusb
echo [*] You chose $wifiorusb.
if [ $wifiorusb = "WiFi" ]
then
    # SSH over WiFi is selected
    echo [*] WiFi selected.
    # Setting Global Variables
    ideviceport=22
    # Getting IP & Root Password
    read -p "[*] Enter the IP address of your iDevice: " ideviceip
    read -p "[*] Enter the root password of your iDevice (Default is alpine, make sure to change): " idevicepassword
    # SSHing into iDevice
    ssh root@$ideviceip exit
    sshpass -p$idevicepassword ssh root@$ideviceip cd /
    echo [*] Connected to iDevice
    # Declaring recovery and tool functions for WiFi
    main_menu
elif [ $wifiorusb = "USB" ]
then
    echo [*] USB selected.
    ideviceip=localhost
    ideviceport=2222
    cd rerain-deps
    echo "[*] Open a second terminal window and enter: cd /usr/bin && sudo fordward.sh "
    read -p "[*] Press enter to continue:"
    read -p "[*] Enter the root password of your iDevice (Default is alpine, make sure to change this): " idevicepassword
    ssh root@localhost -p 2222 exit
    sshpass -p$idevicepassword ssh root@localhost -p 2222 cd /
    echo "[*] Connected to iDevice"
    main_menu
elif [ $wifiorusb = "NONE" ]
then
    none_menu
else
    echo [-] Unknown or Unavailable selected.
    exit
fi
