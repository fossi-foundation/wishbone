Introduction
============

The WISHBONE [#]_ System-on-Chip (SoC) Interconnection Architecture for Portable IP Cores is a flexible design methodology for use with semiconductor IP cores.
Its purpose is to foster design reuse by alleviating System-on-Chip integration problems.
This is accomplished by creating a common interface between IP cores.
This improves the portability and reliability of the system, and results in faster time-to-market for the end user.

Previously, IP cores used non-standard interconnection schemes that made them difficult to integrate.
This required the creation of custom glue logic to connect each of the cores together.
By adopting a standard interconnection scheme, the cores can be integrated more quickly and easily by the end user.

This specification can be used for soft core, firm core or hard core IP. Since firm and hard cores are generally conceived as soft cores, the specification is written from that standpoint.
This specification does not require the use of specific development tools or target hardware.
Furthermore, it is fully compliant with virtually all logic synthesis tools.
However, the examples presented in the specification do use the VHDL hardware description language.
These are presented only as a convenience to the reader, and should be readily understood by users of other hardware description languages (such as Verilog®).
Schematic based tools can also be used.
The WISHBONE interconnect is intended as a general purpose interface.
As such, it defines the standard data exchange between IP core modules.
It does not attempt to regulate the application-specific functions of the IP core.

The WISHBONE architects were strongly influenced by three factors.
First, there was a need for a good, reliable System-on-Chip integration solution.
Second, there was a need for a common interface specification to facilitate structured design methodologies on large project teams.
Third, they were impressed by the traditional system integration solutions afforded by micro-computer buses such as PCI bus and VMEbus.

In fact, the WISHBONE architecture is analogous to a microcomputer bus in that that they both:
(a) offer a flexible integration solution that can be easily tailored to a specific application;
(b) offer a variety of bus cycles and data path widths to solve various system problems; and
(c) allow products to be designed by a variety of suppliers (thereby driving down price while improv- ing performance and quality).

.. [#] Webster's dictionary defines a WISHBONE as "the forked clavicle in front of the breastbone of most birds."
       The term 'WISHBONE interconnect' was coined by Wade Peterson of Silicore Corporation.
       During the initial definition of the scheme he was attempting to find a name that was descriptive of a bi-directional data bus that used either multiplexers or three-state logic.
       This was solved by forming an interface with separate input and output paths.
       When these paths are connected to three-state logic it forms a 'Y' shaped configuration that resembles a wishbone.
       The actual name was conceived during a Thanksgiving Day dinner that included roast turkey.
       Thanksgiving Day is a national holiday in the United States, and is observed on the third Thursday in November.
       It is generally celebrated with a traditional turkey dinner.

However, traditional microcomputer buses are fundamentally handicapped for use as a System-on-Chip interconnection.
That's because they are designed to drive long signal traces and connector systems which are highly inductive and capacitive.
In this regard, System-on-Chip is much simpler and faster.
Furthermore, the System-on-Chip solutions have a rich set of interconnection resources.
These do not exist in microcomputer buses because they are limited by IC packaging and mechanical connectors.

The WISHBONE architects have attempted to create a specification that is robust enough to insure complete compatibility between IP cores.
However, it has not been over specified so as to unduly constrain the creativity of the core developer or the end user.
It is believed that these two goals have been accomplished with the publication of this document.

WISHBONE features
-----------------

The WISHBONE interconnection makes System-on-Chip and design reuse easy by creating a standard data exchange protocol.
Features of this technology include:

* Simple, compact, logical IP core hardware interfaces that require very few logic gates.

* Supports structured design methodologies used by large project teams.

* Full set of popular data transfer bus protocols including:

  * READ/WRITE cycle

  * BLOCK transfer cycle

  * RMW cycle

* Modular data bus widths and operand sizes.

* Supports both BIG ENDIAN and LITTLE ENDIAN data ordering.

* Variable core interconnection methods support point-to-point, shared bus, crossbar switch, and switched fabric interconnections.

*  Handshaking protocol allows each IP core to throttle its data transfer speed.

* Supports single clock data transfers.

* Supports normal cycle termination, retry termination and termination due to error.

* Modular address widths

* Partial address decoding scheme for SLAVEs.
  This facilitates high speed address decoding, uses less redundant logic and supports variable address sizing and interconnection means.

* User-defined tags.
  These are useful for applying information to an address bus, a data bus or a bus cycle.
  They are especially helpful when modifying a bus cycle to identify information such as:

   * Data transfers

   * Parity or error correction bits

   * Interrupt vectors

   * Cache control operations

* MASTER / SLAVE architecture for very flexible system designs.

* Multiprocessing (multi-MASTER) capabilities. This allows for a wide variety of System-on-Chip configurations.

* Arbitration methodology is defined by the end user (priority arbiter, round-robin arbiter, etc.).

* Supports various IP core interconnection means, including:

   * Point-to-point

   * Shared bus

   * Crossbar switch

   * Data flow interconnection

   * Off chip

* Synchronous design assures portability, simplicity and ease of use.

* Very simple, variable timing specification.

* Documentation standards simplify IP core reference manuals.

* Independent of hardware technology (FPGA, ASIC, etc.).

* Independent of delivery method (soft, firm or hard core).

* Independent of synthesis tool, router and layout tool technology.

* Independent of FPGA and ASIC test methodologies.

* Seamless design progression between FPGA prototypes and ASIC production chips.

WISHBONE Objectives
-------------------

The main objectives of this specification are

* to create a flexible interconnection means for use with semiconductor IP cores.
  This allows various IP cores to be connected together to form a System-on-Chip.

* to enforce compatibility between IP cores. This enhances design reuse.

* to create a robust standard, but one that does not unduly constrain the creativity of the core developer or the end user.

* to make it easy to understand by both the core developer and the end user.

* to facilitate structured design methodologies on large project teams.
  With structured design, individual team members can build and test small parts of the design.
  Each member of the design team can interface to the common, well-defined WISHBONE specification.
  When all of the sub-assemblies have been completed, the full system can be integrated.

* to create a portable interface that is independent of the underlying semiconductor technology.
  For example, WISHBONE interconnections can be made that support both FPGA and ASIC target devices.

* to make WISHBONE interfaces independent of logic signaling levels.

* to create a flexible interconnection scheme that is independent of the IP core delivery method.
  For example, it may be used with 'soft core', 'firm core' or 'hard core' delivery methods.

* to be independent of the underlying hardware description.
  For example, soft cores may be written and synthesized in VHDL, Verilog® or some other hardware description language.
  Schematic entry may also be used.

* to require a minimum standard for documentation.
  This takes the form of the WISHBONE DATASHEET, and allows IP core users to quickly evaluate and integrate new cores.

* to eliminate extensive interface documentation on the part of the IP core developer.
  In most cases, this specification along with the WISHBONE DATASHEET is sufficient to completely document an IP core data interface.

* to allow users to create SoC components without infringing on the patent rights of others.
  While the use of WISHBONE technology does not necessarily prevent patent infringement, it does provide a reasonable safe haven where users can design around the patent claims of others.
  The specification also provides cited patent references, which describes the field of search used by the WISHBONE architects.

* to identify critical System-on-Chip interconnection technologies, and to place them into the public domain at the earliest possible date.
  This makes it more difficult for individuals and organizations to create proprietary technologies through the use of patent, trademark, copyright and trade secret protection mechanisms.

* to support a business model whereby IP Core suppliers can cooperate at a technical standards level, but can also compete in the commercial marketplace.
  This improves the overall quality and value of products through market forces such as price, service, delivery, performance and time-to-market.
  This business model also allows open source IP cores to be offered as well.

* to create an architecture that has a smooth transition path to support new technologies.
  This increases the longevity of the specification as it can adapt to new, and as yet unthought-of, requirements.

* to create an architecture that allows various interconnection means between IP core modules.
  This insures that the end user can tailor the System-on-Chip to his/her own needs.
  For example, the entire interconnection system (which is analogous to a backplane on a standard microcomputer bus like VMEbus or cPCI) can be created by the system integrator.
  This allows the interconnection to be tailored to the final target device.

* to create an architecture that requires a minimum of glue logic.
  In some cases the System-on-Chip needs no glue logic whatsoever.
  However, in other cases the end user may choose to use a more sophisticated interconnection method (for example with FIFO memories or crossbar switches) that requires additional glue logic.

* to create an architecture with variable address and data path widths to meet a wide variety of system requirements.

* to create an architecture that fully supports the automatic generation of interconnection and IP Core systems.
  This allows components to be generated with parametric core generators.

* to create an architecture that supports both BIG ENDIAN and LITTLE ENDIAN data transfer organizations.

* to create an architecture that supports one data transfer per clock cycle.

* to create a flexible architecture that allows address, data and bus cycles to be tagged.
  Tags are user defined signals that allow users to modify a bus cycle with additional information.
  They are especially useful when novel or unusual control signals (such as parity, cache control or interrupt acknowledge) are needed on an interface.

* to create an architecture with a MASTER/SLAVE topology.
  Furthermore, the system must be capable of supporting multiple MASTERs and multiple SLAVEs with an efficient arbitration mechanism.

* to create an architecture that supports point-to-point interconnections between IP cores.

* to create an architecture that supports shared bus interconnections between IP cores.

* to create an architecture that supports crossbar switches between IP cores.

* to create an architecture that supports switched fabrics.

* to create a synchronous protocol to insure ease of use, good reliability and easy testing.
  Furthermore, all transactions can be coordinated by a single clock.

* to create a synchronous protocol that works over a wide range of interface clock speeds.
  The effects of this are:
  (a) that the WISHBONE interface can work synchronously with all attached IP cores,
  (b) that the interface can be used on a large range of target devices,
  (c) that the timing specification is much simpler, and
  (d) that the resulting semiconductor device is much more testable.

* to create a variable timing mechanism whereby the system clock frequency can be adjusted so as to control the power consumption of the integrated circuit.

* to create a synchronous protocol that provides a simple timing specification.
  This makes the interface very easy to integrate.

* to create a synchronous protocol where each MASTER and SLAVE can throttle the data transfer rate with a handshaking mechanism.

* to create a synchronous protocol that is optimized for System-on-Chip, but that is also suitable for off-chip I/O routing.
  Generally, the off-chip WISHBONE interconnect will operate at slower speeds.

* to create a backward compatible registered feedback high performance burst bus.

Specification Terminology
-------------------------

To avoid confusion, and to clarify the requirements for compliance, this specification uses five keywords.
They are:

* **RULE**

* **RECOMMENDATION**

* **SUGGESTION**

* **PERMISSION**

* **OBSERVATION**

Any text not labeled with one of these keywords describes the operation in a narrative style.
The keywords are defined as follows:

**RULE**
    Rules form the basic framework of the specification.  They are
    sometimes expressed in text form and sometimes in the form of
    figures, tables or drawings.  All rules MUST be followed to ensure
    compatibility between interfaces.  Rules are characterized by an
    imperative style.  The uppercase words MUST and MUST NOT are
    reserved exclusively for stating rules in this document, and are
    not used for any other purpose.

**RECOMMENDATION**
    Whenever a recommendation appears, designers would be wise to take
    the advice given.  Doing otherwise might result in some awkward
    problems or poor performance.  While this specification has been
    designed to support high performance systems, it is possible to
    create an interconnection that complies with all the rules, but
    has very poor performance.  In many cases a designer needs a
    certain level of experience with the system architecture in order
    to design interfaces that deliver top performance.
    Recommendations found in this document are based on this kind of
    experience and are provided as guidance for the user.

**SUGGESTION**
    A suggestion contains advice which is helpful but not vital.  The
    reader is encouraged to consider the advice before discarding it.
    Some design decisions are difficult until experience has been
    gained.  Suggestions help a designer who has not yet gained this
    experience.  Some suggestions have to do with designing compatible
    interconnections, or with making system integration easier.

**PERMISSION**
    In some cases a rule does not specifically prohibit a certain
    design approach, but the reader might be left wondering whether
    that approach might violate the spirit of the rule, or whether it
    might lead to some subtle problem.  Permissions reassure the
    reader that a certain approach is acceptable and will not cause
    problems.  The upper-case word MAY is reserved exclusively for
    stating a permission and is not used for any other purpose.

**OBSERVATION**
    Observations do not offer any specific advice.  They usually
    clarify what has just been discussed.  They spell out the
    implications of certain rules and bring attention to things that
    might otherwise be overlooked.  They also give the rationale
    behind certain rules, so that the reader understands why the rule
    must be followed.

Use of Timing Diagrams
----------------------

:numref:`timingdiagram` shows some of the key features of the timing diagrams in this specification.
Unless otherwise noted, the MASTER signal names are referenced in the timing diagrams.
In some cases the MASTER and SLAVE signal names are different.
For example, in the point-to-point interconnections the [ADR_O] and [ADR_I] signals are connected together.
Furthermore, the actual waveforms at the SLAVE may vary from those at the MASTER.
That's because the MASTER and SLAVE interfaces can be connected together in different ways.
Unless otherwise noted, the timing diagrams refer to the connection diagram shown in :numref:`connection`.

.. _connection:
.. figure:: _static/connection.*

   Standard connection for timing diagrams.

.. _timingdiagram:
.. wavedrom::
   :caption: Use of timing diagrams.

        { "signal": [
                { "name": "CLK_I",  "wave": "P|.", "label": ".{WSS}(.45).." },
		{ "name": "ADR_O()", "wave": "x<|=>.", "data": "VALID" }
          ],
	  "config": { "hscale": 2 },
	  "head": { "tick": 0 }
	}

Some signals may or may not be present on a specific interface.
That's because many of the signals are optional.

Two symbols are also presented in relation to the [CLK_I] signal.
These include the positive going clock edge transition point and the clock edge number.
In most diagrams a vertical guideline is shown at the positive-going edge of each [CLK_I] transition.
This represents the theoretical transition point at which flip-flops register their input value, and transfer it to their output.
The exact level of this transition point varies depending upon the technology used in the target device.
The clock edge number is included as a convenience so that specific points in the timing diagram may be referenced in the text.
The clock edge number in one timing diagram is not related to the clock edge number in another diagram.

Gaps in the timing waveforms may be shown.
These indicate either:
(a) a wait state or
(b) a portion of the waveform that is not of interest in the context of the diagram.
When the gap indicates a wait state, the symbols ‘-WSM-‘ or ‘-WSS-‘ are placed in the gap along the [CLK_I] waveform.
These correspond to wait states inserted by the MASTER or SLAVE interfaces respectively.
They also indicate that the signals (with the exception of clock transitions and hatched regions) will remain in a steady state during that time.

Undefined signal levels are indicated by a hatched region.
This region indicates that the signal level is undefined, and may take any state.
It also indicates that the current state is undefined, and should not be relied upon.
When signal arrays are used, stable and predictable signal levels are indicated with the word 'VALID'.

Signal Naming Conventions
-------------------------

All signal names used in this specification have the ‘_I’ or ‘_O’ characters attached to them.
These indicate if the signals are an input (to the core) or an output (from the core).
For example, [ACK_I] is an input and [ACK_O] is an output.
This convention is used to clearly identify the direction of each signal.

Signal arrays are identified by a name followed by a set of parenthesis.
For example, [DAT_I()] is a signal array.
Array limits may also be shown within the parenthesis.
In this case the first number of the array limit indicates the most significant bit, and the second number indicates the least significant bit.
For example, [DAT_I(63..0)] is a signal array with upper array boundary number sixty-three (the most significant bit), and lower array boundary number zero (the least significant bit).
The array size on any particular core may vary.
In many cases the array boundaries are omitted if they are irrelevant to the context of the description.

Special user defined signals, called tags, can also be used.
Tags are assigned a tag type that indicates the exact timing to which the signal must adhere.
For example, if a parity bit such as [PAR_O] is added to a data bus, it would probably be assigned a tag type of TAG TYPE: TGD_O().
This indicates that the signal will adhere to the timing diagrams shown for [TGD_O()], which are shown in the timing diagrams for each bus cycle.
Also note that, while all tag types are specified as arrays (with parenthesis '()'), the actual tag does not have to be a signal array.
It can also be non-arrayed signal.
When used as part of a sentence, signal names are enclosed in brackets '[ ]'.
This helps to discriminate signal names from the words in the sentence.

WISHBONE Logo
-------------

The WISHBONE logo can be affixed to SoC documents that are compatible with this standard.
`logo`_ shows the logo.

.. _logo:
.. figure:: _static/wishbone_stamp.pdf

   WISHBONE Logo.

PERMISSION 1.00
  Documents describing a WISHBONE compatible SoC component that are 100% compliant with this specification MAY use the WISHBONE logo.

Glossary of Terms
-----------------

0x (numerical prefix)
  The ‘0x’ prefix indicates a hexadecimal number. It is the same
  nomenclature as commonly used in the ‘C’ programming language.

Active High Logic State
  A logic state that is ‘true’ when the logic level is a binary ‘1’
  (high state). The high state is at a higher voltage than the low
  state.

Active Low Logic State
  A logic state that is ‘true’ when the logic level is a binary ‘0’ (low
  state). The low state is at a lower voltage than the high state.

Address Tag
  One or more user defined signals that modify a WISHBONE address. For
  example, they can be used create a parity bit on an address bus, to
  indicate an address width (16-bit, 24-bit etc.) or can be used by
  memory management hardware to indicate a protected address space. All
  address tags must be assigned a tag type of [TGA_I()] or
  [TGA_O()]. Also see tag, tag type, data tag and cycle tag.

ASIC
  Acronym for: Application Specific Integrated Circuit. A general term
  which describes a generic array of logic gates or analog building
  blocks which are programmed by a metalization layer at a silicon
  foundry. High level circuit descriptions are impressed upon the logic
  gates or analog building blocks in the form of metal interconnects.

Asserted
  1. A verb indicating that a logic state has switched from the
     inactive to the active state. When active high logic is used it means
     that a signal has switched from a logic low level to a logic high
     level.
  2. Assert: to cause a signal line to make a transition from
     its logically false (inactive) state to its logically true (active)
     state. Opposite of negated.

Bit
  A single binary (base 2) digit.

Bridge
  An interconnection system that allows data exchange between two or
  more buses. The buses may have similar or different electrical,
  mechanical and logical structures.

Bus
  1. A common group of signals.
  2. A signal line or a set of lines used by a data transfer system
     to connect a number of devices.

Bus Interface
  An electronic circuit that drives or receives data or power from a bus.

Bus Cycle
  The process whereby digital signals effect the transfer of data across
  a bus by means of an inter- locked sequence of control signals. Also
  see: Phase (bus cycle).

BYTE
  A unit of data that is 8-bits wide. Also see: WORD, DWORD and QWORD.

Crossbar Interconnection (Crossbar Switch)
  Crossbar switches are mechanisms that allow modules to connect and
  communicate. Each con- nection channel can be operated in parallel to
  other connection channels. This increases the data transfer rate of
  the entire system by employing parallelism. Stated another way, two
  100 MByte/second channels can operate in parallel, thereby providing a
  200 MByte/second transfer rate. This makes the crossbar switches
  inherently faster than traditional bus schemes. Crossbar routing
  mechanisms generally support dynamic configuration. This creates a
  configurable and reliable network system. Most crossbar architectures
  are also scalable, meaning that families of crossbars can be added as
  the needs arise. A crossbar interconnection is shown in Figure 1-4.

Cycle Tag
  One or more user defined signals that modify a WISHBONE bus cycle. For
  example, they can be used to discriminate between WISHBONE SINGLE,
  BLOCK and RMW cycles. All cycle tags must be assigned a tag type of
  [TGC_I()] or [TGC_O()]. Also see tag type, address tag and data tag.

Data Flow Interconnection
  An interconnection where data flows through a prearranged set of IP
  cores in a sequential order.  Data flow architectures often have the
  advantage of parallelism, whereby two or more functions are executed
  at the same time. Figure 1-5 shows a data flow interconnection between
  IP cores.

Data Organization
  The ordering of data during a transfer. Generally, 8-bit (byte) data
  can be stored with the most significant byte of a mult-byte transfer
  at the higher or the lower address. These two methods are generally
  called BIG ENDIAN and LITTLE ENDIAN, respectively. In general, BIG
  ENDIAN refers to byte lane ordering where the most significant byte is
  stored at the lower address. LIT- TLE ENDIAN refers to byte lane
  ordering where the most significant byte is stored at the higher
  address. The terms BIG ENDIAN and LITTLE ENDIAN for data organization
  was coined by Danny Cohen of the Information Sciences Institute, and
  was derived from the book Gulliver’s Travels by Jonathan Swift.

Data Tag
  One or more user defined signals that modify a WISHBONE data
  transfer. For example, they can be used carry parity information,
  error correction codes or time stamps. All data tags must be assigned
  a tag type of [TGD_I()] or [TGD_O()]. Also see tag type, address tag
  and cycle tag.

DMA Unit
  Acronym for Direct Memory Access Unit.

  1. A device that transfers data from one location in memory to
     another location in memory.

  2. A device for transferring data between a device and memory
     without interrupting program flow. (3) A device that does not use
     low-level instructions and is intended for transferring data between
     memory and/or I/O locations.

DWORD
  A unit of data that is 32-bits wide. Also see: BYTE, WORD and QWORD.

ENDIAN
  See the definition under ‘Data Organization’.

FIFO
  Acronym for: First In First Out. A type of memory used to transfer
  data between ports on two devices. In FIFO memories, data is removed
  in the same order that they were added. The FIFO memory is very useful
  for interconnecting cores of differing speeds.

Firm Core
  An IP Core that is delivered in a way that allows conversion into an
  integrated circuit design, but does not allow the design to be easily
  reverse engineered. It is analogous to a binary or object file in the
  field of computer software design.

Fixed Interconnection
  An interconnection system that is fixed, and cannot be changed without
  causing incompatibilities between bus modules (or SoC/IP cores). Also
  called a static interconnection. Examples of fixed interconnection
  buses include PCI, cPCI and VMEbus. Also see: variable
  interconnection.

Fixed Timing Specification
  A timing specification that is based upon a fixed set of
  rules. Generally used in traditional mi- crocomputer buses like PCI
  and VMEbus. Each bus module must conform to the ridged set of timing
  specifications. Also see: variable timing specification.

Foundry
  See silicon foundry.

FPGA
  Acronym for: Field Programmable Gate Array. Describes a generic array
  of logical gates and interconnect paths which are programmed by the
  end user. High level logic descriptions are im- pressed upon the gates
  and interconnect paths, often in the form of IP Cores.

Full Address Decoding
  A method of address decoding where each SLAVE decodes all of the
  available address space.  For example, if a 32-bit address bus is
  used, then each SLAVE decodes all thirty-two address bits. This
  technique is used on standard microcomputer buses like PCI and
  VMEbus. Also see: partial address decoding.

Gated Clock
  A clock that can be stopped and restarted. In WISHBONE, a gated clock
  generator allows [CLK_O] to be stopped in its low state. This
  technique is often used to reduce the power con- sumption of an
  integrated circuit. Under WISHBONE, the gated clock generator is
  optional.  Also see: variable clock generator.

Glue Logic
  1. Logic gates and interconnections required to connect IP cores
     together. The requirements for glue logic vary greatly depending upon
     the interface requirements of the IP cores.

  2. A family of logic circuits consisting of various gates and simple
     logic elements, each of which serve as an interface between various
     parts of a computer system.

Granularity
  The smallest unit of data transfer that a port is capable of
  transferring. For example, a 32-bit port can be broken up into four
  8-bit BYTE segments. In this case, the granularity of the interface is
  8-bits. Also see: port size and operand size.

Hard Core
  An IP Core that is delivered in the form of a mask set (i.e. a
  graphical description of the features and connections in an integrated
  circuit).

Hardware Description Language (HDL)
  1. Acronym for: Hardware Description Language. Examples include VHDL
     and Verilog®.
  2. A general-purpose language used for the design of digital electronic
     systems.

Interface
  A combination of signals and data-ports on a module that is capable of
  either generating or re- ceiving bus cycles. WISHBONE defines these as
  MASTER and SLAVE interfaces respectively.  Also see: MASTER and SLAVE
  interfaces.

INTERCON
  A WISHBONE module that interconnects MASTER and SLAVE interfaces.

IP Core
  Acronym for: Intellectual Property Core. Also see: soft core, firm
  core and hard core.

Mask Set
  A graphical description of the features and connections in an
  integrated circuit.

MASTER
  A WISHBONE interface that is capable of generating bus cycles. All
  systems based on the WISHBONE interconnect must have at least one
  MASTER interface. Also see: SLAVE.

Memory Mapped Addressing
  An architecture that allows data to be stored and recalled in memory
  at individual, binary ad- dresses.

Minimization (Logic Minimization)
  A process by which HDL synthesis, router or other software development
  tools remove unused logic. This is important in WISHBONE because there
  are optional signals defined on many of the interfaces. If a signal is
  unused, then the logic minimization tools will remove these signals
  and their associated logic, thereby making a faster and more efficient
  design.

Module
  In the context of this specification, it’s another name for an IP
  core.

Multiplexer Interconnection
  An interconnection that uses multiplexers to route address, data and
  control signals. Often used for System-on-Chip (SoC)
  applications. Also see: three-state bus interconnection.

Negated
  A verb indicating that a logic state has switched from the active to
  the inactive state. When ac- tive high logic is used it means that a
  signal has switched from a logic high level to a logic low level. Also
  see: asserted.

Off-Chip Interconnection
  An off-chip interconnection is used when a WISHBONE interface extends
  off-chip. See Figure 1-6.

Operand Size
  The operand size is the largest single unit of data that is moved
  through an interface. For exam- ple, a 32-bit DWORD operand can be
  moved through an 8-bit port with four data transfers. Also see:
  granularity and port size.

Parametric Core Generator
  A software tool used for the generation of IP cores based on input
  parameters. One example of a parametric core generator is a DSP filter
  generator. These are programs that create lowpass, bandpass and
  highpass DSP filters. The parameters for the filter are provided by
  the user, which causes the program to produce the digital filter as a
  VHDL or Verilog® hardware description.  Parametric core generators can
  also be used create WISHBONE interconnections.

Partial Address Decoding
  A method of address decoding where each SLAVE decodes only the range
  of addresses that it requires. For example, if the module needs only
  four addresses, then it decodes only the two least significant address
  bits. The remaining address bits are decoded by the interconnection
  sys- tem. This technique is used on SoC buses and has the advantages
  of less redundant logic in the system. It supports variable address
  buses, variable interconnection buses, and is relatively fast.  Also
  see: full address decoding.

PCI
  Acronym for: Peripheral Component Interconnect. Generally used as an
  interconnection scheme between integrated circuits. It also exists as
  a board level interconnection known as Compact PCI (or cPCI). While
  this specification is very flexible, it isn’t practical for SoC
  applications.

Phase (Bus Cycle)
  A periodic portion of a bus cycle. For example, a WISHBONE BLOCK READ
  cycle could con- tain ten phases, with each phase transferring a
  single 32-bit word of data. Collectively, the ten phases form the
  BLOCK READ cycle.

Point-to-point Interconnection
  1. An interconnection system that supports a single WISHBONE MASTER
     and a single WISHBONE SLAVE interface. It is the simplest way to
     connect two cores. See Figure 1-7.
  2. A connection with only two endpoints.

Port Size
  The width of the WISHBONE data ports in bits. Also see: granularity
  and operand size.

QWORD
  A unit of data that is 64-bits wide. Also see: BYTE, WORD and DWORD.

Router
  A software tool that physically routes interconnection paths between
  logic gates. Applies to both FPGA and ASIC devices.

RTL
  1. Register-transfer logic. A design methodology that moves data
     between registers. Data is latched in the registers at one or more
     stages along the path of signal propagation. The WISHBONE
     specification uses a synchronous RTL design methodology where all
     registers use a common clock.
  2. Register-transfer level. A description of computer operations where
     data transfers from register to register, latch to latch and through
     logic gates. (3) A level of descrip- tion of a digital design in which
     the clocked behavior of the design is expressly described in terms of
     data transfers between storage elements (which may be implied) and
     combinatorial logic (which may represent any computing logic or
     arithmetic-logic-unit). RTL modeling allows design hierarchy that
     represents a structural description of other RTL models.

Shared Bus Interconnection
  The shared bus interconnection is a system where a MASTER initiates
  addressable bus cycles to a target SLAVE. Traditional buses such as
  VMEbus and PCI bus use this type of interconnec- tion. As a
  consequence of this architecture, only one MASTER at a time can use
  the intercon- nection resource (i.e. bus). Figure 1-8 shows an example
  of a WISHBONE shared bus inter- connection.

Silicon Foundry
  A factory that produces integrated circuits.

SLAVE
  A WISHBONE interface that is capable of receiving bus cycles. All
  systems based on the WISHBONE interconnect must have at least one
  SLAVE. Also see: MASTER.

Soft Core
  An IP Core that is delivered in the form of a hardware description
  language or schematic diagram.

SoC
  Acronym for System-on-Chip. Also see: System-on-Chip.

Structured Design
  1. A popular method for managing complex projects that is often used
     with large project teams.  When structured design practices are used,
     individual team members build and test small parts of the design with
     a common set of tools. Each sub-assembly is designed to a common
     standard.  When all of the sub-assemblies have been completed, the
     full system can be integrated and tested. This approach makes it much
     easier to manage the design process.
  2. Any disciplined approach to design that adheres to specified rules
     based on principles such as modularity and top-down design.

Switched Fabric Interconnection
  A type of interconnection that uses large numbers of crossbar
  switches. These are organized into arrays that resemble the threads in
  a fabric. The resulting system is a network of redundant in-
  terconnections.

SYSCON
  A WISHBONE module that drives the system clock [CLK_O] and reset
  [RST_O] signals.

System-on-Chip (SoC)
  A method by which whole systems are created on a single integrated
  circuit chip. In many cases, this requires the use of IP cores which
  have been designed by multiple IP core providers. Sys- tem-on-Chip is
  similar to traditional microcomputer bus systems whereby the
  individual compo- nents are designed, tested and built separately. The
  components are then integrated to form a finished system.

Tag
  One or more characters or signals associated with a set of data,
  containing information about the set. Also see: tag type.

Tag Type
  A special class of signals that is defined to ease user enhancements
  to the WISHBONE spec.  When a user defined signal is specified, it is
  assigned a tag type that indicates the precise timing to which the
  signal must conform. This simplifies the creation of new
  signals. There are three basic tag types. These include address tags,
  data tags and cycle tags. These allow additional in- formation to be
  attached to an address transfer, a data transfer or a bus cycle
  (respectively). The uppercase form TAG TYPE is used when specifying a
  tag type in the WISHBONE DATA- SHEET. For example, TAG TYPE: TGA_O()
  indicates an address tag. Also see: address tag, data tag and cycle
  tag.

Target Device
  The semiconductor type (or technology) onto which the IP core design
  is impressed. Typical examples include FPGA and ASIC target devices.

Three-State Bus Interconnection
  A microcomputer bus interconnection that relies upon three-state bus
  drivers. Often used to re- duce the number of interconnecting signal
  paths through connector and IC pins. Three state buffers can assume a
  logic low state (‘0’ or ‘L’), a logic high state (‘1’ or ‘H’) or a
  high imped- ance state (‘Z’). Three-state buffers are sometimes called
  Tri-State(R) buffers. Tri-State(R) is a registered trademark of National
  Semiconductor Corporation. Also see: multiplexer interconnec- tion.

Variable Clock Generator
  A type of SYSCON module where the frequency of [CLK_O] can be changed
  dynamically. The frequency can be changed by way of a programmable
  phase-lock-loop (PLL) circuit or other control mechanism. Among other
  things, this technique is used to reduce the power consump- tion of
  the circuit. In WISHBONE the variable clock generator capability is
  optional. Also see: gated clock generator and variable timing
  specification.

Variable Interconnection
  A microcomputer bus interconnection that can be changed without
  causing incompatibilities be- tween bus modules (or SoC/IP
  cores). Also called a dynamic interconnection. An example of a
  variable interconnection bus is the WISHBONE SoC architecture. Also
  see: fixed interconnec- tion.

Variable Timing Specification
  A timing specification that is not fixed. In WISHBONE, variable timing
  can be achieved in a number of ways. For example, the system
  integrator can select the frequency of [CLK_O] by enforcing a timing
  specification during the circuit design. Variable timing can also be
  achieved during circuit operation with a variable clock
  generator. Also see: gated clock generator and variable clock
  generator.

Verilog®
  A textual based hardware description language (HDL) intended for use
  in circuit design. The Verilog® language is both a synthesis and a
  simulation tool. Verilog® was originally a proprietary language
  first conceived in 1983 at Gateway Design Automation (Acton, MA), and
  was later refined by Cadence Corporation. It has since been greatly
  expanded and refined, and much of it has been placed into the public
  domain. Complete descriptions of the language can be found in the IEEE
  1364 specification.

VHDL
  Acronym for: VHSIC Hardware Description Language. [VHSIC: Very High
  Speed Integrated Circuit]. A textual based computer language intended
  for use in circuit design. The VHDL lan- guage is both a synthesis and
  a simulation tool. Early forms of the language emerged from US
  Dept. of Defense ARPA projects in the 1960's, and have since been
  greatly expanded and re- fined. Complete descriptions of the language
  can be found in the IEEE 1076, IEEE 1073.3, IEEE 1164 specifications.

VMEbus
  Acronym for: Versa Module Eurocard bus. A popular microcomputer
  (board) bus. While this specification is very flexible, it isn’t
  practical for SoC applications.

WISHBONE
  A flexible System-on-Chip (SoC) design methodology. WISHBONE
  establishes common inter- face standards for data exchange between
  modules within an integrated circuit chip. Its purpose is to foster
  design reuse, portability and reliability of SoC designs. WISHBONE is
  a public do- main standard.

WISHBONE Classic
  WISHBONE Classic is a high performance System-on-Chip (SoC)
  interconnect.  For zero-wait-state operation it requires that the
  SLAVE generates an asynchronous cycle termi- nation signal. See
  chapter 3 for WISHBONE Classic bus cycles.  Also see: WISHBONE
  Registered Feedback

WISHBONE DATASHEET
  A type of documentation required for WISHBONE compatible IP
  cores. This helps the end user understand the detailed operation of
  the core, and how to connect it to other cores. The WISHBONE DATASHEET
  can be included as part of an IP core technical reference manual, or
  as part of the IP core hardware description.

WISHBONE Registered Feedback
  WISHBONE Registered Feedback is a high performace System-on-Chip (SoC)
  interconnect.  It requires that all interface signals are
  registered. To maintain performance, it introduces a num- ber of novel
  bus-cycles. See chapter 4 for WISHBONE Registered Feedback bus cycles.
  Also see: WISHBONE Classic

WISHBONE Signal
  A signal that is defined as part of the WISHBONE
  specification. Non-WISHBONE signals can also be used on the IP core,
  but are not defined as part of this specification. For example,
  [ACK_O] is a WISHBONE signal, but [CLK100_I] is not.

WISHBONE Logo
  A logo that, when affixed to a document, indicates that the associated
  SoC component is com- patible with the WISHBONE standard.

Wrapper
  A circuit element that converts a non-WISHBONE IP Core into a WISHBONE
  compatible IP Core. For example, consider a 16-byte synchronous memory
  primitive that is provided by an IC vendor. The memory primitive can
  be made into a WISHBONE compatible SLAVE by layering a circuit over
  the memory primitive, thereby creating a WISHBONE compatible SLAVE. A
  wrapper is analogous to a technique used to convert software written
  in ‘C’ to that written in ‘C++’.

WORD
  A unit of data that is 16-bits wide. Also see: BYTE, DWORD and QWORD.


References
----------

IEEE 100: The Authoritative Dictionary of IEEE Standards Terms,
Seventh Edition. IEEE Press 2000.

Feustel, Edward A. “On the Advantages of Tagged Architecture”. IEEE
Transactions on Computers, Vol. C-22, No. 7, July 1973.
