WISHBONE Registered Feedback Bus Cylces
=======================================

Introduction, Synchronous vs. Asynchronous cycle termination
------------------------------------------------------------

To achieve the highest possible throughput, WISHBONE Classic requires
asynchronous cycle termination signals. This results in an
asynchronous loop from the MASTER, through the INTERCONN to the SLAVE,
and then from the SLAVE through the INTERCONN back to the MASTER, as
shown in :numref:`asyncterm`. In large System-on-Chip devices this
routing delay between MASTER and SLAVE is the dominant timing
factor. This is especially true for deep sub-micron technologies.

.. _asyncterm:
.. figure:: _static/asyncterm.*

   Asynchronous cycle termination path

The simplest solution for reducing the delay is to cut the loop, by
using synchronous cycle termination signals. However, this
introduces a wait state for every transfer, as shown in :numref:`classicsync`.

.. _classicsync:
.. wavedrom::
   :caption: WISHBONE Classic synchronous cycle terminated burst

   {"signal": [
     {"name": "CLK_I", "wave": "P....." },
     {"name": "ADR_I()", "wave": "x2.3.x", "data": ["N", "N+1"], "node": ".A.B.."},
     {"name": "STB_I", "wave": "01...0" },
     {"name": "ACK_O", "wave": "0.1010", "node": "..C.D.." }
   ], "edge": ["A~>C", "B~>D"],
   "head": { "tick": 0 }
   }

During cycle-1 the MASTER initiates a transfer. The addressed SLAVE
responds in the next cycle with the assertion of ACK_O. During
cycle-3 the MASTER initiates a second cycle, addressing the same
SLAVE. Because the SLAVE does not know in advance it is being
addressed again, it has to negate ACK_O. At the earliest it can
respond in cycle-4, after which it has to negate ACK_O again in
cycle-5.

Each transfer takes two WISHBONE cycles to complete, thus only half of
the available bandwidth is useable. If the SLAVE would know in
advance that it is being addressed again, it could already respond in
cycle-3. Decreasing the amount of cycles needed to perform the
transfers, and thus increasing throughput. The waveforms for that
cycle are as shown in :numref:`advancedsync`.

.. _advancedsync:
.. wavedrom::
   :caption: Advanced synchronous terminated burst

   {"signal": [
     {"name": "CLK_I", "wave": "P...." },
     {"name": "ADR_I()", "wave": "x2.3x", "data": ["N", "N+1"]},
     {"name": "STB_I", "wave": "01..0" },
     {"name": "ACK_O", "wave": "0.1.0" }
   ], "head": { "tick": 0 }
   }

During cycle-1 the MASTER initiates a transfer. The addressed SLAVE
responds in the next cycle with the assertion of ACK_O. The MASTER
starts a new transfer in cycle-3. The SLAVE knows in advance it is
being addressed again, therefore it keeps ACK_O asserted.

A two cycle burst now takes three cycles to complete, instead of
four. This is a throughput increase of 33%. WISHBONE Classic however
would require only 2 cycles. An eight cycle burst takes nine cycles to
complete, instead of 16. This is a throughput increase of
77%. WISHBONE Classic would require eight cycles. For single transfers
there is no performance gain.

.. _burst_comp:
.. table:: Burst comparison

  +--------------+-------------------+-------------------+----------------------+
  | Burst length | Asynchronous      | Synchronous       | Advanced Synchronous |
  |              | Cycle termination | Cycle termination | Cycle termination    |
  +--------------+-------------------+-------------------+----------------------+
  | 1            |  1 (200%)         |  2 (100%)         |  2                   |
  +--------------+-------------------+-------------------+----------------------+
  | 2            |  2 (150%)         |  4 (75%)          |  3                   |
  +--------------+-------------------+-------------------+----------------------+
  | 4            |  4 (125%)         |  8 (62%)          |  5                   |
  +--------------+-------------------+-------------------+----------------------+
  | 8            |  8 (112%)         | 16 (56%)          |  9                   |
  +--------------+-------------------+-------------------+----------------------+
  | 16           | 16 (106%)         | 32 (53%)          | 17                   |
  +--------------+-------------------+-------------------+----------------------+
  | 32           | 32 (103%)         | 64 (51%)          | 33                   |
  +--------------+-------------------+-------------------+----------------------+

:numref:`burst_comp` shows a comparison between the discussed cycle termination
types, for zero wait state bursts at a given
bus-frequency. Asynchronous cycle termination requires only one cycle
per transfer, synchronous cycle termination requires two cycles per
transfer, and the advanced synchronous cycle termination requires
(burst_length+1) cycles. The percentages show the relative throughput
for a burst length, where the advanced synchronous cycle termination
is set to 100%.

Advanced synchronous cycle termination appears to get the best from
both the synchronous and asynchronous termination schemes. For single
transfers it performs as well as the normal synchronous termination
scheme, for large bursts it performs as well as the asynchronous
termination scheme.

NOTE that for a system that already needs wait states, the advanced
synchronous scheme provides the same throughput as the asynchronous
scheme.

+--------------------------------------------------------------------------+
|  A given system, with an average burst length of 8, is intended to run   |
|  at over 150MHz.  It is shown that moving from asynchronous termination  |
|  to synchronous termination would improve timing by 1.5ns. Thus          |
|  allowing a 193MHz clock frequency, instead of the 150MHz.               |
+--------------------------------------------------------------------------+
|  The asynchronous termination scheme has a theoretical throughput of     |
|  150Mcycles per sec.                                                     |
|                                                                          |
|  For the given average burst length of 8, the advanced synchronous       |
|  termination scheme has a 12% lower theoretical throughput than the      |
|  asynchronous termination scheme. However the increased operating        |
|  frequency allows it to perform more cycles per second. The theoretical  |
|  throughput for the advanced synchronous scheme is 193M / 1.12 =         |
|  172Mcycles per sec.                                                     |
+--------------------------------------------------------------------------+

+--------------------------------------------------------------------------+
|  System layout requires that all block have registered outputs. The      |
|  average burst length used in the system is 4.                           |
+--------------------------------------------------------------------------+
|  Moving to the advanced synchronous termination scheme improves          |
|  performance by 60 %.                                                    |
+--------------------------------------------------------------------------+

WISHBONE Registered Feedback
----------------------------

WISHBONE Registered Feedback bus cycles use the Cycle Type Identifier
[CTI_O()], [CTI_I()] Address Tags to implement the advanced synchronous
cycle termination scheme. Both MASTER and SLAVE interfaces must
support [CTI_O()], [CTI_I()] in order to provide the improved
bandwidth. Additional information about the type of burst is provided
by the Burst Type Extension [BTE_O()], [BTE_I()] Address
Tags. Because WISHBONE Registered Feedback uses Tag signals to
implement the advanced synchronous cycle termination, it is inherently
fully compatible with WISHBONE Classic. If only one of the
interfaces (i.e. either MASTER or SLAVE) supports WISHBONE Registered
Feedback bus cycles, and hence the other supports WISHBONE Classic bus
cycles, the cycle terminates as though it were a WISHBONE Classic bus
cycle. This eases the integration of WISHBONE Classic and WISHBONE
Registered Feedback IP cores.

**PERMISSION 4.00**
  MASTER and SLAVE interfaces MAY be designed to support WISHBONE
  Registered Feedback bus cycles.

**RECOMMENDATION 4.00**
  Interfaces compatible with WISHBONE Registered Feedback bus cycles
  support both WISHBONE Classic and WISHBONE Registered Feedback bus
  cycles. It is recommended to design new IP cores to support WISHBONE
  Registered Feedback bus cycles, so as to ensure maximum throughput in
  all systems.

**RULE 4.00**
  All WISHBONE Registered Feedback compatible cores MUST support
  WISHBONE Classic bus cycles.

Signal Description
------------------

CTI_IO()

The Cycle Type Idenfier [CTI_IO()] Address Tag provides additional information about the current cycle.
The MASTER sends this information to the SLAVE.
The SLAVE can use this information to prepare the response for the next cycle.
:numref:`cti` Type Identifiers

.. _cti:
.. table:: Cycle Type Identifiers

  +-------------+--------------------------------+
  | CTI_IO(2:0) |  Description                   |
  +-------------+--------------------------------+
  | ‘000’       |  Classic cycle.                |
  +-------------+--------------------------------+
  | ‘001’       |  Constant address burst cycle  |
  +-------------+--------------------------------+
  | ‘010’       |  Incrementing burst cycle      |
  +-------------+--------------------------------+
  | ‘011’       |  *Reserved*                    |
  +-------------+--------------------------------+
  | ‘100’       |  *Reserved*                    |
  +-------------+--------------------------------+
  | ‘101        |  *Reserved*                    |
  +-------------+--------------------------------+
  | ‘110’       |  *Reserved*                    |
  +-------------+--------------------------------+
  | ‘111’       |  End-of-Burst                  |
  +-------------+--------------------------------+

**PERMISSION 4.05**
  MASTER and SLAVE interfaces MAY be designed to support the [CTI_I()]
  and [CTI_O()] signals. Also MASTER and SLAVE interfaces MAY be
  designed to support a limited number of burst types.

**RULE 4.05**
  MASTER and SLAVE interfaces that do support the [CTI_I()] and
  [CTI_O()] signals MUST at least support the Classic cycle
  [CTI_IO()=’000’] and the End-of-Cycle [CTI_IO()=’111’].

**RULE 4.10**
  MASTER and SLAVE interfaces that are designed to support a limited
  number of burst types MUST complete the unsupported cycles as though
  they were WISHBONE Classic cycle, i.e.  [CTI_IO()= ‘000’].

**PERMISSION 4.10**
  For description languages that allow default values for input ports
  (like VHDL), [CTI_I()] MAY be assigned a default value of ‘000’.

**PERMISSION 4.15**
  In addition to the WISHBONE Classic rules for generating cycle
  termination signals [ACK_O], [RTY_O], and [ERR_O], a SLAVE MAY assert
  a termination cycle without checking the [STB_I] signal.

**OBSERVATION 4.00**
  To avoid the inherent wait state in synchronous termination schemes,
  the SLAVE must generate the response as soon as possible (i.e. the
  next cycle). It can use the [CTI_I()] signals to determine the
  response for the next cycle. But it cannot determine the state of
  [STB_I] for the next cycle, therefore it must generate the response
  independent of [STB_I].

**PERMISSION 4.20**
  [ACK_O], [RTY_O], and [ERR_O] MAY be asserted while [STB_O] is
  negated.

**RULE 4.15**
  A cycle terminates when both the cycle termination signal and [STB_I],
  [STB_O] is asserted.  Even if [ACK_O], [ACK_I] is asserted, the other
  signals are only valid when [STB_O], [STB_I] is also asserted.

BTE_IO()
  The Burst Type Extension [BTE_O()] Address Tag is send by the MASTER
  to the SLAVE to provides additional information about the current
  burst. Currently this information is only relevant for incrementing
  bursts, but future burst types may use these signals.

.. _bte:
.. table:: Type Extension for Incrementing and Decrementing bursts

  +-------------+--------------------+
  | BTE_IO(1:0) | Description        |
  +-------------+--------------------+
  | ‘00’        | Linear burst       |
  +-------------+--------------------+
  | ‘01’        | 4-beat wrap burst  |
  +-------------+--------------------+
  | ‘10’        | 8-beat wrap burst  |
  +-------------+--------------------+
  | ‘11’        | 16-beat wrap burst |
  +-------------+--------------------+

**RULE 4.20**
  MASTER and SLAVE interfaces that support incrementing burst cycles
  MUST support the [BTE_O()] and [BTE_I()] signals.

**PERMISSION 4.25**
  MASTER and SLAVE interfaces MAY be designed to support a limited
  number of burst extensions.

**RULE 4.25**
  MASTER and SLAVE interfaces that are designed to support a limited
  number of burst extensions MUST complete the unsupported cycles as
  though they were WISHBONE Classic cycle, i.e. [CTI_IO()= 000’].


Bus Cycles
----------

Classic Cycle
`````````````

A Classic Cycle indicates that the current cycle is a WISHBONE Classic
cycle. The SLAVE terminates the cycle as described in chapter 3. There
is no information about what the MASTER will do the next cycle.

**PERMISSION 4.30**
  A MASTER MAY signal Classic Cycle indefinitely.

**OBSERVATION 4.05**
  A MASTER that signals Classic Cycle indefinitely is a pure WISHBONE
  Classic MASTER.  The Cycle Type Identifier [CTI_O()] signals have no
  effect; all SLAVE interfaces already support WISHBONE Classic
  cycles. They might as well not be present on the interface at all. In
  fact, routing them on chip may use up valuable resources. However they
  might be useful for arbitration logic, or to keep the buses from/to
  interfaces coherent.

:numref:`classicread` shows a Classic read cycle. A total of two transfers are
shown. The cycle is terminated after the second transfer. The
protocol for this cycle works as follows:

CLOCK EDGE 0:
  MASTER presents [ADR_O()].

  MASTER presents Classic Cycle on [CTI_O()].

  MASTER negates [WE_O] to indicate a READ cycle.

  MASTER presents select [SEL_O()] to indicate where it expects data.

  MASTER asserts [CYC_O] to indicate cycle start.

  MASTER asserts [STB_O].

SETUP, EDGE 1:
  SLAVE decodes inputs.

  SLAVE recognizes Classic Cycle and prepares response.

  SLAVE prepares to send data.

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 1:
  SLAVE asserts [ACK_I]

  SLAVE presents data on [DAT_I()].

SETUP, EDGE 2:
  SLAVE does not expect another transfer.

  MASTER prepares to latch data on [DAT_I()].

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 2:
  SLAVE negates [ACK_I].

  MASTER latches data on [DAT_I()]

  MASTER presents new address on [ADR_O()]

SETUP, EDGE 3:
  SLAVE decodes inputs.

  SLAVE recognizes Classic Cycle and prepares response.

  SLAVE prepares to send data.

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 3:
  SLAVE asserts [ACK_I]

  SLAVE presents data on [DAT_I()].

SETUP, EDGE 4:
  SLAVE does not expect another transfer.

  MASTER prepares to latch data on [DAT_I()].

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 4:
  SLAVE negates [ACK_I].

  MASTER latches data on [DAT_I()]

  MASTER negates [CYC_O] and [STB_O] ending the cycle

.. todo::
   Does SEL_O really stay constant between accesses?

.. _classicread:
.. wavedrom::
   :caption: Classic Cycle

   {"signal": [
     {"name": "CLK_I",   "wave": "P....." },
     {"name": "CTI_O()", "wave": "x2...x", "data": "000" },
     {"name": "ADR_O()", "wave": "x2.3.x"},
     {"name": "DAT_I()", "wave": "x.2x3x"},
     {"name": "DAT_O()", "wave": "x....."},
     {"name": "SEL_O()", "wave": "x2...x"},
     {"name": "STB_O",   "wave": "01...0" },
     {"name": "ACK_I",   "wave": "0.1010" },
     {"name": "CYC_O",   "wave": "01...0" }
   ], "head": { "tick": -1 }
   }

End-Of-Burst
````````````

End-Of-Burst indicates that the current cycle is the last of the
current burst. The MASTER signals the slave that the burst ends
after this transfer.

**RULE 4.30**
  A MASTER MUST set End-Of-Burst to signal the end of the current burst.

**PERMISSION 4.35**
  The MASTER MAY start a new cycle after the assertion of End-Of-Burst.

**PERMISSION 4.40**
  A MASTER MAY use End-Of-Burst to indicate a single access.

**OBSERVATION 4.05**
  A single access is in fact a burst with a burst length of one.

:numref:`endofburst` demonstrates the usage of End-Of-Burst. A total
of three transfers are shown. The first transfer is part of a WISHBONE
Registered Feedback read burst. Transfer two is the last transfer of
that burst. The burst is ended when the MASTER sets [CTI_O()] to
End-Of-Burst (‘111’). The cycle is terminated after the third
transfer, a single write transfer. The protocol for this cycle works
as follows:

SETUP EDGE 0:
  WISHBONE Registered Feedback burst read cycle is in progress.

  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  MASTER prepares to end current burst

  SLAVE expects another cycle and prepares response

CLOCK EDGE 0:
  MASTER latches data on [DAT_I()]

  MASTER presents new [ADR_O()]

  MASTER presents End-Of-Burst on [CTI_O()]

  SLAVE presents new data on [DAT_I()]

  SLAVE keeps [ACK_I] asserted to indicate that it is ready to send
  new data

SETUP EDGE 1:
  SLAVE decodes inputs.

  SLAVE recognizes End-Of-Burst and prepares to terminate burst

  SLAVE prepares to send last data.

  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  MASTER prepares to start a new cycle

CLOCK EDGE 1:
  MASTER latches data on [DAT_I()]

  MASTER starts new cycle by presenting End-Of-Burst on [CTI_O()]

  MASTER presents new address on [ADR_O()]

  MASTER presents data on [DAT_O()]

  MASTER asserts [WE_O] to indicate a WRITE cycle

  SLAVE negates [ACK_I]

SETUP, EDGE 2:
  SLAVE decodes inputs

  SLAVE recognizes End-Of-Burst and prepares for a single transfer.

  SLAVE prepares response.

  MASTER monitors [ACK_I] and prepares to terminate current data
  phase.

CLOCK EDGE 2:
  SLAVE asserts [ACK_I].

SETUP, EDGE 3:
  SLAVE prepares to latch data on [DAT_O()]

  SLAVE prepares to end cycle.

  MASTER monitors [ACK_I] and prepares to terminate current data
  phase.

CLOCK EDGE 3:
  SLAVE latches data on [DAT_O()]

  SLAVE negates [ACK_I]

  MASTER negates [CYC_O] and [STB_O] ending the cycle.

.. _endofburst:
.. wavedrom::
   :caption: End-of-Burst

   {"signal": [
     {"name": "CLK_I",   "wave": "P...." },
     {"name": "CTI_O()", "wave": "234.x", "data": ["", "111", "111"] },
     {"name": "ADR_O()", "wave": "234.x"},
     {"name": "DAT_I()", "wave": "23x.."},
     {"name": "DAT_O()", "wave": "xx4.x"},
     {"name": "WE_O",    "wave": "0.1.x"},
     {"name": "SEL_O()", "wave": "3.4.x"},
     {"name": "STB_O",   "wave": "1...0" },
     {"name": "ACK_I",   "wave": "1.010" },
     {"name": "CYC_O",   "wave": "1...0" }
   ], "head": { "tick": -1 }
   }

Constant Address Burst Cycle
````````````````````````````

A constant address burst is defined as a single cycle with multiple
accesses to the same address.  Example: A MASTER reading a stream from
a FIFO.

**RULE 4.35**
  A MASTER signaling a constant address burst MUST initiate another
  cycle, the next cycle MUST be the same operation (either read or
  write), the select lines [SEL_O()] MUST have the same value, and that
  the address array [ADR_O()] MUST have the same value.

**PERMISSION 4.40**
  When the MASTER signals a constant address burst, the SLAVE MAY assert
  the termination signal for the next cycle as soon as the current cycle
  terminates.

:numref:`constantaddress` shows a CONSTANT ADDRESS BURST write
cycle. After the initial setup cycle, the Constant Address Burst cycle
is capable of a data transfer on every clock cycle. However, this
example also shows how the MASTER and the SLAVE interfaces can both
throttle the bus transfer rate by inserting wait states. A total of
four transfers are shown. After the first transfer the MASTER inserts
a wait state. After the second transfer the SLAVE inserts a wait
state. The cycle is terminated after the fourth transfer. The protocol
for this transfer works as follows:

CLOCK EDGE 0:
  MASTER presents [ADR_O()].

  MASTER presents Constant Address Burst on [CTI_O()].

  MASTER asserts [WE_O] to indicate a WRITE cycle.

  MASTER presents select [SEL_O()] to indicate where it sends data.

  MASTER asserts [CYC_O] to indicate cycle start.

  MASTER asserts [STB_O].

SETUP, EDGE 1:
  SLAVE decodes inputs.

  SLAVE recognizes Constant Address Burst and prepares response.

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 1:
  SLAVE asserts [ACK_I]

  SETUP, EDGE 2: SLAVE expects another transfer and prepares response
  for new transfer.

  SLAVE prepares to latch data on [DAT_O()].

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 2:
  SLAVE latches data on [DAT_O()].

  SLAVE keeps [ACK_I] asserted to indicate that it’s ready to latch
  new data.

  MASTER inserts wait states by negating [STB_O].

NOTE: any number of wait states can be inserted here.

SETUP, EDGE 3:
  MASTER is ready to transfer data again.

CLOCK, EDGE 3:
  MASTER presents [SEL_O].

  MASTER presents new [DAT_O()].

  MASTER asserts [STB_O].

SETUP, EDGE 4:
  SLAVE prepares to latch data on [DAT_O()]

  MASTER monitors [ACK_I] and prepares to terminate current data
  phase.

CLOCK, EDGE 4:
  SLAVE latches data on [DAT_O()].

  SLAVE inserts wait states by negating [ACK_I].

  MASTER presents new [DAT_O()].

NOTE: any number of wait states can be inserted here.

SETUP, EDGE 5:
  SLAVE is ready to transfer data again.

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  MASTER prepares to signal last transfer.

CLOCK, EDGE 5:
  SLAVE asserts [ACK_I].

SETUP, EDGE 6:
  SLAVE prepares to latch data on [DAT_O()].

  SLAVE expects another transfer and prepares response for new transfer.

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK, EDGE 6:
  SLAVE latches data on [DAT_O()].

  SLAVE keeps [ACK_I] asserted to indicate that it’s ready to latch
  new data.

  MASTER presents new [DAT_O()].

  MASTER presents End-Of-Burst on [CTI_O()].

SETUP, EDGE 7:
  SLAVE prepares to latch last data of burst on [DAT_O()]

  MASTER monitors [ACK_I] and prepares to terminate current cycle.

CLOCK, EDGE 7:
  SLAVE latches data on [DAT_O()].

  SLAVE ends burst by negating [ACK_I].

  MASTER negates [CYC_O] and [STB_O] ending the burst cycle.

.. _constantaddress:
.. wavedrom::
   :caption: Constant address burst

   {"signal": [
     {"name": "CLK_I",   "wave": "P..|.|...", "label": "...{WSM}(0.45).{WSS}(0.45)..."  },
     {"name": "CTI_O()", "wave": "x2.|.|.2x", "data": ["001", "111"] },
     {"name": "ADR_O()", "wave": "x2.|.|..x"},
     {"name": "DAT_I()", "wave": "x..|.|..."},
     {"name": "DAT_O()", "wave": "x.2...<x|>.2.<.|>.....x.", "period": 0.5},
     {"name": "WE_O",    "wave": "x1.|.|..x"},
     {"name": "SEL_O()", "wave": "x.2...<x|>.2.<.|>.....x.", "period": 0.5},
     {"name": "STB_O",   "wave": "0.1...<0|>.1.<.|>.....0.", "period": 0.5 },
     {"name": "ACK_I",   "wave": "0...1.<.|>...<0|>.1...0.", "period": 0.5 },
     {"name": "CYC_O",   "wave": "01.|.|..0" }
   ], "config": { "skin": "narrow", "hscale": 2 }, "head": { "tick": -1 }
   }


Incrementing Burst Cycle
````````````````````````

An incrementing burst is defined as multiple accesses to consecutive
addresses. Each transfer the address is incremented. The increment is
dependent on the data array [DAT_O()], [DAT_I()] size; for an 8bit
data array the increment is 1, for a 16bit data array the increment is
2, for a 32bit data array the increment is 4, etc.

Increments can be linear or wrapped. Linear increments means the next
address is one increment more than the current address. Wrapped
increments means that the address increments one, but that the
addresses’ LSBs are modulo the wrap size.

.. _wrap_size:
.. table:: Wrap Size address increments

  +---------------+-----------------+-----------------+-----------------+
  | Starting      |                 |                 |                 |
  | address’ LSBs |  Linear         | Wrap-4          | Wrap-8          |
  +---------------+-----------------+-----------------+-----------------+
  | 000           | 0-1-2-3-4-5-6-7 | 0-1-2-3-4-5-6-7 | 0-1-2-3-4-5-6-7 |
  +---------------+-----------------+-----------------+-----------------+
  | 001           | 1-2-3-4-5-6-7-8 | 1-2-3-0-5-6-7-4 | 1-2-3-4-5-6-7-0 |
  +---------------+-----------------+-----------------+-----------------+
  | 010           | 2-3-4-5-6-7-8-9 | 2-3-0-1-6-7-4-5 | 2-3-4-5-6-7-0-1 |
  +---------------+-----------------+-----------------+-----------------+
  | 011           | 3-4-5-6-7-8-9-A | 3-0-1-2-7-4-5-6 | 3-4-5-6-7-0-1-2 |
  +---------------+-----------------+-----------------+-----------------+
  | 100           | 4-5-6-7-8-9-A-B | 4-5-6-7-8-9-A-B | 4-5-6-7-0-1-2-3 |
  +---------------+-----------------+-----------------+-----------------+
  | 101           | 5-6-7-8-9-A-B-C | 5-6-7-4-9-A-B-8 | 5-6-7-0-1-2-3-4 |
  +---------------+-----------------+-----------------+-----------------+
  | 110           | 6-7-8-9-A-B-C-D | 6-7-4-5-A-B-8-9 | 6-7-0-1-2-3-4-5 |
  +---------------+-----------------+-----------------+-----------------+
  | 111           | 7-8-9-A-B-C-D-E | 7-4-5-6-B-8-9-A | 7-0-1-2-3-4-5-6 |
  +---------------+-----------------+-----------------+-----------------+

Example: Processor cache line read

**RULE 4.40**
  A MASTER signaling an incrementing burst MUST initiate another cycle,
  the next cycle MUST be the same operation (either read or write), the
  select lines [SEL_O()] MUST have the same value, the address array
  [ADR_O()] MUST be incremented, and the wrap size MUST be set by the
  burst type extension [BTE_O()] signals.

**PERMISSION 4.45**
  When the MASTER signals an incrementing burst, the SLAVE MAY assert
  the termination signal for the next cycle as soon as the current
  cycle terminates.

:numref:`burst` shows a 4-beat wrapped INCREMENTING BURST read
cycle. A total of four transfers are shown. The protocol for this
cycle works as follows:

CLOCK EDGE 0:
  MASTER presents [ADR_O()]

  MASTER presents Incrementing Burst on [CTI_O()]

  MASTER present 4-beat wrap on [BTE_O()]

  MASTER negates [WE_O] to indicate a READ cycle

  MASTER presents select [SEL_O()] to indicate where it expects data

  MASTER asserts [CYC_O] to indicate cycle start

  MASTER asserts [STB_O]

SETUP, EDGE 1:
  SLAVE decodes inputs.

  SLAVE recognizes Incrementing Burst and prepares response.

  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

CLOCK EDGE 1:
  SLAVE asserts [ACK_I]

  SLAVE present data on [DAT_I()]

SETUP, EDGE 2:
  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  SLAVE expects another transfer and prepares response.

CLOCK EDGE 2:
  MASTER latches data on [DAT_I()]

  MASTER presents new address on [ADR_O()]

  SLAVE presents new data on [DAT_I()]

  SLAVE keeps [ACK_I] asserted to indicate that it’s ready to send new data.

SETUP, EDGE 3:
  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  SLAVE expects another transfer and prepares response.

CLOCK, EDGE 3:
  MASTER latches data on [DAT_I()].

  MASTER presents new address on [ADR_O()]

  SLAVE presents new data on [DAT_I()].

  SLAVE keeps [ACK_I] asserted to indicate that it’s ready to send new data.

SETUP, EDGE 4:
  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  SLAVE expects another transfer and prepares response.

CLOCK, EDGE 4:
  MASTER latches data on [DAT_I()].

  MASTER presents new address on [ADR_O()]

  MASTER presents End-Of-Burst on [CTI_O()].

  SLAVE presents new data on [DAT_I()].

  SLAVE keeps [ACK_I] asserted to indicate that it’s ready to send new data.

SETUP, EDGE 5:
  MASTER prepares to latch data on [DAT_I()]

  MASTER monitors [ACK_I] and prepares to terminate current data phase.

  SLAVE recognizes End-Of-Burst and prepares to terminate burst.

CLOCK, EDGE 5:
  MASTER latches data on [DAT_I()].

  MASTER negates [CYC_O] and [STB_O] ending burst cycle

  SLAVE ends burst by negates [ACK_I]

.. _burst:
.. wavedrom::
   :caption: 4-beat wrapped incrementing burst for a 32bit data array

   {"signal": [
     {"name": "CLK_I",   "wave": "P......" },
     {"name": "CTI_O()", "wave": "x2...2x", "data": ["001", "111"] },
     {"name": "BTE_O()", "wave": "x2....x", "data": "01"},
     {"name": "DAT_O()", "wave": "x2.222x", "data": ["N+8", "N+C", "N", "N+4"]},
     {"name": "DAT_I()", "wave": "x.2222x"},
     {"name": "DAT_O()", "wave": "x......"},
     {"name": "WE_O",    "wave": "x0....x"},
     {"name": "SEL_O()", "wave": "x2....x"},
     {"name": "STB_O",   "wave": "01....0"},
     {"name": "ACK_I",   "wave": "0.1...0"},
     {"name": "CYC_O",   "wave": "01....0"}
   ], "head": { "tick": -1 }
   }
