.ifndef melee.library.included; .include "melee"; .endif
melee.module HSDObj
.if module.included == 0

# --- Class Info Tables
HSD.Info.JObj

# --- JObjs
# Descriptor:
JDesc.xName    = 0x00  # for grouping (?)
JDesc.xFlags   = 0x04  # see JObj flag bool and mask definitions
JDesc.xChild   = 0x08  # another JObj that's influenced by this one
JDesc.xSibling = 0x0C  # another JObj that's influenced by the same parent as this one
JDesc.xDObj    = 0x10  # display resources, for model mesh
JDesc.xRotX    = 0x14  #
JDesc.xRotY    = 0x18  # Rotation XYZ
JDesc.xRotZ    = 0x1C  #
JDesc.xScaleX  = 0x20  #
JDesc.xScalyY  = 0x24  # Scale XYZ
JDesc.xScaleZ  = 0x28  #
JDesc.xTransX  = 0x2C  #
JDesc.xTransY  = 0x30  # Translation XYZ
JDesc.xTransZ  = 0x34  #
JDesc.xMtx     = 0x38  # Default matrix (?)
JDesc.xRObj    = 0x3C  # Default RObj (?)

# Instance:
JObj.xInfo    = 0x00
JObj.xSibling = 0x08
JObj.xParent  = 0x0C
JObj.xChild   = 0x10
JObj.xFlags   = 0x14
JObj.xDObj    = 0x18
JObj.xRotX    = 0x1C
JObj.xRotY    = 0x20
JObj.xRotZ    = 0x24
JObj.xRotQ    = 0x28
JObj.xScaleX  = 0x2C
JObj.xScaleY  = 0x30
JObj.xScaleZ  = 0x34
JObj.xTransX  = 0x38
JObj.xTransY  = 0x3C
JObj.xTransZ  = 0x40
JObj.xMtxX0   = 0x44 # top 3 rows of a 4x4 transformation mtx -- implied last row is all 1.0
JObj.xMtxX1   = 0x48
JObj.xMtxX2   = 0x4C
JObj.xMtxX3   = 0x50 # last field in each row is an absolute position for model -> camera
JObj.xMtxY0   = 0x54
JObj.xMtxY1   = 0x58
JObj.xMtxY2   = 0x5C
JObj.xMtxY3   = 0x60
JObj.xMtxZ0   = 0x64
JObj.xMtxZ1   = 0x68
JObj.xMtxZ2   = 0x6C
JObj.xMtxZ3   = 0x70
JObj.xVec     = 0x74
JObj.xMtx     = 0x78
JObj.xAObj    = 0x7C
JObj.xRObj    = 0x80
JObj.xJDesc   = 0x84

# Flags:
JObj.mPad0              = 1<<31; JObj.bPad0              = 0
JObj.mRootTexEdge       = 1<<30; JObj.bRootTexEdge       = 1
JObj.mRootXLU           = 1<<29; JObj.bRootXLU           = 2
JObj.mRootOPA           = 1<<28; JObj.bRootOPA           = 3
JObj.mPad4              = 1<<27; JObj.bPad4              = 4
JObj.mPad5              = 1<<26; JObj.bPad5              = 5
JObj.mMtxIndependSrt    = 1<<25; JObj.bMtxIndependSrt    = 6
JObj.mMtxIndependParent = 1<<24; JObj.bMtxIndependParent = 7
JObj.mUserDef           = 1<<23; JObj.bUserDef           = 8
JObj.mJoint1            = 1<<21
JObj.mJoint2            = 2<<21
JObj.mEffector          = 3<<21
JObj.mPad12             = 1<<20; JObj.bPad12             = 11
JObj.mXLU               = 1<<19; JObj.bXLU               = 12
JObj.mOPA               = 1<<18; JObj.bOPA               = 13
JObj.mUseQuaternion     = 1<<17; JObj.bUseQuaternion     = 14
JObj.mSpecular          = 1<<16; JObj.bSpecular          = 15
JObj.mFlipIK            = 1<<15; JObj.bFlipIK            = 16
JObj.mSpline            = 1<<14; JObj.bSpline            = 17
JObj.mPBillboard        = 1<<13; JObj.bPBillboard        = 18
JObj.mInstance          = 1<<12; JObj.bInstance          = 19
JObj.mBillboard         = 1<<9;
JObj.mVBillboard        = 2<<9;
JObj.mHBillboard        = 3<<9;
JObj.mRBillboard        = 4<<9;
JObj.mTexgen            = 1<<8;  JObj.bTexgen            = 23
JObj.mLighting          = 1<<7;  JObj.bLighting          = 24
JObj.mMtxDirty          = 1<<6;  JObj.bMtxDirty          = 25
JObj.mPTCL              = 1<<5;  JObj.bPTCL              = 26
JObj.mHidden            = 1<<4;  JObj.bHidden            = 27
JObj.mClassicalScaling  = 1<<3;  JObj.bClassicalScaling  = 28
JObj.mEnvelopeModel     = 1<<2;  JObj.bEnvelopeModel     = 29
JObj.mSkeletonRoot      = 1<<1;  JObj.bSkeletonRoot      = 30
JObj.mSkeleton          = 1<<0;  JObj.bSkeleton          = 31



# --- RObjs

# known instance structure:
RObj.xUnk1  = 0x00
RObj.xFlags = 0x04
RObj.xJObj  = 0x08
RObj.xUnk2  = 0x0C
RObj.xUnk3  = 0x10
RObj.xUnk4  = 0x14
RObj.xAObj  = 0x18


# --- DObjs

# Descriptor:
DDesc.xName    = 0x0
DDesc.xSibling = 0x4
DDesc.xMObj    = 0x8
DDesc.xDObj    = 0xC

# Instance:
DObj.xInfo    = 0x00
DObj.xSibling = 0x04
DObj.xMObj    = 0x08
DObj.xPObj    = 0x0C
DObj.xUnk     = 0x10
DObj.xFlags   = 0x14


# --- MObjs

# Descriptor:
MDesc.xName = 0x00
MDesc.xRenderFlags = 0x04
MDesc.xTObj = 0x08
MDesc.xColor = 0x0C
MDesc.xRender = 0x10
MDesc.xPixelProc = 0x14

# Instance:
MObj.xInfo = 0x00
MObj.xRenderFlags = 0x04
MObj.xTObj = 0x08
MObj.xColor = 0x0C
MObj.xRender = 0x10
MObj.xAObj = 0x14
MObj.xTEv = 0x18
MObj.xTExp = 0x1C


# --- PObjs

# Descriptor:
PDesc.xName = 0x00
PDesc.xSibling = 0x04
PDesc.xVtxAttr = 0x08
PDesc.xFlags = 0x0C
PDesc.xDisplayCount = 0x0E
PDesc.xDisplayData = 0x10
PDesc.xInfluenceMtx = 0x14

# Instance:
PObj.xInfo = 0x00
PObj.xSibling = 0x04
PObj.xVtxAttr = 0x08
PObj.xFlags = 0x0C
PObj.xDisplayCount = 0x0E
PObj.xDisplayData = 0x10
PObj.xInfluenceMtx = 0x14

# Flags:
PObj.mSkin = 0<<12
PObj.mShapeAnim = 1<<12
PObj.mEnvelope = 2<<12
PObj.mCullFront = 1<<14; PObj.bCullFront = 17
PObj.mCullBack = 1<<15; PObj.bCullBack = 16

# VtxAttr Struct:
VtxAttr.xGXAttr = 0x00
VtxAttr.xGXAttrType = 0x04
VtxAttr.xGXCompCnt = 0x08
VtxAttr.xGXCompType = 0x0C
VtxAttr.xFrac = 0x10
VtxAttr.xStride = 0x12
VtxAttr.xData = 0x14


# --- TObjs

# Descriptor:
TObj.xName = 0x00
TObj.xNext = 0x04
TObj.xGXTexMapID = 0x08
TObj.xGXTexGenSrc = 0x0C
TObj.xRotX = 0x10
TObj.xRotY = 0x14
TObj.xRotZ = 0x18
TObj.xScaleX = 0x1C
TObj.xScaleY = 0x20
TObj.xScaleZ = 0x24
TObj.xTransX = 0x28
TObj.xTransY = 0x2C
TObj.xTransZ = 0x30
TObj.xWrapS = 0x34
TObj.xWrapT = 0x38
TObj.xRepeatS = 0x3C
TObj.xRepeatT = 0x3D
TObj.xFlags = 0x40
TObj.xBlending = 0x44
TObj.xGXTexFilter = 0x48
TObj.xImageDesc = 0x4C
TObj.xTlutDesc = 0x00
TObj.xTexLODDesc = 0x00
TObj.xTObjTevDesc = 0x00

# --- AObjs

# --- FObjs

# --- LObjs

# --- CObjs

# --- WObjs

# --- FogObjs












































  # Instance:
  enum (0), +4

.endif
