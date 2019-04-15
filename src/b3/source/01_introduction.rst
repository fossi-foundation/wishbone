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
These are presented only as a convenience to the reader, and should be readily understood by users of other hardware description languages (such as Verilog).
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
  For example, soft cores may be written and synthesized in VHDL, Verilog or some other hardware description language.
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

RULE
    Rules form the basic framework of the specification.
    They are sometimes expressed in text form and sometimes in the form of figures, tables or drawings.
    All rules MUST be followed to ensure compatibility between interfaces.
    Rules are characterized by an imperative style.
    The uppercase words MUST and MUST NOT are reserved exclusively for stating rules in this document, and are not used for any other purpose.

RECOMMENDATION
    Whenever a recommendation appears, designers would be wise to take the advice given.
    Doing otherwise might result in some awkward problems or poor performance.
    While this specification has been designed to support high performance systems, it is possible to create an interconnection that complies with all the rules, but has very poor performance.
    In many cases a designer needs a certain level of experience with the system architecture in order to design interfaces that deliver top performance.
    Recommendations found in this document are based on this kind of experience and are provided as guidance for the user.

SUGGESTION
    A suggestion contains advice which is helpful but not vital.
    The reader is encouraged to consider the advice before discarding it.
    Some design decisions are difficult until experience has been gained.
    Suggestions help a designer who has not yet gained this experience.
    Some suggestions have to do with designing compatible interconnections, or with making system integration easier.

PERMISSION
    In some cases a rule does not specifically prohibit a certain design approach, but the reader might be left wondering whether that approach might violate the spirit of the rule, or whether it might lead to some subtle problem.
    Permissions reassure the reader that a certain approach is acceptable and will not cause problems.
    The upper-case word MAY is reserved exclusively for stating a permission and is not used for any other purpose.

OBSERVATION
    Observations do not offer any specific advice.
    They usually clarify what has just been discussed.
    They spell out the implications of certain rules and bring attention to things that might otherwise be overlooked.
    They also give the rationale behind certain rules, so that the reader understands why the rule must be followed.

Use of Timing Diagrams
----------------------

:numref:`timingdiagram` shows some of the key features of the timing diagrams in this specification.
Unless otherwise noted, the MASTER signal names are referenced in the timing diagrams.
In some cases the MASTER and SLAVE signal names are different.
For example, in the point-to-point interconnections the [ADR_O] and [ADR_I] signals are connected together.
Furthermore, the actual waveforms at the SLAVE may vary from those at the MASTER.
That's because the MASTER and SLAVE interfaces can be connected together in different ways.
Unless otherwise noted, the timing diagrams refer to the connection diagram shown in TODO.

.. todo::
   Convert Figure 1.2

.. _timingdiagram:
.. wavedrom::
   :caption: Use of timing diagrams.

        { "signal": [
                { "name": "CLK_I",  "wave": "P|P." },
		{ "name": "ADR_O()", "wave": "x|=.", "data": "VALID" }
          ],
	  "config": { "hscale": 2 },
	  "head": { "tock": 0 }
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

.. todo::

   Missing section


Glossary of Terms
-----------------

.. todo::

   Missing section

References
----------

.. todo::

   Missing section
