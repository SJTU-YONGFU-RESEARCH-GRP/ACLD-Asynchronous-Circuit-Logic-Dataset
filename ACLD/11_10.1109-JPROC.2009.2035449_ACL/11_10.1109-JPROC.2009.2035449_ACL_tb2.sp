// Generated for: spectre
// Generated on: Jul  1 18:19:26 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "/home/yongfu/research-freepdk-library/Cadence45/TECH/GPDK045/gpdk045_v_6_0/gpdk045/../models/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: INCL2W11OF2X1
// View name: schematic
subckt INCL2W11OF2X1 a b q VDD VSS
    MPO0 (VDD IQ q VDD) g45p1svt w=390.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI1 (pl00 b PREQ VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPI0 (VDD a pl00 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPB0 (VDD PREQ IQ VDD) g45p1svt w=390.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPH0 (PREQ IQ ph00 VDD) g45p1svt w=390.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MPH1 (ph00 a VDD VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MPH2 (ph00 b VDD VDD) g45p1svt w=390.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI0 (PREQ b nl00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNI1 (nl00 a VSS VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNO0 (q IQ VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNH1 (VSS a nh00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNH2 (VSS b nh00 VSS) g45n1svt w=260.0n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1
    MNH0 (nh00 IQ PREQ VSS) g45n1svt w=260.0n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
    MNB0 (IQ PREQ VSS VSS) g45n1svt w=260.00n l=45n as=9.45e-15 \
        ad=9.45e-15 ps=300n pd=300n ld=105n ls=105n m=1
ends INCL2W11OF2X1
// End of subcircuit definition.

// Library name: AscendNCLCell
// Cell name: tb_INCL2W11OF2X1
// View name: schematic
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (a VSS) vsource dc=0 type=pulse val0=0 val1=0 period=100n delay=10n \
        rise=100.0p fall=100.0p
V0 (b VSS) vsource dc=0 type=pulse val0=0 val1=0 period=500n delay=10n \
        rise=100.0p fall=100.0p
I2 (a b q) INCL2W11OF2X1
simulatorOptions options reltol=1e-3 vabstol=1e-6 iabstol=1e-12 temp=27 \
    tnom=27 scalem=1.0 scale=1.0 gmin=1e-12 rforce=1 maxnotes=5 maxwarns=5 \
    digits=5 cols=80 pivrel=1e-3 sensfile="../psf/sens.output" \
    checklimitdest=psf 
modelParameter info what=models where=rawfile
element info what=inst where=rawfile
outputParameter info what=output where=rawfile
designParamVals info what=parameters where=rawfile
primitives info what=primitives where=rawfile
subckts info what=subckts  where=rawfile
saveOptions options save=allpub