.ifndef melee.library.included; .include "melee"; .endif
melee.module mem
.if module.included == 0
punkpc regs

r13.xOSArenaLo=-0x5a90
# This points to the current top of the ArenaLo stack (ascends from the bottom of RAM, upwards)
# - Arena begins where static data ends -- usually at 0x804EEC00 (following runtime stack)

r13.xOSArenaHi=-0x4330
# This points to the current top of the ArenaHigh stack (descends from top of RAM, downwards)


MemDef.xID       = 0x00
MemDef.xBehavior = 0x04
MemDef.xPrevID   = 0x08
MemDef.xSize     = 0x0C
MemDef.size      = 0x10
MemDef.addr      = 0x803ba380
# These are defined statically in the DOL

MemGlob.xIDMax   = 0x00
MemGlob.xSRAMLo  = 0x04
MemGlob.xSRAMHi  = 0x08
MemGlob.xDRAMLo  = 0x0C
MemGlob.xDRAMHi  = 0x10
MemGlob.size     = 0x14
MemGlob.addr     = 0x80431f90
# These are updated globally, as a header to the MemDesc struct array
# - adding '.size' to this base address will convert it into the base of 'MemDesc.'

MemDesc.xHeapID   = 0x00
MemDesc.xCache    = 0x04
MemDesc.xStart    = 0x08
MemDesc.xSize     = 0x0C
MemDesc.xBehavior = 0x10
MemDesc.xInit     = 0x14
MemDesc.xDisabled = 0x18
MemDesc.size      = 0x1C
MemDesc.addr      = 0x80431fb0
# An array of 'Desc' structs define dynamic memory regions used by the HSD scene system

HeapDesc.xTotal  = 0x00
HeapDesc.xFree   = 0x04
HeapDesc.xAlloc  = 0x08
HeapDesc.size    = 0x0C
r13.xOSHeapDescs = -0x4340
# OSHeaps provide dynamically free-able memory, and is used by HSD for scene-persistent allocs

HeapMeta.xPrev   = 0x00
HeapMeta.xNext   = 0x04
HeapMeta.xSize   = 0x08
HeapMeta.size    = 0x0C

CacheDesc.xNext  = 0x00
CacheDesc.xLow   = 0x04
CacheDesc.xHigh  = 0x08
CacheDesc.xMeta  = 0x0C
CacheDesc.size   = 0x10

CacheMeta.xNext  = 0x00
CacheMeta.xAlloc = 0x04
CacheMeta.xSize  = 0x08
CacheMeta.size   = 0x0C
# (these structs can be navigated to from the above global structs)




# --- RETURNS for <mem.alloc>, <mem.allocz>
# args: r3=rSize
# args: r3=rID, rSize  (alternative syntax)
mem.alloc.rAlloc       = r3
mem.alloc.rMeta        = r4
mem.alloc.rAligned     = r5
mem.alloc.rSize        = r6
mem.alloc.rID          = r7
mem.alloc.bIsAvailable = cr1.lt
mem.alloc.bIsARAM      = cr1.gt
mem.alloc.bIsHeap      = cr1.eq


# --- RETURNS for <mem.ID>
# args: r3=rID
mem.ID.rID          = r3
mem.ID.rMem         = r4
mem.ID.rHeap        = r5
mem.ID.rCache       = r6
mem.ID.rStart       = r7
mem.ID.rSize        = r8
mem.ID.rDef         = r9
mem.ID.rDefSize     = r10
mem.ID.bIsAvailable = cr1.lt
mem.ID.bIsARAM      = cr1.gt
mem.ID.bIsHeap      = cr1.eq



# --- RETURNS for <mem.info>
# args: r3=rAddress
# args: r3=rID, rSize   (alternative syntax)
mem.info.rID          = r3
mem.info.rMem         = r4
mem.info.rHeap        = r5
mem.info.rCache       = r6
mem.info.rStart       = r7
mem.info.rSize        = r8
mem.info.rOffset      = r9
mem.info.rMeta        = r10
mem.info.rStatic      = r11
mem.info.rString      = r12
mem.info.bInRegion    = cr1.lt
mem.info.bIsAllocated = cr1.gt
mem.info.bIsHeap      = cr1.eq
mem.info.bIsAvailable = cr1.lt
mem.info.bIsARAM      = cr1.gt
# - rOffset is derived from rStart, but only if r3=rAddress input syntax is used

# special returns for case of rSize being too large for making allocation (bIsAvailable = False):
mem.info.rFCount = r7
mem.info.rFBig   = r8
mem.info.rFTotal = r9
mem.info.rACount = r10
mem.info.rABig   = r11
mem.info.rATotal = r12
# - rF* and rA* represent 'Free' and 'Allocated' params for the given region ID
# - r*Big returns the largest found fragment of free/alloc fragments counted in this region


.endif
