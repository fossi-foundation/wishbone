The Wishbone SoC Interconnect Architecture
==========================================

Wishbone is an interconnect for Systems-on-Chip.
It's been placed in the public domain and is (as far as we know) free from patents and royalties.
Wishbone is widely used in free and open source designs, but it can also be used in commercial designs without limitations.

Find more information on our website: [https://wishbone-interconnect.org](https://wishbone-interconnect.org)

### Etherbone Extension

**Etherbone** is an extension that enables Wishbone transactions to be transported over Ethernet.  
It encapsulates Wishbone read/write cycles into Ethernet/UDP packets, allowing remote memory access and control of Wishbone-based systems across a network.

**Official resources:**
- Etherbone project on OHWR: https://www.ohwr.org/projects/etherbone-core  
- Etherbone specification: https://www.ohwr.org/project/etherbone-core/tree/master/spec

Etherbone is widely used in FPGA and embedded systems to provide remote debugging, register access, and distributed hardware control over Ethernet.