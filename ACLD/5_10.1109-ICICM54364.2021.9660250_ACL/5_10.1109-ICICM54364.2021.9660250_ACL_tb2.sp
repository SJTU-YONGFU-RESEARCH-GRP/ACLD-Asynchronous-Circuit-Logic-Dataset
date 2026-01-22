// Generated for: spectre
// Generated on: Jul 15 10:32:25 2025
// Design library name: RTCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0 VSS! VDD!
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: RTCell045
// Cell name: RTNOR2X1
// View name: schematic
subckt RTNOR2X1 a b y VDD VSS
    mn1 (y b VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (y a VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp1 (y b net41 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (net41 a VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends RTNOR2X1
// End of subcircuit definition.

// Library name: RTCell045
// Cell name: tb_RTNAND
// View name: schematic
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (a VSS) vsource dc=0 type=pulse val0=0 val1=0 period=100n delay=10n \
        rise=100.0p fall=100.0p
V3 (b VSS) vsource type=pulse val0=0 val1=0 period=100n delay=30n \
        rise=100.0p fall=100.0p
I3 (a b y VDD VSS) RTNOR2X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 
tran tran stop=200n write="spectre.ic" writefinal="spectre.fc" \
    annotate=status maxiters=5 
finalTimeOP info what=oppoint where=rawfile
dcOp dc write="spectre.dc" maxiters=150 maxsteps=10000 annotate=status
dcOpInfo info what=oppoint where=rawfile
modelParameter info what=models where=rawfile
element info what=inst where=rawfile
outputParameter info what=output where=rawfile
designParamVals info what=parameters where=rawfile
primitives info what=primitives where=rawfile
subckts info what=subckts  where=rawfile
saveOptions options save=allpub
parameters vdd=1.2

simulator lang=spice
.measure dc Static_Power AVG PAR('ABS(I(V1))*1.2') FROM=35n TO=45n
simulator lang=spectre
