#ifndef SNAKE_GPF_H
#define SNAKE_GPF_H

/* Original large-model GPF declarations.  Compile with byte-aligned structs. */
typedef struct GpfHeader {
    char identification[23];
    int count;
    char reserved[8];
} GpfHeader;

typedef struct GpfEntry {
    char name[13];
    unsigned char method;
    long position;
    unsigned packed_size;
    unsigned unpacked_size;
} GpfEntry;

extern int near gpf_handle;
extern GpfHeader near gpf_header;
extern GpfEntry near gpf_entry;

/* These four original external pointer lvalues overlap in the linked game.
   Their addresses, and the original cross-module declaration inconsistency,
   are retained in bindings.json.  Do not replace them by a pointer array. */
extern char *near gpf_plane0;
extern char *near gpf_plane1;
extern char *near gpf_plane2;
extern char *near gpf_plane3;

int gpf_open(char *name);
int gpf_close(void);
int gpf_find(char *name, GpfEntry *entry);
void *gpf_alloc(char *name, int decode, int *status);
int gpf_load(char *name, int decode, void *output);
int gpf_planes(char *name);
int gpf_show(char *name, int page);
int gpf_display(char *packed, int page);
char *gpf_upper(char *text);
void lzss_decode(char *packed, void *output, unsigned length);

#endif
