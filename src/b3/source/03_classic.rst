WISHBONE Classic Bus Cycle
==========================

WISHBONE Classic bus cycles are described in terms of their general operation, reset operation, handshaking protocol and the data organization during transfers.
Additional requirements for bus cycles (especially those relating to the common clock) can be found in the timing specifications in Chapter 5.

General Operation
-----------------

MASTER and SLAVE interfaces are interconnected with a set of signals that permit them to exchange data.
For descriptive purposes these signals are cumulatively known as a bus, and are contained within a functional module called the INTERCON.
Address, data and other information is impressed upon this bus in the form of bus cycles.

Reset Operation
```````````````

All hardware interfaces are initialized to a pre-defined state.
This is accomplished with the reset signal [RST_O] that can be asserted at any time.
It is also used for test simulation purposes by initializing all self-starting state machines and counters which may be used in the design.
The reset signal [RST_O] is driven by the SYSCON module.
It is connected to the [RST_I] signal on all MASTER and SLAVE interfaces.
:numref:`resetcycle` shows the reset cycle.

.. _resetcycle:
.. wavedrom::
   :caption: Reset cycle.

        { "signal": [
		["Master Signals",
                  { "name": "CLK_I",  "wave": "P...." },
		  { "name": "RST_I", "wave": "0.1.x|0...", "period": 0.5 },
		  { "name": "STB_O", "wave": "x...0|..x.", "period": 0.5 },
		  { "name": "CYC_O", "wave": "x...0|..x.", "period": 0.5 }
		]
          ],
	  "config": { "hscale": 2 },
	  "head": { "tick": 0 }
	}


RULE 3.00
    All WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I].
    They MUST stay in the initialized state until the rising [CLK_I] edge that follows the negation of [RST_I].

RULE 3.05
    [RST_I] MUST be asserted for at least one complete clock cycle on all WISHBONE interfaces.

PERMISSION 3.00
    [RST_I] MAY be asserted for more than one clock cycle, and MAY be asserted indefinitely.

RULE 3.10
    All WISHBONE interfaces MUST be capable of reacting to [RST_I] at any time.

RULE 3.15
    All self-starting state machines and counters in WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I].
    They MUST stay in the initialized state until the rising [CLK_I] edge that follows the negation of [RST_I].

OBSERVATION 3.00
    In general, self-starting state machines do not need to be initialized.
    However, this may cause problems because some simulators may not be sophisticated enough to find an initial starting point for the state machine.
    Furthermore, self-starting state machines can go through an indeterminate number of initialization cycles before finding their starting state, thereby making it difficult to predict their behavior at start-up time.
    The initialization rule prevents both problems by forcing all state machines to a pre-defined state in response to the assertion of [RST_I].


RULE 3.20
    The following MASTER signals MUST be negated at the rising [CLK_I] edge following the assertion of [RST_I], and MUST stay in the negated state until the rising [CLK_I] edge that follows the negation of [RST_I]: [STB_O], [CYC_O].
    The state of all other MASTER signals are undefined in response to a reset cycle.

OBSERVATION 3.05
    On MASTER interfaces [STB_O] and [CYC_O] may be asserted beginning at the rising [CLK_I] edge following the negation of [RST_I].

OBSERVATION 3.10
    SLAVE interfaces automatically negate [ACK_O], [ERR_O] and [RTY_O] when their [STB_I] is negated.

RECOMENDATION 3.00
    Design SYSCON modules so that they assert [RST_O] during a power-up condition.
    [RST_O] should remain asserted until all voltage levels and clock frequencies in the system are stabilized.
    When negating [RST_O], do so in a synchronous manner that conforms to this specification.

OBSERVATION 3.15
    If a gated clock generator is used, and if the clock is stopped, then the WISHBONE interface is not capable of responding to its [RST_I] signal.

SUGGESTION 3.00
    Some circuits require an asynchronous reset capability.
    If an IP core or other SoC component requires an asynchronous reset, then define it as a non-WISHBONE signal.
    This prevents confusion with the WISHBONE reset [RST_I] signal that uses a purely synchronous protocol, and needs to be applied to the WISHBONE interface only.

OBSERVATION 3.20
    All WISHBONE interfaces respond to the reset signal.
    However, the IP Core connected to a WISHBONE interface does not necessarily need to respond to the reset signal.

Transfer Cycle initiation
`````````````````````````

MASTER interfaces initiate a transfer cycle by asserting [CYC_O].
When [CYC_O] is negated, all other MASTER signals are invalid.
SLAVE interfaces respond to other SLAVE signals only when [CYC_I] is asserted.
SYSCON signals and responses to SYSCON signals are not affected.

RULE 3.25
    MASTER interfaces MUST assert [CYC_O] for the duration of SINGLE READ / WRITE, BLOCK and RMW cycles.
    [CYC_O] MUST be asserted no later than the rising [CLK_I] edge that qualifies the assertion of [STB_O].
    [CYC_O] MUST be negated no earlier than the rising [CLK_I] edge that qualifies the negation of [STB_O].

PERMISSION 3.05
    MASTER interfaces MAY assert [CYC_O] indefinitely.

RECOMMENDATION 3.05
    Arbitration logic often uses [CYC_I] to select between MASTER interfaces.
    Keeping [CYC_O] asserted may lead to arbitration problems.
    It is therefore recommended that [CYC_O] is not indefinitely asserted.

RULE 3.30
    SLAVE interfaces MAY NOT respond to any SLAVE signals when [CYC_I] is negated.
    However, SLAVE interfaces MUST always respond to SYSCON signals.

Handshaking Protocol
````````````````````

All bus cycles use a handshaking protocol between the MASTER and SLAVE
interfaces. As shown in Figure 3-2, the MASTER asserts [STB_O] when it
is ready to transfer data. [STB_O] remains asserted until the SLAVE
asserts one of the cycle terminating signals [ACK_I], [ERR_I] or
[RTY_I]. At every rising edge of [CLK_I] the terminating signal is
sampled. If it is asserted, then [STB_O] is negated. This gives both
MASTER and SLAVE interfaces the possibility to control the rate at
which data is transferred.

PERMISSION 3.10
  If the SLAVE guarantees it can keep pace with all MASTER interfaces
  and if the [ERR_I] and [RTY_I] signals are not used, then the SLAVE’s
  [ACK_O] signal MAY be tied to the logical AND of the SLAVE’s [STB_I]
  and [CYC_I] inputs. The interface will function normally under these
  circumstances.

OBSERVATION 3.25
  SLAVE interfaces assert a cycle termination signal in response to
  [STB_I]. However, [STB_I] is only valid when [CYC_I] is valid.  RULE
  3.35 The cycle termination signals [ACK_O], [ERR_O], and [RTY_O] must
  be generated in response to the logical AND of [CYC_I] and [STB_I].

PERMISSION 3.15
  Other signals, besides [CYC_I] and [STB_I], MAY be included in the generation of the cycle
  termination signals.

OBSERVATION 3.30
  Internal SLAVE signals also determine what cycle termination signal is
  asserted and when it is asserted.

Most of the examples in this specification describe the use of [ACK_I]
to terminate a local bus cycle. However, the SLAVE can optionally
terminate the cycle with an error [ERR_O], or re- quest that the cycle
be retried [RTY_O].

All MASTER interfaces include the [ACK_I] terminator signal. Asserting
this signal during a bus cycle causes it to terminate normally.

Asserting the [ERR_I] signal during a bus cycle will terminate the
cycle. It also serves to notify the MASTER that an error occurred
during the cycle. This signal is generally used if an error was
detected by SLAVE logic circuitry. For example, if the SLAVE is a
parity-protected mem- ory, then the [ERR_I] signal can be asserted if
a parity fault is detected. This specification does not dictate what
the eMASTER will do in response to [ERR_I].

Asserting the optional [RTY_I] signal during a bus cycle will
terminate the cycle. It also serves to notify the MASTER that the
current cycle should be aborted, and retried at a later time. This
signal is generally used for shared memory and bus bridges. In these
cases SLAVE circuitry as- serts [RTY_I] if the local resource is
busy. This specification does not dictate when or how the MASTER will
respond to [RTY_I].

RULE 3.40
  As a minimum, the MASTER interface MUST include the following signals:
  [ACK_I], [CLK_I], [CYC_O], [RST_I], and [STB_O]. As a minimum, the
  SLAVE interface MUST include the fol- lowing signals: [ACK_O],
  [CLK_I], [CYC_I], [STB_I], and [RST_I]. All other signals are op-
  tional.

PERMISSION 3.20
  MASTER and SLAVE interfaces MAY be designed to support the [ERR_I] and
  [ERR_O] sig- nals. In these cases, the SLAVE asserts [ERR_O] to
  indicate that an error has occurred during the bus cycle. This
  specification does not dictate what the MASTER does in response to
  [ERR_I].

PERMISSION 3.25
  MASTER and SLAVE interfaces MAY be designed to support the [RTY_I] and
  [RTY_O] sig- nals. In these cases, the SLAVE asserts [RTY_O] to
  indicate that the interface is busy, and that the bus cycle should be
  retried at a later time. This specification does not dictate what the
  MASTER will do in response to [RTY_I].

RULE 3.45
  If a SLAVE supports the [ERR_O] or [RTY_O] signals, then the SLAVE
  MUST NOT assert more than one of the following signals at any time:
  [ACK_O], [ERR_O] or [RTY_O].  OBSERVATION 3.35 If the SLAVE supports
  the [ERR_O] or [RTY_O] signals, but the MASTER does not support these
  signals, deadlock may occur.

RECOMMENDATION 3.10
  Design INTERCON modules to prevent deadlock conditions. One solution
  to this problem is to include a watchdog timer function that monitors
  the MASTER’s [STB_O] signal, and asserts [ERR_I] or [RTY_I] if the
  cycle exceeds some pre-defined time limit. INTERCON modules can also
  be designed to disconnect interfaces from the WISHBONE bus if they
  constantly generate bus errors and/or watchdog time-outs.

RECOMMENDATION 3.15
  Design WISHBONE MASTER interfaces so that there are no intermediate
  logic gates between a registered flip-flop and the signal outputs on
  [STB_O] and [CYC_O]. Delay timing for [STB_O] and [CYC_O] are very
  often the most critical paths in the system. This prevents sloppy
  design practices from slowing down the interconnect because of added
  delays on these two signals.

RULE 3.50
  SLAVE interfaces MUST be designed so that the [ACK_O], [ERR_O], and
  [RTY_O] signals are asserted and negated in response to the assertion
  and negation of [STB_I].

PERMISSION 3.30
  The assertion of [ACK_O], [ERR_O], and [RTY_O] MAY be asynchronous to
  the [CLK_I] sig- nal (i.e. there is a combinatorial logic path between
  [STB_I] and [ACK_O]).

OBSERVATION 3.40
  The asynchronous assertion of [ACK_O], [ERR_O], and [RTY_O] assures
  that the interface can accomplish one data transfer per clock
  cycle. Furthermore, it simplifies the design of arbiters in
  multi-MASTER applications.

OBSERVATION 3.45
  The asynchronous assertion of [ACK_O], [ERR_O], and [RTY_O] could
  proof impossible to implement. For example slave wait states are
  easiest implemented using a registered [ACK_O] signal.

OBSERVATION 3.50
  In large high speed designs the asynchronous assertion of [ACK_O],
  [ERR_O], and [RTY_O] could lead to unacceptable delay times, caused by
  the loopback delay from the MASTER to the SLAVE and back to the
  MASTER. Using registered [ACK_O], [ERR_O], and [RTY_O] signals
  significantly reduces this loopback delay, at the cost of one
  additional wait state per transfer. See WISHBONE Registered Feedback
  Bus Cycles for methods of eliminating the wait state.

PERMISSION 3.35
  Under certain circumstances SLAVE interfaces MAY be designed to hold
  [ACK_O] in the as- serted state. This situation occurs on
  point-to-point interfaces where there is a single SLAVE on the
  interface, and that SLAVE always operates without wait states.

RULE 3.55
  MASTER interfaces MUST be designed to operate normally when the SLAVE
  interface holds [ACK_I] in the asserted state.

Use of [STB_O]
``````````````

RULE 3.60
  MASTER interfaces MUST qualify the following signals with [STB_O]:
  [ADR_O], [DAT_O()], [SEL_O()], [WE_O], and [TAGN_O].

PERMISSION 3.40
  If a MASTER doesn’t generate wait states, then [STB_O] and [CYC_O] MAY
  be assigned the same signal.

OBSERVATION 3.55
  [CYC_O] needs to be asserted during the entire transfer cycle. A
  MASTER that doesn’t generate wait states doesn’t negate [STB_O] during
  a transfer cycle, i.e. it is asserted the entire transfer
  cycle. Therefore it is allowed to use the same signal for [CYC_O] and
  [STB_O]. Both signals must be present on the interface though.

Use of [ACK_O], [ERR_O] and [RTY_O]
```````````````````````````````````

RULE 3.65
  SLAVE interfaces MUST qualify the following signals with [ACK_O],
  [ERR_O] or [RTY_O]: [DAT_O()].

Use of TAG TYPES
````````````````

The WISHBONE interface can be modified with user defined signals. This
is done with a tech- nique known as tagging. Tags are a well known
concept in the microcomputer bus industry.  They allow user defined
information to be associated with an address, a data word or a bus
cycle.  All tag signals must conform to set of guidelines known as TAG
TYPEs. Table 3-1 lists all of the defined TAG TYPEs along with their
associated data set and signal waveform. When a tag is added to an
interface it is assigned a TAG TYPE from the table. This explicitly
defines how the tag operates. This information must also be included
in the WISHBONE DATASHEET.

+------------------+----------+-----------------+----------+-----------------+
| Description      | TAG TYPE | Associated with | TAG TYPE | Associated with |
+------------------+----------+-----------------+----------+-----------------+
| Address tag      | TGA_O()  |  ADR_O()        | TGA_I()  |  ADR_I()        |
+------------------+----------+-----------------+----------+-----------------+
| Data tag, input  | TGD_I()  |  DAT_I()        | TGD_I()  |  DAT_I()        |
+------------------+----------+-----------------+----------+-----------------+
| Data tag, output | TGD_O()  |  DAT_O()        | TGD_O()  |  DAT_O()        |
+------------------+----------+-----------------+----------+-----------------+
| Cycle tag        | TGC_O()  |  Bus Cycle      | TGC_I()  |  Bus Cycle      |
+------------------+----------+-----------------+----------+-----------------+

For example, consider a MASTER interface where a parity protection bit
named [PAR_O] is generated from an output data word on
[DAT_O(15..0)]. It’s an ‘even’ parity bit, meaning that it’s asserted
whenever there are an even number of ‘1’s in the data word. If this
signal were added to the interface, then the following information (in
the WISHBONE DATASHEET) would be sufficient to completely define the
timing of [PAR_O]:

  SIGNAL NAME:
    PAR_O

  DESCRIPTION:
    Even parity bit

  MASTER TAG TYPE:
    TGD_O()

RULE 3.70
  All user defined tags MUST be assigned a TAG TYPE. Furthermore, they
  MUST adhere to the timing specifications given in this document for
  the indicated TAG TYPE.

PERMISSION 3.45
  While all TAG TYPES are specified as arrays (with parenthesis ‘()’),
  the actual tag MAY be a non-arrayed signal.

RECOMMENDATION 3.15
  If a MASTER interface supports more than one defined bus cycle over a
  common set of signal lines, then include a cycle tag to identify each
  type of bus cycle. This allows INTERCON and SLAVE interface circuits
  to discriminate between these bus cycles (if needed). Define the sig-
  nals as TAG TYPE: [TGC_O()], using signal names of [SGL_O], [BLK_O]
  and [RMW_O] when identifying SINGLE, BLOCK and RMW cycles
  respectively.

SINGLE READ / WRITE Cycles
--------------------------

.. todo::

   Missing section

BLOCK READ / WRITE Cycles
-------------------------

.. todo::

   Missing section

RMW Cycle
---------

.. todo::

   Missing section

Data Organization
-----------------

.. todo::

   Missing section

References
----------

.. todo::

   Missing section
