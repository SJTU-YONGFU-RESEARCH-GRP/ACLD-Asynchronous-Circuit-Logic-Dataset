// Generated for: spectre
// Generated on: Jul  1 17:24:33 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

/ Library name: AscendNCLCell
// Cell name: ACELEM1X1
// View name: schematic
subckt ACELEM1X1 a m p q VDD VSS
    M_i_8 (net_11 a net_7 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_7 (VDD m net_11 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_11 (VDD p net_9 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_13 (VDD net_7 q VDD) g45p1svt w=390.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_12 (net_8 net_7 VDD VDD) g45p1svt w=390.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_9 (net_7 net_8 net_9 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_10 (net_9 a VDD VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_0 (net_6 m VSS VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_3 (net_7 a net_10 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_4 (net_10 p VSS VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_6 (VSS net_7 q VSS) g45n1svt w=260.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_1 (VSS a net_6 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_2 (net_6 net_8 net_7 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    M_i_5 (net_8 net_7 VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
ends ACELEM1X1
// End of subcircuit definition.

// Library name: AscendNCLCell
// Cell name: tb_ACELEM1X1
// View name: schematic
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (A VSS) vsource dc=0 type=pulse val0=0 val1=0 period=100n delay=10n \
        rise=100.0p fall=100.0p
V2 (P VSS) vsource dc=0 type=pulse val0=0 val1=0 period=25n delay=10n \
        rise=100.0p fall=100.0p
V0 (M VSS) vsource dc=0 type=pulse val0=0 val1=0 period=50n delay=10n \
        rise=100.0p fall=100.0p
I2 (A M P Q) ACELEM1X1
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

