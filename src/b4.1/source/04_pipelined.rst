WISHBONE Pipelined Bus Cycle
============================

WISHBONE Classic bus cycle throughput is limited by the latency of
the slave.  This chapter and the next one describe a mechanism
to improve the throughput.

The pipelined bus cycle is a simple (but non backward compatible) extension
of the classic bus cycle.  A transfer is started on each rising [CLK_I] edge
when both [STB_O] and [CYC_O] are asserted.  Note that a new transfer can
be scheduled even if the previous one was not acknowledged.  A transfer
is acknowldge when [ACK_O] is asserted on a rising [CLK_I] edge.  For
backpressure, a new signal is added [STALL_O] which disables a start of
a new transfer when asserted.

The remaining of this chapter describes the pipelined bus cycle in details.

Added WISHBONE Signal Description
---------------------------------

Added MASTER Signals
````````````````````

**STALL_I**

The pipeline stall input [STALL_I] indicates that current slave is not
able to accept the transfer in the transaction queue.


Added SLAVE Signals
```````````````````

**STALL_O**

The pipeline stall signal [STALL_O] indicates that the slave can not
accept additional transactions in its queue.


Handshaking Protocol
--------------------

A new traffic mode is defined in addition to the standard mode: the pipelined
mode.

Pipelined wishbone protocol
```````````````````````````

In pipelined mode the handshake protocol is somewhat different.

* The master doesn't wait for [ACK_I] before outputting next
  address/data word on the bus

* we have a [STALL_I] input in the master, indicating that the slave
  pipeline can accept another request at the moment. For a bus arbiter a
  multiplexer should be used to select the targeted slave [STALL_O]
  signal and feed that to the master. This path should be non
  registered.

* master outputs the requests as long as [STALL_I] is low. When
  [STALL_I] is asserted, it waits. Also, the pipeline in the
  interconnect doesn't push any requests when [STALL_I] is asserted.

* cycle consisting of N transactions is terminated with a sequence of
  N [ACK_I].  Subsequent [ACK_I] indicate the finished
  transactions. Master terminates the bus cycle (by deasserting [CYC_O])
  after receiving the last [ACK_I] pulse.

* read data is valid when [ACK_I] is high.

.. _pipelined:
.. wavedrom::
   :caption: Piplined mode, signal access

        { "signal": [
                  { "name": "CLK_I",   "wave": "P...." },
                  { "name": "CYC_O",   "wave": "01..0" },
		  { "name": "STB_O",   "wave": "010.." },
                  { "name": "STALL_I", "wave": "0...." },
		  { "name": "ACK_I",   "wave": "0..10" }
          ],
	  "head": { "tick": 0 }
	}

**RULE 3.57**
    In pipelined mode a read transaction is started when the
    signals [CYC_I] and [STB_I] are asserted and when [STALL_I] and [WE_I]
    are negated.

**RULE 3.58**
    In pipelined mode a write transaction is started when
    the signals [CYC_I], [STB_I] and [WE_I] are asserted and when
    [STALL_I] is negated.

**RULE 3.59**
    In pipelined mode the MASTER must accept [ACK_I] signals at any time
    after a transaction is initiated.


SINGLE READ / WRITE Cycles
--------------------------

Pipelined SINGLE READ Cycle
```````````````````````````

:numref:`pipelinedsinglereadcycle` shows a pipelined SINGLE READ cycle. The bus protocol works as follows:

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate a transaction.

CLOCK EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  SLAVE asserts [ACK_I] in response to [STB_O] to indicate valid data.

  MASTER negates [STB_O] to indicate end of data phase.

  MASTER monitors [ACK_I], and prepares to latch data on [DAT_I()] and
  [TGD_I()].

CLOCK EDGE 2:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER negates [CYC_O] to indicate the end of the cycle.

  SLAVE negates [ACK_I].

.. _pipelinedsinglereadcycle:
.. wavedrom::
   :caption: Pipelined SINGLE READ cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "0P.." },
       { "name": "ADR_O()", "wave": "x=x.", "data": ["VALID"] },
       { "name": "DAT_I()", "wave": "x.=x", "data": ["VALID"] },
       { "name": "DAT_O()", "wave": "x..." },
       { "name": "WE_O", "wave": "x0x." },
       { "name": "SEL_O()", "wave": "x=x.", "data": ["VALID"] },
       { "name": "STB_O", "wave": "010." },
       { "name": "CYC_O", "wave": "01.0" },
       { "name": "ACK_I", "wave": "0.10" },
       { "name": "STALL_I", "wave": "0..." }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x=x.", "data": ["VALID"]  },
       { "name": "TGD_I()", "wave": "x.=x", "data": ["VALID"]  },
       { "name": "TGD_O()", "wave": "x..." },
       { "name": "TGC_O()", "wave": "x=x.", "data": ["VALID"]  }
     ]
    ],
    "config": { "hscale": 2 },
    "head": { "tick": -1 }
   }


Pipelined SINGLE WRITE Cycle
````````````````````````````

:numref:`pipelinedsinglewritecycle` shows a pipelined SINGLE WRITE
cycle. The bus protocol works as follows:

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER presents valid data on [DAT_O()] and [TGD_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents bank select [SEL_O()] to indicate where it sends data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the phase.

CLOCK EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE prepares to latch data on [DAT_O()] and [TGD_O()].

  SLAVE asserts [ACK_I] in response to [STB_O] to indicate latched data.

  MASTER negates [STB_O] to indicated the end of the data phase.

  MASTER monitors [ACK_I], and prepares to terminate the cycle.

  Note: SLAVE may insert wait states (-WSS-) before asserting [ACK_I],
  thereby allowing it to throttle the cycle speed. Any number of wait
  states may be added.

CLOCK EDGE 2:
  SLAVE latches data on [DAT_O()] and [TGD_O()].

  MASTER negates [CYC_O] to indicate the end of the cycle.

  SLAVE negates [ACK_I].

.. _pipelinedsinglewritecycle:
.. wavedrom::
   :caption: Pipelined SINGLE WRITE cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "0P.." },
       { "name": "ADR_O()", "wave": "x=x.", "data": ["VALID"] },
       { "name": "DAT_I()", "wave": "x..." },
       { "name": "DAT_O()", "wave": "x=x.", "data": ["VALID"] },
       { "name": "WE_O", "wave": "x1x." },
       { "name": "SEL_O()", "wave": "x=x.", "data": ["VALID"] },
       { "name": "STB_O", "wave": "010." },
       { "name": "CYC_O", "wave": "01.0" },
       { "name": "ACK_I", "wave": "0.10" },
       { "name": "STALL_I", "wave": "0..." }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x=x.", "data": ["VALID"]  },
       { "name": "TGD_I()", "wave": "x..." },
       { "name": "TGD_O()", "wave": "x=x.", "data": ["VALID"]  },
       { "name": "TGC_O()", "wave": "x=x.", "data": ["VALID"]  }
     ]
    ],
    "config": { "hscale": 2 },
    "head": { "tick": -1 }
   }

BLOCK READ / WRITE Cycles
-------------------------

Pipelined BLOCK READ Cycle
``````````````````````````

In pipelined mode a higher throughput can be obtained compared to the
classic mode. If the wishbone slave can support the pipelined behavior
transactions can be overlapping. This behavior can also be studied for
SDRAM memories. In this example SLAVE asserts [STALL_O] indicating
that the queue is temporarily full and that the bus cycle should be
resent.

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the first phase.

  MASTER monitors [ACK_I], and prepares to latch [DAT_I()] and [TGD_I()].

CLOCK EDGE 1:
  SLAVE decodes inputs, and responding SLAVE asserts [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [STB_O] to indicate the start of the second data phase.

CLOCK EDGE 2:
  [STALL_I] during clock cycle 1 causes MASTER to repeat last cycle

  MASTER latches data on [DAT_I()] and [TGD_I()].

  SLAVE negates [ACK_I]

CLOCK EDGE 3:
  MASTER negates [STB_O]

  SLAVE asserts [ACK_I].

  SLAVE presents valid data on [DAT_I()] and [TGD_I()].

CLOCK EDGE 4:
  MASTER latches data on [DAT_I()] and [TGD_I()].

  MASTER negates [CYC_O] upon receiving second [ACK_O].

  SLAVE negates [ACK_I]


.. _pipelinedblockreadcycle:
.. wavedrom::
   :caption: Pipelined BLOCK READ cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "0P...." },
       { "name": "ADR_O()", "wave": "x==.x.", "data": ["A0", "A1"] },
       { "name": "DAT_I()", "wave": "x.=x=x", "data": ["D0", "D1"] },
       { "name": "DAT_O()", "wave": "x....." },
       { "name": "WE_O", "wave": "x00.x." },
       { "name": "SEL_O()", "wave": "x==.x.", "data": ["VALID", "VALID"] },
       { "name": "STB_O", "wave": "011.0." },
       { "name": "CYC_O", "wave": "01...0" },
       { "name": "ACK_I", "wave": "0.1010" },
       { "name": "STALL_I", "wave": "0.10.." }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x==.x.", "data": ["VALID", "VALID"]  },
       { "name": "TGD_I()", "wave": "x.=x=x", "data": ["VALID", "VALID"]  },
       { "name": "TGD_O()", "wave": "x....." },
       { "name": "TGC_O()", "wave": "x==.x.", "data": ["VALID", "VALID"]  }
     ]
    ],
    "config": { "hscale": 2 },
    "head": { "tick": -1 }
   }


Pipelined BLOCK WRITE Cycle
```````````````````````````

In pipelined mode a new transactions can be performed by the MASTER before all
transactions have been confirmed with [ACK_O].

CLOCK EDGE 0:
  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] and [TGC_O()] to indicate the start of the cycle.

  MASTER asserts [STB_O] to indicate the start of the first phase.

CLOCK EDGE 1:
  Responding SLAVE asserts [ACK_I].

  MASTER presents a valid address on [ADR_O()] and [TGA_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents bank select [SEL_O()] to indicate where it expects data.

  MASTER asserts [STB_O] to indicate the start of the second data phase.

CLOCK EDGE 2:
  [STALL_I] during clock cycle 1 causes MASTER to repeat last cycle

  SLAVE negates [ACK_I].

CLOCK EDGE 3:
  Responding SLAVE asserts [ACK_I].

  MASTER negates [STB_O] when [STALL_I] inactive

CLOCK EDGE 4:
  MASTER negates [CYC_O] upon receiving second [ACK_O].

  SLAVE negates [ACK_I].

.. _pipelinedblockwritecycle:
.. wavedrom::
   :caption: Pipelined BLOCK WRITE cycle.

   { "signal": [
     ["Master Signals",
       { "name": "CLK_I",  "wave": "0P...." },
       { "name": "ADR_O()", "wave": "x==.x.", "data": ["A0", "A1"] },
       { "name": "DAT_I()", "wave": "x....." },
       { "name": "DAT_O()", "wave": "x==.x.", "data": ["D0", "D1"] },
       { "name": "WE_O", "wave": "x11.x." },
       { "name": "SEL_O()", "wave": "x==.x.", "data": ["VALID", "VALID"] },
       { "name": "STB_O", "wave": "011.0." },
       { "name": "CYC_O", "wave": "01...0" },
       { "name": "ACK_I", "wave": "0.1010" },
       { "name": "STALL_I", "wave": "0.10.." }
       ],
     ["Tag Types (M)",
       { "name": "TAG_O()", "wave": "x==.x.", "data": ["VALID", "VALID"]  },
       { "name": "TGD_I()", "wave": "x....." },
       { "name": "TGD_O()", "wave": "x==.x.", "data": ["VALID", "VALID"]  },
       { "name": "TGC_O()", "wave": "x==.x.", "data": ["VALID", "VALID"]  }
     ]
    ],
    "config": { "hscale": 2 },
    "head": { "tick": -1 }
   }

Interfacing standard and pipelined peripherals
----------------------------------------------

The following use cases need special attention

  1. A MASTER operating in standard mode connected to a SLAVE operating in
     pipelined mode

  2. A MASTER operating in pipelined mode connected to a SLAVE operating in
     standard mode

Standard master connected to pipelined slave
````````````````````````````````````````````

For this combination to work the [STB_I] signal must be changed.

For a standard master the following is true:

  1. [STB_O] is asserted at the beginning of a transfer and is negated
     upon receiving [ACK_I]

For a pipelined slave the following is true:

  1. a new transaction is initiated when [STB_I] is asserted

A finite state machine is needed to supervise the bus activity. This
state machine should have two states:

  1. idle:
     if [STB_I] change state to wait4ack

  2. wait4ack:
     if [ACK_O] change state to idle

Signal [STB_I] to slave can now be defined as a function of current
state and [STB_O] from MASTER.

VHDL example::

    WBS_STB_I <= WBM_STB_O when state=idle else '0';

Verilog example::

    assign WBS_STB_I = (state==idle) ? WBM_STB_O : 1'b0;

This logic could be implemented in wrapper. The new top level would
present a standard wishbone peripheral.

Pipelined master connected to standard slave
````````````````````````````````````````````

For this to work we must ensure that the updated functionality,
pipelining, in the master is not put into use. With the [STALL_I]
signal asserted this function can be avoided.  There is also a special
case where a simple slave peripheral designed for Wishbone release B3
actually can support pipelined mode in a limited context.

Using [STALL_I] to avoid pipelining
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A master with [STALL_I] asserted will not initiate new transactions
until the [STALL_I] condition is negated. This can easily be achieved
with a [STALL_I] as a function of [ACK_O] and [CYC_I].

Example in VHDL::

  WBM_STALL_I <= '0' when WBS_CYC_I='0' else not WBS_ACK_O;

Example in Verilog::

  assign WBM_STALL_I = !WBS_CYC_I ? 1'b0 : !WBS_ACK_O;


.. _writepipemasterstdslave:
.. wavedrom::
   :caption: Write - pipelined master standard slave

   { "signal": [
     { "name": "CLK_I",   "wave": "P..." },
      { "name": "WE_O",    "wave": "01.0" },
      { "name": "CYC_O",   "wave": "01.0" },
      { "name": "STB_O",   "wave": "01.0" },
      { "name": "STALL_I", "wave": "010." },
      { "name": "ACK_I",   "wave": "0.10" }
     ],
     "config": { "hscale": 2 },
     "head": { "tick": 0 }
   }


.. _readpipemasterstdslave:
.. wavedrom::
   :caption: Read - pipelined master standard slave

   { "signal": [
      { "name": "CLK_I",   "wave": "P..." },
      { "name": "WE_O",    "wave": "0..." },
      { "name": "CYC_O",   "wave": "01.0" },
      { "name": "STB_O",   "wave": "01.0" },
      { "name": "STALL_I", "wave": "010." },
      { "name": "ACK_I",   "wave": "0.10" }
     ],
     "config": { "hscale": 2 },
     "head": { "tick": 0 }
   }

This logic could be implemented in a wrapper. The new top level module
would present a pipelined peripheral. In Verilog HDL this could
optionally be done in the port mapping.

Simple slaves directly supporting pipelined mode
````````````````````````````````````````````````

Even though not initially designed for pipelined mode many simple
wishbone slaves directly support this mode. For this to be true the
following characteristics must be true

  1. [ACK_O] should be registered

  2. a read or write classic bus cycle should always occupy two clock cycles

  3. actual write to internal register must be done on rising clock edge 1.
     See :numref:`pipelinedwrite4` below

Master input signal [STALL_I] should be tied low, inactive, statically.

Classic pipelined write to simple wishbone peripheral
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _pipelinedwrite4:
.. wavedrom::
   :caption: Pipelined write

   { "signal": [
     { "name": "CLK_I",   "wave": "P..." },
     { "name": "WE_O",    "wave": "010." },
     { "name": "CYC_O",   "wave": "01.0" },
     { "name": "STB_O",   "wave": "010." },
     { "name": "STALL_I", "wave": "0..." },
     { "name": "ACK_I",   "wave": "0.10" }
     ],
     "config": { "hscale": 2 },
     "head": { "tick": -1 }
   }

CLOCK EDGE 0:
  MASTER presents [CYC_O] and [STB_O] to initiate transaction

  MASTER asserts [WE_O] to indicate a WRITE cycle

CLOCK EDGE 1:
  SLAVE writes [DAT_I] to register (or similar function depending on peripheral
  functionality)

  SLAVE asserts [ACK_O]

  MASTER negate [STB_O] when [STALL_I] is inactive

CLOCK EDGE 2:
  MASTER negates [CYC_I] in response to [ACK_I] and terminates cycle

Classic pipelined read from simple wishbone peripheral
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. wavedrom::
   :caption: Pipelined read

   { "signal": [
     { "name": "CLK_I",   "wave": "P..." },
     { "name": "WE_O",    "wave": "0..." },
     { "name": "CYC_O",   "wave": "01.0" },
     { "name": "STB_O",   "wave": "010." },
     { "name": "STALL_I", "wave": "0..." },
     { "name": "ACK_I",   "wave": "0.10" }
     ],
     "config": { "hscale": 2 },
     "head": { "tick": -1 }
   }

CLOCK EDGE 0:
  MASTER presents [CYC_O] and [STB_O] to initiate transaction

  MASTER negates [WE_O] to indicate a READ cycle

CLOCK EDGE 1:
  SLAVE presents [DAT_O]

  SLAVE asserts [ACK_O]

  MASTER negate [STB_O] when [STALL_I] is inactive

CLOCK EDGE 2:
  MASTER negates [CYC_I] in response to [ACK_I] and terminates cycle
