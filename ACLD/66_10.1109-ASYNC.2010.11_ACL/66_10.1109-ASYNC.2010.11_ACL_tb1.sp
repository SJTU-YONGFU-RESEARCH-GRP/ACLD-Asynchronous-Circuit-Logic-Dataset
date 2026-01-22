// Generated for: spectre
// Generated on: Jul  1 14:59:41 2025
// Design library name: ClickCell045
// Design cell name: tb_MERGE
// Design view name: schematic
simulator lang=spectre
global 0 VDD! VSS!
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: gsclib045u
// Cell name: AND2X1
// View name: schematic
subckt AND2X1 A B Y inh_VDD inh_VSS
    mn2 (Y n0 inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (net127 B inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn1 (n0 A net127 inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp1 (n0 B inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (n0 A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp2 (Y n0 inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends AND2X1
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: INVX1
// View name: schematic
subckt INVX1 A Y inh_VDD inh_VSS
    mp0 (Y A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mn0 (Y A inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
ends INVX1
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: DFFX1
// View name: schematic
subckt DFFX1 CK D Q QN inh_VDD inh_VSS
    mn26 (n20 CKb n21 inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn25 (n21 D inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn57 (QN qint inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn55 (Q qbint inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn50 (n35 qbint inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn51 (n30 CKb n35 inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn35 (n25 mout inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn36 (n20 CKbb n25 inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn20 (CKb CK inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn45 (qbint n30 inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn56 (qint qbint inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 \
        as=36.4f ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m \
        sa=140n sb=140n sd=160n sca=144.98299 scb=0.10251 scc=0.01780 \
        m=(1)
    mn21 (CKbb CKb inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn30 (mout n20 inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn40 (n30 CKbb mout inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp26 (n20 CKbb n22 inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp25 (n22 D inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp51 (n30 CKbb n36 inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp50 (n36 qbint inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp57 (QN qint inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp55 (Q qbint inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp35 (n26 mout inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp36 (n20 CKb n26 inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp20 (CKb CK inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp45 (qbint n30 inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp56 (qint qbint inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 \
        as=54.6f ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m \
        sa=140n sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 \
        m=(1)
    mp21 (CKbb CKb inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp40 (n30 CKb mout inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp30 (mout n20 inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends DFFX1
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: OR2X1
// View name: schematic
subckt OR2X1 A B Y inh_VDD inh_VSS
    mn2 (Y n0 inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (n0 A inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn1 (n0 B inh_VSS inh_VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mp1 (n0 B n1 inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp2 (Y n0 inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (n1 A inh_VDD inh_VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends OR2X1
// End of subcircuit definition.

// Library name: gsclib045u
// Cell name: XOR2X1
// View name: schematic
subckt XOR2X1 A B vdd vss n0
    NM1 (n0 Bb net032 vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM0 (net032 Ab vss vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM2 (Bb B vss vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn1 (n0 B net53 vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn2 (Ab A vss vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    mn0 (net53 A vss vss) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    PM3 (Bb B vdd vdd) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM2 (net59 Ab vdd vdd) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM0 (net54 A vdd vdd) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM1 (n0 B net59 net59) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp2 (Ab A vdd vdd) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (n0 Bb net54 net54) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends XOR2X1
// End of subcircuit definition.

// Library name: ClickCell045
// Cell name: MERGE
// View name: schematic
subckt MERGE VDD VSS a a_ack a_req a_sel b b_ack b_req b_sel c c_ack
    I15 (b_sel b n4 VDD VSS) AND2X1
    I14 (a_sel a n3 VDD VSS) AND2X1
    I9 (b_sel n n1 VDD VSS) AND2X1
    I8 (a_sel n n0 VDD VSS) AND2X1
    I11 (c_req net017 VDD VSS) INVX1
    I7 (net016 n VDD VSS) INVX1
    I17 (clk net015 c net018 VDD VSS) DFFX1
    I13 (click net022 b_ack net019 VDD VSS) DFFX1
    I20 (click net03 a_ack net07 VDD VSS) DFFX1
    I2 (click net017 c_req net06 VDD VSS) DFFX1
    I16 (n3 n4 net015 VDD VSS) OR2X1
    I10 (n0 n1 clk VDD VSS) OR2X1
    I12 (b_ack b_sel VDD VSS net022) XOR2X1
    I5 (c_ack c_req VDD VSS net016) XOR2X1
    I4 (b_ack b_req VDD VSS b_sel) XOR2X1
    I6 (a_ack a_req VDD VSS a_sel) XOR2X1
    I1 (a_ack a_sel VDD VSS net03) XOR2X1
ends MERGE
// End of subcircuit definition.

// Library name: ClickCell045
// Cell name: tb_MERGE
// View name: schematic
I9 (VDD VSS a a_ack a_req a_sel b b_ack b_req b_sel c c_ack) \
        MERGE
V7 (b VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=200n delay=0 \
        rise=100.0p fall=100.0p
V4 (a VSS) vsource dc=0 type=pulse val0=1.2 val1=0 period=200n delay=0 \
        rise=100.0p fall=100.0p
V3 (a_req VSS) vsource type=pulse val0=0 val1=1.2 period=200n delay=20n \
        rise=100.0p fall=100.0p width=50n
V2 (c_ack VSS) vsource type=pulse val0=0 val1=1.2 period=100n delay=30n \
        rise=100.0p fall=100.0p
V6 (b_req VSS) vsource type=pulse val0=0 val1=1.2 period=200n delay=120n \
        rise=100.0p fall=100.0p width=50n
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=1.2 type=dc
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
.measure tran Trans_Delay TRIG V(a_req) VAL=0.6 RISE=1 TARG V(c_ack) VAL=0.6 RISE=1
.measure tran Switching_Energy INTEG PAR('ABS(I(V1))*1.2') FROM=17n TO=33n
simulator lang=spectre
