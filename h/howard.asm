page 60, 132

;-----   HOWARD the FONT   -----------------------------------------------------

; Author: Alan E. Beelitz
; Last revised: 25 July 1988

title Download Display Font for MCGA and VGA

; This program combines a high-quality RAM-loadable font for the MCGA and VGA
; with code to make the font resident.

assume CS: cseg, DS: cseg, SS: cseg, ES: cseg;     {set by dos loader}

cseg segment para public 'code'

    display_handler equ 10h;     {interrupt number for bios video i/o driver}
      set_display_mode equ 00h;     {set video mode to the specified value}
      get_current_video_state equ 0Fh;     {to get video display mode}
      read_display_combination_code equ 1A00h;     {identify attached display}
      cr equ 0Dh;     {carriage return}
      lf equ 0Ah;     {line feed}
      terminator equ '$';     {terminates an ascii string}

    program_terminate equ 20h;     {interrupt number for returning to dos}

    dos_function_handler equ 21h;     {interrupt number for dos functions}
      print_string equ 09h;     {writing a string to the screen}
      get_dos_version_number equ 30h;     {get dos version}
      terminate_and_stay_resident equ 31h;     {remain in memory after exit}
      free_allocated_memory equ 49h;     {free the specified block of memory}
      terminate_process equ 4Ch;     {terminate program and return to dos}
page

org 100h;     {skip to the end of the Program Segment Prefix}

  program label near;     {this is the dos entry point}
      jmp download_display_font;     {jump over intervening data}

    font_data_area db 4096 dup (?);     {HOWIE will insert font data here}
page

    alternate_parameter_table label word;
      dd ?;     {Video Parameter Table Pointer (offset:segment)}
      dw 0, 0;     {reserved doubleword; must be zero}
      dw offset alphanumeric_aux_font_table;
      dw ?;     {segment for alphanumeric_aux_font_table}
      dw offset graphics_aux_font_table;
      dw ?;     {segment for graphics_aux_font_table}
      dd ?;     {secondary save pointer}
      dd 2 dup (0);     {reserved; must be zero}

    alphanumeric_aux_font_table label byte;
      db 16;     {bytes per character}
      db 0;     {block to load (zero for normal operation)}
      dw 100h;     {count to store (100h for normal operation)}
      dw 0;     {character offset (zero for normal operation)}
      dw offset font_data_area;     {offset of pointer to font data}
      dw ?;     {segment of pointer to font data}
      db 0FFh;     {use maximum calculated value for displayable rows}
      db 0, 1, 2, 3, 7, 0FFh;     {mode values for which font will be used}

    graphics_aux_font_table label byte;
      db 16;     {displayable rows}
      dw 16;     {bytes per character}
      dw offset font_data_area;     {offset of pointer to font data}
      dw ?;     {segment of pointer to font data}
      db 11h, 12h, 0FFh;     {mode values for which this font will be used}
page

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;-----   IBM PS/2 Font Download   ----------------------------------------------
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    download_display_font proc near;

      call perform_initial_checks;     {check dos version and display adapter}
      call modify_parameter_tables;

      mov AH, get_current_video_state;     {find out what the current mode is}
      int display_handler;     {display mode is returned in (AL)}
      mov AH, set_display_mode;     {set mode to current value}
      int display_handler;     {perform mode change to activate the new font}

      mov AH, free_allocated_memory;     {de-allocate environment's memory}
      mov ES, CS: [002Ch];     {segment address of environment is stored here}
      int dos_function_handler;     {this allows dos to use memory better}

      mov AH, print_string;     {tell user that font has been installed}
      push CS;
      pop DS;
      mov DX, offset font_loaded_message;     {string is located at DS: [DX]}
      int dos_function_handler;

      mov AX, (terminate_and_stay_resident * 100h);     {free unneeded memory}
      mov DX, offset download_display_font;     {memory size in bytes}
      mov CL, 4;     {shift count for division by sixteen}
      shr DX, CL;     {convert from bytes to paragraphs}
      inc DX;     {take care of any remainder}
      int dos_function_handler;     {return to dos; font table stays in memory}

  download_display_font endp;
page

  perform_initial_checks proc near;

      mov DX, offset wrong_machine_message;     {possible cause of error}
      mov AX, read_display_combination_code;     {check for MCGA or VGA}
      int display_handler;     {on return, (BX) contains display code}
      cmp AL, 1Ah;     {is this function supported?}
      jne indicate_error;     {if not, don't try to load the font}

      mov DX, offset wrong_version_message;     {possible cause of error}
      mov AH, get_dos_version_number;     {check for correct dos version}
      int dos_function_handler;     {on return, (AL) = major version number}
      cmp AL, 3;     {if (AL) = 0, assume dos version is previous to 2.00}
      ja initial_checks_done;     {if dos version mode is okay, return}
      jb indicate_error;     {otherwise, indicate error}
      cmp AH, 30;     {major version = 3, so check minor version number}
      jae initial_checks_done;     {return if minor version number is okay}

    indicate_error:
      mov AH, print_string;     {write a message to the screen informing the}
      int dos_function_handler;     {.. user what corrective action to take}
      int program_terminate;     {return to dos}

    initial_checks_done:
      ret;

    perform_initial_checks endp;
page

  modify_parameter_tables proc near;

      mov alternate_parameter_table.10, CS;     {fill in segment addresses for}
      mov alternate_parameter_table.14, CS;     {.. alternate parameter table}

      mov word ptr alphanumeric_aux_font_table.8, CS;     {fill in segments for}
      mov word ptr graphics_aux_font_table.5, CS;     {.. auxiliary font tables}

      mov DS, bios_data_segment;     {set (DS) for accessing SAVE_TBL at 40:A8}
        assume DS: nothing;

      les BX, DS: [00A8h];     {set pointer to old alternate parameter table}
        assume ES: nothing;

      mov AX, ES: [BX];     {copy video parameter table pointer to the new}
      mov CS: alternate_parameter_table, AX;     {.. alternate parameter table}
      mov AX, ES: [BX + 2];
      mov CS: alternate_parameter_table.2, AX;

      mov AX, ES: [BX + 16];     {copy secondary save pointer to the new}
      mov CS: alternate_parameter_table.16, AX;     {.. alt parameter table}
      mov AX, ES: [BX + 18];
      mov CS: alternate_parameter_table.18, AX;

      mov DS: [00A8h], offset alternate_parameter_table;     {set SAVE_TBL to}
      mov DS: [00AAh], CS;     {.. point to the new alternate parameter table}
      ret;

    modify_parameter_tables endp;
page

    bios_data_segment dw 0040h;     {segment address for bios data area}

    wrong_machine_message db cr, lf;
      db 'HOWARD requires an MCGA or VGA display adapter.';
      db cr, lf, terminator;

    wrong_version_message db cr, lf;
      db 'HOWARD requires DOS Version 3.30 or above.', cr, lf, terminator;

    font_loaded_message db cr, lf;
      db 'HOWARD the FONT is now resident for your eternal pleasure.', cr, lf;
      db '��������������������   Version 2.21   ��������������������', cr, lf;
      db 'Designed by Alan E. Beelitz / Inspired by Howard W. Glueck';
      db cr, lf, terminator;

  cseg ends;

end program;
