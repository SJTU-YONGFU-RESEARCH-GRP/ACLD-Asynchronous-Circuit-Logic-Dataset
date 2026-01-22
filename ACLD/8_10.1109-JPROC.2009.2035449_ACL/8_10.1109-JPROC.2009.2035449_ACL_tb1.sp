// Generated for: spectre
// Generated on: Jul  1 17:24:33 2025
// Design library name: AscendNCLCell
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: AscendNCLCell
// Cell name: tb_ACELEM1X1
// View name: schematic
V5 (VSS 0) vsource dc=0 type=dc
V1 (VDD VSS) vsource dc=vdd type=dc
V4 (A VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=100n delay=10n \
        rise=100.0p fall=100.0p
V2 (P VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=25n delay=10n \
        rise=100.0p fall=100.0p
V0 (M VSS) vsource dc=0 type=pulse val0=0 val1=1.2 period=50n delay=10n \
        rise=100.0p fall=100.0p
I2 (A M P Q VDD VSS) ACELEM1X1
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
.measure tran Trans_Delay TRIG V(P) VAL=0.6 RISE=1 TARG V(Q) VAL=0.6 RISE=1
.measure tran Switching_Energy INTEG PAR('ABS(I(V1))*1.2') FROM=17n TO=33n
simulator lang=spectre
