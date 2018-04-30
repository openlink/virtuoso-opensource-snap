# OpenLink Virtuoso Open Source Edition (SNAP)

Copyright (c) 2018 OpenLink Software

## Intro
This is an **experimental** release of an OpenLink Virtuoso Open Source Edition 7.2.x snap package.

**DISCLAIMER**:
    At this time this package should be used for testing only and is not recommended in production or mission critical environments.

Virtuoso is a scalable cross-platform server that combines Relational, Graph, and Document Data Management with Web Application Server and Web Services Platform functionality.

As stated on the [SnapCraft website](http://snapcraft.io):
```
    Snaps are containerised software packages that are simple to create and install.
    They auto-update and are safe to run. And because they bundle their dependencies,
    they work on all major Linux systems without modification.
```

Distributions that support snap packages currently include recent versions of Ubuntu, Debian, Mint, Gentoo, Arch, Fedora and OpenSuse.


## Installing the snap package on your local systems

### Building the snap package from source
To build snap packages you first need to install a number of development tools including a C compiler and a number of development libraries.

The following instructions will work on most recent Debian and Ubuntu installations:
```shell
    # Install the snap daemon and the snapcraft toolkit
    $ sudo apt install snap snapcraft

    # Install the basic development tools
    $ sudo apt install build-essential equivs devscripts \
                       autoconf automake bison flex gawk git gperf libtool \
                       git make tar gzip bzip2 m4 vim openssl

    # Install development libraries
    $ sudo apt install libbz2-dev libldap2-dev libssl-dev liblzma-dev libz-dev libedit-dev
```

Installing a development environment on other Linux distributions follows a similar pattern.

To build this snap package in your own environment you can run the following commands:
```shell
    # Clone this project to your local system
    $ git clone https://github.com/openlink/virtuoso-opensource-snap
    $ cd virtuoso-opensource-snap

    # The following command will download the latest VOS sources from github,
    # run configure, make, make install and bundle the resulting into a snap image
    # Depending on your machine, this may take some time
    $ make

    # If successful you should end up with
    $ ls -lh *.snap
    -rw-r--r-- 1 pkleef development 44068864 Apr 30 20:51 virtuoso-opensource_7.2.5-dev_amd64.snap

    # Install the snap image on your computer
    $ sudo snap install --devmode virtuoso-opensource_7.2.5-dev_amd64.snap
```

### Downloading the snap package from OpenLink Software
If you rather just experiment with a pre-build version you can run the following commands:
```shell
    # Install the snap daemon
    $ sudo apt install snap

    # Download a copy of the snap image build by OpenLink Software
    $ cd /tmp
    $ wget ftp://devhub.openlinksw.com/pub/Support/snap/virtuoso-opensource_7.2.5-dev_amd64.snap

    # Install the snap image on your computer
    $ sudo snap install --devmode virtuoso-opensource_7.2.5-dev_amd64.snap
```

### Downloading the snap package from the snap repository
**TODO**: OpenLink Software will create a registration for this package and provide instructions to download the package and install it.

### Checking if the snap package is installed
The following command can be used to see if the package is installed:
```shell
    $ snap list
    Name                 Version    Rev   Tracking  Developer  Notes
    core                 16-2.32.5  4486  stable    canonical  core
    virtuoso-opensource  7.2.5-dev  x1    -         -          devmode
```

### Uninstalling the snap package from your local systems
The following command can be used to remove the package from your system:
```shell
    $ sudo snap remove virtuoso-opensource
```

**IMPORTANT**: Removing the snap package also removes the virtuoso database and all other created content.


## How to create and start a new virtuoso

The snap package installs a virtuoso-opensource command which is a wrapper script to simplify creating a new database instance, starting and stopping it etc.

To get a list of all the commands, simply run:
```shell
    $ virtuoso-opensource help

    OpenLink Virtuoso Open Source Edition (SNAP)
    Version: 7.2.5-dev/amd64/x1
    Copyright (C) 1009-2018 OpenLink Software

    Usage:
        virtuoso-opensource CMD args

    CMD list:
      help           -  This text
      version        -  Show version of current snap package
      create [DB]    -  Create database DB
      start [DB]     -  Start database DB
      stop [DB]      -  Stop database DB
      config [DB]    -  Show path to virtuoso.ini for database DB
      logfile [DB]   -  Show path to virtuoso.log for database DB
```

The script can be run by any user on the system to create a personal database under their own home directory:
```
    /home/loginname/snap/virtuoso-opensource/common
```
or using sudo to create a database in the system wide directory:
```
    /var/snap/virtuoso-opensource/common
```

Note that virtuoso can run multiple database instances simultaneous on the same platform as long as each installation uses unique port numbers.


### Creating a new virtuoso database
To create a new Virtuoso database you can run the following command:
```shell
    $ virtuoso-opensource create testdb

    Initializing new database in /home/pkleef/snap/virtuoso-opensource/common/testdb...
	Mon Apr 30 2018
    ...
    ...
    22:42:22 OpenLink Virtuoso Universal Server
    22:42:22 Version 07.20.3217-pthreads for Linux as of Apr 30 2018
    22:42:22 uses parts of OpenSSL, PCRE, Html Tidy
    22:42:22 Starting for DBA password change.
    22:42:22 SQL Optimizer enabled (max 1000 layouts)
    22:42:22 Compiler unit is timed at 0.000600 msec
    22:42:26 Checkpoint started
    22:42:26 Roll forward started
    22:42:26 Roll forward complete
    22:42:26 Checkpoint started
    22:42:26 Checkpoint finished, log reused
    ...
    22:42:28 The DBA password is changed.
    22:42:28 The DAV password is changed.
    22:42:28 Checkpoint started
    22:42:29 Checkpoint finished, log reused
    22:42:29 Server exiting

    NOTE: Initial password for dba and dav: dOEEu29f
```

For security reasons each new database is created with a unique random password for the dba and dav accounts. Please make a note of this password before continuing.

Next we start the database:
```shell
    $ virtuoso-opensource start testdb
```

Connect to the new instance using the isql tool, login using the password recorded above and change the dba password:
```shell
    $ virtuoso-opensource isql testdb

    Trying to contact virtuoso on port 1111
    OpenLink Virtuoso Interactive SQL (Virtuoso)
    Version 07.20.3217 as of Apr 30 2018
    Type HELP; for help and EXIT; to exit.

    *** Error 28000: [Virtuoso Driver]CL034: Bad login
    at line 0 of Top-Level:

    Enter password for dba :
    Connected to OpenLink Virtuoso
    Driver: 07.20.3217 OpenLink Virtuoso ODBC Driver
    SQL> user_set_password ('dba', 'myverysecretpassword');

    Done. -- 3 msec.
    SQL> quit;
```

To stop the virtuoso instance use:
```
    $ virtuoso-opensource stop testdb
```
