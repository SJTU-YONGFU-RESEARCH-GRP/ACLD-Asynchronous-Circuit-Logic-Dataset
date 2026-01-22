// Generated for: spectre
// Generated on: Jul  3 08:40:13 2025
// Design library name: SAHBCell045
// Design cell name: testing
// Design view name: schematic
simulator lang=spectre
global 0
include "../../../input/spectre/gpdk045.scs" section=mc

// Library name: gsclib045
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

// Library name: SAHBCell045
// Cell name: COMPLETX1
// View name: schematic
subckt COMPLETX1 L_ack VDD VSS nL_ack nQF nQT
    I0 (L_ack nL_ack VDD VSS) INVX1
    I3 (nQT nQF L_ack VDD VSS) NAND2X1
ends COMPLETX1
// End of subcircuit definition.

// Library name: SAHBCell045
// Cell name: CsubBUFFX1
// View name: schematic
subckt CsubBUFFX1 QF QT VDD VDDV VSS nQF nQT
    NM1 (QT QF VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM0 (QF QT VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    I0 (QT nQT VDD VSS) INVX1
    I2 (QF nQF VDD VSS) INVX1
    PM1 (QT QF VDDV VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM0 (QF QT VDDV VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
ends CsubBUFFX1
// End of subcircuit definition.

// Library name: SAHBCell045
// Cell name: NXORX1
// View name: schematic
subckt NXORX1 AF AT BF BT L_ack QF QT RST R_ack VDD VDDL VSS nAF nAT nBF nBT \
        nL_ack nQF nQT nR_ack
    NM36 (net92 nAT VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM35 (net92 nBT VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM32 (QT R_ack net089 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM31 (net089 nAT net81 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM30 (net81 nAF net088 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM29 (net82 nBF VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM27 (net090 nBT net70 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM26 (net70 nBF VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM25 (net63 nAF net012 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM24 (net63 nBT net012 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM23 (net053 AT net092 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM22 (net092 BT net55 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM19 (net053 AF net093 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM18 (net093 BT net38 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM33 (net030 nAF net92 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM16 (net42 nAF net090 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM15 (net049 nAT net42 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM14 (net012 nBF VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM21 (net053 AF net091 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM12 (net053 AT net017 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM11 (VDDL nR_ack net053 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM20 (net091 BF net55 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM9 (net55 nQF QT VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM8 (net017 BF net38 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM7 (net38 nQT QF VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM6 (QF RST QT VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM28 (net088 nBT net82 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM4 (QT nQF net030 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM3 (QF R_ack net049 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM34 (net030 nBF net92 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM2 (QF nQT net63 VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f ad=36.4f \
        ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n sd=160n \
        sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    NM0 (net012 nAT VSS VSS) g45n1svt w=(260n) l=45n nf=1 as=36.4f \
        ad=36.4f ps=800n pd=800n nrd=538.462m nrs=538.462m sa=140n sb=140n \
        sd=160n sca=144.98299 scb=0.10251 scc=0.01780 m=(1)
    PM10 (net025 nBT VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM9 (net025 nBF VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM8 (net035 nBF net47 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM7 (net035 nBT net47 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM6 (net025 R_ack VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM5 (net025 nAT VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM4 (net025 nAF VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM3 (VDDV nQF net025 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM2 (VDDV nQT net025 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM1 (net47 nAF VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    PM0 (VDDV R_ack net035 VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f \
        ad=54.6f ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n \
        sb=140n sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    mp0 (net47 nAT VDD VDD) g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)
    I3 (L_ack VDD VSS nL_ack nQF nQT) COMPLETX1
    I4 (QF QT VDD VDDV VSS nQF nQT) CsubBUFFX1
ends NXORX1
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

// Library name: SAHBCell045
// Cell name: tb_NXORX1
// View name: schematic
I10 (AF AT BF BT L_ack QF QT RST R_ack VDD VDDL VSS nAF nAT nBF nBT nL_ack \
        nQF nQT nR_ack) NXORX1
I7 (BF nBF VDD VSS) INVX1
I6 (BT nBT VDD VSS) INVX1
I4 (R_ack nR_ack VDD VSS) INVX1
I3 (AF nAF VDD VSS) INVX1
I1 (AT nAT VDD VSS) INVX1
V3 (VDDL VSS) vsource dc=800.0m type=dc
V1 (VSS 0) vsource dc=0 type=dc
V0 (VDD VSS) vsource dc=1.2 type=dc
V12 (BF2 VSS) vsource type=pulse val0=0 val1=1.2 period=160n delay=130n \
        width=20n
V11 (BF1 VSS) vsource type=pulse val0=0 val1=1.2 period=160n delay=90n \
        width=20n
V10 (BT2 VSS) vsource type=pulse val0=0 val1=1.2 period=160n delay=50n \
        width=20n
V9 (BT1 VSS) vsource type=pulse val0=0 val1=1.2 period=160n delay=10n \
        width=20n
V6 (R_ack VSS) vsource type=pulse val0=1.2 val1=0 period=40n delay=10n
V5 (RST VSS) vsource type=pulse val0=0 val1=1.2 period=200n width=5n
V4 (AF VSS) vsource type=pulse val0=0 val1=1.2 period=80n delay=50n \
        width=20n
V2 (AT VSS) vsource type=pulse val0=0 val1=1.2 period=80n delay=10n \
        width=20n
I9 (BF1 BF2 BF VDD VSS) OR2X1
I8 (BT1 BT2 BT VDD VSS) OR2X1
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
.measure tran Trans_Delay TRIG V(l_ack) VAL=0.6 RISE=1 TARG V(r_ack) VAL=0.6 RISE=1
.measure tran Switching_Energy INTEG PAR('ABS(I(V1))*1.2') FROM=17n TO=33n
simulator lang=spectre
