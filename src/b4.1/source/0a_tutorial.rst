WISHBONE Tutorial
=================

By: Wade D. Peterson, Silicore Corporation

The WISHBONE System-on-Chip (SoC) interconnection is a method for
connecting digital circuits together to form an integrated circuit
‘chip’. This tutorial provides an introduction to the WISHBONE design
philosophy and its practical applications.

The WISHBONE architecture solves a very basic problem in integrated
circuit design. That is, how to connect circuit functions together in
a way that is simple, flexible and portable. The circuit functions
are generally provided as ‘IP Cores’ (Intellectual Property Cores),
which system integrators can purchase or make themselves.

Under this topology, IP Cores are the functional building blocks in
the system. They are available in a wide variety of functions such
as microprocessors, serial ports, disk interfaces, network controllers
and so forth. Generally, the IP cores are developed independently from
each other and are tied together and tested by a third party system
integrator. WISHBONE aides the system integrator by standardizing the
IP Core interfaces. This makes it much easier to connect the cores,
and therefore much easier to create a custom System-on-Chip.

An Introduction to WISHBONE
---------------------------

WISHBONE uses a MASTER/SLAVE architecture. That means that functional
modules with MASTER interfaces initiate data transactions to
participating SLAVE interfaces. As shown in Figure A-1, the MASTERs
and SLAVEs communicate through an interconnection interface called the
INTERCON. The INTERCON is best thought of as a ‘cloud’ that contains
circuits.  These circuits allow MASTERs to communicate with SLAVEs.

The term ‘cloud’ is borrowed from the telecom community. Oftentimes,
telephone systems are modeled as clouds that represent a system of
telephone switches and transmission devices. Telephone handsets are
connected to the cloud, and are used to make phone calls. The cloud
itself represents a network that carries a telephone call from one
location to another. The activity going on inside the cloud depends
upon where the call is made and where it is going. For example, if a
call is made to another office down the hall, then the cloud may
represent a local telephone switch located in the same
building. However, if the call is made across an ocean, then the cloud
may represent a combination of copper, fiber optic and satellite
transmission systems.

The cloud analogy is used because WISHBONE can be modeled in a similar
way. MASTER and SLAVE interfaces (which are analogous to the
telephones) communicate thorough an interconnection (which is
analogous to the telephone network ‘cloud’). The WISHBONE
interconnection network can be changed by the system integrator to
suit his or her own needs. In WISHBONE terminology this is called a
variable interconnection.

Variable interconnection allows the system integrator to change the
way in which the MASTER and SLAVE interfaces communicate with each
other. For example, a pair of MASTER and SLAVE interfaces can
communicate with point-to-point, data flow, shared bus or crossbar
switch topologies.

The variable interconnection scheme is very different from that used
in traditional microcomputer buses such as PCI, cPCI, VMEbus and ISA
bus. Those systems use printed circuit backplanes with hardwired
connectors. The interfaces on those buses can’t be changed, which
severely limits how microcomputer boards communicate with each
other. WISHBONE overcomes this limitation by allowing the system
integrator to change the system interconnection.

This is possible because integrated circuit chips have interconnection
paths that can be adjusted.  These are very flexible, and take the
form of logic gates and routing paths. These can be ‘programmed’
into the chip using a variety of tools. For example, if the
interconnection is described with a hardware description language like
VHDL or Verilog(R), then the system integrator has the ability to define
and adjust the interconnection. Interconnection libraries can also be
formed and shared.

The WISHBONE interconnection itself is nothing more than a large,
synchronous circuit. It must be designed to logically operate over a
nearly infinite frequency range. However, every integrated circuit has
physical characteristics that limit the maximum frequency of the
circuit. In WISHBONE terminology this is called a variable timing
specification. This means that a WISHBONE compatible circuit will
theoretically function normally at any speed, but that it’s maximum
speed will always be limited by the process technology of the
integrated circuit.

At Silicore Corporation we generally define our WISHBONE
interconnections using the VHDL hardware description language. These
take the form of an ASCII file that contains the VHDL language
instructions. This allows us to fully define our interconnections in a
way that best fits the application. However, it also allows us to
share our interconnections with others, who can adjust them to meet
their own needs. It’s important to note, though, that there’s nothing
magic about the interconnection itself. It’s just a file, written with
off-the-shelf tools, that fully describes the hardware in the
interconnection.

Types of WISHBONE Interconnection
---------------------------------

The WISHBONE variable interconnection allows the system integrator to
change the way that IP cores connect to each other. There are four
defined types of WISHBONE interconnection, and include:

* Point-to-point

* Data flow

* Shared bus

* Crossbar switch

A fifth possible type is the off-chip interconnection. However,
off-chip implementations generally fit one of the other four basic
types. For example, WISHBONE interfaces on two different integrated
circuits can be connected using a point-to-point interconnection.

The WISHBONE specification does not dictate how any of these are
implemented by the system integrator. That’s because the
interconnection itself is a type of IP Core interface called the
INTERCON. The system integrator can use or modify an off-the-shelf
INTERCON, or create their own.

Point-to-point Interconnection
``````````````````````````````

The point-to-point interconnection is the simplest way to connect two
WISHBONE IP cores together. As shown in Figure A-2, the
point-to-point interconnection allows a single MASTER interface to
connect to a single SLAVE interface. For example, the MASTER interface
could be on a microprocessor IP core, and the SLAVE interface could be
on a serial I/O port.

Figure A-2. The point-to-point interconnection.

Data Flow Interconnection
`````````````````````````

The data flow interconnection is used when data is processed in a
sequential manner. As shown in Figure A-3, each IP core in the data
flow architecture has both a MASTER and a SLAVE interface. Data
flows from core-to-core. Sometimes this process is called pipelining.

The data flow architecture exploits parallelism, thereby speeding up
execution time. For example, if each of the IP cores in the Figure
represents a floating point processor, then the system has three times
the number crunching potential of a single unit. This assumes, of
course, that each IP Core takes an equal amount of time to solve its
problem, and that the problem can be solved in a sequential manner. In
actual practice this may or may not be true, but it does illustrate
how the data flow architecture can provide a high degree of
parallelism when solving problems.

Shared Bus Interconnection
``````````````````````````

The shared bus interconnection is useful for connecting two or more
MASTERs with one or more SLAVEs. A block diagram is shown in Figure
A-4. In this topology a MASTER initiates a bus cycle to a target
SLAVE. The target SLAVE then participates in one or more bus cycles
with the MASTER.

An arbiter (not shown in the Figure) determines when a MASTER may gain
access to the shared bus. The arbiter acts like a ‘traffic cop’ to
determine when and how each MASTER accesses the shared resource. Also,
the type of arbiter is completely defined by the system
integrator. For example, the shared bus can use a priority or a round
robin arbiter. These grant the shared bus on a priority or equal
basis, respectively.

The main advantage to this technique is that shared interconnection
systems are relatively compact. Generally, it requires fewer logic
gates and routing resources than other configurations, especially the
crossbar switch. Its main disadvantage is that MASTERs may have to
wait before gaining access to the interconnection. This degrades the
overall speed at which a MASTER may transfer data.

The WISHBONE specification does not dictate how the shared bus is
implemented. Later on, we’ll see that it can be made either with
multiplexer or three-state buses. This gives the system integrator
additional flexibility, as some logic chips work better with
multiplexor logic, and some work better with three-state buses.

The shared bus is typically found in standard buses like PCI and
VMEbus. There, a MASTER interface arbitrates for the common shared
bus, and then communicates with a SLAVE. In both cases this is done
with three-state buses.

Crossbar Switch Interconnection
```````````````````````````````

The crossbar switch interconnection is used when connecting two or
more WISHBONE MASTERs together so that each can access two or more
SLAVEs. A block diagram is shown in Figure A-5. In the crossbar
interconnection, a MASTER initiates an addressable bus cycle to a
target SLAVE. An arbiter (not shown in the diagram) determines when
each MASTER may gain access to the indicated SLAVE. Unlike the shared
bus interconnection, the crossbar switch allows more than one MASTER
to use the interconnection (as long as two MASTERs don’t access the
same SLAVE at the same time).

Under this method, each master arbitrates for a ‘channel’ on the
switch. Once this is established, data is transferred between the
MASTER and the SLAVE over a private communication link.  The Figure
shows two possible channels that may appear on the switch. The first
connects MASTER ‘MA’ to SLAVE ‘SB’. The second connects MASTER ‘MB’ to
SLAVE ‘SA’.

The overall data transfer rate of the crossbar switch is higher than
shared bus mechanisms. For example, the figure shows two MASTER/SLAVE
pairs interconnected at the same time. If each communication channel
supports a data rate of 100 Mbyte/sec, then the two data pairs would
operate in parallel at 200 Mbyte/sec. This scheme can be expanded to
support extremely high data transfer rates.

One disadvantage of the crossbar switch is that it requires more
interconnection logic and routing resources than shared bus
systems. As a rule-of-thumb, a crossbar switch with two MASTERs and
two SLAVEs takes twice as much interconnection logic as a similar
shared bus system (with two MASTERs and two SLAVEs).

The crossbar interconnection is a typical configuration that one might
find in microcomputer buses like RACEway, SKY Channel or Myrinet.

Raceway: ANSI/VITA 5-1994. SKYchannel: ANSI/VITA 10-1995. Myrinet:
ANSI/VITA 26-1998. For more information about these standards see
www.vita.com.

The WISHBONE Interface Signals
------------------------------

WISHBONE MASTER and SLAVE interfaces can be connected together in a
number of ways.  This requires that WISHBONE interface signals and bus
cycles be designed in a very flexible and reusable manner. The signals
were defined with the following requirements:

* The signals allow MASTER and SLAVE interfaces to support
  point-to-point, data flow, shared bus and crossbar switch
  interconnections.

* The signals allow three basic types of bus cycle. These include
  SINGLE READ/WRITE, BLOCK READ/WRITE and RMW (read-modify-write) bus
  cycles. The operation of these bus cycles are described below.

* A handshaking mechanism is used so that either the MASTER or the
  participating SLAVE interface can adjust the data transfer rate during
  a bus cycle. This allows the speed of each bus cycle (or phase) to be
  adjusted by either the MASTER or the SLAVE interface. This means that
  all WISHBONE bus cycles run at the speed of the slowest interface.

* The handshaking mechanism allows a participating SLAVE to accept a
  data transfer, reject a data transfer with an error or ask the
  MASTER to retry a bus cycle. The SLAVE does this by generating the
  [ACK_O], [ERR_O] or [RTY_O] signals respectively. Every interface must
  support the [ACK_O] signal, but the error and retry acknowledgement
  signals are optional.

* All signals on MASTER and SLAVE interfaces are either inputs or
  outputs, but are never bi-directional (i.e. three-state). This is
  because some FPGA and ASIC devices do not support bi-directional
  signals. However, it is permissible (and sometimes advantageous) to
  use bi-directional signals in the interconnection logic if the target
  device supports it.

* Address and data bus widths can be altered to fit the
  application. 8, 16, 32 and 64-bit data buses, and 0-64 bit address
  buses are defined.

* As shown in Figure A-6, all signals are arranged so that MASTER and
  SLAVE interfaces can be connected directly together to form a simple
  point-to-point interface. This allows very compact and efficient
  WISHBONE interfaces to be built. For example, WISHBONE could be used
  as the external system bus on a microprocessor IP Core. However, it’s
  efficient enough so that it can be used for internal buses inside of
  the microprocessor.

* User defined signals in the form of ‘tags’ are allowed. This allows
  the system integrator to add special purpose signals to each WISHBONE
  interface. For example, the system integrator could add a parity bit
  to the address or data buses.

A comprehensive list of the WISHBONE signals and their descriptions is
given in the specification.

The WISHBONE Bus Cycles
-----------------------

There are three types of defined WISHBONE bus cycles. They include:

* SINGLE READ/WRITE
* BLOCK READ/WRITE
* READ MODIFY WRITE (RMW)

SINGLE READ/WRITE Cycle
```````````````````````

The SINGLE READ/WRITE is the most basic WISHBONE bus cycle. As the
name implies, it is used to transfer a single data operand. Figure A-7
shows a typical SINGLE READ cycle.

The WISHBONE specification shows all bus cycle timing diagrams as if
the MASTER and SLAVE interfaces were connected in a point-to-point
configuration. They also show all of the signals on the MASTER side of
the interface. This provides a standard way of describing the
interface without having to describe the whole system. For example,
the Figure shows a signal called [ACK_I], which is an input to a
MASTER interface. In this configuration it is directly connected to
[ACK_O], which is driven by the SLAVE. If the timing diagram were
shown from the perspective of the SLAVE, then the [ACK_O] signal would
have been shown. The SINGLE READ cycle operates thusly:

1. In response to clock edge 0, the MASTER interface asserts
[ADR_O()], [WE_O], [SEL_O], [STB_O] and [CYC_O].

2. The SLAVE decodes the bus cycle by monitoring its [STB_I] and
address inputs, and presents valid data on its [DAT_O()]
lines. Because the system is in a point-to-point configuration, the
SLAVE [DAT_O()] signals are connected to the MASTER [DAT_I()] signals.

3. The SLAVE indicates that it has placed valid data on the data bus
by asserting the MASTER’s [ACK_I] acknowledge signal. Also note that
the SLAVE may delay its response by inserting one or more wait
states. In this case, the SLAVE does not assert the acknowledge
line. The possibility of a wait state in the timing diagrams is
indicated by ‘-WSS-‘.

4. The MASTER monitors the state of its [ACK_I] line, and determines
that the SLAVE has acknowledged the transfer at clock edge 1.

5. The MASTER latches [DAT_I()] and negates its [STB_O] signal in
response to [ACK_I].

The SINGLE WRITE cycle operates in a similar
manner, except that the MASTER asserts [WE_O] and places data on
[DAT_O]. In this case the SLAVE asserts [ACK_O] when it has latched
the data.

BLOCK READ/WRITE Cycle
``````````````````````

The BLOCK READ/WRITE cycles are very similar to the SINGLE READ/WRITE
cycles. The BLOCK cycles can be thought of as two or more back-to-back
SINGLE cycles strung together.  In WISHBONE terminology the term cycle
refers to the whole BLOCK cycle. The small, individual data
transfers that make up the BLOCK cycle are called phases.

The starting and stopping point of the BLOCK cycles are identified by
the assertion and negation of the MASTER [CYC_O] signal
(respectively). The [CYC_O] signal is also used in shared bus and
crossbar interconnections because it informs system logic that the
MASTER wishes to use the bus. It also informs the interconnection when
it is through with its bus cycle.

READ-MODIFY-WRITE (RMW) Cycle
`````````````````````````````

The READ-MODIFY-WRITE cycle is used in multiprocessor and multitasking
systems. This special cycle allows multiple software processes to
share common resources by using semaphores. This is commonly done on
interfaces for disk controllers, serial ports and memory. As the name
implies, the READ-MODIFY-WRITE cycle reads and writes data to a memory
location in a single bus cycle. It prevents the allocation of a
common resource to two or more processes. The READ-MODIFY-WRITE
cycle can also be thought of as an indivisible cycle.

The read portion of the cycle is called the read phase, and the write
portion is called the write phase. When looking at the timing diagram
of this bus cycle, it can be thought of as a two phase BLOCK cycle
where the first phase is a read and the second phase is a write.

The READ-MODIFY-WRITE cycle is also known as an indivisible cycle
because it is designed for multiprocessor systems. WISHBONE shared bus
interconnections must be designed so that once an arbiter grants the
bus to a first MASTER, it will not grant the bus to a second MASTER
until the first MASTER gives up the bus. This allows a single MASTER
(such as a microprocessor) to read some data, modify it and then
write it back...all in a single, contiguous bus cycle. If the arbiter
were allowed to change MASTERs in the middle of the cycle, then the
two processors could incorrectly interpret the semaphore. The arbiter
does this by monitoring the [CYC_O] cycle from each MASTER on the
interconnection. The problem is averted because the [CYC_O] signal is
always asserted for the duration of the RMW cycle.

To illustrate this point, consider a two processor system with a
single disk controller. In this case each processor has a MASTER
interface, and the disk controller has a SLAVE interface. Often-
times, these systems require that only one processor access the disk
at any given time 6 . To satisfy this requirement, a semaphore bit
somewhere in memory is assigned to act as a ‘traffic cop’ between the
two processors. If the bit is cleared, then the disk is available for
use. If it’s set, then the disk controller is busy.


This is a common requirement to prevent one form of disk
‘thrashing’. In this case, if both processors were allowed to access
the disk during the same time interval, then one processor could
request data from one sector of the disk while the other requested
data from another sector. This could cause a situation where the disk
head is constantly moved between the two locations, thereby
degrading its performance or causing it to fail altogether.

Now consider a system where the two processors both need to use the
disk. We’ll call them processor #0 and processor #1. In order for
processor #0 to acquire the disk it first reads and stores the state
of the semaphore bit, and then sets the bit by writing back to
memory. The reading and setting of the bit takes place inside of a
single RMW cycle.

Once the processor is done with the semaphore operation, it checks the
state of the bit it read during the first phase of the RMW cycle. If
the bit is clear it goes ahead and uses the disk controller. If the
other processor attempts to use the disk controller at this time, it
reads a ‘1’ from the semaphore, thereby preventing it from accessing
the disk controller. When the first processor (#0) is done with the
disk controller, it simply clears the semaphore bit by writing a ‘0’
to it.  This allows the other processor to gain access to the
controller the next time it checks the semaphore.

Now consider the same situation, except where the semaphore is set and
cleared using a SINGLE READ cycle followed by a SINGLE WRITE cycle. In
this case it is possible for both processors to gain access to the
disk controller at the same time...a situation that would crash the
system.  That’s because the arbiter can grant the bus in the following
order:

* Processor #0 reads ‘0’ from the semaphore bit.
* Processor #1 reads ‘0’ from the semaphore bit.
* Processor #0 writes ‘1’ to the semaphore bit.
* Processor #1 writes ‘1’ to the semaphore bit.

This leads to a system crash because both processors read a ‘0’ from
the semaphore bit, thereby causing both to access the disk controller.

It is important to note that a processor (or other device connected to
the MASTER interface) must support the RMW cycle in order for this to
be effective. This is generally done with special instructions that
force a RMW bus cycle. Not all processors do this. A good example is
the 680XX family of microprocessors. These use special compare-and-set
(CAS) and test-and-set (TAS) instructions to generate RMW cycles, and
to do the semaphore operations.

Endian
------

The WISHBONE specification regulates the ordering of data. This is
because data can be presented in two different ways. In the first
way, the most significant byte of an operand is placed at the higher
(bigger) address. In the second way, the most significant byte of an
operand can be placed at the lower (smaller) address. These are called
BIG ENDIAN and LITTLE ENDIAN data operands, respectively. WISHBONE
supports both types.

ENDIAN becomes an issue when the granularity of a WISHBONE port is
smaller than the operand size. For example, a 32-bit port can have
an 8-bit (BYTE wide) granularity. This results in a fairly ambiguous
situation where the most significant byte of the 32-bit operand could
be placed at the higher or lower byte address of the port. However,
ENDIAN is not an issue when the granularity and port size are the
same.

The system integrator may wish to connect a BIG ENDIAN interface to a
LITTLE ENDIAN inteface. In many cases the conversion is quite
straightforward, and does not require any exotic conversion
logic. Furthermore, the conversion does not create any speed
degradation in the interface. In general, the ENDIAN conversion
takes place by renaming the data and select I/O signals at a MASTER
or SLAVE interface.

Figure A-8 shows a simple example where a 32-bit BIG ENDIAN MASTER
output (CORE ‘A’) is connected to a 32-bit LITTLE ENDIAN SLAVE input
(CORE ‘B’). Both interfaces have 32-bit operand sizes and 8-bit
granularities. As can be seen in the diagram, the ENDIAN conversion is
accomplished by cross coupling the data and select signal arrays. This
is quite simple since the conversion is accomplished at the
interconnection level, or using a wrapper. This is especially simple
in soft IP cores using VHDL or Verilog hardware description
languages, as it only requires the renaming of signals.

In some cases the address lines may also need to be modified between
the two cores. For example, if 64-bit operands are transferred
between two cores with 8-bit port sizes, then the address lines may
need to be modified as well.

SLAVE I/O Port Examples
-----------------------

In this section we’ll investigate several examples of WISHBONE
interface for SLAVE I/O ports.  Our purpose is to:

* Show some simple examples of how the WISHBONE interface operates.

* Demonstrate how simple interfaces work in conjunction with standard
  logic primitives on FPGA and ASIC devices. This also means that very
  little logic is needed to implement the WISHBONE interface.

* Demonstrate the concept of granularity.

* Provide some portable design examples.

* Give examples of the WISHBONE DATASHEET.

* Show VHDL implementation examples.

Simple 8-bit SLAVE Output Port
------------------------------

Figure A-9 shows a simple 8-bit WISHBONE SLAVE output port. The entire
interface is implemented with a standard 8-bit ‘D-type’ flip-flop
register (with synchronous reset) and a single AND gate. During write
cycles, data is presented at the data input bus [DAT_I(7..0)], and is
latched at the rising edge of [CLK_I] when [STB_I] and [WE_I] are both
asserted.

Figure A-9. Simple 8-bit WISHBONE SLAVE output port.

The state of the output port can be monitored by a MASTER by routing
the output data lines back to [DAT_O(7..0)]. During read cycles the
AND gate prevents erroneous data from being latched into the register.

This circuit is highly portable, as all FPGA and ASIC target devices
support D-type flip-flops with clock enable and synchronous reset
inputs.

The circuit also demonstrates how the WISHBONE interface requires
little or no logic overhead.  In this case, the WISHBONE interface
does not require any extra logic gates whatsoever. This is because
WISHBONE is designed to work in conjunction with standard, synchronous
and combinatorial logic primitives that are available on most FPGA
and ASIC devices.

The WISHBONE specification requires that the interface be
documented. This is done in the form of the WISHBONE DATASHEET. The
standard does not specify the form of the datasheet. For example, it
can be part of a comment field in a VHDL or Verilog source file or
part of a technical reference manual for the IP core. Table A-1 shows
one form of the WISHBONE DATASHEET for the 8-bit output port circuit.

The purpose of the WISHBONE DATASHEET is to promote design reuse. It
forces the originator of the IP core to document how the interface
operates. This makes it easier for another person to re-use the
core.

Table A-1. WISHBONE DATASHEET for the 8-bit output port example.

+----------------------------------+---------------------------------+
| Description                      | Specification                   |
+----------------------------------+---------------------------------+
| General description:             | 8-bit SLAVE output port.        |
+----------------------------------+---------------------------------+
|                                  | SLAVE, READ/WRITE               |
| Supported cycles:                | SLAVE, BLOCK READ/WRITE         |
|                                  | SLAVE, RMW                      |
+----------------------------------+---------------------------------+
| Data port, size:                 | 8-bit                           |
| Data port, granularity:          | 8-bit                           |
| Data port, maximum operand size: | 8-bit                           |
| Data transfer ordering:          | Big endian and/or little endian |
| Data transfer sequencing:        | Undefined                       |
+----------------------------------+--------------+------------------+
|                                  | Signal Name  |  WISHBONE Equiv. |
+----------------------------------+--------------+------------------+
|                                  | ACK_O        | ACK_O            |
|                                  | CLK_I        | CLK_I            |
| Supported signal list and        | DAT_I(7..0)  | DAT_I()          |
| cross reference                  | DAT_O(7..0)  | DAT_O()          |
| to equivalent WISHBONE signals:  | RST_I        | RST_I            |
|                                  | STB_I        | STB_I            |
|                                  | WE_I         | WE_I             |
+----------------------------------+--------------+------------------+

Figure A-10 shows a VHDL implementation of same circuit. The WBOPRT08
entity implements the all of the functions shown in the schematic
diagram of Figure A-9.

::

  library ieee;
  use ieee.std_logic_1164.all;

  entity WBOPRT08 is
    port(
      -- WISHBONE SLAVE interface:

      ACK_O : out std_logic;
      CLK_I : in  std_logic;
      DAT_I : in  std_logic_vector( 7 downto 0 );
      DAT_O : out std_logic_vector( 7 downto 0 );
      RST_I : in  std_logic;
      STB_I : in  std_logic;
      WE_I  : in  std_logic;

      -- Output port (non-WISHBONE signals):
      PRT_O : out std_logic_vector( 7 downto 0 )
    );
  end entity WBOPRT08;

  architecture WBOPRT081 of WBOPRT08 is
    signal Q: std_logic_vector( 7 downto 0 );
  begin
    REG: process( CLK_I )
    begin
      if( rising_edge( CLK_I ) ) then
        if( RST_I = '1' ) then
          Q <= B"00000000";
        elsif( (STB_I and WE_I) = '1' ) then
          Q <= DAT_I( 7 downto 0 );
        else
          Q <= Q;
        end if;
      end if;
    end process REG;

    ACK_O <= STB_I;
    DAT_O <= Q;
    PRT_O <= Q;
  end architecture WBOPRT081;

Figure A-10. VHDL implementation of the 8-bit output port interface.

Simple 16-bit SLAVE Output Port With 16-bit Granularity
```````````````````````````````````````````````````````

Figure A-11 shows a simple 16-bit WISHBONE SLAVE output port. Table
A-2 shows the WISHBONE DATASHEET for this design. It is identical to
the 8-bit port shown earlier, except that the data bus is wider. Also,
this port has 16-bit granularity. In the next section, it will be
compared to a 16-bit port with 8-bit granularity.

Figure A-11. Simple 16-bit WISHBONE SLAVE output port with 16-bit granularity

Table A-2. WISHBONE DATASHEET for the 16-bit output port with 16-bit
granularity.

+----------------------------------+---------------------------------+
| Description                      |  Specification                  |
+----------------------------------+---------------------------------+
| General description:             | 16-bit SLAVE output port.       |
+----------------------------------+---------------------------------+
|                                  | SLAVE, READ/WRITE               |
| Supported cycles:                | SLAVE, BLOCK READ/WRITE         |
|                                  | SLAVE, RMW                      |
+----------------------------------+---------------------------------+
| Data port, size:                 | 16-bit                          |
| Data port, granularity:          | 16-bit                          |
| Data port, maximum operend size: | 16-bit                          |
| Data transfer ordering:          | Big endian and/or little endian |
| Data transfer sequencing:        | Undefined                       |
+----------------------------------+---------------+-----------------+
|                                  | Signal Name   | WISHBONE Equiv. |
+----------------------------------+---------------+-----------------+
|                                  | ACK_O         | ACK_O           |
|                                  | CLK_I         | CLK_I           |
| Supported signal list and cross  | DAT_I(15..0)  | DAT_I()         |
| reference                        | DAT_O(15..0)  | DAT_O()         |
| to equivalent WISHBONE signals:  | RST_I         | RST_I           |
|                                  | STB_I         | STB_I           |
|                                  | WE_I          | WE_I            |
+----------------------------------+---------------+-----------------+

Simple 16-bit SLAVE Output Port With 8-bit Granularity
``````````````````````````````````````````````````````

Figure A-12 shows a simple 16-bit WISHBONE SLAVE output port. This
port has 8-bit granularity, which means that data can be transferred
8 or 16-bits at a time.

Figure A-12. Simple 16-bit WISHBONE SLAVE output port with 8-bit granularity.

This circuit differs from the aforementioned 16-bit port because it
has 8-bit granularity. This means that the 16-bit register can be
accessed with either 8 or 16-bit bus cycles. This is accomplished by
selecting the high or low byte of data with the select lines
[SEL_I(1..0)]. When [SEL_I(0)] is asserted, the low byte is
accessed. When [SEL_I(1)] is asserted, the high byte is accessed. When
both are asserted, the entire 16-bit word is accessed.

The circuit also demonstrates the proper use of the [STB_I] and
[SEL_I()] lines for slave devices. The [STB_I] signal operates much
like a chip select signal, where the interface is selected when
[STB_I] is asserted. The [SEL_I()] lines are only used to determine
where data is placed by the MASTER or SLAVE during read and write
cycles.

In general, the [SEL_I()] signals should never be used by the SLAVE to
determine when the IP core is being accessed by a master. They should
only be used to determine where data is placed on the data input and
output buses. Stated another way, the MASTER will assert the select
signals [SEL_O()] during every bus cycle, but a particular slave is
only accessed when it monitors that its [STB_I] input is
asserted. Stated another way, the [STB_I] signal is generated by
address decode logic within the WISHBONE interconnect, but the
[SEL_I()] signals may be broadcasted to all SLAVE devices.

Table A-3 shows the WISHBONE DATASHEET for this IP core. This is very
similar to the 16-bit data port with 16-bit granularity, except that
the granularity has been changed to 8-bits.

It should also be noted that the datasheet specifies that the circuit
will work with READ/WRITE, BLOCK READ/WRITE and RMW cycles. This means
that the circuit will operate normally when presented with these
cycles. It is left as an exercise for the user to verify that the
circuit will indeed work with all three of these cycles.

Table A-3. WISHBONE DATASHEET for the 16-bit output port with 8-bit
granularity.

+----------------------------------+------------------------------------+
| Description                      |  Specification                     |
+----------------------------------+------------------------------------+
| General description:             | 16-bit SLAVE output port with 8-bit|
|                                  | granularity.                       |
+----------------------------------+------------------------------------+
|                                  | SLAVE, READ/WRITE                  |
| Supported cycles:                | SLAVE, BLOCK READ/WRITE            |
|                                  | SLAVE, RMW                         |
+----------------------------------+------------------------------------+
| Data port, size:                 | 16-bit                             |
| Data port, granularity:          | 8-bit                              |
| Data port, maximum operand size: | 16-bit                             |
| Data transfer ordering:          | Big endian and/or little endian    |
| Data transfer sequencing:        | Undefined                          |
+----------------------------------+-----------------+------------------+
|                                  | Signal Name     | WISHBONE Equiv.  |
+----------------------------------+-----------------+------------------+
|                                  | ACK_O           | ACK_O            |
|                                  | CLK_I           | CLK_I            |
| Supported signal list and cross  | DAT_I(15..0)    | DAT_I()          |
| reference                        | DAT_O(15..0)    | DAT_O()          |
| to equivalent WISHBONE signals:  | RST_I           | RST_I            |
|                                  | STB_I           | STB_I            |
|                                  | WE_I            | WE_I             |
+----------------------------------+-----------------+------------------+

Figure A-13 shows a VHDL implementation of same circuit. The WBOPRT16
entity implements the all of the functions shown in the schematic
diagram of Figure A-12.

::

   entity WBOPRT16 is
     port(
       -- WISHBONE SLAVE interface:
       ACK_O: out std_logic;
       CLK_I: in  std_logic;
       DAT_I: in  std_logic_vector( 15 downto 0 );
       DAT_O: out std_logic_vector( 15 downto 0 );
       RST_I: in  std_logic;
       SEL_I: in  std_logic_vector( 1 downto 0 );
       STB_I: in  std_logic;
       WE_I : in  std_logic;

       -- Output port (non-WISHBONE signals):
       PRT_O: out std_logic_vector( 15 downto 0 )
     );
   end entity WBOPRT16;

   architecture WBOPRT161 of WBOPRT16 is
      signal QH: std_logic_vector( 7 downto 0 );
      signal QL: std_logic_vector( 7 downto 0 );
   begin
      REG: process( CLK_I )
      begin
         if( rising_edge( CLK_I ) ) then
            if( RST_I = '1' ) then
              QH <= B"00000000";
            elsif( (STB_I and WE_I and SEL_I(1)) = '1' ) then
              QH <= DAT_I( 15 downto 8 );
            else
              QH <= QH;
            end if;
         end if;
         if( rising_edge( CLK_I ) ) then
            if( RST_I = '1' ) then
              QL <= B"00000000";
            elsif( (STB_I and WE_I and SEL_I(0)) = '1' ) then
              QL <= DAT_I( 7 downto 0 );
            else
              QL <= QL;
            end if;
         end if;
      end process REG;
      ACK_O <= STB_I;
      DAT_O( 15 downto 8) <= QH;
      DAT_O( 7 downto  0) <= QL;
      PRT_O( 15 downto 8) <= QH;
      PRT_O( 7 downto  0) <= QL;
   end architecture WBOPRT161;

Figure A-13. VHDL implementation of the 16-bit output port with 8-bit
granularity.

WISHBONE Memory Interfacing
---------------------------

In this section we’ll examine WISHBONE memory interfacing and present
some examples. The purpose of this section is to:

* Introduce the FASM synchronous RAM and ROM models.
* Show a simple example of how the WISHBONE interface operates.
* Demonstrate how simple interfaces work in conjunction with standard
  logic primitives on FPGA and ASIC devices. This also means that very
  little logic (if any) is needed to implement the WISHBONE interface.
* Present a WISHBONE DATASHEET example for a memory element.
* Describe portability issues with regard to FPGA and ASIC memory elements.

FASM Synchronous RAM and ROM Model
``````````````````````````````````

The WISHBONE interface can be connected to any type of RAM or ROM
memory. However, some types will be faster and more efficient than
others. If the memory interface closely resembles the WISHBONE
interface, then everything will run very fast. If the memory is
significantly different than WISHBONE, then everything will slow
down. This is such a fundamental and important issue that both the
WISHBONE interface and its bus cycles were designed around the most
common memory interface that could be found.

This was very problematic in the original WISHBONE concept. That’s
because there are very few portable RAM and ROM types used across all
both FPGA and ASIC devices. In fact, the most common memory type that
could be found are what we call ‘FASM’, or the FPGA and ASIC Subset
Model 7 .

The FASM synchronous RAM model conforms to the connection and timing
diagram shown in Figure A-14. The WISHBONE bus cycles all are designed
to interface directly to this type of RAM. During write cycles, FASM
Synchronous RAM stores input data at the indicated address
whenever: (a) the write enable (WE) input is asserted, and (b) there
is a rising clock edge.

During read cycles, FASM Synchronous RAM works like an asynchronous
ROM. Data is fetched from the address indicated by the ADR() inputs,
and is presented at the data output (DOUT). The clock input is
ignored. However, during write cycles, the output data is updated
immediately during a write cycle.

A good exercise for the user is to compare the FASM Synchronous RAM
cycles to the WISHBONE SINGLE READ/WRITE, BLOCK READ/WRITE and
READ-MODIFY-WRITE cycles.  You will find that these three bus cycles
operate in an identical fashion to the FASM Synchronous RAM
model. They are so close, in fact, that FASM RAMs can be interfaced to
WISHBONE with as little as one NAND gate.

7 The original FASM model actually encompasses many type of devices,
but in this tutorial we’ll focus only on the FASM synchronous RAM and
ROM models.

While most FPGA and ASIC devices will provide RAM that follows the
FASM guidelines, you will probably find that most devices also support
other types of memories as well. For example, in some brands of FPGA
you will find block memories that use a different interface. Some of
these will still interface very smoothly to WISHBONE, while others
will introduce a wait-state.  In all cases that we found, all FPGAs
and most ASICs did support at least one style of FASM memory.

Figure A-14. Generic FASM synchronous RAM connection and timing diagram.

The FASM ROM closely resembles the FASM RAM during its read
cycle. FASM ROM conforms to the connection and timing diagram shown
in Figure A-15.

Figure A-15. FASM asynchronous ROM connection and timing diagram.

Simple 16 x 8-bit SLAVE Memory Interface
````````````````````````````````````````

Figure A-16 shows a simple 8-bit WISHBONE memory. The 16 x 8-bit
memory is formed from two 16 x 4-bit FASM compatible synchronous
memories. Besides the memory elements, the entire interface is
implemented with a single AND gate. During write cycles, data is
presented at the data input bus [DAT_I(7..0)], and is latched at the
rising edge of [CLK_I] when [STB_I] and [WE_I] are both
asserted. During read cycles, the memory output data (DO) is made
available at the data output port [DAT_O(7..0)].

Figure A-16. Simple 16 x 8-bit SLAVE memory.

The memory circuit does not have a reset input. That’s because most
RAM memories do not have a reset capability.

The circuit also demonstrates how the WISHBONE interface requires
little or no logic overhead.  In this case, the WISHBONE interface
requires a single AND gate. This is because WISHBONE is designed to
work in conjunction with standard, synchronous and combinatorial logic
primitives that are available on most FPGA and ASIC devices.

The WISHBONE specification requires that the interface be
documented. This is done in the form of the WISHBONE DATASHEET. The
standard does not specify the form of the datasheet. For example, it
can be part of a comment field in a VHDL or Verilog source file or
part of a technical reference manual for the IP core. Table A-4 shows
one form of the WISHBONE DATASHEET for the 16 x 8-bit memory IP core.

The purpose of the WISHBONE DATASHEET is to promote design reuse. It
forces the originator of the IP core to document how the interface
operates. This makes it easier for another person to re-use the
core.

Table A-4. WISHBONE DATASHEET for the 16 x 8-bit SLAVE memory.

+----------------------------------+----------------------------------------+
| Description                      | Specification                          |
+----------------------------------+----------------------------------------+
| General description:             | 16 x 8-bit memory IP core.             |
+----------------------------------+----------------------------------------+
|                                  | SLAVE, READ/WRITE                      |
| Supported cycles:                | SLAVE, BLOCK READ/WRITE                |
|                                  | SLAVE, RMW                             |
+----------------------------------+----------------------------------------+
| Data port, size:                 | 8-bit                                  |
| Data port, granularity:          | 8-bit                                  |
| Data port, maximum operand size: | 8-bit                                  |
| Data transfer ordering:          | Big endian and/or little endian        |
| Data transfer sequencing:        | Undefined                              |
+----------------------------------+----------------------------------------+
| Clock frequency constraints:     | NONE (determined by memory primitive)  |
+----------------------------------+------------------+---------------------+
|                                  | Signal Name      | WISHBONE Equiv.     |
|                                  | ACK_O            | ACK_O               |
|                                  | ADR_I(3..0)      | ADR_I()             |
| Supported signal list and cross  | CLK_I            | CLK_I               |
| reference                        | DAT_I(7..0)      | DAT_I()             |
| to equivalent WISHBONE signals:  | DAT_O(7..0)      | DAT_O()             |
|                                  | STB_I            | STB_I               |
|                                  | WE_I             | WE_I                |
+----------------------------------+------------------+---------------------+
|                                  | Circuit assumes the use of synchronous |
| Special requirements:            | RAM primitives with asynchronous read  |
|                                  | capability.                            |
+----------------------------------+----------------------------------------+

Memory Primitives and the [ACK_O] Signal
````````````````````````````````````````

Memory primitives, specific to the FPGA or ASIC target device, are
usually used for the RAM storage elements. That’s because most
high-level languages (such as VHDL and Verilog(R)) don’t synthesize
these very efficiently. For this reason, the user should verify that
the memory primitives are available for the target device.

The memory circuits shown above are highly portable, but do assume
that FASM compatible memories are available. During write cycles, most
synchronous RAM primitives latch the input data when at the rising
clock edge when the write enable input is asserted. However, during
read cycles the RAM primitives may behave in different ways.

There are two types of RAM primitives that are generally found on FPGA
and ASIC devices: (a) those that synchronously present data at the
output after the rising edge of the clock input, and
(b) those that asynchronously present data at the output after the address is presented to the RAM
element.

The circuit assumes that the RAM primitive is the FASM, asynchronous
read type. That’s because during read cycles the WISHBONE interface
assumes that output data is valid at the rising

[CLK_I] edge following the assertion of the [ACK_O] output. Since the
circuit ties the [STB_I] signal back to the [ACK_O] signal, the
asynchronous read RAM is needed on the circuit shown here.

For this reason, if synchronous read type RAM primitives are used,
then the circuit must be modified to insert a single wait-state during
all read cycles. This is quite simple to do, and only requires an
additional flip-flop and gate in the [ACK_O] circuit.

Furthermore, it can be seen that the circuit operates faster if the
asynchronous read type RAM primitives are used. That’s because the
[ACK_O] signal can be asserted immediately after the assertion of
[STB_I]. If the synchronous read types are used, then a single-clock
wait-state must be added.

Customization with Tags and TAG TYPEs
-------------------------------------

One fundamental problem with traditional microcomputer buses is that
they can’t be customized very easily. That’s because they rely on
fixed printed circuit boards and connectors. Customization of these
components are costly (in terms of time and money) and very often
result in system components that aren’t compatible.

SoC interconnections like WISHBONE are much easier to
customize. That’s because their interconnections are programmable in
FPGA and ASIC target devices. Furthermore, they are supported by a
rich set of development tools such as the VHDL and Verilog hardware
description languages, as well as a wide variety of routing
tools. These make it possible to quickly change the
interface. However, this can also lead to incompatible interfaces.

WISHBONE allows MASTER and SLAVE interfaces to be customized, while
still retaining a highly compatible interface. This is accomplished
with a technique known as a tagged architecture. This technique is not
new to the microcomputer bus industry. The IEEE Authoritative
Dictionary defines it as: a computer architecture in which each word
is ‘tagged’ as either an instruction or a unit of data. A similar
concept is used by WISHBONE.

Custom tags can be added to the WISHBONE interface as long as they
conform to something called a TAG TYPE. There are three general TAG
TYPEs defined by WISHBONE. They include an address tag, a set of
data tags and a cycle tag. When a custom signal is added to a WISHBONE
interface it is assigned a TAG TYPE. This indicates the exact timing
that the signal must adhere to. Table A-5 shows some examples for
each of the TAG TYPEs.

Table A-5. TAG TYPE examples.


+--------------+----------------------+-------------------+-------------------+
| General Type | Address Tag          | Data Tag          | Cycle Tag         |
| of tag       |                      |                   |                   |
| (MASTER):    |                      |                   |                   |
+--------------+----------------------+-------------------+-------------------+
| Assigned     |                      |                   |                   |
| TAG TYPE:    | TGA_O()              | TGD_I() & TGD_O() | TGC_O()           |
+--------------+----------------------+-------------------+-------------------+
| Examples:    | Address width (e.g.  | Parity bits       | Cycle type (e.g.  |
|              | 16-bit, 24-bit etc.) | Error correction  | SINGLE, BLOCK     |
|              | Memory manage-       | codes (ECC)       | and RMW cycles)   |
|              | ment (e.g. user vs.  | Time stamps       | Cache control     |
|              | protected address)   | Endian type       | Interrupt acknowl-|
|              |                      | Size of data      | edge cycles       |
|              |                      | accepted by SLAVE | Instruction vs.   |
|              |                      |                   | data cycles       |
+--------------+----------------------+-------------------+-------------------+

For example, consider a MASTER interface that is adapted to generate a
parity bit called [PAR_O]. Since this signal modifies the output data
bus, it would be assigned a data TAG TYPE of: TGD_O(). If the MASTER’s
input bus were similarly modified, it would be assigned a TAG TYPE of:
TGD_O(). Assignment of the TAG TYPE does two things: (a) it links the
parity bit [PAR_O] to the data bus and (b) it defines the exact
timing during SINGLE, BLOCK and RMW bus cycles. However, the creator
of the MASTER interface would still need to define the operation of
[PAR_O] in the WISHBONE DATASHEET.

Also note that the [TGD_O()] TAG TYPE is an array (i.e. it includes a
parenthesis), while the [PAR_O] tag is not arrayed. This is allowed
under the WISHBONE specification.

Point-to-point Interconnection Example
--------------------------------------

Now that we’ve reviewed some of the WISHBONE basics, it’s time to try
them out with a simple example. In this section we’ll create a
complete WISHBONE system with a point-to-point interconnection. The
system includes a 32-bit MASTER interface to a DMA 8 unit, and a
32-bit SLAVE interface to a memory. In this example the DMA transfers
data to and from the memory using block transfer cycles.

The purpose of this system is to create a portable benchmarking
device. Although the system is very simple, it does allow the user to
determine the typical maximum speeds and minimum sizes on any given
FPGA or ASIC target device 9 .

8
DMA: Direct Memory Access.

9 Benchmarking can be a difficult thing to do. On this system the
philosophy was to create a ‘real-world’ SoC that estimates ‘typical
maximum’ speeds and ‘typical minimum’ size. It’s akin to the ‘flight
envelope’ of an airplane. A flight envelope is a graph that shows the
altitude vs. the speed of the aircraft. It’s one ‘benchmark’ for the
airplane.  While the graph may show that the airplane is capable of
flying at MACH 2.3 at an altitude of 28,000 meters, it may never
actually fly in that situation during its lifetime. The graph is
simply a tool for quickly understanding the engineering limits of
the design. The same is true for the WISHBONE benchmarks given in this
tutorial. However, having said this it is important to remember that
the benchmarks are real systems, and do include all of the logic and
routing resources needed to implement the design.

Source code for this example can be found in the WISHBONE Public
Domain Library for VHDL (under ‘EXAMPLE1’ in the EXAMPLES folder). The
library also has detailed documentation for the library modules,
including detailed circuit descriptions and timing diagrams for the
INTERCON, SYSCON, DMA and memory modules. The reader is encouraged to
review and experiment with all of these files.

Figure A-17 shows the system. The WISHBONE interconnection system
(INTERCON) can be found in file ICN0001a. That system connects a
simple DMA MASTER (DMA0001a) to an 8 x 32-bit register based memory
SLAVE (MEM0002a). The reset and clock signals are generated by system
controller SYSCON (SYC0001a).

This system was synthesized and routed on two styles of Xilinx 10
FPGA: the Spartan 2 and the Virtex 2. For benchmarking purposes the
memories were altered so that they used Xilinx distributed RAMs
instead of the register RAMs in MEM0002a. A memory interface for the
Xilinx RAMs can be found in MEM0001a, which is substituted for
MEM0002a.

10
Xilinx is a registered trademark of Xilinx, Inc.

It should be noted that the Xilinx distributed RAMs are quite
efficient on the WISHBONE interface. As can be seen in the source
code, only a single ‘AND’ gate was needed to interface the RAM to
WISHBONE.

The system for the Xilinx Spartan 2 was synthesized and operated on a
Silicore evaluation board.  This was a ‘reality check’ that verified
that things actually routed and worked as expected. Some of the common
signals were brought out to test points on the evaluation board. These
were monitored with an HP54620a logic analyzer to verify the
operation. Figure A-18 shows an example trace from the logic
analyzer. Address lines, data write lines and several control signals
were viewed. That Figure shows a write cycle with eight phases
followed by a read cycle with eight phases. The data lines always show
0x67 because that’s the data transferred by the DMA in this example.

Table A-6 shows the speed of the system after synthesis and
routing. The Spartan 2 benchmarked at about 428 Mbyte/sec, and was
tested in hardware (HW TEST). The Virtex 2 part was synthesized and
routed, but was only tested under software (SW TEST).

Table A-6. 32-bit Point-to-point Interconnection Benchmark Results

+------------+-----------------+------+------+----------+-----------+---------+---------------+
| MFG & Type |  Part Number    | HW   | SW   | Size     | Timing    | Actual  | Data          |
|            |                 | TEST | TEST |          | Constraint| Speed   | Transfer      |
|            |                 |      |      |          | (MIN)     | (MAX)   | Rate (MAX)    |
+------------+-----------------+------+------+----------+-----------+---------+---------------+
| Xilinx     | XC2S50-5-PQ208C | X    |      | 53 SLICE | 100 MHz   | 107 MHz | 428 Mbyte/sec |
| Spartan 2  |                 |      |      |          |           |         |               |
| (FPGA)     |                 |      |      |          |           |         |               |
+------------+-----------------+------+------+----------+-----------+---------+---------------+
| Xilinx     | XC2V40-4-FG256C |      | X    | 53 SLICE | 200 MHz   | 203 MHz | 812 Mbyte/sec |
| Virtex 2   |                 |      |      |          |           |         |               |
| (FPGA)     |                 |      |      |          |           |         |               |
+------------+-----------------+------+------+----------+-----------+---------+---------------+

Notes:
VHDL synthesis tool: Altium Accolade PeakFPGA 5.30a
Router: Xilinx Alliance 3.3.06I_V2_SE2
Hardware evaluation board: Silicore 170101-00 Rev 1.0
Listed size was reported by the router.
Spartan 2 test used ‘-5’ speed grade part (slower than the faster ‘-6’ part).

11 The logic analyzer samples at 500 Mhz, so the SoC was slowed down
to make the traces look better. This trace was taken with a SoC clock
speed of 5 MHz. Slowing the clock down is also a good way to verify
that the speed of the WISHBONE interface can be ‘throttled’ up and
down.

Shared Bus Example
------------------

Now that we’ve built a WISHBONE point-to-point interconnection, it’s
time to look at a more complex SoC design. In this example, we’ll
create a 32-bit shared bus system with four MASTERs and four
SLAVEs. Furthermore, we’ll re-use the same DMA, memory and SYSCON
modules that we used in the point-to-point interconnection example
above. This will demonstrate how WISHBONE interfaces can be adapted
to many different system topologies.

This example will require the introduction of some new concepts. As
the system integrator, we’ll need to make some decisions about how we
want our system to work. After that, we’ll need to create the various
parts of the design in order to finish the job. Some of the decisions
and tasks include:

* Choosing between multiplexed and non-multiplexed bus topology.
* Choosing between three-state and multiplexor based interconnection logic.
* Creating the interconnection topology.
* Creating an address map (using variable address decoding).
* Creating a four level round-robin arbiter.
* Creating and benchmarking the system.

Choosing Between Multiplexed and Non-multiplexed Bus Topology
`````````````````````````````````````````````````````````````

The first step in designing a shared bus is to determine how we’ll
move our data around the system. In this section we’ll explore
multiplexed and non-multiplexed buses, and explore some of the
trade-offs between them.

The big advantage of multiplexed buses is that they reduce the number
of interconnections by routing different types of data over the same
set of signal lines. The most common form of multiplexed bus is
where address and data lines share a common set of signals. A
multiplexed bus is shown in Figure A-19. For example, a 32-bit address
bus and 32-bit data bus can be combined to form a 32-bit common
address/data bus. This reduces the number of routed signals from 64
to 32.

The major disadvantage of the multiplexed bus is that it takes twice
as long to move the information. In this case a non-multiplexed,
synchronous bus can generally move address and data information in
as little as one clock cycle. Multiplexed address and data buses
require at least two clock cycles to move the same information.

Since we’re creating a benchmarking system that is optimized for
speed, we’ll use the non-multiplexed scheme for this example. This
will allow us to move one data operand during every clock cycle.

It should be noted that multiplexed buses have long been used in the
electronics industry. In semiconductor chips the technique is used to
reduced the number of pins on a chip. In the microcomputer bus
industry the technique is often used to reduce the number of backplane
connector pins.

Choosing Between Three-State and Multiplexor Interconnection Logic
``````````````````````````````````````````````````````````````````

WISHBONE interconnections can use three-state 12 or multiplexor logic
to move data around a SoC. The choice depends on what makes sense in
the application, and what’s available on the integrated circuit.

Three-state I/O buffers have long been used in the semiconductor and
microcomputer bus industries. These reduce the number of signal pins
on an interface. In microcomputer buses with master-slave
architectures, the master that ‘owns’ the bus turns its buffers ‘on’,
while the other master(s) turn their buffers ‘off’ 13 . This prevents
more than one bus master from driving any signal line at any given
time. A similar situation also occurs at the slave end. There, a slave
that participates in a bus cycle enables its output buffers during
read cycles.

In WISHBONE, all IP core interfaces have ‘in’ and ‘out’ signals on the
address, data and other internal buses. This allows the interface to
be adapted to point-to-point, multiplexed and three-state I/O
interconnections. Figure A-20 shows how the ‘in’ and ‘out’ signals can
be connected to a three-state I/O bus 14 .

12 Three-state buffers are sometimes called Tri-State(R)
buffers. Tri-State is a registered trademark of National
Semiconductor Corporation.

13 Here, ‘on’ and ‘off’ refer to the three-state and non three-state
conditions, respectively.

14 Also note that the resistor/current source shown in the figure can
also be a pull-down resistor or a bus terminator, or eliminated
altogether.

Figure A-20. Connection of a data bus bit to a three-state interconnection.

A simple SoC interconnection that uses three-state I/O buffers is
shown in the block diagram of Figure A-21(a). There, the data buses on
two master and two slave modules are interconnected with three-state
logic. However, this approach has two major drawbacks. First, it is
inherently slower than direct interconnections. That’s because there
are always minimum timing parameters that must be met to turn
buffers on-and-off. Second, many IC devices do not have any internal
three-state routing resources available to them, or they are very
restrictive in terms of location or quantity of these interconnects.

As shown in Figure A-21(b), the SoC bus can be adapted to use
multiplexor logic to achieve the same goal. The main advantage of this
approach is that it does not use the three-state routing resources
which are not available on many FPGA and ASIC devices.

The main disadvantage of the multiplexor logic interconnection is that
it requires a larger number of routed interconnects and logic gates
(which are not required with the three-state bus approach).

However, there is also a growing body of evidence that suggests that
this type of interconnection is easier to route in both FPGA and ASIC
devices. Although this is very difficult to quantify, the author has
found that the multiplexor logic interconnection is quite easily
handled by standard FPGA and ASIC routers. This is because:

* Three-state interconnections force router software to organize the
  SoC around the fixed three-state bus locations. In many cases, this
  constraint results in poorly optimized and/or slow circuits.

* Very often, ‘bit locations’ within a design are grouped together. In
  many applications, the multiplexor logic interconnection is easier to
  handle for place & route tools.

* Pre-defined, external I/O pin locations are easier to achieve with
  multiplexor logic inter-connections. This is especially true with
  FPGA devices.  For the shared bus example we will use multiplexor
  logic for the interconnection. That’s because multiplexor logic
  interconnections are more portable than three-state logic designs. The
  shared bus design in this example is intended to be used on many
  brands of FPGA and ASIC devices.

Creating the Interconnection Topology
`````````````````````````````````````

In the previous two sections it was decided to use multiplexor
interconnections with non-multiplexed address and data buses. In this
section we’ll refine those concepts into a broad interconnection
topology for our system. However, we’ll save the details for
later. For now, we’re just interested in looking at some of the
general issues.

In WISHBONE nomenclature, the interconnection is also called the
INTERCON. The INTERCON is an IP Core that connects all of the MASTER
and SLAVE interfaces together.

Figure A-22 shows the generic topology of an INTERCON that supports
multiplexor interconnections with multiplexed address and data
buses. By ‘generic’, we mean that there are ‘N’ MASTERs and SLAVEs
shown in the diagram. The actual number of MASTER and SLAVE interfaces
can be adjusted up or down, depending upon what’s needed in the
system. In the shared bus example we’ll use four MASTERs and four
SLAVEs. However, for now we’ll think in more general terms.

A module called the SYSCON provides the system with a stable clock
[CLK_O] and reset signal [RST_O]. For now, we’ll assume that the clock
comes from off-chip, and that the reset signal is synchronized from
some global system reset.

After the initial system reset, one or more MASTERs request the
interconnection, which we’ll call a ‘bus’ for now. MASTERs do this by
asserting their [CYC_O] signal. An arbiter, which we’ll discuss
shortly, determines which MASTER can use the bus. One clock edge after
the assertion of a [CYC_O] signal the arbiter grants the bus to one
of the MASTERs that requested it.  It grants the bus by asserting
grant lines GNT0 – GNTN and GNT(N..0). This informs both the INTERCON
as to which MASTER can own the bus.

Once the bus is arbitrated, the output signals from the selected
MASTER are routed, via multiplexors, onto the shared buses. For
example, if MASTER #0 obtains the bus, then the address lines
[ADR_O()] from MASTER #0 are routed to shared bus [ADR()]. The same
thing happens to the data out [DAT_O()], select out [SEL_O()], write
enable [WE_O] and strobe [STB_O] signals. The shared bus output
signals are routed to the inputs on the SLAVE interfaces.

The arbiter grant lines are also used to enable the terminating
signals [ACK_I], [RTY_I] and [ERR_I]. These are enabled at the MASTER
that acquired the bus. For example, if MASTER #0 is granted the bus by
the arbiter, then the [ACK_I], [RTY_I] and [ERR_I] are enabled at
MASTER #0. Other MASTERs, who may also be requesting the bus, never
receive a terminating signal, and therefore will wait until they are
granted the bus.

During this interval the common address bus [ADR()] is driven with the
address lines from the MASTER. The address lines are decoded by the
address comparator, which splits the address space into ‘N’
sections. The decoded output from the comparator is used to select the
slave by way of its strobe input [STB_I]. A SLAVE may only respond to
a bus cycle when its [STB_I] is asserted. This is also a wonderful
illustration of the partial address decoding technique used by
WISHBONE, which we’ll discuss in depth below.

For example, consider a system with an addressing range of sixteen
bits. If the addressing range were evenly split between all of the
SLAVEs, then each SLAVE would be allocated 16 Kbytes of address
space. This is shown in the address map of Figure A-23. In this case,
the address comparator would decode bits [ADR(15..14)]. In actual
practice the system integrator can alter the address map at his or her
discretion.

Once a SLAVE is selected, it participates in the current bus cycle
generated by the MASTER. In response to the cycle, the SLAVE must
assert either its [ACK_O], [RTY_O] or [ERR_O] output.  These signals
are collected with an ‘or’ gate, and routed to the current MASTER.

Also note that during read cycles, the SLAVE places data on its
[DAT_O()] bus. These are routed from the participating SLAVE to the
current MASTER by way of a multiplexor. In this case, the multiplexor
source is selected by some address lines which have been appropriately
selected to switch the multiplexor.

Once the MASTER owning the bus has received an asserted terminating
signal, it terminates the bus cycle by negating its strobe output
[STB_O]. If the MASTER is in the middle of a block transfer cycle, it
will generate another phase of the block transfer. If it’s performing
a SINGLE cycle, or if its at the end of a BLOCK cycle, the MASTER
terminates the cycle by negating its [CYC_O] signal. This informs the
MASTER that it’s done with the bus, and that it can rearbitrate it.

Full vs. Partial Address Decoding
`````````````````````````````````

The address comparator in our INTERCON example is a good way to
explain the concept of WISHBONE partial address decoding.

Many systems, including standard microcomputer buses like PCI and
VMEbus, use full address decoding. Under that method, each slave
module decodes the full address bus. For example, if a 32-bit address
bus is used, then each slave decodes all thirty-two address bits (or
at least a large portion of them).

SoC buses like WISHBONE use partial address decoding on slave
modules. Under this method, each slave decodes only the range of
addresses that it uses. For example, if the slave has only four
registers, then the WISHBONE interface uses only two address
bits. This technique has the following advantages:

* It facilitates high speed address decoders.
* It uses less redundant address decoding logic (i.e. fewer gates).
* It supports variable address sizing (between zero and 64-bits).
* It supports the variable interconnection scheme.
* It gives the system integrator a lot of flexibility in defining the
  address map.

For example, consider the serial I/O port (IP core) with the internal
register set shown in Figure A-24(a). If full address decoding is
used, then the IP core must include an address decoder to select the
module. In this case, the decoder requires: 32 bits – 2 bits = 30
bits. In addition, the IP core would also contain logic to decode the
lower two bits which are used to determine which I/O registers are
selected.

If partial address decoding is used, then the IP core need only decode
the two lower address bits (2 2 = 4). The upper thirty bits are
decoded by logic outside of the IP core. In this case the decoder
logic is shown in Figure A-24(b).

Standard microcomputer buses always use the full address decoding
technique. That’s because the interconnection method does not allow
the creation of any new signals on the interface.  However, in
WISHBONE this limitation does not exist. WISHBONE allows the system
integrator to modify the interconnection logic and signal paths.

One advantage of the partial address decoding technique is that the
size of the address decoder (on the IP core) is minimized. This speeds
up the interface, as decoder logic can be relatively slow. For
example, a 30-bit full address decoder often requires at least 30 XOR
gates, and a 30-input AND gate.

Another advantage of the partial address decoding technique is that
less decoder logic is required. In many cases, only one ‘coarse’
address decoder is required. If full address decoding is used, then
each IP core must include a redundant set of address decoders.

Another advantage of the partial address decoding technique is that it
supports variable address sizing. For example, on WISHBONE the address
path can be any size between zero and 64-bits.  Slave modules are
designed to utilize only the block of addresses that are required. In
this case, the full address decoding technique cannot be used because
the IP core designer is unaware of the size of the system address
path.

Another advantage of the partial address decoding technique is that it
supports the variable interconnection scheme. There, the type of
interconnection logic is unknown to the IP core designer.  The
interconnection scheme must adapt to the types of slave IP cores that
are used.

The major disadvantage of the partial address decoding technique is
that the SoC integrator must define part of the address decoder logic
for each IP core. This increases the effort to integrate the IP cores
into the final SoC.

The System Arbiter
``````````````````

The system arbiter determines which MASTER can use the shared bus. The
WISHBONE specification allows a variety of arbiters to be
used. However, in this example a four level round-robin arbiter is
used.

Round-robin arbiters give equal priority to all of the MASTERs. These
arbiters grant the bus on a rotating basis much like the four position
rotary switch shown in Figure A-25. When a MASTER relinquishes the
bus (by negating its [CYC_O] signal), the switch is turned to the next
position, and the bus is granted to the MASTER on that level. If a
request is not pending on a certain level, the arbiter skips over that
level and continues onto the next one. In this way all of the MASTERs
are granted the bus on an equal basis.

Round-robin arbiters are popular in data acquisition systems where
data is collected and placed into shared memory. Often these
peripherals must off-load data to memory on an equal basis.  Priority
arbiters (where each MASTER is assigned a higher or lower level of
priority) do not work well in these applications because some
peripherals would receive more bus bandwidth than others, thereby
causing data ‘gridlock’.

The arbiter used in this example can be found in the WISHBONE Public
Domain Library for VHDL. ARB0001a is used for the example.

Creating and Benchmarking the System
````````````````````````````````````

The final task in our shared bus system example is to create and
benchmark the entire system.  The INTERCON in our example system is
based on the generic shared bus topology that was described
above. However, that system is fine tuned to give the exact features
that we will need.

The final system supports four DMA0001a MASTERs, four MEM0002a
memories (SLAVEs), a 32-bit data bus, a five bit address bus, a single
SYC0001a system controller and a ARB0001a four level round-robin
arbiter. The resulting VHDL file can be found under ICN0002a in the
WISHBONE Public Domain Library for VHDL.

In this application, the round-arbiter was chosen because all of the
MASTERs are DMA controllers. That means that all four MASTERs
continuously vie for the bus. If a priority arbiter were used, then
only the one or two highest priority MASTERs would ever get the bus.

As we’ll see shortly, the error and retry signals [ERR_I] and [RTY_I]
are not supported on the MASTER and SLAVE interfaces on our example
system. That’s perfectly okay because these signals are optional in
the WISHBONE specification. We could have added these signals in
there, but they would have been removed by synthesis and router logic
minimization tools.

Since all of the MASTERs and SLAVEs on this system have identical port
sizes and granularities, the select [SEL] interconnection has been
omitted. This could have been added, but it wasn’t needed.

The INTERCON system includes a partial address decoder for the
SLAVEs. This decoder creates the system address space shown in
Figure A-26. The final address map is shown in Table A-7.

Source code for this example can be found in the WISHBONE Public
Domain Library for VHDL (in the EXAMPLES folder). The library also has
detailed documentation for the library modules, including detailed
circuit descriptions and timing diagrams. The reader is encouraged to
review and experiment with all of these files.

This system was synthesized and routed on two styles of Xilinx 15
FPGA: the Spartan 2 and the Virtex 2. For benchmarking purposes the
memories were altered so that they used Xilinx distributed RAMs
instead of the register RAMs in MEM0002a. A memory interface for the
Xilinx RAMs can be found in MEM0001a, which is substituted for
MEM0002a.

It should be noted that the Xilinx distributed RAMs are quite
efficient on the WISHBONE interface. As can be seen in the source
code, only a single ‘AND’ gate was needed to interface the RAM to
WISHBONE.

The system for the Xilinx Spartan 2 was synthesized and operated on a
Silicore evaluation board.  In order to verify that the system
actually does run correctly, an HP54620a logic analyzer was connected
to test pins on the board, and some of the signals were viewed. Figure
A-27 shows the trace. Address lines, data write lines and several
control signals are shown.

Table A-8 shows the speed of the system after synthesis and
routing. The Spartan 2 benchmarked at about 220 Mbyte/sec, and was
tested in hardware (HW TEST). The Virtex 2 part was only synthesized
and routed, and showed a maximum speed of about 404 Mbyte/sec (SW
TEST).

15 Xilinx is a registered trademark of Xilinx, Inc.

16 The logic analyzer samples at 500 Mhz, so the SoC was slowed down
to make the traces look better. This trace was taken with a SoC clock
speed of 5 MHz.

Notes:
VHDL synthesis tool: Altium Accolade PeakFPGA 5.30a
Router: Xilinx Alliance 3.3.06I_V2_SE2
Hardware evaluation board: Silicore 170101-00 Rev 1.0
Listed size was reported by the router.
Spartan 2 test used ‘-5’ speed grade part (slower than the faster ‘-6’ part).

Other Benchmarks
````````````````

Other benchmarks have also been run on the shared bus
interconnection. At present, the fastest implementation of the 4
MASTER / 4 SLAVE shared bus system has been with 64-bit interfaces.
This has resulted in data transfer rates in excess of 800 Mbyte/sec.

References
----------

Di Giacomo, Joseph. Digital Bus Handbook. McGraw-Hill 1990. ISBN
0-07-016923-3.

Peterson, Wade D. The VMEbus Handbook, 4 th Edition. VITA 1997. ISBN
1-885731-08-6
