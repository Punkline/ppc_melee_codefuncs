.ifndef melee.library.included; .include "melee"; .endif
melee.module DVD
.if module.included == 0
punkpc enum


enum.enum_conc "r13.",, (-0x4424), +4, xFSTEntries, xFSTPaths, xFSTCount, (-0x3ea8), xDVDAsyncQueue

# --- RETURNS for <DVD.file>
# args: r3=rFile  (== rNum, rPath, or rOffset)
enum.enum_conc "DVD.file.",, (r3), +1, rNum, rPath, rSize, rAlign, rOffset, rFST, rFile,  (cr1.eq), bInvalid

# rFST:
enum.enum_conc "FST.",, (0), +4, xStr, xOffset, xSize


# --- RETURNS for <DVD.async_info>
# args: r3=rQuery
enum.enum_conc "DVD.async_info.",, (r3), +1, rAsync, rNum, rQuery, (cr1.lt), bNotSynced, bMatch, bSynced

# rAsync:
enum.enum_conc "DVD.async.",, (0), +4, xNext, xIDX, xNum, xStart, xDest, xSize, +2, xFlags, xError, +4, xSyncCB, xSyncArg


# --- RETURNS for all variations of <DVD.read*>
# args: r3=rFile, r4=rOut, r5=... (additional args vary by function)
enum.enum_conc "DVD.read.",, (r3), +1, rNum, rOut, rStart, rSize, rSyncCB, rArch, rMeta, rPath, rAsync, (cr1.lt), bNotSynced, (cr1.eq), bInvalid


# --- ARGUMENTS for sync callbacks
# --> passed to rSyncCB on asynchronous reads
enum.enum_conc "DVD.sync.",, (r3), +1, rID, rSyncArg, (r6), rErrorID

.endif
