Interface Specification
=======================

This chapter describes the signaling method between the MASTER
interface, SLAVE interface, and SYSCON module. This includes numerous
options which may or may not be present on a particular
interface. Furthermore, it describes a minimum level of required
documentation that must be created for each IP core.

Required Documentation for IP Cores
-----------------------------------

WISHBONE compatible IP cores include documentation that describes the
interface. This helps the end user understand the operation of the
core, and how to connect it to other cores. This documentation takes
the form of a WISHBONE DATASHEET. It can be included as part of the IP
core technical reference manual, it can be embedded in source code or
it can take other forms as well.

General Requirements for the WISHBONE DATASHEET
```````````````````````````````````````````````

**RULE 2.00**
  Each WISHBONE compatible IP core MUST include a WISHBONE DATASHEET
  as part of the IP core documentation.

**RULE 2.15**
  The WISHBONE DATASHEET for MASTER and SLAVE interfaces MUST include
  the following information:

  1. The revision level of the WISHBONE specification to which is was
     designed.

  2. The type of interface: MASTER or SLAVE.

  3. The signal names that are defined for the WISHBONE SoC
     interface. If a signal name is different than that defined in this
     specification, then it MUST be cross-referenced to the corresponding
     signal name which is used in this specification.

  4. If a MASTER supports the optional [ERR_I] signal, then the WISHBONE
     DATASHEET MUST describe how it reacts in response to the signal. If
     a SLAVE supports the optional [ERR_O] signal, then the WISHBONE
     DATASHEET MUST describe the conditions under which the signal is
     generated.

  5. If a MASTER supports the optional [RTY_I] signal, then the
     WISHBONE DATASHEET MUST describe how it reacts in response to the
     signal. If a SLAVE supports the optional [RTY_O] signal, then the
     WISHBONE DATASHEET MUST describe the conditions under which the
     signal is generated.

  6. All interfaces that support tag signals MUST describe the name,
     TAG TYPE and operation of the tag in the WISHBONE DATASHEET.

  7. The WISHBONE DATASHEET MUST indicate the port size.  MUST be
     indicated as: 8-bit, 16-bit, 32-bit or 64-bit.

  8. The WISHBONE DATASHEET MUST indicate the port granularity. The
     granularity MUST be indicated as: 8-bit, 16-bit, 32-bit or 64-bit.

  9. The WISHBONE DATASHEET MUST indicate the maximum operand size. The
     maximum operand size MUST be indicated as: 8-bit, 16-bit, 32-bit or
     64-bit. If the maximum operand size is unknown, then the maximum
     operand size shall be the same as the granularity.

  10. The WISHBONE DATASHEET MUST indicate the data transfer
      ordering. The ordering MUST be indicated as BIG ENDIAN or LITTLE
      ENDIAN. When the port size equals the granularity, then the interface
      shall be specified as BIG/LITTLE ENDIAN. [When the port size equals
      the granularity, then BIG ENDIAN and LITTLE ENDIAN transfers are
      identical].

  11. The WISHBONE DATASHEET MUST indicate the sequence of data
      transfer through the port. If the sequence of data transfer is not
      known, then the datasheet MUST indicate it as UNDEFINED.

  12. The WISHBONE DATASHEET MUST indicate if there are any constraints
      on the [CLK_I] signal. These constraints include (but are not limited
      to) clock frequency, application specific timing constraints, the use
      of gated clocks or the use of variable clock generators.

Signal Naming
`````````````

**RULE 2.20**
  Signal names MUST adhere to the rules of the native tool in which
  the IP core is designed.

**PERMISSION 2.00**
  Any signal name MAY be used to describe the WISHBONE signals.

**OBSERVATION 2.00**
  Most hardware description languages (such as VHDL or Verilog®) have
  naming conventions.  For example, the VHDL hardware description
  language defines the alphanumeric symbols which may be
  used. Furthermore, it states that UPPERCASE and LOWERCASE characters
  may be used in a signal name.

**RECOMENDATION 2.00**
  It is recommended that the interface uses the signal names defined
  in this document.

**OBSERVATION 2.05**
  Core integration is simplified if the signal names match those given
  in this specification. However, in some cases (such as IP cores with
  multiple WISHBONE interconnects) they cannot be used. The use of
  non-standard signal names will not result in any serious integration
  problems since all hardware description tools allow signals to be
  renamed.

**PERMISSION 2.05**
  Non-WISHBONE signals MAY be used with IP core interfaces.

**OBSERVATION 2.15**
  Most IP cores will include non-WISHBONE signals. These are outside
  the scope of this specification, and no attempt is made to govern
  them. For example, a disk controller IP core could have a WISHBONE
  interface on one end and a disk interface on the other. In this case
  the specification does not dictate any technical requirements for
  the disk interface signals.

Logic Levels
````````````

**RULE 2.30**
  All WISHBONE interface signals MUST use active high logic.

**OBSERVATION 2.10**
  In general, the use of active low signals does not present a
  problem. However, RULE 2.30 is included because some tools
  (especially schematic entry tools) do not have a standard way of
  indicating an active low signal. For example, a reset signal could
  be named [#RST_I], [/RST_I] or [N_RST_I]. This was found to cause
  confusion among users and incompatibility between modules. This
  constraint should not create any undue difficulties, as the system
  integrator can invert any signals before use by the WISHBONE
  interface.

WISHBONE Signal Description
---------------------------

This section describes the signals used in the WISHBONE
interconnect. Some of these signals are optional, and may or may not
be present on a specific interface.

SYSCON Module Signals
`````````````````````

**CLK_O**

The system clock output [CLK_O] is generated by the SYSCON module. It
coordinates all activities for the internal logic within the
WISHBONE interconnect. The INTERCON module connects the [CLK_O] output
to the [CLK_I] input on MASTER and SLAVE interfaces.

**RST_O**

The reset output [RST_O] is generated by the SYSCON module. It forces
all WISHBONE interfaces to restart. All internal self-starting state
machines are forced into an initial state. The INTERCON connects the
[RST_O] output to the [RST_I] input on MASTER and SLAVE interfaces.

Signals Common to MASTER and SLAVE Interfaces
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**CLK_I**

The clock input [CLK_I] coordinates all activities for the internal
logic within the WISHBONE interconnect. All WISHBONE output signals
are registered at the rising edge of [CLK_I]. All WISHBONE input
signals are stable before the rising edge of [CLK_I].

**DAT_I()**

The data input array [DAT_I()] is used to pass binary data. The array
boundaries are determined by the port size, with a maximum port size
of 64-bits (e.g. [DAT_I(63..0)]). Also see the [DAT_O()] and [SEL_O()]
signal descriptions.

**DAT_O()**

The data output array [DAT_O()] is used to pass binary data. The array
boundaries are determined by the port size, with a maximum port size
of 64-bits (e.g. [DAT_I(63..0)]). Also see the [DAT_I()] and [SEL_O()]
signal descriptions.

**RST_I**

The reset input [RST_I] forces the WISHBONE interface to
restart. Furthermore, all internal self-starting state machines will
be forced into an initial state. This signal only resets the WISHBONE
interface. It is not required to reset other parts of an IP core
(although it may be used that way).

**TGD_I()**

Data tag type [TGD_I()] is used on MASTER and SLAVE interfaces. It
contains information that is associated with the data input array
[DAT_I()], and is qualified by signal [STB_I]. For example, parity
protection, error correction and time stamp information can be
attached to the data bus. These tag bits simplify the task of defining
new signals because their timing (in relation to every bus cycle) is
pre-defined by this specification. The name and operation of a data
tag must be defined in the WISHBONE DATASHEET.

**TGD_O()**

Data tag type [TGD_O()] is used on MASTER and SLAVE interfaces. It
contains information that is associated with the data output array
[DAT_O()], and is qualified by signal [STB_O]. For example, parity
protection, error correction and time stamp information can be
attached to the data bus. These tag bits simplify the task of defining
new signals because their timing (in relation to every bus cycle) is
pre-defined by this specification. The name and operation of a data
tag must be defined in the WISHBONE DATASHEET.

MASTER Signals
``````````````

**ACK_I**

The acknowledge input [ACK_I], when asserted, indicates the normal
termination of a bus cycle.  Also see the [ERR_I] and [RTY_I] signal
descriptions.

**ADR_O()**

The address output array [ADR_O()] is used to pass a binary
address. The higher array boundary is specific to the address width of
the core, and the lower array boundary is determined by the data port
size and granularity. For example the array size on a 32-bit data port
with BYTE granularity is [ADR_O(n..2)]. In some cases (such as FIFO
interfaces) the array may not be present on the interface.

**CYC_O**

The cycle output [CYC_O], when asserted, indicates that a valid bus
cycle is in progress. The signal is asserted for the duration of all
bus cycles. For example, during a BLOCK transfer cycle there can be
multiple data transfers. The [CYC_O] signal is asserted during the
first data transfer, and remains asserted until the last data
transfer. The [CYC_O] signal is useful for interfaces with multi-port
interfaces (such as dual port memories). In these cases, the [CYC_O]
signal requests use of a common bus from an arbiter.

**ERR_I**

The error input [ERR_I] indicates an abnormal cycle termination. The
source of the error, and the response generated by the MASTER is
defined by the IP core supplier. Also see the [ACK_I] and [RTY_I]
signal descriptions.

**LOCK_O**

The lock output [LOCK_O] when asserted, indicates that the current bus
cycle is uninterruptible.  Lock is asserted to request complete
ownership of the bus. Once the transfer has started, the INTERCON does
not grant the bus to any other MASTER, until the current MASTER
negates [LOCK_O] or [CYC_O].

**RTY_I**

The retry input [RTY_I] indicates that the interface is not ready to
accept or send data, and that the cycle should be retried. When and
how the cycle is retried is defined by the IP core supplier.  Also see
the [ERR_I] and [RTY_I] signal descriptions.

**SEL_O()**

The select output array [SEL_O()] indicates where valid data is
expected on the [DAT_I()] signal array during READ cycles, and where
it is placed on the [DAT_O()] signal array during WRITE cycles. The
array boundaries are determined by the granularity of a port. For
example, if 8-bit granularity is used on a 64-bit port, then there
would be an array of eight select signals with boundaries of
[SEL_O(7..0)]. Each individual select signal correlates to one of
eight active bytes on the 64-bit data port. For more information about
[SEL_O()], please refer to the data organization section in Chapter
3 of this specification. Also see the [DAT_I()], [DAT_O()] and [STB_O]
signal descriptions.

**STB_O**

The strobe output [STB_O] indicates a valid data transfer cycle. It is
used to qualify various other signals on the interface such as
[SEL_O()]. The SLAVE asserts either the [ACK_I], [ERR_I] or [RTY_I]
signals in response to every assertion of the [STB_O] signal.

**TGA_O()**

Address tag type [TGA_O()] contains information associated with
address lines [ADR_O()], and is qualified by signal [STB_O]. For
example, address size (24-bit, 32-bit etc.) and memory management
(protected vs. unprotected) information can be attached to an
address. These tag bits simplify the task of defining new signals
because their timing (in relation to every bus cycle) is defined by
this specification. The name and operation of an address tag must be
defined in the WISHBONE DATASHEET.

**TGC_O()**

Cycle tag type [TGC_O()] contains information associated with bus
cycles, and is qualified by signal [CYC_O]. For example, data
transfer, interrupt acknowledge and cache control cycles can be
uniquely identified with the cycle tag. They can also be used to
discriminate between WISHBONE SINGLE, BLOCK and RMW cycles. These tag
bits simplify the task of defining new signals because their timing
(in relation to every bus cycle) is defined by this specification.
The name and operation of a cycle tag must be defined in the WISHBONE
DATASHEET.

**WE_O**

The write enable output [WE_O] indicates whether the current local bus
cycle is a READ or WRITE cycle. The signal is negated during READ
cycles, and is asserted during WRITE cycles.

SLAVE Signals
`````````````

**ACK_O**

The acknowledge output [ACK_O], when asserted, indicates the
termination of a normal bus cycle. Also see the [ERR_O] and [RTY_O]
signal descriptions.

**ADR_I()**

The address input array [ADR_I()] is used to pass a binary
address. The higher array boundary is specific to the address width of
the core, and the lower array boundary is determined by the data port
size. For example the array size on a 32-bit data port with BYTE
granularity is [ADR_O(n..2)]. In some cases (such as FIFO interfaces)
the array may not be present on the interface.

**CYC_I**

The cycle input [CYC_I], when asserted, indicates that a valid bus
cycle is in progress. The signal is asserted for the duration of all
bus cycles. For example, during a BLOCK transfer cycle there can be
multiple data transfers. The [CYC_I] signal is asserted during the
first data transfer, and remains asserted until the last data
transfer.

**ERR_O**

The error output [ERR_O] indicates an abnormal cycle termination. The
source of the error, and the response generated by the MASTER is
defined by the IP core supplier. Also see the [ACK_O] and [RTY_O]
signal descriptions.

**LOCK_I**

The lock input [LOCK_I], when asserted, indicates that the current bus
cycle is uninterruptible.  A SLAVE that receives the LOCK [LOCK_I]
signal is accessed by a single MASTER only, until either [LOCK_I] or
[CYC_I] is negated.

**RTY_O**

The retry output [RTY_O] indicates that the indicates that the
interface is not ready to accept or send data, and that the cycle
should be retried. When and how the cycle is retried is defined by the
IP core supplier. Also see the [ERR_O] and [RTY_O] signal
descriptions.

**SEL_I()**

The select input array [SEL_I()] indicates where valid data is placed
on the [DAT_I()] signal array during WRITE cycles, and where it should
be present on the [DAT_O()] signal array during READ cycles. The array
boundaries are determined by the granularity of a port. For example,
if 8-bit granularity is used on a 64-bit port, then there would be an
array of eight select signals with boundaries of [SEL_I(7..0)]. Each
individual select signal correlates to one of eight active bytes on
the 64-bit data port. For more information about [SEL_I()], please
refer to the data organization section in Chapter 3 of this
specification. Also see the [DAT_I(63..0)], [DAT_O(63..0)] and [STB_I]
signal descriptions.

**STB_I**

The strobe input [STB_I], when asserted, indicates that the SLAVE is
selected. A SLAVE shall respond to other WISHBONE signals only when
this [STB_I] is asserted (except for the [RST_I] signal which should
always be responded to). The SLAVE asserts either the [ACK_O], [ERR_O]
or [RTY_O] signals in response to every assertion of the [STB_I]
signal.

**TGA_I**

Address tag type [TGA_I()] contains information associated with
address lines [ADR_I()], and is qualified by signal [STB_I]. For
example, address size (24-bit, 32-bit etc.) and memory management
(protected vs. unprotected) information can be attached to an
address. These tag bits simplify the task of defining new signals
because their timing (in relation to every bus cycle) is pre-defined
by this specification. The name and operation of an address tag must
be defined in the WISHBONE DATASHEET.

**TGC_I()**

Cycle tag type [TGC_I()] contains information associated with bus
cycles, and is qualified by signal [CYC_I]. For example, data
transfer, interrupt acknowledge and cache control cycles can be
uniquely identified with the cycle tag. They can also be used to
discriminate between WISHBONE SINGLE, BLOCK and RMW cycles. These tag
bits simplify the task of defining new signals because their timing
(in relation to every bus cycle) is pre-defined by this
specification. The name and operation of a cycle tag must be defined
in the WISHBONE DATASHEET.

**WE_I**

The write enable input [WE_I] indicates whether the current local bus
cycle is a READ or WRITE cycle. The signal is negated during READ
cycles, and is asserted during WRITE cycles.
