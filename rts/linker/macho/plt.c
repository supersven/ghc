#include "Rts.h"
#include "plt.h"
#include "RtsUtils.h"

#if defined(aarch64_HOST_ARCH)

#if defined(OBJFORMAT_MACHO)

#include <mach/machine.h>
#include <mach-o/fat.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>
#include <mach-o/reloc.h>

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

#define _makeStub       ADD_SUFFIX(makeStub)
#define needStubForRel  ADD_SUFFIX(needStubForRel)

unsigned
numberOfStubsForSection( ObjectCode *oc, unsigned sectionIndex) {
    unsigned n = 0;

    MachOSection *section = &oc->info->macho_sections[sectionIndex];
    MachORelocationInfo *relocation_info = (MachORelocationInfo*)(oc->image + section->reloff);
    if(section->size > 0)
        for(size_t i = 0; i < section->nreloc; i++)
            if(needStubForRel(&relocation_info[i]))
                n += 1;

    return n;
}

bool
findStub(Section * section,
          void* * addr,
          uint8_t flags) {
    for(Stub * s = section->info->stubs; s != NULL; s = s->next) {
        if(   s->target == *addr
           && s->flags  == flags) {
            *addr = s->addr;
            return EXIT_SUCCESS;
        }
    }
    return EXIT_FAILURE;
}

bool
makeStub(Section * section,
          void* * addr,
          uint8_t flags) {

    Stub * s = (Stub *)stgCallocBytes(sizeof(Stub), 1, "makeStub");
    CHECK(s != NULL);
    s->target = *addr;
    s->flags  = flags;
    s->next = NULL;
    s->addr = (uint8_t *)section->info->stub_offset + STUB_SIZE * section->info->nstubs;

    if((*_makeStub)(s))
        return EXIT_FAILURE;

    /* Optimized O(1) stub insertion using tail pointer */
    if(section->info->stubs == NULL) {
        CHECK(section->info->nstubs == 0);
        /* no stubs yet, let's just create this one */
        section->info->stubs = s;
        section->info->stubs_tail = s;
    } else {
        /* Use tail pointer for O(1) insertion instead of O(n) traversal */
        CHECK(section->info->stubs_tail != NULL);
        CHECK(section->info->stubs_tail->next == NULL);
        section->info->stubs_tail->next = s;
        section->info->stubs_tail = s;
    }
    section->info->nstubs += 1;
    *addr = s->addr;
    return EXIT_SUCCESS;
}

void
freeStubs(Section * section) {
    if(NULL == section || section->info->nstubs == 0)
        return;
    Stub * last = section->info->stubs;
    while(last->next != NULL) {
        Stub * t = last;
        last = last->next;
        stgFree(t);
    }
    stgFree(last);  /* Free the final stub */
    section->info->stubs = NULL;
    section->info->stubs_tail = NULL;  /* Clear tail pointer */
    section->info->nstubs = 0;
}

#endif // OBJECTFORMAT_MACHO
#endif // aarch64_HOST_ARCH
