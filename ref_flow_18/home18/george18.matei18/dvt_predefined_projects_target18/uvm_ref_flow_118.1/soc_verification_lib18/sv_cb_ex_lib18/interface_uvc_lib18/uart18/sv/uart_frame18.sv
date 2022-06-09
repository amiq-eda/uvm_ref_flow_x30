/*-------------------------------------------------------------------------
File18 name   : uart_frame18.sv
Title18       : TX18 frame18 file for uart18 uvc18
Project18     :
Created18     :
Description18 : Describes18 UART18 Transmit18 Frame18 data structure18
Notes18       :  
----------------------------------------------------------------------*/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH18
`define UART_FRAME_SVH18

// Parity18 Type18 Control18 knob18
typedef enum bit {GOOD_PARITY18, BAD_PARITY18} parity_e18;

class uart_frame18 extends uvm_sequence_item;  //lab1_note118
  // UART18 Frame18
  rand bit start_bit18;
  rand bit [7:0] payload18;
  bit parity18;
  rand bit [1:0] stop_bits18;
  rand bit [3:0] error_bits18;
 
  // Control18 Knobs18
  rand parity_e18 parity_type18;
  rand int transmit_delay18;

  // Default constraints  //lab1_note218
  constraint default_txmit_delay18 {transmit_delay18 >= 0; transmit_delay18 < 20;}
  constraint default_start_bit18 { start_bit18 == 1'b0;}
  constraint default_stop_bits18 { stop_bits18 == 2'b11;}
  constraint default_parity_type18 { parity_type18==GOOD_PARITY18;}
  constraint default_error_bits18 { error_bits18 == 4'b0000;}

  // These18 declarations18 implement the create() and get_type_name() 
  // and enable automation18 of the uart_frame18's fields     //lab1_note318
  `uvm_object_utils_begin(uart_frame18)   
    `uvm_field_int(start_bit18, UVM_DEFAULT)
    `uvm_field_int(payload18, UVM_DEFAULT)  
    `uvm_field_int(parity18, UVM_DEFAULT)  
    `uvm_field_int(stop_bits18, UVM_DEFAULT)
    `uvm_field_int(error_bits18, UVM_DEFAULT)
    `uvm_field_enum(parity_e18,parity_type18, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay18, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor18 - required18 UVM syntax18  //lab1_note418
  function new(string name = "uart_frame18");
    super.new(name);
  endfunction 
   
  // This18 method calculates18 the parity18
  function bit calc_parity18(int unsigned num_of_data_bits18=8,
                           bit[1:0] ParityMode18=0);
    bit temp_parity18;

    if (num_of_data_bits18 == 6)
      temp_parity18 = ^payload18[5:0];  
    else if (num_of_data_bits18 == 7)
      temp_parity18 = ^payload18[6:0];  
    else
      temp_parity18 = ^payload18;  

    case(ParityMode18[0])
      0: temp_parity18 = ~temp_parity18;
      1: temp_parity18 = temp_parity18;
    endcase
    case(ParityMode18[1])
      0: temp_parity18 = temp_parity18;
      1: temp_parity18 = ~ParityMode18[0];
    endcase
    if (parity_type18 == BAD_PARITY18)
      calc_parity18 = ~temp_parity18;
    else 
      calc_parity18 = temp_parity18;
  endfunction 

  // Parity18 is calculated18 in the post_randomize() method   //lab1_note518
  function void post_randomize();
   parity18 = calc_parity18();
  endfunction : post_randomize

endclass

`endif
