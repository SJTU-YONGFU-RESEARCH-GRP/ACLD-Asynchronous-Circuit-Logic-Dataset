// Generated for: spectre
// Generated on: Jul 14 18:59:22 2025
// Design library name: GASPCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

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

// Library name: GASPCell045
// Cell name: GASPLATCHX1
// View name: schematic
subckt GASPLATCHX1 VDD VSS data_in data_out
    I4 (net2 data_in VDD VSS) gsclib045u_INVX1_schematic
    I3 (net2 data_out VDD VSS) gsclib045u_INVX1_schematic
    I2 (net2 data_out VDD VSS) gsclib045u_INVX1_schematic
    I1 (data_in net2 VDD VSS) gsclib045u_INVX1_schematic
    I0 (data_in net2 VDD VSS) gsclib045u_INVX1_schematic
ends GASPLATCHX1
// End of subcircuit definition.

// Library name: GASPCell045
// Cell name: tb_GASPNANDX1
// View name: schematic
I1 (VDD VSS data_in data_out s0 s1) GASPLATCHX1
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V0 (data_in VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=100n \
        delay=10n rise=100.0p fall=100.0p
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