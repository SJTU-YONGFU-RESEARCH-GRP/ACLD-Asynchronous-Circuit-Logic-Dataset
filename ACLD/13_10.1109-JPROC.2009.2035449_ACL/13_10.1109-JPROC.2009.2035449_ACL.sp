/ Generated for: spectre
// Generated on: Jul  1 18:10:54 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: INCL1W1OF1X1
// View name: schematic
subckt INCL1W1OF1X1 a q VDD VSS
    MPO0 (VDD a q VDD) g45p1svt w=390n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNO0 (q a VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
ends INCL1W1OF1X1
// End of subcircuit definition.

// Library name: AscendNCLCell
// Cell name: testing
// View name: schematic
I7 (net2 net1) INCL1W1OF1X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 