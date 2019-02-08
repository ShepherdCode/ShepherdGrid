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
* Try #1. 
We test installed Ubuntu desktop on one node.
The node could dual boot. Booting into Ubuntu works. (5/14/18)
* Try #2. 
We installed Ubuntu desktop over Windows on 3 nodes: Shep1, Shep2, Shep3. (5/21/18)
* Try #3.
We installed Unbuntu [Server](https://www.ubuntu.com/download/server) 18.04 LTS from USB to 3 nodes: shep1, shep2, shep3.
With just Ubuntu Server, the computer interface was hard to use: 
full screen text, no windows, no browsers, no mouse, no cut & paste, no scroll back. 
We had difficulty configuring slurm. 
* Try #4
Therefore we installed ubuntu desktop. That probably installed way too much GUI stuff. 
This is a big install (1 GB, 50 minutes to install) and might not be required on for the remaining nodes. 
Later, we should pare down the software we install on grid nodes. 
See this [argument](https://askubuntu.com/questions/53822/how-do-you-run-ubuntu-server-with-a-gui) 
and this [guide](https://help.ubuntu.com/community/ServerGUI).
We turned off screen lock and turned on auto login.

## Slurm

### Slurm links
* Invik [blog](https://www.invik.xyz/work/Slurm-on-Ubuntu-Trusty/) how to install slurm-llnl.
* [How to Install](https://www.howtoinstall.co/en/ubuntu/trusty/slurm-llnl) slurm-llnl.
* [Wiki](https://wiki.archlinux.org/index.php/Slurm) installation and setup.
* SchedMD [docs](https://slurm.schedmd.com/documentation.html) 
and [download](https://slurm.schedmd.com/download.html)
and [FAQ](https://slurm.schedmd.com/faq.html#cred_invalid).
* [Tutorial](https://computing.llnl.gov/tutorials/moab/) for slurm and moab
* Technical [FAQ](http://www.sdsc.edu/~hocks/FG/CMT.slurm.problems.html)
* Sample slurm.conf [file](https://github.com/neurokernel/gpu-cluster-config/blob/master/slurm.conf)

### Slurm Versions
Much documentation recommends slurm-llnl which runs the [cluster](https://computing.llnl.gov/tutorials/linux_clusters/) at Lawrence Livermore National Labs. That version may be deprecated. We could not find an installer for it for Ubuntu. We used WLM instead. It creates a /etc/slurm-llnl directory so perhaps WLM is son-of-llnl?

### Slurm Install
```sudo apt-get install slurm```
then ```sudo apt-get install slurm-wlm```.
The command ```sudo apt-get install munge``` said already installed.
Then ```sudo apt-get install libopenmpi-dev openmpi-bin```
and ```sudo apt-get install mysql-server```.
The ```sinfo``` command complains that /etc/slurm-llnl/slurm.conf is missing.

Files installed include: 
/usr/share/doc/slurm-wlm/slurm-wlm-configurator.easy.html
/usr/share/doc/slurm/README (doc), 
/usr/share/doc/slurmctrld/slurm-wlm-configurator.html (tool),
/var/lib/slurm-llnl (state).

Configure the slurm user.
This user is created during the apt-get insall.
The slurm user needs /usr/sbin in his path.
As [documented](https://wiki.archlinux.org/index.php/Slurm), 
files and directories are owned by uid 64030, user=slurm, group=slurm.
The slurm install creates a non-interactive user 'slurm' to own files.
This user shows up on the Ubuntu bootup and, confused, I changed slurm to a normal user.
If you create the slurm user manually, make sure the user has the same uid as owns the files.
These Linux user 
[management](http://www.comptechdoc.org/os/linux/usersguide/linux_ugusers.html)
commands are helpful:
```passwd```, ```usermod -d```, ```usermod -u```, and ```chsh -s``` and others.

### Slurm Configure
See our slurm.conf examples in this repository.

Follow [schedmd](https://slurm.schedmd.com/slurm.conf.html).
Examples [easy](https://slurm.schedmd.com/configurator.easy.html) or [full](https://slurm.schedmd.com/configurator.html).
Use FireFox on the Ubuntu node and open
/usr/share/doc/slurmctrld/slurm-wlm-configurator.html
which will generate a text file in the same browser window.
RealMemory must be specified (in megabytes) if memory is a consumable resource; leave it blank for now.
Choose CR_Socket which seems to mean the smallest consumable unit will be one of our nodes
(```slurmd -C``` shows 1 socket, 4 cores, 2 threads, 8 cpu).
Slurm accounting with a database would require path to MySQL conf file; choose text file accounting for now.
We created /etc/slurm-llnl/slurm.conf with shep1 as control node.
We copied the same file to every node using scp and the node's IP4 address.
Not done yet: ldconfig -n <library_location> to gain access to slurm APIs.
In slurm.conf, the ControlMachine must be a name like 'shep1' not an IP address.

### Start slurm control node
Run ```sudo /etc/init.d/slrmctld start``` on control node.
Do not run as user=slurm; the log complains "not running as root".
Run as user=shepherd with sudo.

We encountered these problems at first.
Intially, ```sacct``` failed saying "/var/log/slurm_jobacct.log no such file"; 
creating the file fixed the error.
Initially, ```squeue``` said "Unable to resolve shep1: unknown host";
this now works (shows empty queue) with a configuration file that says ControlMachine=shep1 and no ControlAddr.
Initially, ```smap``` said "slurm_load_node: Unable to contact slurm controller (connect failure)";
this now works (shows two empty boxes).
However, we always get the same errors in /var/log/slurm-llnl/slurmctld.log file:
"slurm_unpack_received_msg: Protocol authentication error", 
"Munge decode failed: Invalid credential",
"slurm_unpack_received_msg: MESSAGE_NODE_REGISTRATION_STATUS has authentication error: Invalid credential",
"slurm_receive_msg \[10.1.200.0:nnnn]: Unspecified error".
The errors indicate the daemon is contacting other IP addresses on this switch (e.g. 10.1.200.1:44140).
Or it may be looking for "Nodes=shep\[2-3]" as specified in the conf file.
So, the control node may be working ok.
The command ```sinfo``` works and shows zero nodes on partition1.
Munge is a LLNL accounting + authentication + security module.
We disabled it with AuthType=auth/none in the conf file.

In theory, the control node can also be a worker node.
We would run slurmd as well as slurmctld on the same node.
We would have to adjust the NodeName setting in the slurm.conf file.
If we run ```sudo slurmd``` on control node as is , it complains "Unable to determine this slurmd's NodeName".
This page shows how to  
[adjust configuration](https://www.mail-archive.com/slurm-dev@schedmd.com/msg10758.html).

If we start the control node first, the log shows errors about not finding workers.
If we start the worker nodes first, their logs show errors about not infing the controller.
We found it best to start one worker first.

### Start slurm worker nodes
Run ```sudo /etc/init.d/slurmd start``` on worker nodes.
Try ```scontrol show config``` to see every setting. 
For example, search the output for "Control" to see the control node name.

On workers with ControlMachine=shep1, we get error "Unable to establish control machine address"
and slurmd.log shows Unable to resolve "shep1".
We fixed this by also specifying ControlAddr=10.200.0.3 in slurm.conf on every node.

It looks like slurmd on the worker also runs slurmctld 
because we get a slurmctld.log file that says "starting slurmctld version 17.11.2"
and "this host (shep3/shep3) is not a valid controller".

Our slurmd logs indicated error: domain socket directory.
We made the error go away by creating a /var/spool/slurmd directory user=group=slurm.
The log was cleaner after the next ```sudo /etc/init.d/slurmd restart``` 
although slurm ```sinfo``` still considered the node to be down.

### Submit slurm job
Run ```sbatch test_script.sh``` on any worker node.
Run ```squeue``` to track and ```scancel <job>``` to kill.

Running ```sbatch``` on control node does not work: Unable to contact slurm controller.
Must use a worker node. Is there such a thing as a submitter node?

My first job sat there with Job State = Pending (ST=PD).
The log on control node indicated unable to find shep3.
The command ```scontrol show node shep3``` works on the worker but not the control node.
We submitted the test_script.sh script but it remained in state=pending.
The ```sinfo``` command says all node states are down.
The ```scontrol show node shep3``` command says (among other things)
Reason=NO NETWORK ADDRESS FOUND (plus the time).
The recommended solution ```scontrol update nodename=shep3 state=resume``` actually worked!
The node became "idle" then "alloc".
The pending job with state=PD entered state=R.
It generated its output file in the current directory.
However, the finished job remained in the queue with state=R forever.
Also, the slurmd log says Invalid host-index -1 for Job 6.
Googling that error, I can only find a suggested code patch from 2012.

### Finally, success!
We wrote a script to report the node name.
We had the master node give it to two worker nodes. 
It worked! 
Unfortunately, we were so excited, we didn't write down the change that made it work.
However, the 3-node grid is currently configured to run that script.
All we have to do is start it up.

## Other software to consider
* Basics
    * Building a simple Beowulf cluster. [How to](https://www-users.cs.york.ac.uk/~mjf/pi_cluster/src/Building_a_simple_Beowulf_cluster.html) by Serrano Pereira.
* MPI message passing interface
    * [Wikipedia](https://en.wikipedia.org/wiki/Message_Passing_Interface)
    * javaMPI API [spec](https://www.open-mpi.org/papers/mpi-java-spec/) (2016)
    * Intel MPI optimized for Intel CPUs (not free)
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
* MAAS
    * Not free. Sold by Ubuntu. Works with Ubuntu for Cloud and OpenStack. Manages the cluster.

## Contact
* Professor Jason Miller

