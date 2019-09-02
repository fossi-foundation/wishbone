Timing Specification
====================

The WISHBONE specification is designed to provide the end user with
very simple timing constraints. Although the application specific
circuit(s) will vary in this regard, the interface itself is designed
to work without the need for detailed timing specifications. In all
cases, the only timing information that is needed by the end user is
the maximum clock frequency (for [CLK_I]) that is passed to a place &
route tool. The maximum clock frequency is dictated by the time delay
between a positive clock edge on [CLK_I] to the setup on a stage
further down the logical signal path. This delay is shown graphically
in :numref:`timing`, and is defined as Tpd,clk-su.

.. _timing:
.. figure:: _static/timing.*

   Definition for Tpd,clk-su.

**RULE 5.00**
  The clock input [CLK_I] to each IP core MUST coordinate all activities
  for the internal logic within the WISHBONE interface. All WISHBONE
  output signals are registered at the rising edge of [CLK_I]. All
  WISHBONE input signals MUST be stable before the rising edge of
  [CLK_I].

**PERMISSION 5.00**
  The user’s place and route tool MAY be used to enforce RULE 5.00.

**OBSERVATION 5.00**
  Most place and route tools can be easily configured to enforce RULE
  5.00. Generally, it only requires a single timing specification for
  Tpd,clk-su.

**RULE 5.05**
  The WISHBONE interface MUST use synchronous, RTL design methodologies
  that, given nearly infinitely fast gate delays, will operate over a
  nearly infinite range of clock frequencies on [CLK_I].

**OBSERVATION 5.05**
  Realistically, the WISHBONE interface will never be expected to
  operate over a nearly infinite frequency range. However this
  requirement eliminates the need for non-portable timing constraints
  (that may work only on certain target devices).

**OBSERVATION 5.10**
  The WISHBONE interface logic assumes that a low-skew clock
  distribution scheme is used on the target device, and that the
  clock-skew shall be low enough to permit reliable operation over the
  environmental conditions.

**PERMISSION 5.05**
  The IP core connected to a WISHBONE interface MAY include application
  specific timing requirements.

**RULE 5.10**
  The clock input [CLK_I] MUST have a duty cycle that is no less than
  40%, and no greater than 60%.

**PERMISSION 5.10**
  The SYSCON module MAY use a variable clock generator. In these cases
  the clock frequency can be changed by the SYSCON module so long as the
  clock edges remain clean and monotonic, and if the clock does not
  violate the duty cycle requirements.

**PERMISSION 5.15**
  The SYSCON module MAY use a gated clock generator. In these cases the
  clock shall be stopped in the low logic state. When the gated clock is
  stopped and started the clock edges are required to remain clean and
  monotonic.

**SUGGESTION 5.00**
  When using a gated clock generator, turn the clock off when the
  WISHBONE interconnection is not busy. One way of doing this is to
  create a MASTER interface whose sole purpose is to acquire the
  WISHBONE interconnection and turn the clock off. This assures that the
  WISHBONE interconnection is not busy when gating the clock off. When
  the clock signal is restored the MASTER then releases the WISHBONE
  interconnection.

**OBSERVATION 5.15**
  This specification does not attempt to govern the
  design of gated or variable clock generators.

**SUGGESTION 5.10**
  Design an IP core so that all of the circuits (including the WISHBONE
  interconnect) follow the aforementioned RULEs, as this will make the
  core portable across a wide range of target devices and technologies.
