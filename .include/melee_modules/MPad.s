.ifndef melee.library.included; .include "melee"; .endif
melee.module MPad
.if module.included == 0
punkpc enum

# --- MPad structure
MPad.address = 0x804C1FAC
# This base address can be used to reach the vanilla MPad structures, without any codes
# If you have the module installed, you can use <PPad.pad> or <PPad.mode> to get an indexed MPad
# - Otherwise, you can use the MPad.size symbol to create your own index


# --- Controller Digital Data bools - these are mapped in each of the button fields
MPad.crf.mCStick = 0x20
MPad.bCStick    =  8;  MPad.mCStick    = 0xF00000   # --- CStick nibble
MPad.bCRight    =  8;  MPad.mCRight    = 0x800000   # Right on CStick
MPad.bCLeft     =  9;  MPad.mCLeft     = 0x400000   # Left  on CStick
MPad.bCDown     = 10;  MPad.mCDown     = 0x200000   # Down  on CStick
MPad.bCUp       = 11;  MPad.mCUp       = 0x100000   # Up    on CStick

MPad.crf.mStick = 0x10
MPad.bStick     = 12;  MPad.mStick     = 0x0F0000   # --- Stick nibble
MPad.bRight     = 12;  MPad.mRight     = 0x080000   # Right on Directional-Stick
MPad.bLeft      = 13;  MPad.mLeft      = 0x040000   # Left  on Directional-Stick
MPad.bDown      = 14;  MPad.mDown      = 0x020000   # Down  on Directional-Stick
MPad.bUp        = 15;  MPad.mUp        = 0x010000   # Up    on Directional-Stick

MPad.crf.mOther = 0x8
MPad.bOther     = 16;  MPad.mOther     = 0x00F000   # --- Other nibble
MPad.bStart     = 19;  MPad.mStart     = 0x001000   # Start Button

MPad.crf.mButtons = 0x4
MPad.bButtons   = 20;  MPad.mButtons   = 0x000F00   # --- Buttons nibble
MPad.bY         = 20;  MPad.mY         = 0x000800   # Y Button
MPad.bX         = 21;  MPad.mX         = 0x000400   # X Button
MPad.bB         = 22;  MPad.mB         = 0x000200   # B Button
MPad.bA         = 23;  MPad.mA         = 0x000100   # A Button

MPad.crf.mShoulders = 0x2
MPad.bShoulders = 24;  MPad.mShoulders = 0x0000F0   # --- Shoulders nibble
MPad.bL         = 25;  MPad.mL         = 0x000040   # L Shoulder -- heavy press only
MPad.bR         = 26;  MPad.mR         = 0x000020   # R Shoulder -- heavy press only
MPad.bZ         = 27;  MPad.mZ         = 0x000010   # Z Button

MPad.crf.mDPad = 0x1
MPad.bDPad      = 28;  MPad.mDPad      = 0x00000F   # --- DPad nibble
MPad.bDUp       = 28;  MPad.mDUp       = 0x000008   # Left  on Digital-Pad
MPad.bDDown     = 29;  MPad.mDDown     = 0x000004   # Right on Digital-Pad
MPad.bDRight    = 30;  MPad.mDRight    = 0x000002   # Up    on Digital-Pad
MPad.bDLeft     = 31;  MPad.mDLeft     = 0x000001   # Down  on Digital-Pad
# MPad.crf.m* values can be used to generate masks for mtcrf instructions


# --- Digital Data Fields - these use the above bools to capture digital state of controller
# raw data: 0x00
enum +4, (0)  # WORDS:
enum MPad.xOnThis # Controller Digital Data (this frame)
enum MPad.xOnPrev # Controller Digital Data (previous frame)
# filtered Data: 0x08
enum MPad.xOnPress   # Instant of Button Press
enum MPad.xOnAuto    # Automatic Tick (using repeater) -- repeating instant when buttons are held
enum MPad.xOnRelease # Instant of Button Release

# The repeater countdown powers the OnAuto tick:
enum MPad.xRepeater  # repeater wait countdown (sets to 45 on any input, when 0: resets to 8)
# - the repeater triggers OnAuto to recoccur when reaching 0, causing a reset of the repeater count
# - repeater continuously samples the OnThis field holding a button, but only on each tick frame


# --- Analog Bytes - these are condensed integer-versions of the floating point data below it
enum +1  # BYTES:  0x18
enum MPad.xByteX    # SIGNED Analog Directional-Stick X byte
enum MPad.xByteY    # SIGNED Analog Directional-Stick Y byte
enum MPad.xByteCX   # SIGNED Analog C-Stick X byte
enum MPad.xByteCY   # SIGNED Analog C-Stick Y byte
enum MPad.xByteR    # UNSIGNED Analog R byte
enum MPad.xByteL    # UNSIGNED Analog L byte
enum MPad.xByteA    # - these last 2 are not used, as far as I know
enum MPad.xByteB    # -


# --- Analog Floats - these are floats polled from the analog sensors in the controller
enum +4  # FLOATS:  0x20
enum MPad.xAnalogX  # Analog Directional-Stick X
enum MPad.xAnalogY  # Analog Directional-Stick Y
enum MPad.xAnalogCX # Analog C-Stick X
enum MPad.xAnalogCY # Analog C-Stick Y
enum MPad.xAnalogR  # Analog R
enum MPad.xAnalogL  # Analog L
enum MPad.xAnalogA  # -
enum MPad.xAnalogB  # -


# --- Error Code - detects status of the controller with error codes
enum +3, (enum + 1) # BYTE:  0x41 (byte[1] of this word is the only known variable)
enum MPad.xErr  # signed byte -  0: NONE,  -1: NO CONTROLLER,  -2: INITIALIZING,  -3: INVALID

MPad.size = enum.count
# There are 4 MPads in an array. You can index them with this size value



.endif
