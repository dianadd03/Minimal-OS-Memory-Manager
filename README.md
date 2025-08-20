# Computer Systems Architecture – Assignment

This project implements a minimal **storage management module** for a simplified operating system, written in **x86 Assembly**.  
It is based on the lab assignment for the _Computer Systems Architecture_ course (University of Bucharest, 2024–2025).

---

## 📌 Project Description

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

---

## 📂 Project Structure

```
📁 project-root
 ┣ 📄 0.s   # Assembly implementation for Requirement 0x00 (1D memory)
 ┣ 📄 1.s   # Assembly implementation for Requirement 0x01 (2D memory)
 ┣ 📄 README.md
 ┣ 📄 input.txt   # Example input file for testing
 ┗ 📄 output.txt  # Example output file (optional)
```

---

## ▶️ Running the Project

1. Assemble and link your code (using NASM + LD):  
   ```bash
   nasm -f elf32 0.s -o 0.o
   ld -m elf_i386 0.o -o task00
   nasm -f elf32 1.s -o 1.o
   ld -m elf_i386 1.o -o task01
   ```

2. Run with redirected input file:  
   ```bash
   ./task00 < input.txt
   ./task01 < input.txt
   ```

3. Expected output will describe file allocations, deletions, and defragmentations.  

---

## 📑 Input Format

- First line: number of operations **O**  
- Each operation encoded as:  
  - `1` – ADD (followed by N, then N pairs of `<descriptor> <size>`)  
  - `2` – GET (followed by `<descriptor>`)  
  - `3` – DELETE (followed by `<descriptor>`)  
  - `4` – DEFRAGMENTATION  
  - `5` – CONCRETE (two-dimensional only; followed by an absolute folder path)  

---

## 📝 Example

**Input:**  
```
4
1
2
5
20
143
14
2
143
3
5
4
```

**Output:**  
```
5: (0, 2)
143: (3, 4)
(3, 4)
0, 0, 0, 143, 143, 0, ...
143: (0, 1)
```

---

## 🎯 Grading Criteria

- Requirement 0x00 (1D memory) → **50 pts**  
- Requirement 0x01 (2D memory) → **50 pts**  
