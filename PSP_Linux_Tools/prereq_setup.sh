#!/bin/bash

Home_dir=`pwd`
echo "kindly make sure the repo is configured, otherwise yje package install will fail"
echo "checking for required packages"

if [ -e /etc/redhat-release ];
  then 
	yum -y install time*
	yum -y install perl*
	yum -y install patch*
	yum -y install perl-Time-HiRes
	yum -y install numactl-devel*
	yum -y install gnuplot*
	yum -y install ncurses-devel*
	yum -y install libxml2-devel*
	yum -y install boost-devel*
	yum -y install perf*
	yum -y install cmake*
	yum -y install binutils-devel*
elif [ -e /etc/SuSE-release ];
  then 
	zypper install -y time*
	zypper install -y perl*
	zypper install -y perl-Time-HiRes
	zypper install -y patch*
	zypper install -y perl-Time-HiRes 
	zypper install -y numactl-devel*
	yum -y install perf*
	zypper install -y gnuplot*
	zypper install -y ncurses-devel*
	zypper install -y libxml2-devel*
	zypper install -y boost-devel*
	zypper install -y cmake*
	
                        elif [ -e /etc/os-release ];
                                then osdetails=`lsb_release -a 2>/dev/null | grep -i 'Description' | awk '{print $2$3;}'`;

                                        else osdetails=`echo "OSdetails unavailable"`


fi
