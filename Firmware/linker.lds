ENTRY(_start)

MEMORY
{
    MEM (wrx) : ORIGIN = 0x0, LENGTH = 65536
}

SECTIONS
{
    .text :
    {   
        *(.text*);
    } > MEM

    .rodata :
    {
        *(.rodata*);
    } > MEM 

    .data :
    {
        *(.data*);
    } > MEM 

    .bss :
    {
        *(.bss*);
        *(COMMON);
    } > MEM

}