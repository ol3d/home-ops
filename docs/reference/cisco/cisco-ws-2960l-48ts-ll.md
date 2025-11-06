# Cisco WS-2960L-48TS-LL

When working in proxmox, I ran into a few issues attempting to re-initialize my ceph network. The issue was caused by a misconfiguration involving [Jumbo Frames](https://en.wikipedia.org/wiki/Jumbo_frame). Since the network interfaces that are set up for the proxmox ceph cluster are using an MTU of 9000, this means that the interfaces on the networking switch also needed to be updated to the same value.

> ## [Catalyst 2970/2960 Series](https://www.cisco.com/c/en/us/support/docs/switches/catalyst-6000-series-switches/24048-148.html)
>
> You cannot set the MTU size for an individual interface; you set it for all 10/100 or all Gigabit Ethernet interfaces on the switch. When you change the system or jumbo MTU size, you must reset the switch before the new configuration takes effect.

This means that ALL of the interfaces are switched to jumbo frames due to the nature of the switch structure and Cisco IOS software implementation. Additionally this was not able to be set within the ansible playbook due to differences between switches. Instead the setting needs to be done manually.

Follow the official [Cisco Instructions](https://www.cisco.com/c/en/us/td/docs/switches/lan/catalyst2960l/software/15-2_5_e/config-guide/b_1525e_consolidated_2960l_cg/b_1525e_consolidated_2960l_cg_chapter_0110.html) to set the system MTU to the correct value _(As of 2024/04/14)_.

To test that jumbo frames are working, ping using this command:

```yaml
ping IP_ADDRESS -M do -s 8972
```

Additionally, Cisco C2960L and C2960LP do not support native vlans on trunk interfaces (Native VLAN is always default VLAN 1).
