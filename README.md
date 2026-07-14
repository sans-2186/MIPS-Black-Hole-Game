# Black Hole — MIPS Assembly Board Game

A complete implementation of the **Black Hole** abstract strategy game, written entirely in **MIPS assembly** for the MARS simulator. Built as a term project for **CS 2340 (Computer Architecture)** at The University of Texas at Dallas.

The project focuses on low-level systems programming — manual memory layout, register conventions, modular procedure design, graphics via memory-mapped bitmap I/O, and MIDI via syscalls — without a high-level language runtime.

---

## Overview

Players and a computer opponent each place numbered tiles (1–10) onto a **21-cell triangular board**. After all tiles are placed, a **black hole** occupies the final empty cell. Scores are the sum of each side’s tiles adjacent to the black hole; the **lower score wins**.

The program drives a full game loop: board initialization, shuffled placement, dual display (ASCII + bitmap), scoring, win/lose audio, and optional replay.

---

## Technical Highlights

| Area | What was built |
|------|----------------|
| **Language / platform** | Pure MIPS-32 assembly on [MARS](http://courses.missouristate.edu/kenvollmar/mars/) |
| **Architecture** | Multi-file modular design with `.globl` exports and stack-based calling conventions |
| **Data structures** | Parallel word arrays for board ownership/values; adjacency table for graph-style neighbor lookup |
| **Algorithms** | Fisher–Yates shuffle for randomized tile positions; adjacency-based scoring |
| **Graphics** | Custom 64×64 bitmap renderer (pixel store, colored cells, digit/letter glyphs) |
| **Audio** | MIDI note sequences for intro, in-game melody, win fanfare, and loss sting |
| **I/O** | Syscalls for console I/O, random seeding, sleep delays, and MIDI |

---

## Features

- Player (blue) vs computer (red) on a 6-row triangular board
- Randomized placement via Fisher–Yates shuffle
- Black hole auto-placed on the last open tile
- Dual view: formatted ASCII board in the Run I/O window + live bitmap display
- Score calculation from black-hole neighbors and winner announcement
- Intro / play / win / lose music cues
- Play-again prompt with input validation

---

## Project Structure

```
MIPS-Black-Hole-Game/
├── main.asm        # Entry point, game loop, orchestration
├── board.asm       # Board state, shuffle, adjacency table, tile placement
├── computer.asm    # RNG seed and computer placement messaging
├── display.asm     # ASCII board + 64×64 bitmap drawing / glyphs
├── input.asm       # Welcome screen and replay input
├── scoring.asm     # Adjacent-tile scoring and winner logic
├── music.asm       # MIDI melodies (intro, play, win, lose)
├── SysCalls.asm    # Named syscall constants
├── Project Report.pdf
└── User Manual.pdf
```

---

## How to Run

1. Install [MARS](http://courses.missouristate.edu/kenvollmar/mars/) (Java required).
2. Open **all** `.asm` files in the project (or assemble from `main.asm` with settings that assemble all files in the directory).
3. Configure the **Bitmap Display** tool:
   - Base address: address of `bitmap_data` (see `display.asm`)
   - Unit width/height: **4** (or as documented in the User Manual)
   - Display width/height: **256** (for a 64×64 pixel buffer at 4× scaling)
4. Open **Tools → Music / MIDI** if you want audio.
5. Assemble and run `main.asm`.

See **User Manual.pdf** for exact tool settings and screenshots.

---

## Skills Demonstrated

- MIPS instruction set, registers, and procedure linkage
- Manual stack frame management (`$ra`, callee-saved registers)
- Modular assembly design across multiple source files
- Memory-mapped graphics and pixel-level rendering
- Event-driven game loop with timing (`syscall` sleep)
- Deterministic data tables (adjacency graph, glyph bit patterns)

---

## Resume Bullet (suggested)

> Implemented a full Black Hole board game in MIPS assembly (~2K LOC across 7 modules), including Fisher–Yates shuffle, adjacency-based scoring, a custom 64×64 bitmap renderer, and MIDI audio — demonstrating systems-level programming without a high-level runtime.

---

## Author

**Sanskriti Tiwari** — CS 2340 Term Project, UTD (Spring 2026)

---

## License

Academic coursework project. Source is provided for portfolio review.
