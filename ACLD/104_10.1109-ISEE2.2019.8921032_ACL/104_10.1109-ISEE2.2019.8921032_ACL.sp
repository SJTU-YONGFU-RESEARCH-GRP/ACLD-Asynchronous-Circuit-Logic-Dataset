// Generated for: spectre
// Generated on: Jul 14 19:37:24 2025
// Design library name: LCLCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: LCLCell045
// Cell name: LCL1W11OF2X1
// View name: schematic
subckt LCL1W11OF2X1 A B Q VDD VSS
    M_i_5 (Q Q_neg VSS VSS) g45n1svt w=260.00n l=45n as=1.2013e-14 \
        ad=1.2013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_1 (Q_neg B VSS VSS) g45n1svt w=260.00n l=45n as=1.2013e-14 \
        ad=1.2013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_0 (VSS A Q_neg VSS) g45n1svt w=260.00n l=45n as=1.2013e-14 \
        ad=1.2013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_4 (Q Q_neg VDD VDD) g45p1svt w=390.00n l=45n as=2.1012e-14 \
        ad=2.1012e-14 ps=410.0n pd=410.0n ld=105n ls=105n m=1
    M_i_3 (net_0 B VDD VDD) g45p1svt w=390.0n l=45n as=3.125e-14 \
        ad=3.125e-14 ps=500n pd=500n ld=105n ls=105n m=1
    M_i_2 (Q_neg A net_0 VDD) g45p1svt w=390.0n l=45n as=3.125e-14 \
        ad=3.125e-14 ps=500n pd=500n ld=105n ls=105n m=1
ends LCL1W11OF2X1
// End of subcircuit definition.

// Library name: LCLCell045
// Cell name: testing
// View name: schematic
I4 (net4 net5 net3 net1 net2) LCL1W11OF2X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 