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
// Cell name: tb_LCL2W11OF2X1
// View name: schematic
I7 (A B Q VDD VSS) LCL2W11OF2X1
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
parameters vdd=1.2

simulator lang=spice
.measure dc Static_Power AVG PAR('ABS(I(V1))*1.2') FROM=35n TO=45n
simulator lang=spectre
