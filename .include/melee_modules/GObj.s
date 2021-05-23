.ifndef melee.library.included; .include "melee"; .endif
melee.module GObj
.if module.included == 0
melee HSDObj

# --- Macros:

.macro GObj.desc/*
  Creates GObjs that can be initialized with a starting GProc/GXDraw function, and a data table

  # Desc format is as follows:
  # 0 = point or branch to GProc callback
  # 4 = point or branch to GXDraw callback
  # 8 = SPriority        - 1-byte priority for GProc in tree
  # 9 = Data Table Size  - 3-byte number of bytes to instantiate, with a generic destructor
  # C = PLink Group ID   - the group this GObj gets processed with
  # D = GXLink Group ID  - the group this GObj gets drawn with
  # E = PPriority  - priority for placement in PLink list
  # F = GXPriority - priority for placement in GXLink list
  #
  GObj callback labels:
  */ GProc, GXDraw, /*

  GObj params:
  */ PLink=0x18, GXLink=0x13, PPriority=0x10, GXPriority=0x10, Data=0, SPriority=0x10,/*

  RAM_On* will take RAM addresses instead of labels to callbacks:
  */ RAM_GProc, RAM_GXDraw


  .irp x, /* for each callback
  */    "\GProc,  \RAM_GProc",/*
  */    "\GXDraw, \RAM_GXDraw",;
    GObj.desc.check_callback_type \x;

  .endr; .long (\Data & 0xffffff) | (\SPriority << 24)
  .byte \PLink,\GXLink,\PPriority,\GXPriority

.endm; .macro GObj.desc.check_callback_type, label, RAM, ID
  # this macro helps avoid accidentally trying to evaluate labels with if statements
  # - it creates a way to handle multiple types of address inputs
  .ifnb \label; b \label; .exitm; .endif  # labels get priority
  .ifnb \RAM; .long \RAM; .exitm; .endif  # else RAM addresses
  .ifnb \ID;  .long \ID;  .exitm; .endif  # else ID
  .long 0  # else null
.endm

# --- Symbols:
# Descriptor format:
GDesc.xGProc      = 0x0# point or branch to GObj GProc callback
GDesc.xGXDraw     = 0x4# point or branch to GObj GXDraw callback
GDesc.xSPriority  = 0x8# Priority for GProc child list
GDesc.xData       = 0x9# 3-byte: Number of bytes to assign for data table
GDesc.xPLink      = 0xC# GProc group link ID
GDesc.xGXLink     = 0xD# GXDraw group link ID
GDesc.xPPriority  = 0xE# Priority for GObj carrying GProc
GDesc.xGXPriority = 0xF# Priority for GObj carrying GXDraw

# Instance format:
GObj.xClass      = 0x00 # class ID, not always used
GObj.xPLink      = 0x02 # group that this GObj gets processed with
GObj.xGXLink     = 0x03 # group that this GObj gets drawn with
GObj.xPPri       = 0x04 # priority of placement in PLink list
GObj.xGXPri      = 0x05 # priority of placement in GXLink list
GObj.xObjType    = 0x06 # see GObj.type.* symbols
GObj.xDataType   = 0x07 # usually matches class ID, or -1 if no data pointer is present
GObj.xNext       = 0x08 # to next PLinked GObj -- these share a similar process group
GObj.xPrev       = 0x0C # to previous PLinked GObj
GObj.xNextGX     = 0x10 # to next GXLinked GObj -- these are drawn by the same camera
GObj.xPrevGX     = 0x14 # to previous GXLinked GObj
GObj.xGProc      = 0x18 # to root GProc node (see GProc.* symbols)
GObj.xGXDraw     = 0x1C # to GXDraw callback
GObj.xCamFlags1  = 0x20 # - if using a CObj (camera) and a special GXDraw callback ...
GObj.xCamFlags0  = 0x24 #   - ... then these 64 bools represent the GXLinks to draw
GObj.xObj        = 0x28 # to the root object associated with this GObj (identified by ObjType)
GObj.xData       = 0x2C # to the data table assocaited with this GObj
GObj.xDestructor = 0x30 # to the destructor callback, for freeing data table on GObj destruction
# These offsets may be used to navigate the PLink or GXLink globals, in sdata (r13)

# Type IDs:
GObj.type.None = -1
GObj.type.CObj = 1
GObj.type.LObj = 2
GObj.type.JObj = 3
GObj.type.Fog  = 4
GObj.class.custom = 0x70
# this class ID means nothing, but can be used to identify custom GObjs from normal ones


# --- GProc Instance structure:
GProc.xChild    = 0x00  # next GProc for this GObj
GProc.xNext     = 0x04  # next root GProc for next GObj
GProc.xPrev     = 0x08  # prev root GProc for prev GObj
GProc.xSPriority= 0x0C  # priority for this GProc to execute before other GProcs in same GObj
GProc.xFlags    = 0x0D  # bools that control the state of the GProc
GProc.xGObj     = 0x10  # points back to the GObj using this GProc
GProc.xCallback = 0x14  # points to the callback assigned to this GProc
GProc.mDisable  = 0x40  # a mask for disabling or enabling a GProc, using its 'flags'

# --- NTSC 1.02 Callback Addresses
GObj.GProc.JObjAnimate = 0x8022eae0
GObj.GXDraw.JObjDisplay = 0x80391070

# --- NTSC 1.02 Globals
# r13 offsets:
r13.xPLinks         = -0x3e74 # points to table of 64 ASCENDING PLink GObj groups
r13.xLastPLinks     = -0x3e78 # points to table of 64 DESCENDING PLink GObj groups
r13.xSLinks         = -0x3e5c # points to table of 64 ASCENDING GProc callback groups
r13.xLastSLinks     = -0x3e60 # points to table of 64 DESCENDING GProc callback groups
r13.xGXLinks        = -0x3e7c # points to table of 64 ASCENDING GXLink GObj groups
r13.xLastGXLinks    = -0x3e80 # points to table of 64 DESCENDING GXLink GObj groups
r13.xThisGProc      = -0x3e68 # points to the currently executing GProc
r13.xNextGProc      = -0x3e70 # points to the next GProc in prioritized event queue
r13.xThisGProcGObj  = -0x3e84 # points to the current GObj (from perspective of GProc)
r13.xThisGXDrawCObj = -0x3e88 # points to the current CObj (from perspective of GXDraw)
r13.xThisGXDrawGObj = -0x3e8c # points to the current GObj (from perspective of GXDraw)


# --- unique GObj symbols:
# You can use these to navigate to or identify certain types of GObjs

GXLink.xCameras = 64<<2
# the camera list can be accessed from GXLink tables

GObj.class.fighter = 4
GObj.PLink.fighter = 8
PLink.xFighter = GObj.PLink.fighter<<2
# only in Melee scenes -- this PLink is used for other purposes in different scenes


GObj.class.stage = 3
GObj.PLink.stage = 5
PLink.xStage = GObj.PLink.stage<<2
# needs confirmation -- possibly related to stage polygons that animate ecb verts

GObj.class.item = 6
GObj.PLink.item = 9
PLink.xItem = GObj.PLink.item<<2

GObj.class.fighter_light = 0xC
GObj.PLink.fighter_light = 3
PLink.xFighterLight = GObj.PLink.fighter_light<<2
# observed with other types of lights in PLink 3 in scenes with fighters and items in it
# - also applies to items

GObj.class.stage_light = 0xD
GObj.PLink.stage_light = 3
PLink.xStageLight = GObj.PLink.stage_light<<2
# observed with class C lights in same PLink group, along with unknown class E

GObj.class.main_menu_text = 7
GObj.PLink.main_menu_text = 8
PLink.xMainMenuText = GObj.PLink.main_menu_text<<2
# only on main menu -- the descriptive text at the bottom of the screen


.endif
