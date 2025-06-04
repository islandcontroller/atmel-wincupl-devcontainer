# WinCUPL devcontainer demo project

### Usage

1. Open the `demo.pld` CUPL source file.
2. Launch the default build task with `Ctrl+Shift+B`

### Viewing documentation

Use the VSCode PDF preview plugin to browse the documentation included with WinCUPL.

```sh
code $WINEPREFIX/drive_c/Wincupl/WinCupl/AtmelHlp
```

### Customizing the build task

Check out the [tlgkccampbell/code-cupl](https://github.com/tlgkccampbell/code-cupl) repo for more information about how to configure the build task. Or check the cupl built-in command line help!

```
vscode ➜ ~ $ cupl
Usage: cupl -flags <library.dl> <device> file
       Where: flags
       Download file formats
-j   JEDEC output (jedec compatible programming file)
-h   ASCII-hex output (PROM ASCII hex download file)
-i   HL output (Signetics IFL devices only)
-n   download filename=PLD filename
       Output file formats
-a   absolute file (required for simulation)
-l   listing file (generate error listing file)
-e   expanded macro definition file (macros and REPEAT statements)
-x   expanded product terms (generate documentation file)
-f   fuse plot/chip diagram (attach fuse plot in documentation file)
-b   Berkeley PLA file (generate a Berkeley PLA file for fitters)
-o   One-hot-bit state machine (use one-hot bit encoding for state machines)
-d   Deactivate unused OR terms (remove unused product terms in IFL devices)
-r   Disable product term merging (identical p-term generation in IFL devices)
-g   Program security fuse (blow security fuse after programming if supported)
-u   Use specified library, must immediatley preceed library name (override library specified in the environment)
-s   Simulate after compile (simulate after successful compilation)
       Optimization methods
-kb  Optimize product term usage (overrides the DEMORGAN statement in file)
-kd  Demorganize all pins and pinnodes (overrides the DEMORGAN statement)
-ks  Force product term sharing (enable group reduction)
-kx  Do not exapnd XOR equations (virtual or fitter that supports XOR gates)
       Minimization Method
-m0  No minimization (no logic reduction)
-m1  Quick minimization (default. Lowest memory usage and fastest)
-m2  Quine-McCluskey minimization (highest memory usage and slowest.)
-m3  Presto minimization (good trade-off between memory and speed)
-m4  Espresso mimization (high memory usage and slow. Good for fitter designs)
```