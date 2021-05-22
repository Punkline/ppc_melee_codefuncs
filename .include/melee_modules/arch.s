.ifndef melee.library.included; .include "melee"; .endif
melee.module arch

.if module.included == 0
  punkpc items, stack, align

  items.method arch.__params
  # create a new items pseudo-object to store list of param names ...

  .irp param, arch.symbols, arch.relocs, arch.refs, arch.__id, arch.__inst; \param = 0; .endr
  # - these will store a state of the block context using various symbols ...

  stack arch.__mem
  # .__mem will store state memory in a stack, for pushing/popping nested archives

  .macro arch.__id, macro, va:vararg; sidx.noalt "<\macro _>", arch.__id, ", ", \va
  # wrapper for sidx (scalar indexing macro) passes state ID to methods, for use in namespaces

  .endm; .macro arch.start, va:vararg;
    arch.__mem.push arch.symbols, arch.relocs, arch.refs, arch.__id
    # push params to memory ...

    align 5;
    arch.__inst = arch.__inst + 1
    arch.__id = arch.__inst
    # new ID for this archive instance

    arch.__id arch.__start, \va
    # continue with literal ID (as decimal string)

  .endm; .macro arch.reloc, va:vararg; arch.__id arch.__reloc, \va
  .endm; .macro arch.point, va:vararg; arch.__id arch.__point, \va
  .endm; .macro arch.symbol, va:vararg; arch.__id arch.__symbol, \va
  .endm; .macro arch.end, va:vararg; arch.__id arch.__end, \va
  # - these wrappers will pass the current state ID to each method
  #   - this makes it easier to create unique labels for resolving errata correctly

  .endm; .macro arch.__start, id, tag=0x30303142, pad1=0, pad2=0
    arch.__start\id = .
    # new start label ...

    .irp x, _size\id
      .irp param, total\x, data\x, rt\x, st\x, ref\x
        .long arch.__\param
        # promise to resolve errata for .long once these uniquely indexed names are calculated

    .endr; .endr; .long \tag, \pad1, \pad2
    # finish header using args, or default args if none were provided

    arch.__data_start\id = .
    # set new data start label, following the header

    items.method arch.__strings\id
    stack arch.__relocs\id, arch.__symbols\id, arch.__refs\id
    # all state parameters have been initialized...
    # - use arch.symbol, arch.reloc, and/or arch.point to construct archive contents
    # - finish archive with arch.end

  .endm; .macro arch.__symbol, id, name
    arch.__strings\id, "\name"
    arch.__symbols\id\().push .-arch.__data_start\id
    # record current location to this str object as an extended attribute

  .endm; .macro arch.__reloc, id, loc="."
    arch.__relocs\id\().push \loc-arch.__data_start\id
    # location is stacked for relocation table entry

  .endm; .macro arch.__point, id, dest
    arch.__reloc \id
    .long \dest-arch.__data_start\id
    # creates a pointer to destination (and marks it for relocation)

  .endm; .macro arch.__end, id
    align 2
    arch.__rt_start\id = .
    # start of relocation table ...

    arch.__data_size\id = .-arch.__data_start\id
    arch.__rt_size\id = arch.__relocs\id\().s
    arch.__st_size\id = arch.__symbols\id\().s
    arch.__ref_size\id = arch.__refs\id\().s
    # finalize size of data section, to resolve header errata

    stack.rept arch.__relocs\id, .long
    # emit relocation table...
    # - refs are currently unsupported, but planned

    arch.__st_start\id = .
    # start symbol table ...

    arch.__strings\id arch.__symbols_loop
    # handle generation of symbols table and symbol strings ...

    align 5
    arch.__total_size\id = .-arch.__start\id
    # resolve final piece of errata by calculating total file size ...

    arch.__mem.push arch.symbols, arch.relocs, arch.refs, arch.__id
    # push params to memory ...

    arch.__mem.popm arch.__id, arch.refs, arch.relocs, arch.symbols
    # recover state memory

  .endm; .macro arch.__symbols_loop, va:vararg; arch.__id arch.___symbols_loop, \va
  .endm; .macro arch.___symbols_loop, id, va:vararg
    .irp str, \va
      .ifnb \str
        arch.__q = arch.__symbols\id\().q
        arch.__symbols\id\().deq arch.__sym
        sidx.noalt "<.long arch.__sym, arch.__sym\id>", arch.__q
        # create new errata for symbol start labels ...

      .endif
    .endr; arch.__q = 0; .irp str, \va
      .ifnb \str
        sidx.noalt "<arch.__sym\id>", arch.__q, " = ."
        .asciz "\str"
        arch.__q = arch.__q + 1
      .endif
    .endr
  .endm
.endif

arch.start
0:
.long 1, 2, 3, 4
1:
arch.symbol "sym1"

arch.point 0b
arch.point 2f
.long 5, 6, 7, 8
2:
arch.symbol "sym2"

  arch.start
  _test:
  .long 99, 98, 97, 96
  arch.symbol "sym3"
  arch.point _test
  arch.end

arch.point 1b

arch.end
