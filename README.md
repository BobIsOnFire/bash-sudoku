# Bash Sudoku

TUI, authentic, not complete. Bash Sudoku.

Brief history: This was one of my hometasks in ITMO University, the first semester that I came in. We were learning how to work with Unix systems, so I had to write this... thing. After ~3 years, I decided to finish it and make it look at least nice. So here we are!

# Getting Started

Prerequisites:
- Git (lol)
- GNU make
- GNU coreutils (check if you have `shuf` and `tput` installed)

To build a project, run:

```sh
$ make
```

`play-sudoku` binary should appear. `./play-sudoku` should be enough to start the game!

You can also install `play-sudoku` into your system:

```sh
$ sudo make install PREFIX=...
```

`PREFIX=...` is optional, default is `/usr/local/bin`.

# How to play

The objective is to fill a 9×9 grid with digits so that each column, each row, and each of the nine 3×3 subgrids that compose the grid (also called "boxes", "blocks", or "regions") contains all of the digits from 1 to 9 (stolen from [Wikipedia](https://en.wikipedia.org/wiki/Sudoku))

## Controls

Check `./play-sudoku --help` or press `H` in-game for up-to-date controls information!

# Contributing

There are a bunch of TODOs lying here and there, you can help with them. Feel free to add your own changes if you want.

# License

The code in this repository is licensed under the [MIT License](LICENSE).

