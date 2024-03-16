# PiKVM Issues and Fixes

This is a collection of issues encountered when setting up a Raspberry Pi PiKVM device. This is a growing list and will continue to be modified and improved over time.

## Log

### Intel Nuc CSI Bridge Compatibility Error

When using an Intel Nuc, the Nuc's CSI Bridge while navigating the BIOS interferes with the PiKVM default EDID value. This is a known issue on PiKVM's documentation and can be found [here](https://docs.pikvm.org/edid/) *(03/13/2024)*.

Without the EDID update, while in Intel Nuc BIOS, the PiKVM WebGUI KVM output is a black screen with no input/output. The default EDID value must be modified to the following:

```hex
00FFFFFFFFFFFF005262888800888888
1C150103800000780AEE91A3544C9926
0F505425400001000100010001000100
010001010101D32C80A070381A403020
350040442100001E7E1D00A050001940
3020370080001000001E000000FC0050
492D4B564D20566964656F0A000000FD
00323D0F2E0F000000000000000001C4
02030400DE0D20A03058122030203400
F0B400000018E01500A0400016303020
3400000000000018B41400A050D01120
3020350080D810000018AB22A0A05084
1A3030203600B00E1100001800000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000045
```