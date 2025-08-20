# Computer Systems Architecture – Assignment

This project implements a minimal **storage management module** for a simplified operating system, written in **x86 Assembly**.  

---

## Project Description

The goal is to simulate how an operating system manages a **storage device** (HDD/SSD) using simplified models:

- **One-dimensional memory model**
  - Memory size: 8 MB, split into 8 kB blocks.
  - Files must occupy contiguous blocks.
  - Operations supported:
    - `ADD` – Add a file (descriptor + size).
    - `GET` – Retrieve where a file is stored.
    - `DELETE` – Remove a file from memory.
    - `DEFRAGMENT` – Compact files to eliminate gaps.

- **Two-dimensional memory model**
  - Memory size: 8 MB × 8 MB (matrix).
  - Contiguity is row-based.
  - Supports the same operations as above, plus:
    - `CONCRETE` – Import real files from a folder and store them in memory.
