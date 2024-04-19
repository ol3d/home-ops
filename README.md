# Home-Ops

The goal of this repository is to be a source of truth for my homelab, and to automate as much of my homelab as possible. This project utilizes [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) and [GitOps](https://codefresh.io/learn/gitops/) to simplify provisioning, operating, and updating self-hosted and cloud services in my homelab. The effort put into the various automation flows makes the ease of teardown and setup worth it.

A large goal for my homelab is to be as fully automated as possible while allowing user intervention and control when necessary. However, the process of automation is complex and the effort to set up a well thought out automation flow may take more time than its worth in the end.

> **What is a homelab?**
>
> A homelab is a space where individuals can create their own customized computing environments for experimentation, learning, and practical applications.
>
> Homelabs provide enthusiasts, hobbyists, and professionals with a sandbox-like environment to explore new technologies, develop skills, and test solutions without the constraints and limitations of traditional production environments.

---

## Overview

This is a mono respository for my home infrastructure and other self hosted services. The repository is constantly changing and adapting to new technologies being released and updated. Currently, tools such as [Ansible](https://www.ansible.com/), [Terraform](https://www.terraform.io/), and [GitHub Actions](https://github.com/features/actions) are being used to improve the workflow and adhere to IaC and GitOps practices. A list of all tools and services being used within this project can be found [here](TODO link here).

---

### Network

My homelab network is divided into different VLANS to separate certain devices from one another. This is mainly used for security purposes but can sometimes be for convenience as well.

![Network Setup](src/assets/network/homelab_v2024-02-13.png)

---

### Hardware

This is a list of all of my current homelab hardware. This includes hardware mounted inside of my server rack, but also external hardware such as wireless access points, essential home assistant devices, etc.

| Device                      | Count | OS Disk Size | Data Disk Size               | Ram  | Operating System | Purpose               |
|-----------------------------|-------|--------------|------------------------------|------|------------------|-----------------------|
| Intel NUC8i7BEH             | 3     | 128GB SSD    | 1TB NVMe (rook-ceph)         | 64GB | Debian (Proxmox) | Proxmox Cluster Nodes |
| Intel NUC7i5BNK             | 1     | 128GB SSD    | 128TB NVMe                   | 16GB | Debian           | Management Node       |
| Cisco WS-2960L-24PS-LL      | 1     | -            | -                            | -    | -                | PoE Access Switch     |
| Cisco WS-2960L-48TS-LL      | 1     | -            | -                            | -    | -                | Control Switch        |

---

### Cloud Services

Along with my free self-hosted services, I also utilize cloud services or need specific licencing to use certain product. Due to this, here is a list of all of the free as well as paid cloud products/services that I am currently using in my homelab.

| Service                                                 | Use                                                            | Cost           |
|---------------------------------------------------------|----------------------------------------------------------------|----------------|
| [Duplicacy](https://duplicacy.com/)                     | Personal License for Cloud Storage Backup Solution             | ~$20/yr        |
| [GitHub](https://github.com/)                           | Hosting this repository and continuous integration/deployments | ~$50/yr        |
| [Tdarr](https://home.tdarr.io/)                         | Video file transcoding and optimization                        | Free           |
| [Backblaze B2](https://www.backblaze.com/cloud-storage) | Cloud Storage and Backups                                      | ~$15/mo        |
| [Cloudflare](https://www.cloudflare.com/)               | Domain Registrar and DNS Management                            | Free           |
| [Mailgun](https://www.mailgun.com/)                     |                                                                | Free           |
| [AntiCaptcha](https://anti-captcha.com/)                |                                                                |                |
| [ProtonMail](https://proton.me/mail)                    | Torrenting Mail Client                                         | Free           |
| [Trello](https://trello.com/)                           | Project Task Management and Tracking                           | Free           |
|                                                         |                                                                | Total: ~$20/mo |

---

## Initial Setup

---
