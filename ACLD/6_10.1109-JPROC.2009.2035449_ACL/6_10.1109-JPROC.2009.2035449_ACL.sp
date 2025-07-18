// Generated for: spectre
// Generated on: Jul  1 17:48:54 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: NCL1W111OF3X1
// View name: schematic
subckt NCL1W111OF3X1 a b c q VDD VSS
    MPI0 (VDD a pl00 VDD) g45p1svt w=3.05e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPI2 (pl01 c PREQ VDD) g45p1svt w=3.05e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPI1 (pl00 b pl01 VDD) g45p1svt w=3.05e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPO0 (VDD PREQ q VDD) g45p1svt w=2.05e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNI0 (PREQ a VSS VSS) g45n1svt w=1.15e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNI1 (PREQ b VSS VSS) g45n1svt w=1.15e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNI2 (PREQ c VSS VSS) g45n1svt w=1.15e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNO0 (q PREQ VSS VSS) g45n1svt w=1.55e-07 l=5e-08 as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
ends NCL1W111OF3X1
// End of subcircuit definition.

// Library name: AscendNCLCell
// Cell name: testing
// View name: schematic
I3 (net4 net3 net2 net1) NCL1W111OF3X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 