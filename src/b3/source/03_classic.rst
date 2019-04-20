WISHBONE Classic Bus Cycle
==========================

WISHBONE Classic bus cycles are described in terms of their general
operation, reset operation, handshaking protocol and the data
organization during transfers.  Additional requirements for bus cycles
(especially those relating to the common clock) can be found in the
timing specifications in Chapter 5.

General Operation
-----------------

MASTER and SLAVE interfaces are interconnected with a set of signals
that permit them to exchange data.  For descriptive purposes these
signals are cumulatively known as a bus, and are contained within a
functional module called the INTERCON.  Address, data and other
information is impressed upon this bus in the form of bus cycles.

Reset Operation
```````````````

All hardware interfaces are initialized to a pre-defined state.  This
is accomplished with the reset signal [RST_O] that can be asserted at
any time.  It is also used for test simulation purposes by
initializing all self-starting state machines and counters which may
be used in the design.  The reset signal [RST_O] is driven by the
SYSCON module.  It is connected to the [RST_I] signal on all MASTER
and SLAVE interfaces.  :numref:`resetcycle` shows the reset cycle.

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


**RULE 3.00**
    All WISHBONE interfaces MUST initialize themselves at the rising
    [CLK_I] edge following the assertion of [RST_I].  They MUST stay
    in the initialized state until the rising [CLK_I] edge that
    follows the negation of [RST_I].

**RULE 3.05**
    [RST_I] MUST be asserted for at least one complete clock cycle on
    all WISHBONE interfaces.

**PERMISSION 3.00**
    [RST_I] MAY be asserted for more than one clock cycle, and MAY be
    asserted indefinitely.

**RULE 3.10**
    All WISHBONE interfaces MUST be capable of reacting to [RST_I] at any time.

**RULE 3.15**
    All self-starting state machines and counters in WISHBONE
    interfaces MUST initialize themselves at the rising [CLK_I] edge
    following the assertion of [RST_I].  They MUST stay in the
    initialized state until the rising [CLK_I] edge that follows the
    negation of [RST_I].

**OBSERVATION 3.00**
    In general, self-starting state machines do not need to be
    initialized.  However, this may cause problems because some
    simulators may not be sophisticated enough to find an initial
    starting point for the state machine.  Furthermore, self-starting
    state machines can go through an indeterminate number of
    initialization cycles before finding their starting state, thereby
    making it difficult to predict their behavior at start-up time.
    The initialization rule prevents both problems by forcing all
    state machines to a pre-defined state in response to the assertion
    of [RST_I].


**RULE 3.20**
    The following MASTER signals MUST be negated at the rising [CLK_I]
    edge following the assertion of [RST_I], and MUST stay in the
    negated state until the rising [CLK_I] edge that follows the
    negation of [RST_I]: [STB_O], [CYC_O].  The state of all other
    MASTER signals are undefined in response to a reset cycle.

**OBSERVATION 3.05**
    On MASTER interfaces [STB_O] and [CYC_O] may be asserted beginning
    at the rising [CLK_I] edge following the negation of [RST_I].

**OBSERVATION 3.10**
    SLAVE interfaces automatically negate [ACK_O], [ERR_O] and [RTY_O]
    when their [STB_I] is negated.

**RECOMENDATION 3.00**
    Design SYSCON modules so that they assert [RST_O] during a
    power-up condition.  [RST_O] should remain asserted until all
    voltage levels and clock frequencies in the system are stabilized.
    When negating [RST_O], do so in a synchronous manner that conforms
    to this specification.

**OBSERVATION 3.15**
    If a gated clock generator is used, and if the clock is stopped,
    then the WISHBONE interface is not capable of responding to its
    [RST_I] signal.

**SUGGESTION 3.00**
    Some circuits require an asynchronous reset capability.  If an IP
    core or other SoC component requires an asynchronous reset, then
    define it as a non-WISHBONE signal.  This prevents confusion with
    the WISHBONE reset [RST_I] signal that uses a purely synchronous
    protocol, and needs to be applied to the WISHBONE interface only.

**OBSERVATION 3.20**
    All WISHBONE interfaces respond to the reset signal.  However, the
    IP Core connected to a WISHBONE interface does not necessarily
    need to respond to the reset signal.

Transfer Cycle initiation
`````````````````````````

MASTER interfaces initiate a transfer cycle by asserting [CYC_O].
When [CYC_O] is negated, all other MASTER signals are invalid.  SLAVE
interfaces respond to other SLAVE signals only when [CYC_I] is
asserted.  SYSCON signals and responses to SYSCON signals are not
affected.

**RULE 3.25**
    MASTER interfaces MUST assert [CYC_O] for the duration of SINGLE
    READ / WRITE, BLOCK and RMW cycles.  [CYC_O] MUST be asserted no
    later than the rising [CLK_I] edge that qualifies the assertion of
    [STB_O].  [CYC_O] MUST be negated no earlier than the rising
    [CLK_I] edge that qualifies the negation of [STB_O].

**PERMISSION 3.05**
    MASTER interfaces MAY assert [CYC_O] indefinitely.

**RECOMMENDATION 3.05**
    Arbitration logic often uses [CYC_I] to select between MASTER
    interfaces.  Keeping [CYC_O] asserted may lead to arbitration
    problems.  It is therefore recommended that [CYC_O] is not
    indefinitely asserted.

**RULE 3.30**
    SLAVE interfaces MAY NOT respond to any SLAVE signals when [CYC_I]
    is negated.  However, SLAVE interfaces MUST always respond to
    SYSCON signals.

Handshaking Protocol
````````````````````

All bus cycles use a handshaking protocol between the MASTER and SLAVE
interfaces. As shown in Figure :ref:`hanshaking <handshake>`, the
MASTER asserts [STB_O] when it is ready to transfer data. [STB_O]
remains asserted until the SLAVE asserts one of the cycle terminating
signals [ACK_I], [ERR_I] or [RTY_I]. At every rising edge of [CLK_I]
the terminating signal is sampled. If it is asserted, then [STB_O] is
negated. This gives both MASTER and SLAVE interfaces the possibility
to control the rate at which data is transferred.

.. _handshake:
.. wavedrom::
   :caption: Local bus handshaking protocol.

        { "signal": [
                  { "name": "CLK_I", "wave": "P..." },
		  { "name": "STB_O", "wave": "0...1..0",
                                     "node": "....A..C", "period": 0.5 },
		  { "name": "ACK_I", "wave": "0....10.",
                                     "node": ".....BD.", "period": 0.5 }
          ],
          "edge": [ "A~>B", "D~>C" ],
	  "config": { "hscale": 2 },
	  "head": { "tick": 0 }
	}

**PERMISSION 3.10**
  If the SLAVE guarantees it can keep pace with all MASTER interfaces
  and if the [ERR_I] and [RTY_I] signals are not used, then the SLAVE’s
  [ACK_O] signal MAY be tied to the logical AND of the SLAVE’s [STB_I]
  and [CYC_I] inputs. The interface will function normally under these
  circumstances.

**OBSERVATION 3.25**
  SLAVE interfaces assert a cycle termination signal in response to
  [STB_I]. However, [STB_I] is only valid when [CYC_I] is valid.  RULE
  3.35 The cycle termination signals [ACK_O], [ERR_O], and [RTY_O] must
  be generated in response to the logical AND of [CYC_I] and [STB_I].

**PERMISSION 3.15**
  Other signals, besides [CYC_I] and [STB_I], MAY be included in the
  generation of the cycle termination signals.

**OBSERVATION 3.30**
  Internal SLAVE signals also determine what cycle termination signal is
  asserted and when it is asserted.

Most of the examples in this specification describe the use of [ACK_I]
to terminate a local bus cycle. However, the SLAVE can optionally
terminate the cycle with an error [ERR_O], or request that the cycle
be retried [RTY_O].

All MASTER interfaces include the [ACK_I] terminator signal. Asserting
this signal during a bus cycle causes it to terminate normally.

Asserting the [ERR_I] signal during a bus cycle will terminate the
cycle. It also serves to notify the MASTER that an error occurred
during the cycle. This signal is generally used if an error was
detected by SLAVE logic circuitry. For example, if the SLAVE is a
parity-protected memory, then the [ERR_I] signal can be asserted if
a parity fault is detected. This specification does not dictate what
the eMASTER will do in response to [ERR_I].

Asserting the optional [RTY_I] signal during a bus cycle will
terminate the cycle. It also serves to notify the MASTER that the
current cycle should be aborted, and retried at a later time. This
signal is generally used for shared memory and bus bridges. In these
cases SLAVE circuitry asserts [RTY_I] if the local resource is
busy. This specification does not dictate when or how the MASTER will
respond to [RTY_I].

**RULE 3.40**
  As a minimum, the MASTER interface MUST include the following signals:
  [ACK_I], [CLK_I], [CYC_O], [RST_I], and [STB_O]. As a minimum, the
  SLAVE interface MUST include the following signals: [ACK_O],
  [CLK_I], [CYC_I], [STB_I], and [RST_I]. All other signals are optional.

**PERMISSION 3.20**
  MASTER and SLAVE interfaces MAY be designed to support the [ERR_I] and
  [ERR_O] signals. In these cases, the SLAVE asserts [ERR_O] to
  indicate that an error has occurred during the bus cycle. This
  specification does not dictate what the MASTER does in response to
  [ERR_I].

**PERMISSION 3.25**
  MASTER and SLAVE interfaces MAY be designed to support the [RTY_I] and
  [RTY_O] signals. In these cases, the SLAVE asserts [RTY_O] to
  indicate that the interface is busy, and that the bus cycle should be
  retried at a later time. This specification does not dictate what the
  MASTER will do in response to [RTY_I].

**RULE 3.45**
  If a SLAVE supports the [ERR_O] or [RTY_O] signals, then the SLAVE
  MUST NOT assert more than one of the following signals at any time:
  [ACK_O], [ERR_O] or [RTY_O].  OBSERVATION 3.35 If the SLAVE supports
  the [ERR_O] or [RTY_O] signals, but the MASTER does not support these
  signals, deadlock may occur.

**RECOMMENDATION 3.10**
  Design INTERCON modules to prevent deadlock conditions. One solution
  to this problem is to include a watchdog timer function that monitors
  the MASTER’s [STB_O] signal, and asserts [ERR_I] or [RTY_I] if the
  cycle exceeds some pre-defined time limit. INTERCON modules can also
  be designed to disconnect interfaces from the WISHBONE bus if they
  constantly generate bus errors and/or watchdog time-outs.

**RECOMMENDATION 3.15**
  Design WISHBONE MASTER interfaces so that there are no intermediate
  logic gates between a registered flip-flop and the signal outputs on
  [STB_O] and [CYC_O]. Delay timing for [STB_O] and [CYC_O] are very
  often the most critical paths in the system. This prevents sloppy
  design practices from slowing down the interconnect because of added
  delays on these two signals.

**RULE 3.50**
  SLAVE interfaces MUST be designed so that the [ACK_O], [ERR_O], and
  [RTY_O] signals are asserted and negated in response to the assertion
  and negation of [STB_I].

**PERMISSION 3.30**
  The assertion of [ACK_O], [ERR_O], and [RTY_O] MAY be asynchronous to
  the [CLK_I] signal (i.e. there is a combinatorial logic path between
  [STB_I] and [ACK_O]).

**OBSERVATION 3.40**
  The asynchronous assertion of [ACK_O], [ERR_O], and [RTY_O] assures
  that the interface can accomplish one data transfer per clock
  cycle. Furthermore, it simplifies the design of arbiters in
  multi-MASTER applications.

**OBSERVATION 3.45**
  The asynchronous assertion of [ACK_O], [ERR_O], and [RTY_O] could
  proof impossible to implement. For example slave wait states are
  easiest implemented using a registered [ACK_O] signal.

**OBSERVATION 3.50**
  In large high speed designs the asynchronous assertion of [ACK_O],
  [ERR_O], and [RTY_O] could lead to unacceptable delay times, caused by
  the loopback delay from the MASTER to the SLAVE and back to the
  MASTER. Using registered [ACK_O], [ERR_O], and [RTY_O] signals
  significantly reduces this loopback delay, at the cost of one
  additional wait state per transfer. See WISHBONE Registered Feedback
  Bus Cycles for methods of eliminating the wait state.

**PERMISSION 3.35**
  Under certain circumstances SLAVE interfaces MAY be designed to hold
  [ACK_O] in the asserted state. This situation occurs on
  point-to-point interfaces where there is a single SLAVE on the
  interface, and that SLAVE always operates without wait states.

**RULE 3.55**
  MASTER interfaces MUST be designed to operate normally when the SLAVE
  interface holds [ACK_I] in the asserted state.

Use of [STB_O]
``````````````

**RULE 3.60**
  MASTER interfaces MUST qualify the following signals with [STB_O]:
  [ADR_O], [DAT_O()], [SEL_O()], [WE_O], and [TAGN_O].

**PERMISSION 3.40**
  If a MASTER doesn’t generate wait states, then [STB_O] and [CYC_O] MAY
  be assigned the same signal.

**OBSERVATION 3.55**
  [CYC_O] needs to be asserted during the entire transfer cycle. A
  MASTER that doesn’t generate wait states doesn’t negate [STB_O] during
  a transfer cycle, i.e. it is asserted the entire transfer
  cycle. Therefore it is allowed to use the same signal for [CYC_O] and
  [STB_O]. Both signals must be present on the interface though.

Use of [ACK_O], [ERR_O] and [RTY_O]
```````````````````````````````````

**RULE 3.65**
  SLAVE interfaces MUST qualify the following signals with [ACK_O],
  [ERR_O] or [RTY_O]: [DAT_O()].

Use of TAG TYPES
````````````````

The WISHBONE interface can be modified with user defined signals. This
is done with a technique known as tagging. Tags are a well known
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

**RULE 3.70**
  All user defined tags MUST be assigned a TAG TYPE. Furthermore, they
  MUST adhere to the timing specifications given in this document for
  the indicated TAG TYPE.

**PERMISSION 3.45**
  While all TAG TYPES are specified as arrays (with parenthesis ‘()’),
  the actual tag MAY be a non-arrayed signal.

**RECOMMENDATION 3.15**
  If a MASTER interface supports more than one defined bus cycle over
  a common set of signal lines, then include a cycle tag to identify
  each type of bus cycle. This allows INTERCON and SLAVE interface
  circuits to discriminate between these bus cycles (if
  needed). Define the signals as TAG TYPE: [TGC_O()], using signal
  names of [SGL_O], [BLK_O] and [RMW_O] when identifying SINGLE, BLOCK
  and RMW cycles respectively.

SINGLE READ / WRITE Cycles
--------------------------

The SINGLE READ / WRITE cycles perform one data transfer at a
time. These are the basic cycles used to perform data transfers on the
WISHBONE interconnect.  Note that the [CYC_O] signal isn’t shown here
to keep the timing diagrams as simple as possible. It is assumed
that [CYC_O] is continuously asserted.

**RULE 3.75**
  All MASTER and SLAVE interfaces that support SINGLE READ or SINGLE
  WRITE cycles MUST conform to the timing requirements given in sections
  3.2.1 and 3.2.2.

**PERMISSION 3.50**
  MASTER and SLAVE interfaces MAY be designed so that they do not
  support the SINGLE READ or SINGLE WRITE cycles.

SINGLE READ Cycle
`````````````````

:numref:`singlereadcycle` shows a SINGLE READ cycle. The bus protocol works as follows:

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the phase.

SETUP, EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  SLAVE asserts [ACK_I] in response to [STB_O] to indicate valid data.

  MASTER monitors [ACK_I], and prepares to latch data on [DAT_I()] and
  [TGD_I()].

  Note: SLAVE may insert wait states (-WSS-) before asserting [ACK_I],
  thereby allowing it to throttle the cycle speed. Any number of wait
  states may be added.

CLOCK EDGE 1:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER negates [STB_O] and [CYC_O] to indicate the end of the cycle.

  SLAVE negates [ACK_I] in response to negated [STB_O].

.. _singlereadcycle:
.. wavedrom::
   :caption: SINGLE READ cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "P|.", "label": ".{WSS}(0.45)." },
       { "name": "ADR_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"] },
       { "name": "DAT_I()", "wave": "x.<.|>=.x", "period": 0.5, "data": ["VALID"] },
       { "name": "DAT_O()", "wave": "x.<.|>...", "period": 0.5 },
       { "name": "WE_O", "wave": "x.<0|>..x", "period": 0.5 },
       { "name": "SEL_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"] },
       { "name": "STB_O", "wave": "0.<1|>..0", "period": 0.5 },
       { "name": "CYC_O", "wave": "0.<1|>..0", "period": 0.5  },
       { "name": "ACK_I", "wave": "0.<.|>1.0", "period": 0.5 }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"]  },
       { "name": "TGD_I()", "wave": "x.<.|>=.x", "period": 0.5, "data": ["VALID"]  },
       { "name": "TGD_O()", "wave": "x.<.|>...", "period": 0.5  },
       { "name": "TGC_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"]  }
     ]
          ],
	  "config": { "hscale": 2 },
	  "head": { "tick": 0 }
	}

SINGLE WRITE Cycle
``````````````````

:numref:`singlewritecycle` shows a SINGLE WRITE cycle. The bus protocol works as follows:

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER presents valid data on [DAT_O()] and [TGD_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents bank select [SEL_O()] to indicate where it sends data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the phase.

SETUP, EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  SLAVE asserts [ACK_I] in response to [STB_O] to indicate latched data.

  MASTER monitors [ACK_I], and prepares to terminate the cycle.

  Note: SLAVE may insert wait states (-WSS-) before asserting [ACK_I],
  thereby allowing it to throttle the cycle speed. Any number of wait
  states may be added.

CLOCK EDGE 1:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER negates [STB_O] and [CYC_O] to indicate the end of the cycle.

  SLAVE negates [ACK_I[ in response to negated [STB_O].

.. _singlewritecycle:
.. wavedrom::
   :caption: SINGLE WRITE cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "P|.", "label": ".{WSS}(0.45)." },
       { "name": "ADR_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"] },
       { "name": "DAT_I()", "wave": "x.<.|>...", "period": 0.5 },
       { "name": "DAT_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"] },
       { "name": "WE_O", "wave": "x.<1|>..x", "period": 0.5 },
       { "name": "SEL_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"] },
       { "name": "STB_O", "wave": "0.<1|>..0", "period": 0.5 },
       { "name": "CYC_O", "wave": "0.<1|>..0", "period": 0.5  },
       { "name": "ACK_I", "wave": "0.<.|>1.0", "period": 0.5 }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"]  },
       { "name": "TGD_I()", "wave": "x.<.|>...", "period": 0.5  },
       { "name": "TGD_O()", "wave": "x.<.|>=.x", "period": 0.5, "data": ["VALID"]  },
       { "name": "TGC_O()", "wave": "x.<=|>..x", "period": 0.5, "data": ["VALID"]  }
     ]
          ],
	  "config": { "hscale": 2 },
	  "head": { "tick": 0 }
	}

BLOCK READ / WRITE Cycles
-------------------------

The BLOCK transfer cycles perform multiple data transfers. They are
very similar to single READ and WRITE cycles, but have a few special
modifications to support multiple transfers.

During BLOCK cycles, the interface basically performs SINGLE
READ/WRITE cycles as described above. However, the BLOCK cycles are
modified somewhat so that these individual cycles (called phases)
are combined together to form a single BLOCK cycle. This function is
most useful when multiple MASTERs are used on the interconnect. For
example, if the SLAVE is a shared (dual port) memory, then an arbiter
for that memory can determine when one MASTER is done with it so that
another can gain access to the memory.

As shown in :numref:`cycduringblock`, the [CYC_O] signal is asserted
for the duration of a BLOCK cycle.  This signal can be used to request
permission to access a shared resource from a local arbiter. To hold
the access until the end of the cycle the [LOCK_O] signal must be
asserted, as is shown.  During each of the data transfer phases
(within the block transfer), the normal handshaking protocol between
[STB_O] and [ACK_I] is maintained.

.. _cycduringblock:
.. wavedrom::
   :caption: Use of [CYC_O] signal during BLOCK cycles.

   {"signal": [
      {"name": "CLK_I", "wave": "P||.|||" },
      {"name": "LOCK_O", "wave": "0.<1|>.<.|>...<.|>.<.|><.0>..", "period": 0.5 },
      {"name": "CYC_O", "wave": "0.<1|>.<.|>...<.|>.<.|><.0>..", "period": 0.5 },
      {"name": "STB_O", "wave": "0.<1|>.<0|>...<1|>.<0|>...", "period": 0.5 },
      {"name": "ACK_I", "wave": "0.<.|><.1><0|>...<.|><.1><0|>...", "period": 0.5 }
    ],
    "config": { "hscale": 2, "skin": "narrow" },
    "head": { "tick": 0 }
   }

**RULE 3.80**
  All MASTER and SLAVE interfaces that support BLOCK cycles MUST conform
  to the timing requirements given in sections 3.3.1 and 3.3.2.

**PERMISSION 3.55**
  MASTER and SLAVE interfaces MAY be designed so that they do not
  support the BLOCK cycles.


BLOCK READ Cycle
````````````````

:numref:`blockreadcycle` shows a BLOCK READ cycle. The BLOCK cycle is
capable of a data transfer on every clock cycle. However, this example
also shows how the MASTER and the SLAVE interfaces can both throttle
the bus transfer rate by inserting wait states. A total of five
transfers (phases) are shown. After the second transfer the MASTER
inserts a wait state. After the fourth transfer the SLAVE inserts a
wait state. The cycle is terminated after the fifth transfer. The
protocol for this transfer works as follows:

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the first phase.

  Note: the MASTER asserts [CYC_O] and/or [TGC_O()] at, or anytime
  before, clock edge 1.

SETUP, EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 1:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER presents new [ADR_O()] and [TGA_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it expects
  data.

SETUP, EDGE 2:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and [TGD_I()].

CLOCK EDGE 2:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER negates [STB_O] to introduce a wait state (-WSM-).

SETUP, EDGE 3:
  SLAVE negates [ACK_I] in response to [STB_O].

  Note: any number of wait states can be inserted by the MASTER.

CLOCK EDGE 3:
  MASTER presents new [ADR_O()] and [TGA_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it expects
  data.

  MASTER asserts [STB_O].

SETUP, EDGE 4:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 4:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it expects
  data.

SETUP, EDGE 5:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 5:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  SLAVE negates [ACK_I] to introduce a wait state.

  Note: any number of wait states can be inserted by the SLAVE at this
  point.

SETUP, EDGE 6:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 6:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER terminates cycle by negating [STB_O] and [CYC_O].

.. _blockreadcycle:
.. wavedrom::
   :caption: BLOCK READ cycle.

   {"signal": [
     ["Master Signals",
       {"name": "CLK_I", "wave": "P..|..|.", "labels": "...{WSM}(0.45)..{WSS}(0.45)." },
       {"name": "ADR_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "DAT_I()", "wave": "x..2x3<x|>x.4x5<x|>5x.", "period": 0.5 },
       {"name": "DAT_O()", "wave": "x..|..|." },
       {"name": "WE_O", "wave": "x0.|..|x" },
       {"name": "SEL_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "CYC_O", "wave": "01.|..|0" },
       {"name": "STB_O", "wave": "0.1...<0|>.1...<.|>.0.", "period": 0.5 },
       {"name": "ACK_I", "wave": "0..1..<0|>..1..<0|>10.", "period": 0.5 }
     ], ["Tag Types (M)",
       {"name": "TAG_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "TGD_I()", "wave": "x..2x3<x|>x.4x5<x|>5x.", "period": 0.5 },
       {"name": "TGD_O()", "wave": "x..|..|." },
       {"name": "TGC_O()", "wave": "x=.|..|x" }
      ]
    ],
    "config": { "hscale": 2, "skin": "narrow" },
    "head": { "tick": 0 }
   }

BLOCK WRITE Cycle
`````````````````

:numref:`blockwritecycle` shows a BLOCK WRITE cycle. The BLOCK cycle
is capable of a data transfer on every clock cycle. However, this
example also shows how the MASTER and the SLAVE interfaces can both
throttle the bus transfer rate by inserting wait states. A total of
five transfers are shown. After the second transfer the MASTER inserts
a wait state. After the fourth transfer the SLAVE inserts a wait
state. The cycle is terminated after the fifth transfer. The protocol
for this transfer works as follows:

CLOCK EDGE 0:
  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents bank select [SEL_O()] to indicate where it sends data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate cycle start.

  MASTER asserts [STB_O].

  Note: the MASTER asserts [CYC_O] and/or [TGC_O()] at, or anytime
  before, clock edge 1.

SETUP, EDGE 1:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate current data phase.

CLOCK EDGE 1:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it sends
  data.

SETUP, EDGE 2:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate current data phase.

CLOCK EDGE 2:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER negates [STB_O] to introduce a wait state (-WSM-).

SETUP, EDGE 3:
  SLAVE negates [ACK_I] in response to [STB_O].

  Note: any number of wait states can be inserted by the MASTER at this
  point.

CLOCK EDGE 3:
  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER presents bank select [SEL_O()] to indicate where it sends data.

  MASTER asserts [STB_O].

SETUP, EDGE 4:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate data phase.

CLOCK EDGE 4:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it sends
  data.

SETUP, EDGE 5:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate data phase.

CLOCK EDGE 5:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  SLAVE negates [ACK_I] to introduce a wait state.

  Note: any number of wait states can be inserted by the SLAVE at this point.

SETUP, EDGE 6:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate data phase.

CLOCK EDGE 6:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER terminates cycle by negating [STB_O] and [CYC_O].

.. _blockwritecycle:
.. wavedrom::
   :caption: BLOCK WRITE cycle.

   {"signal": [
     ["Master Signals",
       {"name": "CLK_I", "wave": "P..|..|.", "labels": "...{WSM}(0.45)..{WSS}(0.45)." },
       {"name": "ADR_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "DAT_I()", "wave": "x..|..|.", "period": 0.5 },
       {"name": "DAT_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "WE_O", "wave": "x1.|..|x" },
       {"name": "SEL_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "CYC_O", "wave": "01.|..|0" },
       {"name": "STB_O", "wave": "0.1...<0|>.1...<.|>.0.", "period": 0.5 },
       {"name": "ACK_I", "wave": "0..1..<0|>..1..<0|>10.", "period": 0.5 }
     ], ["Tag Types (M)",
       {"name": "TAG_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "TGD_I()", "wave": "x..|..|." },
       {"name": "TGD_O()", "wave": "x.2.3.<x|>x4.5.<.|>.x.", "period": 0.5 },
       {"name": "TGC_O()", "wave": "x=.|..|x" }
      ]
    ],
    "config": { "hscale": 2, "skin": "narrow" },
    "head": { "tick": 0 }
   }

RMW Cycle
---------

The RMW (read-modify-write) cycle is used for indivisible semaphore
operations. During the first half of the cycle a single read data
transfer is performed. During the second half of the cycle a write
data transfer is performed. The [CYC_O] signal remains asserted during
both halves of the cycle.

**RULE 3.85**
  All MASTER and SLAVE interfaces that support RMW cycles MUST conform
  to the timing requirements given in section 3.4.

**PERMISSION 3.60**
  MASTER and SLAVE interfaces MAY be designed so that they do not
  support the RMW cycles.

Figure 3-8 shows a read-modify-write (RMW) cycle. The RMW cycle is
capable of a data transfer on every clock cycle. However, this
example also shows how the MASTER and the SLAVE interfaces can both
throttle the bus transfer rate by inserting wait states. Two transfers
are shown. After the first (read) transfer, the MASTER inserts a wait
state. During the second transfer the SLAVE inserts a wait
state. The protocol for this transfer works as follows:

CLOCK EDGE 0:
  MASTER presents [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects
  data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of cycle.

  MASTER asserts [STB_O].

  Note: the MASTER asserts [CYC_O] and/or [TGC_O()] at, or anytime
  before, clock edge 1. The use of [TAGN_O] is optional.

SETUP, EDGE 1:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 1:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER negates [STB_O] to introduce a wait state (-WSM-).

SETUP, EDGE 2:
  SLAVE negates [ACK_I] in response to [STB_O].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  Note: any number of wait states can be inserted by the MASTER at this
  point.

CLOCK EDGE 2:
  MASTER presents WRITE data on [DAT_O()] and [TGD_O()].

  MASTER presents new bank select [SEL_O()] to indicate where it sends
  data.

  MASTER asserts [STB_O].

SETUP, EDGE 3:
  SLAVE decodes inputs, and responds by asserting [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  MASTER monitors [ACK_I], and prepares to terminate data phase.

  Note: any number of wait states can be inserted by the SLAVE at this
  point.

CLOCK EDGE 3:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER negates [STB_O] and [CYC_O] indicating the end of the cycle.

  SLAVE negates [ACK_I] in response to negated [STB_O].

Data Organization
-----------------

Data organization refers to the ordering of data during
transfers. There are two general types of ordering. These are called
BIG ENDIAN and LITTLE ENDIAN. BIG ENDIAN refers to data ordering where
the most significant portion of an operand is stored at the lower
address. LITTLE ENDIAN refers to data ordering where the most
significant portion of an operand is stored at the higher address. The
WISHBONE architecture supports both methods of data ordering.

Nomenclature
````````````

A BYTE(N), WORD(N), DWORD(N) and QWORD(N) nomenclature is used to
define data ordering. These terms are defined in Table 3-1. Figure
3-9 shows the operand locations for input and output data ports.

+--------------+-------------+-------------------------------------------------+
| Nomenclature | Granularity | Description                                     |
+--------------+-------------+-------------------------------------------------+
| BYTE(N)      | 8-bit       | An 8-bit BYTE transfer at address 'N'.          |
+--------------+-------------+-------------------------------------------------+
| WORD(N)      | 16-bit      | A 16-bit WORD transfer at address 'N'.          |
+--------------+-------------+-------------------------------------------------+
| DWORD(N)     | 32-bit      | A 32-bit Double WORD transfer at address 'N'.   |
+--------------+-------------+-------------------------------------------------+
| QWORD(N)     | 64-bit      | A 64-bit Quadruple WORD transfer at address 'N'.|
+--------------+-------------+-------------------------------------------------+

The table also defines the granularity of the interface. This
indicates the minimum unit of data transfer that is supported by the
interface. For example, the smallest operand that can be passed
through a port with 16-bit granularity is a 16-bit WORD. In this case,
an 8-bit operand cannot be transferred.

Figure 3-10 shows an example of how the 64-bit value of
0x0123456789ABCDEF is transferred through BYTE, WORD, DWORD and QWORD
ports using BIG ENDIAN data organization.  Through the 64-bit QWORD
port the number is directly transferred with the most significant bit
at DAT_I(63) / DAT_O(63). The least significant bit is at DAT_I(0) /
DAT_O(0). However, when the same operand is transferred through a
32-bit DWORD port, it is split into two bus cycles. The two bus
cycles are each 32-bits in length, with the most significant DWORD
transferred at the lower address, and the least significant DWORD
transferred at the upper address. A similar situation applies to the
WORD and BYTE cases.

Figure 3-11 shows an example of how the 64-bit value of
0x0123456789ABC is transferred through BYTE, WORD, DWORD and QWORD
ports using LITTLE ENDIAN data organization. Through the 64-bit QWORD
port the number is directly transferred with the most significant bit
at DAT_I(63) / DAT_O(63). The least significant bit is at DAT_I(0) /
DAT_O(0).  However, when the same operand is transferred through a
32-bit DWORD port, it is split into two bus cycles. The two bus cycles
are each 32-bits in length, with the least significant DWORD
transferred at the lower address, and the most significant DWORD
transferred at the upper address. A similar situation applies to the
WORD and BYTE cases.

**RULE 3.90**
  Data organization MUST conform to the ordering indicated in Figure 3-9.

Transfer Sequencing
```````````````````

The sequence in which data is transferred through a port is not
regulated by this specification.  For example, a 64-bit operand
through a 32-bit port will take two bus cycles. However, the
specification does not require that the lower or upper DWORD be
transferred first.

**RECOMMENDATION 3.20**
  Design interfaces so that data is transferred sequentially from lower
  addresses to higher addresses.

**OBSERVATION 3.60**
  The sequence in which an operand is transferred through a data port is
  not highly regulated by the specification. That is because different
  IP cores may produce the data in different ways. The sequence is
  therefore application-specific.

Data Organization for 64-bit Ports
``````````````````````````````````

**RULE 3.95**
  Data organization on 64-bit ports MUST conform to Figure 3-12.

Data Organization for 32-bit Ports
``````````````````````````````````

**RULE 3.100**
  Data organization on 32-bit ports MUST conform to Figure 3-13.

Data Organization for 16-bit Ports
``````````````````````````````````

**RULE 3.105**
  Data organization on 16-bit ports MUST conform to Figure 3-14.

Data Organization for 8-bit Ports
`````````````````````````````````

**RULE 3.1010**
  Data organization on 8-bit ports MUST conform to Figure 3-15.

References
----------

Cohen, Danny. On Holy Wars and a Plea for Peace. IEEE Computer
Magazine, October 1981.  Pages 49-54. [Description of BIG ENDIAN and
LITTLE ENDIAN.]
