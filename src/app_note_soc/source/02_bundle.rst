Bus Bundling
=======================

Depending upon the system complexity the Wishbone bus may be bundled with a variety
of other buses. This is done to ensure that all connections are made when the master
is connected to the slave in a single connection. If the master
and slave have to use the same clock then we bundle that clock in with the wishbone bus
so that it is impossible to connect a wrong clock. This is called "Correct by construction" design technique.

The actual bus bundles will vary for each different design and design team. They are
usually created in a wrapper and customized for each design.




RESET Bus Signals
```````````````````


**WB_RST**

All embedded systems require a power on  reset to hold the design in a safe state while
power and clocks are stabilizing before booting the program. This system is also used
to recover from any error states. A watchdog circuit will detect a failure and reset
the system.

Modern SOC's can contain many different embedded systems and if one of these fail then
you only want to reset the failed system. You do not want to reset the entire design.

So modern systems use a soft reset so that you can reset a small piece of the system
while the rest is unaffected.

If you are in the middle of a wishbone cycle waiting for an ack response from a slave and
you receive a soft reset then you must also tell the slave to preform its own reset.
Otherwise the slave remains in an unknown state and is unusable.

This can be done by bundling a reset bus signal along with the wishbone bus. That way the
slave that you connect to will automatically have access to your reset signal.

The reverse is also true. A slave needs to send its reset to the master to tell is when
the slave has been reset. If this happens during a wishbone cycle then it may be done
using the Error and Retry signals. But if it happens outside of a cycle then you must send
the slaves reset signal back to the master.








CLOCK Bus
`````````````````

**WB_CLK**

The Wishbone bus is synchronous so the master and slaves must all
reside on the same clock domain. Any process that requires two separate actions to make
a change will run the risk that only one of these will occur and the design will fail.
One way to prevent this is to bundle the clock in with the wishbone bus so that connecting
the bus between two components will also pass the correct clock.










CLOCK ENABLE Bus 
````````````````````````

**WB_EN**

Cpu designers aim for the fastest clock speed that they can achieve. But the
I/O bus usually does not need to run at full cpu speed and most designers would
rather not have to design the rest of the chip for an excessively high clock
rate. A common technique is to run the I/O bus at a sub multiple of the cpu
clock and this is achieved using a clock enable signal.

Some times the cpu provides this signal to the peripheral and other times
the peripheral provides it to the cpu.



