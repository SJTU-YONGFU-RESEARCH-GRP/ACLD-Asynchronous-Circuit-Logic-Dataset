/ Generated for: spectre
// Generated on: Jul  1 18:10:54 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: INCL1W1OF1X1
// View name: schematic
subckt INCL1W1OF1X1 a q VDD VSS
    MPO0 (VDD a q VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    MNO0 (q a VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
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