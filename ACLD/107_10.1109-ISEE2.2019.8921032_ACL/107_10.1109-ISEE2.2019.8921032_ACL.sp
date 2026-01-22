// Generated for: spectre
// Generated on: Jul 14 19:35:16 2025
// Design library name: LCLCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: LCLCell045
// Cell name: LCL2W11OF2X1
// View name: schematic
subckt LCL2W11OF2X1 A B Q VDD VSS
    MNH1 (VSS A nh00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNB0 (IQ PREQ VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNH0 (nh00 IQ PREQ VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNO0 (Q PREQ VSS VSS) g45n1svt w=260n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNH2 (VSS B nh00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI0 (PREQ B nl00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI1 (nl00 A VSS VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPH0 (PREQ IQ ph00 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPB0 (VDD PREQ IQ VDD) g45p1svt w=390.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPO0 (VDD PREQ Q VDD) g45p1svt w=390.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI1 (pl00 B PREQ VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPH1 (ph00 A VDD VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI0 (VDD A pl00 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPH2 (ph00 B VDD VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
ends LCL2W11OF2X1
// End of subcircuit definition.

// Library name: LCLCell045
// Cell name: testing
// View name: schematic
I3 (net4 net5 net3 net1 net2) LCL2W11OF2X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 