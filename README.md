# libi86

[![(Travis CI build status)](https://travis-ci.org/tkchia/libi86.svg?branch=master)](https://travis-ci.org/tkchia/libi86) · [![(GitLab pipeline status)](https://gitlab.com/tkchia/libi86/badges/master/pipeline.svg)](https://gitlab.com/tkchia/libi86/-/commits/master)

An attempt to reimplement non-standard C library facilities (e.g. `<conio.h>`) commonly used in classical MS-DOS programs, for use with a [GCC toolchain for 16-bit x86](https://github.com/tkchia/build-ia16/).

The current aim is to be compatible enough with the [Open Watcom](https://github.com/open-watcom/open-watcom-v2/) runtime — as described in the [_Open Watcom C Library Reference_](https://github.com/open-watcom/open-watcom-v2-wikidocs/blob/master/docs/clib.pdf) — to be useful for building existing MS-DOS code.

Defining the macro `_BORLANDC_SOURCE` will also enable some degree of compatibility with the [Borland Turbo C++](http://cc.embarcadero.com/Item/25636) compiler's C library.

## Synopsis

#### Use

`ia16-elf-gcc` [..._gcc-options_...] `-li86` [...]

#### Installing from pre-compiled Ubuntu Linux packages, for cross development

Grab the `gcc-ia16-elf` and `libi86-ia16-elf` packages from [my `build-ia16` PPA](https://launchpad.net/~tkchia/+archive/ubuntu/build-ia16/).

#### Building and installing from sources, on Linux

 1. &nbsp;`git clone https://gitlab.com/tkchia/libi86.git`

 2. &nbsp;Install `gcc-ia16-elf`.

 3. &nbsp;`(cd libi86 && ./autogen.sh)`

 4. &nbsp;`mkdir build-libi86`

 5. &nbsp;`cd build-libi86`

 6. &nbsp;`../libi86/configure --prefix=`_install-path_

 7. &nbsp;`make`

 8. &nbsp;`make check`

 9. &nbsp;`make install`

## License

`libi86` is distributed under the [GNU Lesser General Public License version 3](COPYING3.LIB) or above.

In addition, the test setup and test cases (under [`tests/`](tests/)) are distributed under the [GNU LGPL version 2](COPYING2.LIB) or above.

## Implemented functions

Legend:

  * <sup>[BC]</sup> from Borland Turbo C++ — enable with `_BORLANDC_SOURCE`
  * <sup>[X]</sup> `libi86`-specific extension; not in Open Watcom or Borland C++

### `<bios.h>`

  * `_bios_disk (`_service_`,` \*_diskinfo_`);`
    - as an extension, also accepts _service_ = `_DISK_DRIVEPARAMS`, which returns drive parameters in \*_diskinfo_
  * `_bios_equiplist ();`
  * `_bios_memsize ();`
  * `_bios_keybrd (`_service_`);`
  * `_bios_timeofday (`_service_`,` \*_timeval_`);`
  * <sup>[X]</sup> `_bios_joystick (`_service_`,` \*_joyinfo_`);`
    - reads joystick status via `int 0x15` function `0x84`

### `<conio.h>`

  * \*`cgets (`\*_buf_`);`
  * `cprintf (`\*_fmt_`, ...);`
  * `cputs (`\*_buf_`);`
  * `cscanf (`\*_fmt_`, ...);`
  * `_getch ();`
  * `_getche ();`
  * `_kbhit ();`
  * `_ungetch (`_ch_`);`
  * `putch (`_ch_`);`
  * `vcprintf (`\*_fmt_`,` _ap_`);`
  * `vcscanf (`\*_fmt_`,` _ap_`);`
  * `inp (`_port_`);`
    - also `_inp`, <sup>[BC]</sup> `inportb`
  * `inpw (`_port_`);`
    - also `_inpw`, <sup>[BC]</sup> `inportw`
  * `outp (`_port_`,` _value_`);`
    - also `_outp`, <sup>[BC]</sup> `outportb`
  * `outpw (`_port_`,` _value_`);`
    - also `_outpw`, <sup>[BC]</sup> `outportw`

### `<dos.h>`

  * `bdos (`_dos-func_`,` _dx_`,` _al_`);`
  * `bdosptr (`_dos-func_`,` \*_dx_`,` _al_`);`
  * `intdos (`\*_in-regs_`,` \*_out-regs_`);`
  * `intdosx (`\*_in-regs_`,` \*_out-regs_`,` \*_seg-regs_`);`
  * `_dos_allocmem (`_size_`,` \*_segment_`);`
  * `_dos_close (`_handle_`);`
  * `_dos_freemem (`_segment_`);`
  * `_dos_getdrive (`\*_drive_`);`
  * `_dos_getfileattr (`\*_path_`,` \*_attributes_`);`
  * `_dos_setfileattr (`\*_path_`,` _attributes_`);`
  * `_getdrive ();`
  * `<dos.h>` also includes `<i86.h>`

### `<graph.h>`

  * `_setvideomode (`_mode_`)`
    - does not work with DPMI
    - in the case of SuperVGA screen modes, only works with VESA interface

### `<i86.h>`

  * `delay (`_ms_`);`
  * `nosound ();`
  * `sound (`_freq_`);`
  * `segread (`\*_seg-regs_`);`
  * `_disable ();`
  * `_enable ();`
  * `int86 (`_inter-no_`,` \*_in-regs_`,` \*_out-regs_`);`
  * `int86x (`_inter-no_`,` \*_in-regs_`,` \*_out-regs_`,` \*_seg-regs_`);`
  * `intr (`_inter-no_`,` \*_regs_`);`
  * <sup>[X]</sup> `_int86f (`_inter-no_`,` \*_in-regs_`,` \*_out-regs_`);`
    - loads `SZAPC` flags before issuing interrupt
  * <sup>[X]</sup> `_int86xf (`_inter-no_`,` \*_in-regs_`,` \*_out-regs_`,` \*_seg-regs_`);`
    - loads `SZAPC` flags before issuing interrupt
  * <sup>[X]</sup> `_intrf (`_inter-no_`,` \*_regs_`);`
    - loads `SZAPC` flags before issuing interrupt
  * `FP_OFF (`\*_ptr_`);`
    - macro; also `_FP_OFF`
  * `FP_SEG (`\*_ptr_`);`
    - macro; also `_FP_SEG`
  * `MK_FP (`_seg_`,` _off_`);`
    - macro; also `_MK_FP`

### `<libi86/string.h>`

  * \*`_fmemcpy (`\*_dest_`,` \*_src_`,` _n_`);`
  * \*`_fmemmove (`\*_dest_`,` \*_src_`,` _n_`);`

## Implemented variables

### `<libi86/stdlib.h>`

  * `_osmajor` `_osminor` `_psp`
