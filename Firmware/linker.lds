ENTRY(_start)

MEMORY
{
    ROM (rx) : ORIGIN = 0x0, LENGTH = 30k
    RAM (w)  : ORIGIN = 0x7530, LENGTH = 35535
}

SECTIONS
{
    .text :
    {   
        *(.text*);
    } > ROM

    .data :
    {
        *(.data*);
    } > RAM AT > ROM 
}