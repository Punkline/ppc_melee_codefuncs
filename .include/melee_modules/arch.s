.ifndef melee.library.included; .include "melee"; .endif
melee.module arch

.if module.included == 0
  punkpc str, stack, align

  items.method arch.__params
  # create a new items pseudo-object to store list of param names ...

  .irp param, arch.symbols, arch.relocs, arch.refs, arch.__id, arch.__inst; \param = 0; .endr
  # - these will store a state of the block context using various symbols ...

  stack arch.__mem
  # .__mem will store state memory in a stack, for pushing/popping nested archives



  .macro arch.start, tag=0x30303142, pad1=0, pad2=0
    arch.__mem.push arch.symbols, arch.relocs, arch.refs, arch.__id
    # push params to memory ...

    align 5;
    arch.__inst = arch.__inst + 1
    arch.__id = arch.__inst
    # new ID for this archive instance

    sidx.noalt "<arch.__start>", arch.__id, "< = .>"
    # set new start label

    .irp param, arch.symbols, arch.relocs, arch.refs, arch.__id, arch.__inst; \param = 0; .endr
    # set all params back to null for current state ...

    .irp param, total_size, data_size, rt_size, st_size, ref_size
      sidx.noalt "<.long arch.__\param>", arch.__id
      # promise to resolve errata for .long once these uniquely indexed names are calculated

    .endr; .long \tag, \pad1, \pad2
    # finish header using args, or default args if none were provided

    sidx.noalt "<arch.__data_start>", arch.__id, "< = .>"
    # set new data start label, following the header

    sidx.noalt3 "<stack arch.__symbols>", arch.__id, /*
    */ "<, arch.__relocs>", arch.__id,  /*
    */ "<, arch.__refs>", arch.__id
    sidx.noalt "<arch.symbols = arch.__symbols>", arch.__id, ".is_stack"
    sidx.noalt "<arch.relocs = arch.__relocs>", arch.__id, ".is_stack"
    sidx.noalt "<arch.refs = arch.__refs>", arch.__id, ".is_stack"
    # stack pointers unique to this archive block have been copied to the current state params
    # - these will now be used when referencing the symbol/reloc stacks
    # - these are backed up with state memory when making nested archives

    # all state parameters have been initialized...
    # - use arch.symbol, arch.reloc, and/or arch.point to construct archive contents
    # - finish archive with arch.end


  .endm; .macro arch.symbol, name:vararg
    sidx.noalt3 "<arch.__symbol arch.__symbols>", arch.__id, /*
    */ "<, arch.__symbols>", arch.__id, "", arch.st_size, "<, >", \name
    # convert indexed stack and string names into copyable literals ...

  .endm; .macro arch.__symbol, stack, str, name:vararg
    arch.st_size = arch.st_size + 1
    str \str, \name
    \stack\().push \str\().is_str
    # push symbol stack

    \str\().addr = .-arch.__data_start
    # record current location to this str object as an extended attribute

  .endm; .macro arch.ref, value;
    arch.ref_size = arch.ref_size + 1
    stack.push arch.refs, \value
    # value is stacked for references

  .endm; .macro arch.reloc, loc="."
    arch.rt_size = arch.rt_size + 1
    stack.push arch.relocs, \loc-arch.__data_start
    .noaltmacro
    # location is stacked for relocation table entry

  .endm; .macro arch.point, dest
    arch.reloc; .long \dest-arch.__data_start
    # creates a pointer to destination (and marks it for relocation)

  .endm; .macro arch.end
    .noaltmacro
    align 2
    arch.__rt_start = .
    # start of relocation table ...

    sidx.noalt "<arch.__data_size>", arch.__id, "< = .-arch.__data_start>"
    # finalize size of data section, to resolve header errata

    sidx.noalt "<arch.__rt_size>", arch.__id, "< = arch.rt_size>"
    sidx.noalt "<arch.__st_size>", arch.__id, "< = arch.st_size>"
    sidx.noalt "<arch.__ref_size>", arch.__id, "< = arch.ref_size>"
    # finalize other header params

    stack.rept arch.relocs, .long
    # emit relocation table...

    stack.rept arch.refs, .long

        arch.__st_start = .
    # start symbol table ...

    stack.rept arch.symbols, arch.__symbols_end
    # handle generation of symbol string position errata in symbols table

    arch.__symbols_start = .
    # start of symbol strings ...

    stack.rept_range arch.symbols, 0, arch.st_size arch.__symbol_string
    # handle generation of symbol string generation, to resolve errata for string start refs

    .noaltmacro
    align 5

    sidx.noalt2 "<arch.__total_size>", arch.__id, "<= .-arch.__start>", arch.__id
    # resolve final piece of errata by calculating total file size ...

    arch.__mem.popm arch.__sym_start, arch.__ref_start, arch.__st_start, arch.__rt_start, /*
    */ arch.__data_start, arch.__start, arch.__id, arch.refs, arch.relocs, arch.symbols, /*
    */ arch.pad2, arch.pad1, arch.tag, arch.ref_size, arch.st_size, arch.rt_size, /*
    */ arch.data_size, arch.total_size
    # recover state memory

  .endm; .macro arch.__symbols_end, sym; .long \sym\().addr, \sym\().str
  .endm; .macro arch.__symbol_string, sym
    \sym\().str = .-arch.__symbols_start
    # resolve symbol string ref errata by pointing to current location

    str.str \sym, .asciz
    # ... and finally, emit the string given to symbol string definition
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
