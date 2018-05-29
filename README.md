# Shepherd Grid

## Planning
* Cluster sets of identical desktop computers previously used in classrooms.
* Create a Beowulf cluster supporting distributed processing with local storage.
* Use existing rack mounting in CME server closet.
* Provision one switch and sufficient ethernet cabling.

## Nodes
* Dell Optiplex 7010, Intel Core i7-3770 (3.4 GHz) with 8 GB RAM and 500 GB disk.
* Win10 overwritten. If we ever needed Windows back, our department has the original Win10 image disk.

## Ubuntu
* On Windows, use rufus to format a bootable USB stick.
* We test installed Ubuntu desktop on one node. The node now has dual boot. Booting into Ubuntu works. (5/14/18)
* We installed Ubuntu desktop over Windows on 3 nodes: Shep1, Shep2, Shep3. (5/21/18)
* We installed Unbuntu [Server](https://www.ubuntu.com/download/server) 18.04 LTS from USB to 3 nodes: shep1, shep2, shep3.
* With just Ubuntu Server, the computer interface was hard to use: full screen text, no windows, no browsers, no mouse, no cut & paste, no scroll back. We had difficulty configuring slurm. 
Therefore we installed ubuntu desktop. That probably installed way too much GUI stuff. 
This is a big install (1 GB, 50 minutes to install) and might not be required on for the remaining nodes. 
Later, we should pare down the software we install on grid nodes. 
See this [argument](https://askubuntu.com/questions/53822/how-do-you-run-ubuntu-server-with-a-gui) 
and this [guide](https://help.ubuntu.com/community/ServerGUI).

## Slrum
* Much documentation recommends slurm-llnl which runs the [cluster](https://computing.llnl.gov/tutorials/linux_clusters/) at Lawrence Livermore National Labs. 
That version may be deprecated. We could not find an installer for it for Ubuntu. 
We used WLM instead. It creates a /etc/slurm-llnl directory so perhaps WLM is son-of-llnl.
* ```sudo apt-get install slurm-wlm```
from [packages](https://packages.ubuntu.com/bionic/slurm-wlm) 
This installed files like /usr/share/doc/slurm-wlm/slurm-wlm-configurator.easy.html
* We found we needed a web browser do configure the nodes. 
For example, Slurm comes with instructions and examples as HTML files. 
We installed Firefox like this ```sudo apt-get install ubuntu-firefox```, probably redundant with the next step. 
We installed Gnome etc. like this ```sudo apt-get install ubuntu-desktop```, which took an hour. 
* Slurm
    * Invik [blog](https://www.invik.xyz/work/Slurm-on-Ubuntu-Trusty/) how to install slurm-llnl.
    * [How to Install](https://www.howtoinstall.co/en/ubuntu/trusty/slurm-llnl) for slurm-llnl.
    * [Wiki](https://www.howtoinstall.co/en/ubuntu/trusty/slurm-llnl) how to set up slurm-llnl.

## Network software not used
* Basics
    * Building a simple Beowulf cluster. [How to](https://www-users.cs.york.ac.uk/~mjf/pi_cluster/src/Building_a_simple_Beowulf_cluster.html) by Serrano Pereira.
* MPI message passing interface
    * [Wikipedia](https://en.wikipedia.org/wiki/Message_Passing_Interface)
    * javaMPI API [spec](https://www.open-mpi.org/papers/mpi-java-spec/) (2016)
* SGE batch control
    * [Wikipedia](https://en.wikipedia.org/wiki/Oracle_Grid_Engine)
    * Open source
    * Commercial support by Oracle ended 2010
    * Support by [Open Grid Scheuduler](http://gridscheduler.sourceforge.net/) lacks updates since 2013
    * Commercial version by [Univa](http://www.univa.com/products/)
* Scyld ClusterWare (commercial software)
    * [Penguin Computing](https://www.penguincomputing.com/support/documentation/)
    * Scyld [Documentation](https://www.penguincomputing.com/documentation/scyld-clusterware/7/admin-guide/index.html)
    * [News](http://www.dataversity.net/penguin-computing-announces-scyld-clusterware-7-large-clusters/): Penguin Computing Announces Scyld ClusterWare 7 for Large Clusters (Jan 2017)
    * Support for PBS/Torque and others including SGE
* LCM
    * Linux Cluster Manager [LCM](http://linuxcm.sourceforge.net/)

## Contact
* Professor Jason Miller

