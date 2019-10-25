Introduction
============


The introduction of the Wishbone Interconnection Architecture changed the way that engineers designed embedded systems.  
Previously designers would simply extend the cpu's native bus out to every peripheral and each IP core had to implement a specific
vendors signals and protocols. Reusing an IP core with a different vendors cpu required redesigning it's interface.

Wishbone changed all of that. You could now design to a single interface that could be used with any cpu that had a wishbone master
interface.

But Wishbone was originally created back in the 20th century and used the conventions at that time of including a port's direction in
it's signal name and connecting masters to slaves by cross wiring outputs to inputs.

That practice has not aged well. Modern designs are huge and include many embedded system designs on a variety of different clock domains.
Following the wishbone port naming convention results in buses sent up and down hierarchies that can change names in the middle of the hierarchy.
Half the time an output port will have the name that identifies it as an input and an input port name will identify it as an output.

It can be extremely confusing.

This paper details a method of extending the wishbone bus in a manner that works with modern SOC design tools. It grandfather's in the 
original wishbone names for leaf cells and only affects the design in hierarchical modules. It allows the designer to use modern
"correct-by-construction" eda tools to actually connect all the components together into a design.


We start by coming up with the new set of signal names that are used to connect wishbone masters with wishbone slaves. The port names on
a leaf cell will still use the classic names but all signals in the SOC design hierarchy  will use the new unified set.

The new signal names have two important differences:



* Each name contains the letters WB to identify it as a wishbone signal.


* The signal name does not change anywhere in the hierarchy.


The signal names are all shown in Upper Case. That is not a requirement. Each team should follow their own coding guidelines.  



Unified Wishbone Signal Names
------------------------------

The Names and connections are:

**WB_ADR()**    [ADR_O() master]  [ADR_I() slave]

**WB_CYC**      [CYC_O master]    [CYC_I slave]

**WB_SEL()**    [SEL_O() master]  [SEL_I() slave]

**WB_WE**       [WE_O master]     [WE_I slave]

**WB_STB**      [STB_O master]    [STB_I slave]

**WB_wDAT()**   [DAT_O() master]  [DAT_I() slave]

**WB_wTGD()**   [TGD_O() master]  [TGD_I() slave]

**WB_LOCK**     [LOCK_O master]   [LOCK_I slave]

**WB_TGA()**    [TGA_O()master]   [TGA_I()slave]

**WB_TGC()**    [TGC_O() master]  [TGC_I() slave]

**WB_rDAT()**   [DAT_I() master]  [DAT_O() slave]

**WB_rTGD()**   [TGD_I() master]  [TGD_O() slave]

**WB_ACK**      [ACK_I master]    [ACK_O slave]

**WB_ERR**      [ERR_I master]    [ERR_O slave]

**WB_RTY**      [RTY_I master]    [RTY_O slave]







Wishbone Bus Naming Algorithm
-----------------------------



The unified wishbone names provide a base name for every signal. When there are multiple wishbone
buses in a block we pre-pend an ad_hoc identifier to the base name to distinguish them from each other.

When porting a wishbone bus up a hierarchy we pre-pend the instance name to the base name to create
a new signal name. When the bus makes a connection between  master and slave then we use the master's
instance name.





.. _Hierarchical:
.. figure:: _static/Hierarc_names.*

   Wishbone bus naming in a hierarchical design.







   

Reverse Master and Reverse Slave
---------------------------------


The Wishbone standard defines a master used by components such as a cpu and a slave used by components such
as a uart. But you would never create a system with only a cpu connected to a uart. Masters and slaves are
usually never directly connected together, there is always some sort of switch component between them.

You could design this switch component with slave ports to connect to the masters and master ports to connect
to the slaves.

Or

You could design this switch component with reverse master ports to connect to the masters and reverse slave  ports to connect
to the slaves.


A reverse port has all the same signals but reverses the direction of the normal port. A reverse master is similar to a slave
port but there can be differences.

A design team may decide to modify the wishbone bus by decoding the upper address lines and only providing a chip_select along
with the remaining address lines. This chip_select would be part of their slave and reverse slave buses but not part of the
master.


When porting a wishbone bus up a hierarchy between a slave and a reverse slave  we pre-pend the slave instance name to the base name to create
a new signal name. 






.. _System:
.. figure:: _static/System.*

   Wishbone bus naming in a System.

