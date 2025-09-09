#include <stdio.h> #include <stdint.h>

#define MEMORY_SIZE (100 * 1024) // 100 KB

typedef struct BlockHeader { uint32_t size; // Size of this block (excluding header) uint8_t free; // 1 if free, 0 if allocated struct BlockHeader *next; // Pointer to next block } BlockHeader;

static uint8_t memory_pool[MEMORY_SIZE]; static BlockHeader *free_list = NULL;

// Initialize memory void init_memory() { free_list = (BlockHeader )memory_pool; free_list->size = MEMORY_SIZE - sizeof(BlockHeader); free_list->free = 1; free_list->next = NULL; } // Allocate memory void allocate(int size) { if (size <= 0) return NULL;

BlockHeader *curr = free_list;
while (curr) {
    if (curr->free && curr->size >= (uint32_t)size) {
        // Split block if there is extra space
        if (curr->size >= size + sizeof(BlockHeader) + 1) {
            BlockHeader *new_block = (BlockHeader *)((uint8_t *)curr + sizeof(BlockHeader) + size);
            new_block->size = curr->size - size - sizeof(BlockHeader);
            new_block->free = 1;
            new_block->next = curr->next;

            curr->size = size;
            curr->next = new_block;
        }
        curr->free = 0;
        return (uint8_t *)curr + sizeof(BlockHeader);
    }
    curr = curr->next;
}
return NULL; // No suitable block
} // Deallocate memory void deallocate(void *ptr) { if (!ptr) return;

BlockHeader *block = (BlockHeader *)((uint8_t *)ptr - sizeof(BlockHeader));
block->free = 1;

// Merge adjacent free blocks
BlockHeader *curr = free_list;
while (curr && curr->next) {
    if (curr->free && curr->next->free) {
        curr->size += sizeof(BlockHeader) + curr->next->size;
        curr->next = curr->next->next;
    } else {
        curr = curr->next;
    }
}
}

// Demo usage int main() { init_memory();

int *mem[100];
mem[0] = allocate(128);
mem[1] = allocate(1024);
mem[2] = allocate(4096);

deallocate(mem[1]);

mem[1] = allocate(512);

printf("mem[0] = %p\n", mem[0]);
printf("mem[1] = %p\n", mem[1]);
printf("mem[2] = %p\n", mem[2]);
    return 0; }
