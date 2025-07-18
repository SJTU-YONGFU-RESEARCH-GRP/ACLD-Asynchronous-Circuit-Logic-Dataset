// Generated for: spectre
// Generated on: Jul  1 18:14:04 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: INCL1W111OF3X1
// View name: schematic
subckt INCL1W111OF3X1 a b c q VDD VSS
    MPI0 (VDD a pl00 VDD) g45p1svt w=390.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI2 (pl01 c q VDD) g45p1svt w=390.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI1 (pl00 b pl01 VDD) g45p1svt w=390.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNI0 (q a VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI2 (q c VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI1 (q b VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
ends INCL1W111OF3X1
// End of subcircuit definition.

// Library name: AscendNCLCell
// Cell name: tb_INCL1W111OF3X1
// View name: schematic
I1 (A B C Q) INCL1W111OF3X1
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V2 (C VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=25n delay=10n \
        rise=100.0p fall=100.0p
V0 (B VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=50n delay=10n \
        rise=100.0p fall=100.0p
V4 (A VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=100n delay=10n \
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