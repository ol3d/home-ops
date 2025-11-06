# Supermicro X11SCL-iF

When building a computer or server, it is usually fairly straight forward without many issues along the way. However, sometimes you run into little problems that are difficult to debug. This material is meant to be a reference of issues encountered with my Supermicro X11SCL-iF motherboard currently being used in my NAS _(As of 04-03-2024)_.

---

## Official Resources

All resources are from Supermicro's official site. All links and current data are accurate to this reference as of 04-03-2024.

- [X11SCL-iF Product Page](https://www.supermicro.com/en/products/motherboard/x11scl-if)
- [X11SCL-iF Manual](https://www.supermicro.com/manuals/motherboard/X11/MNL-2088.pdf)

---

## Issues

Many of the components that I purchase in my homelab are used, including this Supermicro X11SCL-iF motherboard. This makes things a little more complicated since the devices may have been modified either physically or by way of software.

<!-- TODO This was fixed by using the 3.3v header instead on pin 15 -->
<!--
### Front Panel Connector

The [front panel connector](https://www.supermicro.com/manuals/motherboard/X11/MNL-2088.pdf#p36) of my Supermicro X11SCL-iF motherboard did not have any power LED indicator working. To debug the issue, I attempted multiple differrent headers to see if any worked first of all. Since other headers worked, I determined that either the port was damaged or turned off somehow. To test, I used my multimeter to determine whether any voltage was going through the jumper; there was no voltage.

I looked online onto forums to see whether there was a setting within the BIOS or IPMI that could turn the headers off. No information was found related to software so I decided to take a look into the motherboard manual for any jumpers. Sure enough there was a jumper referenced, JLED1 Header, which controls the onboard power LED. The header reference can be found in the [Headers](https://www.supermicro.com/manuals/motherboard/X11/MNL-2088.pdf#p43) section of the X11SCL-iF motherboard manual on page 48. -->
