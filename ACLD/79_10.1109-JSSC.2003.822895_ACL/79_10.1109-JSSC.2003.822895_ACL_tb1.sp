// Generated for: spectre
// Generated on: Jul 15 11:03:40 2025
// Design library name: STAPLCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: gsclib045u
// Cell name: INVX1
// View name: schematic
subckt gsclib045u_INVX1_schematic A Y inh_VDD inh_VSS
    mp0 (Y A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mn0 (Y A inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
ends gsclib045u_INVX1_schematic
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: NOR2X1
// View name: schematic
subckt gsclib045u_NOR2X1_schematic A B Y inh_VDD inh_VSS
    mn1 (Y B inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (Y A inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp1 (Y B net41 inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (net41 A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends gsclib045u_NOR2X1_schematic
// End of subcircuit definition.

// Library name: STAPLCell045
// Cell name: RPULSEX1
// View name: schematic
subckt RPULSEX1 VDD VSS p xv
    I4 (net01 p VDD VSS) gsclib045u_INVX1_schematic
    I3 (net7 net6 VDD VSS) gsclib045u_INVX1_schematic
    I2 (net8 net7 VDD VSS) gsclib045u_INVX1_schematic
    I1 (net13 net8 VDD VSS) gsclib045u_INVX1_schematic
    I0 (net01 net13 VDD VSS) gsclib045u_INVX1_schematic
    NM0 (net01 xv VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    PM0 (net01 net6 VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends RPULSEX1
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: NAND2X1
// View name: schematic
subckt NAND2X1 A B Y inh_VDD inh_VSS
    mn1 (Y B n0 inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (n0 A inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp1 (Y B inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (Y A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends NAND2X1
// End of subcircuit definition.

// Library name: STAPLCell045
// Cell name: STAPLINVX1
// View name: schematic
subckt STAPLINVX1 VDD VSS l0 l1 r0 r1
    I11 (net018 out_ack VDD VSS) gsclib045u_INVX1_schematic
    I10 (net017 net018 VDD VSS) gsclib045u_INVX1_schematic
    I8 (net021 net022 VDD VSS) gsclib045u_INVX1_schematic
    I7 (net020 net021 VDD VSS) gsclib045u_INVX1_schematic
    I6 (net019 net020 VDD VSS) gsclib045u_INVX1_schematic
    I5 (s1 net019 VDD VSS) gsclib045u_INVX1_schematic
    I3 (net7 net6 VDD VSS) gsclib045u_INVX1_schematic
    I2 (net8 net7 VDD VSS) gsclib045u_INVX1_schematic
    I1 (net13 net8 VDD VSS) gsclib045u_INVX1_schematic
    I0 (s0 net13 VDD VSS) gsclib045u_INVX1_schematic
    NM6 (l1 p VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM5 (l0 p VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM4 (re out_ack VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM3 (net023 l0 re VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM0 (net01 l1 re VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    PM3 (net023 net022 VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM2 (r1 s1 VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM0 (net01 net6 VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM1 (r0 s0 VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    I9 (r0 r1 net017 VDD VSS) gsclib045u_NOR2X1_schematic
    I12 (VDD VSS p xv) RPULSEX1
    I13 (s0 s1 xv VDD VSS) NAND2X1
ends STAPLINVX1
// End of subcircuit definition.

// Library name: STAPLCell045
// Cell name: tb_STAPLINVX1
// View name: schematic
I5 (VDD VSS l0 l1 r0 r1) STAPLINVX1
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (l1 VSS) vsource dc=0 type=pulse val0=1.2 val1=0 period=100n delay=10n \
        rise=100.0p fall=100.0p
V0 (l0 VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=100n delay=10n \
        rise=100.0p fall=100.0p
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 
tran tran stop=200n errpreset=moderate write="spectre.ic" \
    writefinal="spectre.fc" annotate=status maxiters=5 
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
.measure tran Trans_Delay TRIG V(l0) VAL=0.6 RISE=1 TARG V(r0) VAL=0.6 RISE=1
.measure tran Switching_Energy INTEG PAR('ABS(I(V1))*1.2') FROM=17n TO=33n
simulator lang=spectre
