.ifndef melee.library.included; .include "melee"; .endif
melee.module mem
.if module.included == 0
punkpc enum

r13.xOSArenaLo=-0x5a90
# This points to the current top of the ArenaLo stack (ascends from the bottom of RAM, upwards)
# - Arena begins where static data ends -- usually at 0x804EEC00 (following runtime stack)

r13.xOSArenaHi=-0x4330
# This points to the current top of the ArenaHigh stack (descends from top of RAM, downwards)


MemDef.addr= 0x803ba380
enum.enum_conc "MemDef.",, (0), +4, xID,xBehavior,xPrevID,xSize, size
# These are defined statically in the DOL

MemGlob.addr= 0x80431f90
enum.enum_conc "MemGlob.",, (0), +4, xIDMax,xStart,xCB, xSRAMLo,xSRAMHi, xDRAMLo,xDRAMHi, size
# These are updated globally, as a header to the MemDesc struct array
# - adding '.size' to this base address will convert it into the base of 'MemDesc.'

MemDesc.addr= 0x80431fb0
enum.enum_conc "MemDesc.",, (0), +4, xHeapID,xCache,xStart,xSize,xBehavior,xInit,xDisabled, size
# An array of 'Desc' structs define dynamic memory regions used by the HSD scene system

r13.xOSHeapDescs=-0x4340
enum.enum_conc "HeapDesc.",, (0), +4, xTotal,xFree,xAlloc, size
# OSHeaps provide dynamically free-able memory, and is used by HSD for scene-persistent allocs

enum.enum_conc "HeapMeta.",, (0), +4, xPrev,xNext,xSize, size
enum.enum_conc "CacheDesc.",, (0), +4, xNext,xLow,xHigh,xAlloc, size
enum.enum_conc "CacheMeta.",, (0), +4, xNext,xAlloc,xSize, size
# (these structs can be navigated to from the above global structs)




# --- RETURNS for <mem.alloc>, <mem.allocz>
# args: r3=rSize
# args: r3=rID, rSize  (alternative syntax)
enum.enum_conc "mem.alloc.",, (r3), +1, rAlloc, rMeta, rAligned, rSize, rID
enum.enum_conc "mem.alloc.",, (cr1.lt), +1, bIsAvailable, bIsARAM, bIsHeap


# --- RETURNS for <mem.ID>
# args: r3=rID
enum.enum_conc "mem.ID.",, (r3), +1, rID, rMem, rHeap, rCache, rStart, rSize, rDef, rDefSize
enum.enum_conc "mem.ID.",, (cr1.lt), +1, bIsAvailable, bIsARAM, bIsHeap


# --- RETURNS for <mem.info>
# args: r3=rAddress
enum.enum_conc "mem.info.",, (r3), +1, rID, rMem, rHeap, rCache, rAlloc, rSize, rOffset, rMeta, rStatic, rString
enum.enum_conc "mem.info.",, (cr1.lt), +1, bInRegion, bIsAllocated, bIsHeap
# - rOffset is derived from rAlloc, but only if r3=rAddress input syntax is used

# args: r3=rID, rSize   (alternative syntax)
enum.enum_conc "mem.info.",, (cr1.lt), +1, bIsAvailable, bIsARAM, bIsHeap

# special returns for case of rSize being too large for making allocation (bIsAvailable = False):
enum.enum_conc "mem.info.",, (r3), +1, rID, rMem, rHeap, rCache, rFCount, rFBig, rFTotal, rACount, rABig, rATotal
# - rF* and rA* represent 'Free' and 'Allocated' params for the given region ID
# - r*Big returns the largest found fragment of free/alloc fragments counted in this region


.endif
