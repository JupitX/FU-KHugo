# FuckHugo & FuckHugo-NG — Advanced Malware Research Project

> ⚠️ **LEGAL DISCLAIMER — READ BEFORE CONTINUING**
>
> This project was developed **strictly for educational and personal research purposes**.
> All development and testing was conducted exclusively in **isolated, offline lab environments**
> with no connection to external networks or third-party systems.
>
> **This code has never been and will never be used to attack, infect, or compromise
> any system without full explicit consent of its owner.**
>
> Downloading, running, or distributing this software against systems you do not own
> or have explicit written permission to test is **illegal** in most jurisdictions,
> including but not limited to the Computer Fraud and Abuse Act (CFAA, USA),
> the Computer Misuse Act (UK), and equivalent legislation worldwide.
>
> The author holds no responsibility whatsoever for any misuse, damage, or legal
> consequences derived from this project. **You are solely responsible for your actions.**
>
> This repository is published in the spirit of **offensive security research,
> transparency, and education** — consistent with the practices of the cybersecurity
> community and responsible disclosure principles.
>
> **If you are not a security researcher or cybersecurity professional,
> close this page now.**

---

## 🚧 Project Status: ON HOLD

This project is currently on hold due to a data loss incident involving
a disk failure. Recovery of the original files is in progress.

---

## The Story

It all started with a friend named Hugo.

Whenever he came over, I'd let him use my PC while I stepped out. Simple enough.
The problem? Hugo had a habit — every single time, he'd change my keyboard layout,
wallpaper, system sounds, display settings... everything. Every. Single. Time.

One day I got fed up. So I decided to hit back.

### FuckHugo — The Original
The first version was born as pure revenge. Beyond the chaos Hugo inflicted on
my system, I went further — implementing the visual mayhem inspired by the MEMZ
virus, combined with a custom MBR overwrite that replaced the boot screen with
an image of my choosing, permanently breaking the boot process.

The infection vector? A **USB Rubber Ducky** — plug it in, game over.

Hugo didn't touch my PC again after that.

### FuckHugo-NG — The Research Project
FuckHugo worked. But it had a critical flaw: it was detectable by antivirus software.
That bothered me. So I went deep — weeks of research into how modern AVs work,
how malware evades detection, and how APTs operate in the wild.

That research led to FuckHugo-NG.

What started as a prank evolved into a full-scale malware research project —
a modular, all-in-one APT simulation framework that carries everything FuckHugo
did, and takes it to a completely different level. Designed to evade modern
antivirus detection by mimicking legitimate network traffic, leaving no trace,
and maintaining full control over the infected system.

Same infection vector: **USB Rubber Ducky**.

---

## What They Do

### FuckHugo
**Languages:** PowerShell · Python

| Module | Description |
|---|---|
| **System chaos** | Keyboard layout, wallpaper, sounds, settings — all destroyed |
| **MEMZ-inspired payload** | Progressive visual corruption of the system |
| **MBR Overwrite** | Custom boot screen, rendering the system unbootable |

### FuckHugo-NG
**Language:** C++

| Module | Description |
|---|---|
| **Everything FuckHugo does** | Full system chaos, MEMZ payload, MBR overwrite |
| **C2 Framework** | Custom command and control infrastructure |
| **Rootkit** | Deep system persistence, hidden from OS and AV |
| **Ransomware** | File encryption with custom ransom logic |
| **Keylogger** | Silent keystroke capture and exfiltration |
| **Spyware** | Screen capture, clipboard monitoring, credential harvesting |
| **Worm** | Self-replication across network shares and removable drives |
| **Botnet** | Infection and remote management of multiple nodes |
| **Privilege Escalation** | UAC bypass and local privilege escalation techniques |
| **AV Evasion** | Mimics legitimate traffic, no anomalous signatures detected |

---

## What I Learned

This project taught me more about offensive security than any course or
certification ever could:

- How antivirus engines detect malware signatures and heuristics
- How APTs mimic legitimate traffic to avoid detection
- How rootkits achieve persistence at the kernel level
- How C2 infrastructure is designed and operated
- How to develop in C++ for low-level Windows internals
- The real-world gap between basic malware and a professional APT

---

## ⚠️ Final Warning

This is a **real, functional, and highly capable** piece of offensive software.
It was built by a cybersecurity professional for research purposes only.

**Do not use this for anything other than research in controlled environments.**
The author is not responsible for what you do with this information.

---

## Author

**Jefrey Hernandez** — Junior Information Security Engineer
[LinkedIn](https://www.linkedin.com/in/jefrey-hernandez) · [HackTheBox](https://app.hackthebox.com/users/1151098)
