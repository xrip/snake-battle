/* Reconstructed original 11DB module.  Native Borland C++ 2.0, large model.
   This preserves the original control flow, error handling and allocation
   behavior; the independent safe resource tools are in ../../src/. */
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <ctype.h>
#include "GPF.H"

int near gpf_handle = -1;
GpfHeader near gpf_header;
GpfEntry near gpf_entry;

int gpf_open(char *name)
{
    if (gpf_handle != -1)
        gpf_close();
    gpf_handle = open(name, 0x8004);
    if (gpf_handle == -1)
        return -1;
    read(gpf_handle, &gpf_header, 33);
    return 1;
}

int gpf_close(void)
{
    if (gpf_handle == -1)
        return 0;
    close(gpf_handle);
    return 1;
}

int gpf_find(char *name, GpfEntry *entry)
{
    int index;
    gpf_upper(name);
    lseek(gpf_handle, 33L, 0);
    for (index = 0; index < gpf_header.count; ++index) {
        read(gpf_handle, &gpf_entry, 22);
        if (strcmp(name, gpf_entry.name) == 0) {
            *entry = gpf_entry;
            return index;
        }
    }
    return -1;
}

void *gpf_alloc(char *name, int decode, int *status)
{
    char *packed, *output;
    *status = 1;
    if (gpf_find(name, &gpf_entry) != -1) {
        if (gpf_entry.method != 1 && decode == 1)
            decode = 0;
        packed = malloc(gpf_entry.packed_size);
        if (packed == 0) {
            *status = -1;
            return 0;
        }
        lseek(gpf_handle, gpf_entry.position, 0);
        read(gpf_handle, packed, gpf_entry.packed_size);
        if (decode == 1) {
            output = malloc(gpf_entry.unpacked_size);
            if (output == 0) {
                *status = -1;
                return 0;
            }
            lzss_decode(packed, output, gpf_entry.packed_size);
            free(packed);
            return output;
        } else {
            return packed;
        }
    } else {
        *status = -2;
        return 0;
    }
}

int gpf_load(char *name, int decode, void *output)
{
    char *packed;
    if (gpf_find(name, &gpf_entry) != -1) {
        if (gpf_entry.method != 1 && decode == 1)
            decode = 0;
        lseek(gpf_handle, gpf_entry.position, 0);
        if (decode == 1) {
            packed = malloc(gpf_entry.packed_size);
            if (packed == 0)
                return -1;
            read(gpf_handle, packed, gpf_entry.packed_size);
            lzss_decode(packed, output, gpf_entry.packed_size);
            free(packed);
            return 1;
        } else {
            read(gpf_handle, output, gpf_entry.packed_size);
            return 1;
        }
    } else {
        return -2;
    }
}

int gpf_planes(char *name)
{
    int status, length, offset;
    char *packed;
    offset = 0;
    packed = gpf_alloc(name, 0, &status);
    if (packed == 0)
        return status;
    gpf_plane3 = malloc(28000);
    gpf_plane2 = malloc(28000);
    gpf_plane1 = malloc(28000);
    gpf_plane0 = malloc(28000);
    if (gpf_plane0 == 0) {
        if (gpf_plane1 != 0) free(gpf_plane1);
        if (gpf_plane2 != 0) free(gpf_plane2);
        if (gpf_plane3 != 0) free(gpf_plane3);
        return -1;
    }
    memmove(&length, packed, 2);
    offset = 2;
    lzss_decode(packed + offset, gpf_plane3, length);
    offset += length;
    memmove(&length, packed + offset, 2);
    offset += 2;
    lzss_decode(packed + offset, gpf_plane2, length);
    offset += length;
    memmove(&length, packed + offset, 2);
    offset += 2;
    lzss_decode(packed + offset, gpf_plane1, length);
    offset += length;
    memmove(&length, packed + offset, 2);
    offset += 2;
    lzss_decode(packed + offset, gpf_plane0, length);
    return 1;
}

int gpf_show(char *name, int page)
{
    char *packed;
    int status;
    packed = gpf_alloc(name, 0, &status);
    if (packed == 0)
        return status;
    gpf_display(packed, page);
    free(packed);
    return 1;
}

int gpf_display(char *packed, int page)
{
    int plane, mask;
    char *video;
    int offset, length;
    offset = 0;
    video = page == 0 ? (char *)0xA0000000L : (char *)0xA8000000L;
    for (plane = 0; plane < 4; ++plane) {
        mask = 1 << plane;
        asm {
            push dx
            push ax
            mov dx, 3C4h
            mov al, 2
            out dx, al
            inc dx
            mov ax, mask
            out dx, al
            pop ax
            pop dx
        }
        memmove(&length, packed + offset, 2);
        offset += 2;
        lzss_decode(packed + offset, video, length);
        offset += length;
    }
    asm {
        mov dx, 3C4h
        mov al, 2
        out dx, al
        inc dx
        mov ax, 15
        out dx, al
    }
    return 1;
}

char *gpf_upper(char *text)
{
    int index;
    for (index = 0; text[index] != 0; ++index)
        text[index] = toupper(text[index]);
    return text;
}
