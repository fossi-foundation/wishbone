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

.. todo::

   Missing section remainder

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
