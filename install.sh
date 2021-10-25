#!/bin/bash
###############################################################################
# Title: Pandaura Base installer
# Coder : 	Pandaura
# GNU: General Public License v3.0E
#
################################################################################

sudocheck() {
    if [[ $EUID -ne 0 ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  You must execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        exit 0
    fi
}
agreebase() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ READ THIS NOTE!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Upon installing Pandaura you accept the risk of ANY data being transferred to your
mounted Google Drive account. Google obtain the rights to remove your account
if you are illegally using an Education account or not adhering to the
Gsuite Business Terms of Service by having less than 5 users.

We do not condone or support the use of education accounts specifically.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    timer
    doneokay
}
timer() {
    seconds=5; date1=$((`date +%s` + $seconds));
    while [ "$date1" -ge `date +%s` ]; do
        echo -ne "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
    done
}
existpg() {
    file="/opt/plexguide/menu/pg.yml"
    if [[ -f $file ]]; then
        overwrittingpg
else nopg ; fi
}
overwrittingpg() {
    clear
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ We found an existing PG/PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please choose one of the options below:

[Y]es, I want a clean Pandaura installation. (RECOMMENDED)
    -- This will create a backup from 2 folders

[N]o, I want to keep my PG/Pandaura installation
    -- This will cause a lot of problems with Pandaura. Can break PG and PTS.

_____________________________________________________________________________________
[ Z ] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -p '💬  Type Y or N | Press [ENTER]: ' typed </dev/tty
    
    case $typed in
        Y) ovpgex ;;
        y) ovpgex ;;
        N) nope ;;
        n) nope ;;
        z) exit 0 ;;
        Z) exit 0 ;;
        *) badinput1 ;;
    esac
}
nopg() {
    base && repo && packlist && editionpts && value && endingnonexist
}
ovpgex() {
    backupex && base && repo && packlist && editionpts && value && endingexist
}
nope() {
    echo
    exit 0
}
drivecheck() {
    clear
    leftover=$(df / --local | tail -n +2 | awk '{print $4}')
    if [[ "$leftover" -lt "50000000" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Pandaura noticed your current system has <50GB drive space
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You have <50GB of storage space. This can lead to issues.

Please make sure that there is enough space available.

Continue the installation at your own risk!
_____________________________________________________________________________________
EOF
        doneokay
    fi
}
doneokay() {
    echo
    read -p 'Confirm info | PRESS [ENTER] ' typed </dev/tty
}
backupex() {
    clear
    time=$(date +%Y-%m-%d-%H:%M:%S)
    mkdir -p /var/backup-pg/
    tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /opt/plexguide -cf /var/backup-pg/plexguide-old-"$time".tar.gz ./
    tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /var/plexguide -cf /var/backup-pg/var-plexguide-old-"$time".tar.gz ./
    
    printfiles=$(ls -ah /var/backup-pg/ | grep -E 'plex')
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pandaura made a backup of an existing PG / Pandaura installation for you!

$printfiles
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    doneokay
    if [[ -e "/opt/plexguide" ]]; then rm -rf /opt/plexguide; fi
    if [[ -e "/opt/pgstage" ]]; then rm -rf /opt/pgstage; fi
    if [[ -e "/var/plexguide" ]]; then rm -rf /var/plexguide; fi
    if [[ -e "/opt/ptsupdate" ]]; then rm -rf /opt/ptsudate; fi
    clear
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈 Cleanup existing PG / Pandaura installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pandaura has now carried out a cleanup for different needed folders!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    doneokay
}
badinput1() {
    echo
    read -p '⛔️ ERROR - Bad input! | Press [ENTER] ' typed </dev/tty
    overwrittingpg
}
### FUNCTIONS END #####################################################
### everything after this line belongs to the installer
### INSTALLER FUNCTIONS START #####################################################
mainstart() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈  INSTALLING: Pandaura
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

By installing, you are agreeing to the terms and
conditions of the GNUv3 License! https://choosealicense.com/licenses/gpl-3.0/

		                     ┌─────────────────────────────────────┐
		                     │                                     |
                | Pandaura would like to thank all    |
                | those that contributed to past      |
                | projects.                           |
                │                                     |
                │ Thank you for your contributions!   │
                |            ▄██▄       ▄▄            |
                |           ▐███▀     ▄███▌           |
                |      ▄▀  ▄█▀▀        ▀██            |
                |      █   ██                         |
                |      █▌  ▐██  ▄██▌  ▄▄▄   ▄         |
                |      ██  ▐██▄ ▀█▀   ▀██  ▐▌         |
                |      ██▄ ▐███▄▄  ▄▄▄ ▀▀ ▄██         |
                |      ▐███▄██████▄ ▀ ▄█████▌         |
                |      ▐████████████▀▀██████          |
                |       ▐████▀██████  █████           |
                |         ▀▀▀ █████▌ ████▀            |
                |              ▀▀███ ▀▀▀              |
                |        Welcome to Pandaura          |
	          	└─────────────────────────────────────┘
EOF
sleep 5
}
##############################
base() {
    sleep 1
    ##check for open port ( apache and Nginx test )
    base_list="lsof lsb-release software-properties-common"
    
    apt-get install $base_list -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈 Pandaura is checking for existing active Webserver(s) - Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
        elif lsof -Pi :443 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
else echo "" ; fi
    clear
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈Pandaura check for existing Webserver(s) is complete ✔️
Base install - Standby  || This may take a few minutes. Grab a coffee!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    versioncheck=$(cat /etc/*-release | grep "Ubuntu" | grep -E '19')
    if [[ "$versioncheck" == "19" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ WOAH! System OS Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.* / 10

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        exit 0
else echo ""; fi
}
######################
repo() {
    # add repo
    rm -f /var/log/osname.log
    touch /var/log/osname.log
    echo -e "$(lsb_release -si)" >/var/log/osname.log
    
    if [[ $(lsb_release -si) == "Debian" ]]; then
        add-apt-repository main >/dev/null 2>&1
        add-apt-repository non-free >/dev/null 2>&1
        add-apt-repository contrib >/dev/null 2>&1
        wget -qN https://raw.githubusercontent.com/MHA-Team/Install/master/source/ansible-debian-ansible.list /etc/apt/sources.list.d/
        elif [[ $(lsb_release -si) == "Ubuntu" ]]; then
        add-apt-repository main >/dev/null 2>&1
        add-apt-repository universe >/dev/null 2>&1
        add-apt-repository restricted >/dev/null 2>&1
        add-apt-repository multiverse >/dev/null 2>&1
        apt-add-repository --yes --update ppa:ansible/ansible >/dev/null 2>&1
        elif [[ $(lsb_release -si) == "Rasbian" || $(lsb_release -si) == "Fedora" || $(lsb_release -si) == "CentOS" ]]; then
        clear
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ WOAH! Pandaura system warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.*

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        exit 0
    fi
}
##############################
packlist() {
    clear
    package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw ansible fortune intel-gpu-tools python-apt lolcat figlet"
    echo -ne '                         (0%)\r'
    apt-get update -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    echo -ne '####🐼                    (20%)\r'
    apt-get upgrade -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    apt-get dist-upgrade -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    echo -ne '#########🐼                (40%)\r'
    apt-get autoremove -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    echo -ne '##############🐼            (60%)\r'
    apt-get install $package_list -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    echo -ne '###################🐼       (80%)\r'
    apt-get purge unattended-upgrades -yqq >/dev/null 2>&1
    export DEBIAN_FRONTEND=noninteractive
    echo -ne '#######Panda Power########🐼 (100%)\r'
    echo -ne '\n'
    clear
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈 Pandaura finished updating your system ✔️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
#####
editionpts() {
    echo -ne '                         (0%)\r'
    # Delete If it Exist for Cloning
    if [[ -e "/opt/plexguide" ]]; then rm -rf /opt/plexguide; fi
    if [[ -e "/opt/pgstage" ]]; then rm -rf /opt/pgstage; fi
    echo -ne '##🐼                      (10%)\r'
    if [[ -e "/var/plexguide" ]]; then rm -rf /var/plexguide; fi
    if [[ -e "/opt/ptsupdate" ]]; then rm -rf /opt/ptsudate; fi
    echo -ne '####🐼                    (20%)\r'
    rm -rf /opt/pgstage/place.holder >/dev/null 2>&1
    ##fast change the editions
    edition=master
    ##fast change the editions
    echo -ne '######🐼                   (30%)\r'
    git clone -b $edition --single-branch https://github.com/Pandaura/Install.git /opt/pgstage 1>/dev/null 2>&1
    git clone https://github.com/Pandaura/PTS-Update.git /opt/ptsupdate 1>/dev/null 2>&1
    echo -ne '#########🐼                (40%)\r'
    mkdir -p /var/plexguide/logs
    echo "" >/var/plexguide/server.ports
    echo "51" >/var/plexguide/pg.pythonstart
    echo -ne '###########🐼              (50%)\r'
    touch /var/plexguide/pg.pythonstart.stored
    start=$(cat /var/plexguide/pg.pythonstart)
    stored=$(cat /var/plexguide/pg.pythonstart.stored)
    echo -ne '##############🐼            (60%)\r'
    if [[ "$start" != "$stored" ]]; then bash /opt/pgstage/pyansible.sh 1>/dev/null 2>&1; fi
    echo -ne '#################🐼       (70%)\r'
    echo "51" >/var/plexguide/pg.pythonstart.stored
    pip install --upgrade pip 1>/dev/null 2>&1
    ansible-playbook /opt/pgstage/folders/folder.yml
    ansible-playbook /opt/pgstage/clone.yml
    echo -ne '###################🐼       (80%)\r'
    ansible-playbook /opt/plexguide/menu/alias/alias.yml
    ansible-playbook /opt/plexguide/menu/motd/motd.yml
    echo -ne '#####################🐼     (90%)\r'
    ansible-playbook /opt/plexguide/menu/pg.yml --tags journal,system
    ansible-playbook /opt/plexguide/menu/pg.yml --tags rcloneinstall
    ansible-playbook /opt/plexguide/menu/pg.yml --tags mergerfsinstall
    ansible-playbook /opt/plexguide/menu/pg.yml --tags update
    echo -ne '########################🐼 (100%)\r'
    echo -ne '\n'
    clear
}
############
value() {
     if [[ -e "/bin/pandaura" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈  Pandaura is now verifiying it's install @ /bin/pandaura - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ WARNING! Pandaura installer failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We are happy to do this for you again automagically.
We are doing this to ensure that your installation continues to work.
Please wait one moment while Pandaura now checks and sets everything up for you.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        read -p 'Confirm info | PRESS [ENTER] ' typed </dev/tty
        sudocheck && base && repo && packlist && editionpts && value && ending
    fi
}

endingnonexist() {
    clear
    logfile=/var/log/log-install.txt
    chk=$(figlet "<<< Pandaura >>>" | lolcat)
    touch /var/plexguide/new.install
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈 Pandaura is now installed ✔️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Operating System     : $(lsb_release -sd)
Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
IP from server       : $(hostname -I | awk '{print $1}')
HDD space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
RAM space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
Logfile              : $logfile
_____________________________________________________________________________________
🛈  Start anytime by typing >>> sudo pandaura
🛈  Want to add a USER with UID 1000 then type >>> sudo ptsadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
###############
endingexist() {
    clear
    logfile=/var/log/log-install.txt
    chk=$(figlet "<<< Pandaura >>>" | lolcat)
    touch /var/plexguide/new.install
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$chk
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛈 Pandaura is now installed ✔️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Operating System     : $(lsb_release -sd)
Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
IP from server       : $(hostname -I | awk '{print $1}')
HDD space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
RAM space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
PG/Pandaura backup   : /var/backup-pg/
Logfile              : $logfile
_____________________________________________________________________________________
🛈  Start anytime by typing >>> sudo pandaura
🛈  Want to add a USER with UID 1000 then type >>> sudo ptsadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
### INSTALLER FUNCTIONS END #####################################################
#### function layout for order one by one

mainstart
sudocheck
drivecheck
existpg

