// Generated for: spectre
// Generated on: Jul 14 19:37:24 2025
// Design library name: LCLCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

// Library name: LCLCell045
// Cell name: LCL1W11OF2X1
// View name: schematic
subckt LCL1W11OF2X1 A B Q VDD VSS
    M_i_5 (Q Q_neg VSS VSS) g45n1svt w=260.00n l=45n as=0013e-14 \
        ad=0013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_1 (Q_neg B VSS VSS) g45n1svt w=260.00n l=45n as=0013e-14 \
        ad=0013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_0 (VSS A Q_neg VSS) g45n1svt w=260.00n l=45n as=0013e-14 \
        ad=0013e-14 ps=310.0n pd=310.0n ld=105n ls=105n m=1
    M_i_4 (Q Q_neg VDD VDD) g45p1svt w=390.00n l=45n as=2.1012e-14 \
        ad=2.1012e-14 ps=410.0n pd=410.0n ld=105n ls=105n m=1
    M_i_3 (net_0 B VDD VDD) g45p1svt w=390.0n l=45n as=3.125e-14 \
        ad=3.125e-14 ps=500n pd=500n ld=105n ls=105n m=1
    M_i_2 (Q_neg A net_0 VDD) g45p1svt w=390.0n l=45n as=3.125e-14 \
        ad=3.125e-14 ps=500n pd=500n ld=105n ls=105n m=1
ends LCL1W11OF2X1
// End of subcircuit definition.

// Library name: LCLCell045
// Cell name: tb_LCL1W11OF2X1
// View name: schematic
I7 (A B Q VDD VSS) LCL1W11OF2X1
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (B VSS) vsource dc=0 type=pulse val0=0 val1=0 period=50n delay=10n \
        rise=100.0p fall=100.0p
V0 (A VSS) vsource dc=0 type=pulse val0=0 val1=0 period=100n delay=10n \
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