# Shepherd Grid

## Planning
* Cluster sets of identical desktop computers previously used in classrooms.
* Create a Beowulf cluster supporting distributed processing with local storage.
* Use existing rack mounting in CME server closet.
* Provision one switch and sufficient ethernet cabling.

## Network software
* SGE batch control
    * [Wikipedia](https://en.wikipedia.org/wiki/Oracle_Grid_Engine)
    * Open source
    * Commercial support by Oracle ended 2010
    * Support by [Open Grid Scheuduler](http://gridscheduler.sourceforge.net/) lacks updates since 2013
    * Commercial version by [Univa](http://www.univa.com/products/)
* Scyld ClusterWare
    * [Penguin Computing](https://www.penguincomputing.com/support/documentation/)
    * Scyld [Documentation](https://www.penguincomputing.com/documentation/scyld-clusterware/7/admin-guide/index.html)
    * [News](http://www.dataversity.net/penguin-computing-announces-scyld-clusterware-7-large-clusters/): Penguin Computing Announces Scyld ClusterWare 7 for Large Clusters (Jan 2017)
    * Support for PBS/Torque and others including SGE
* MPI message passing interface
    * [Wikipedia](https://en.wikipedia.org/wiki/Message_Passing_Interface)
    * javaMPI API [spec](https://www.open-mpi.org/papers/mpi-java-spec/) (2016)

## Node configuration
* 450 GB disk
* Win10 overwritten. If we ever needed Windows back, our department has the original Win10 image disk.
* Ubuntu.
    * We test installed Ubuntu on one node. The node now has dual boot. Booting into Ubuntu works. (5/14/18)
    * We installed Ubuntu over Windows on 3 nodes: Shep1, Shep2, Shep3. (5/21/18)
    
## Contact
* Professor Jason Miller

