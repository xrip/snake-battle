/* Reconstructed sound-driver data ABI, 16-bit DOS, byte-packed. */
#ifndef SNDATA_H
#define SNDATA_H

typedef unsigned char SndByte;
typedef unsigned short SndWord;
typedef unsigned long SndDword;
typedef int (near *SndProc)();
typedef struct { SndByte field, shift; SndWord mask; } SndField;
typedef struct { SndByte reg, shift, mask, invert; } SndRegField;
typedef struct { SndByte state[18]; } SndPlayer;
typedef struct { SndByte state[52]; } SndSequence;
typedef struct { SndByte state[66]; } SndHooks;
typedef struct { SndByte state[20]; } SndHeldNote;
typedef struct { SndByte state[16]; } SndFade;
typedef struct { SndWord args[8]; } SndCommand;
typedef struct { SndByte state[32]; } SndPart;
typedef struct { SndByte parameters[30]; } SndInstrument;
typedef struct { SndByte state[98]; } SndVoice;
#endif
