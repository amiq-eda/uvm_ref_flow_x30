/*-------------------------------------------------------------------------
File13 name   : uart_frame13.sv
Title13       : TX13 frame13 file for uart13 uvc13
Project13     :
Created13     :
Description13 : Describes13 UART13 Transmit13 Frame13 data structure13
Notes13       :  
----------------------------------------------------------------------*/
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH13
`define UART_FRAME_SVH13

// Parity13 Type13 Control13 knob13
typedef enum bit {GOOD_PARITY13, BAD_PARITY13} parity_e13;

class uart_frame13 extends uvm_sequence_item;  //lab1_note113
  // UART13 Frame13
  rand bit start_bit13;
  rand bit [7:0] payload13;
  bit parity13;
  rand bit [1:0] stop_bits13;
  rand bit [3:0] error_bits13;
 
  // Control13 Knobs13
  rand parity_e13 parity_type13;
  rand int transmit_delay13;

  // Default constraints  //lab1_note213
  constraint default_txmit_delay13 {transmit_delay13 >= 0; transmit_delay13 < 20;}
  constraint default_start_bit13 { start_bit13 == 1'b0;}
  constraint default_stop_bits13 { stop_bits13 == 2'b11;}
  constraint default_parity_type13 { parity_type13==GOOD_PARITY13;}
  constraint default_error_bits13 { error_bits13 == 4'b0000;}

  // These13 declarations13 implement the create() and get_type_name() 
  // and enable automation13 of the uart_frame13's fields     //lab1_note313
  `uvm_object_utils_begin(uart_frame13)   
    `uvm_field_int(start_bit13, UVM_DEFAULT)
    `uvm_field_int(payload13, UVM_DEFAULT)  
    `uvm_field_int(parity13, UVM_DEFAULT)  
    `uvm_field_int(stop_bits13, UVM_DEFAULT)
    `uvm_field_int(error_bits13, UVM_DEFAULT)
    `uvm_field_enum(parity_e13,parity_type13, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay13, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor13 - required13 UVM syntax13  //lab1_note413
  function new(string name = "uart_frame13");
    super.new(name);
  endfunction 
   
  // This13 method calculates13 the parity13
  function bit calc_parity13(int unsigned num_of_data_bits13=8,
                           bit[1:0] ParityMode13=0);
    bit temp_parity13;

    if (num_of_data_bits13 == 6)
      temp_parity13 = ^payload13[5:0];  
    else if (num_of_data_bits13 == 7)
      temp_parity13 = ^payload13[6:0];  
    else
      temp_parity13 = ^payload13;  

    case(ParityMode13[0])
      0: temp_parity13 = ~temp_parity13;
      1: temp_parity13 = temp_parity13;
    endcase
    case(ParityMode13[1])
      0: temp_parity13 = temp_parity13;
      1: temp_parity13 = ~ParityMode13[0];
    endcase
    if (parity_type13 == BAD_PARITY13)
      calc_parity13 = ~temp_parity13;
    else 
      calc_parity13 = temp_parity13;
  endfunction 

  // Parity13 is calculated13 in the post_randomize() method   //lab1_note513
  function void post_randomize();
   parity13 = calc_parity13();
  endfunction : post_randomize

endclass

`endif
