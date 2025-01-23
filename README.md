# Home-Ops

The main goals of this repository are to be a source of truth for my homelab, and to automate as much of it as possible. This project utilizes [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) and [GitOps](https://codefresh.io/learn/gitops/) to simplify provisioning, operating, and updating self-hosted and cloud services in my homelab. The effort put into the various automation flows can make the ease of setup and teardown worth it.

A large goal for my homelab is to be as fully automated as possible while allowing user intervention and control when necessary. However, the process of automation can be complex, and the effort to set up a well thought out automation flow may take more time than its worth in the end.

> **What is a homelab?**
>
> A homelab is a space where individuals can create their own customized computing environments for experimentation, learning, and practical applications.
>
> Homelabs provide enthusiasts, hobbyists, and professionals with a sandbox-like environment to explore new technologies, develop skills, and test solutions without the constraints and limitations of traditional production environments.

---

## Overview

This is a mono respository for my home infrastructure and other self hosted services. The repository is constantly changing and adapting to new technologies being released and updated. Currently, tools such as [Ansible](https://www.ansible.com/), [Terraform](https://www.terraform.io/), and [GitHub Actions](https://github.com/features/actions) are being used to improve the workflow and adhere to IaC and GitOps practices. A list of all additional tools and services being used within this project can be found [here](reference/homelab/services/).

All of the homelab references down below can be found within the [**Reference**](reference/) navigation tab.

---

## Initial Setup

Although this repository is very personalized to my own homelab, it can be used as a generalized template for setting up your own homelab. To begin the initial setup, follow the guides/steps within the [**Setup**](setup/) portion of this documentation. Each section is critical to be able to progress into more advanced topics.
