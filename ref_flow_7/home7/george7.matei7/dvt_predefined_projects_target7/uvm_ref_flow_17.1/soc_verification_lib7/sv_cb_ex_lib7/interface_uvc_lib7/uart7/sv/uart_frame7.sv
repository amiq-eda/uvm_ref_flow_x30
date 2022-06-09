/*-------------------------------------------------------------------------
File7 name   : uart_frame7.sv
Title7       : TX7 frame7 file for uart7 uvc7
Project7     :
Created7     :
Description7 : Describes7 UART7 Transmit7 Frame7 data structure7
Notes7       :  
----------------------------------------------------------------------*/
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH7
`define UART_FRAME_SVH7

// Parity7 Type7 Control7 knob7
typedef enum bit {GOOD_PARITY7, BAD_PARITY7} parity_e7;

class uart_frame7 extends uvm_sequence_item;  //lab1_note17
  // UART7 Frame7
  rand bit start_bit7;
  rand bit [7:0] payload7;
  bit parity7;
  rand bit [1:0] stop_bits7;
  rand bit [3:0] error_bits7;
 
  // Control7 Knobs7
  rand parity_e7 parity_type7;
  rand int transmit_delay7;

  // Default constraints  //lab1_note27
  constraint default_txmit_delay7 {transmit_delay7 >= 0; transmit_delay7 < 20;}
  constraint default_start_bit7 { start_bit7 == 1'b0;}
  constraint default_stop_bits7 { stop_bits7 == 2'b11;}
  constraint default_parity_type7 { parity_type7==GOOD_PARITY7;}
  constraint default_error_bits7 { error_bits7 == 4'b0000;}

  // These7 declarations7 implement the create() and get_type_name() 
  // and enable automation7 of the uart_frame7's fields     //lab1_note37
  `uvm_object_utils_begin(uart_frame7)   
    `uvm_field_int(start_bit7, UVM_DEFAULT)
    `uvm_field_int(payload7, UVM_DEFAULT)  
    `uvm_field_int(parity7, UVM_DEFAULT)  
    `uvm_field_int(stop_bits7, UVM_DEFAULT)
    `uvm_field_int(error_bits7, UVM_DEFAULT)
    `uvm_field_enum(parity_e7,parity_type7, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay7, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor7 - required7 UVM syntax7  //lab1_note47
  function new(string name = "uart_frame7");
    super.new(name);
  endfunction 
   
  // This7 method calculates7 the parity7
  function bit calc_parity7(int unsigned num_of_data_bits7=8,
                           bit[1:0] ParityMode7=0);
    bit temp_parity7;

    if (num_of_data_bits7 == 6)
      temp_parity7 = ^payload7[5:0];  
    else if (num_of_data_bits7 == 7)
      temp_parity7 = ^payload7[6:0];  
    else
      temp_parity7 = ^payload7;  

    case(ParityMode7[0])
      0: temp_parity7 = ~temp_parity7;
      1: temp_parity7 = temp_parity7;
    endcase
    case(ParityMode7[1])
      0: temp_parity7 = temp_parity7;
      1: temp_parity7 = ~ParityMode7[0];
    endcase
    if (parity_type7 == BAD_PARITY7)
      calc_parity7 = ~temp_parity7;
    else 
      calc_parity7 = temp_parity7;
  endfunction 

  // Parity7 is calculated7 in the post_randomize() method   //lab1_note57
  function void post_randomize();
   parity7 = calc_parity7();
  endfunction : post_randomize

endclass

`endif
