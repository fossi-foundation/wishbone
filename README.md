The Wishbone SoC Interconnect Architecture
==========================================

Wishbone is an interconnect for Systems-on-Chip.
It's been placed in the public domain and is (as far as we know) free from patents and royalties.
Wishbone is widely used in free and open source designs, but it can also be used in commercial designs without limitations.


Specification Documents
-----------------------

Today, the most used versions of Wishbone are revision B.3, and to a lesser extend, revision B.4.
Revision B.4 most notably adds support for pipelining more efficient access to high-latency peripherals like DRAM.

* [Wishbone B.4](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_b4.pdf)
* [Wishbone B.3](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_b3.pdf)

Note: Version B.4 adds new features which are not as widely accepted as the functionality of the previous versions.
A future version of the specification will try to reach wider agreement in this regard.

### Superseeded Specifications
The following specification documents have been replaced by newer versions and should not be used for new designs any more.

* [Wishbone B.2](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_b2.pdf)
* [Wishbone B.1](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_b1.pdf)
* [Wishbone B.0](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_b0.pdf)
* [Wishbone A.1](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_a1.pdf)
* [Wishbone A.0](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/spec/wbspec_a0.pdf)


Application Notes
-----------------

* [Combining Wishbone interface signals by Richard Herveille](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/appnotes/appnote_01.pdf)
* [Review of Three SoC Buses by Rudolf Usselmann](https://github.com/imphil/proposal-wishbone-project/raw/master/documents/appnotes/soc_bus_comparison.pdf)


Contributing and Maintainership
-------------------------------

The primary author and maintainer of the Wishbone specification is Richard Herveille.
The specification is now maintained by a group of people under the umbrella of the [FOSSi Foundation](http://www.fossi-foundation.org).
Please join the discussion@lists.librecores.org mailing list ([subscribe](https://lists.librecores.org/listinfo/discussion)) if you have questions or want to contribute to the specification process.
