Steps to use :
1. git clone https://github.com/prashantph/PSP_Linux_Tools
or wget https://github.com/prashantph/PSP_Linux_Tools/archive/refs/heads/main.zip

2. cd PSP_Linux_Tools; 
Specify the duration for data collection. 300-600s would be ideal, specify the tools that are suppose to run 
./PTools_DataCollection.sh -t 600 -l lpcpu


3. Data collected will be processed and packaged in tar.bz2 format

Capabilities :
Collects the following for the specified duration :

    lpcpu
    24x7 <-- To enable this, uncomment line #41 after meeting the Pre-Requisites listed in https://w3.ibm.com/w3publisher/power-systems-performance-tools/p10-24x7-data-collection
    perf profiles


Assumptions :
The OS repositories are set so that the dependent packages are installed.
