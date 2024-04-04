# Supermicro Fan Control

Supermicro motherboards for versions X9/X10/X11 have four modes of fan speed control. The information has been taken and simplified from @PigLover from this [Reference Material](https://forums.servethehome.com/index.php?resources/supermicro-x9-x10-x11-fan-speed-control.20/). These fan settings can be accessed through Supermicro IPMI.

## Fan Zones

X9/X10/X11 versions of Supermicro motherboards have two separate fan zones:

- CPU or System fans, labelled with a number (e.g., FAN1, FAN2, etc.) - zone 0
- Peripheral zone fans, labelled with a letter (e.g., FANA, FANB, etc.) - zone 1

## Fan Speed Control

There are a total of four speed control modes for the fans:

- Standard: BMC control of both fan zones, with CPU zone based on CPU temp (target speed 50%) and Peripheral zone based on PCH temp (target speed 50%)
- Optimal: BMC control of the CPU zone (target speed 30%), with Peripheral zone fixed at low speed (fixed ~30%)
- Full: all fans running at 100%
- Heavy IO: BMC control of CPU zone (target speed 50%), Peripheral zone fixed at 75%
