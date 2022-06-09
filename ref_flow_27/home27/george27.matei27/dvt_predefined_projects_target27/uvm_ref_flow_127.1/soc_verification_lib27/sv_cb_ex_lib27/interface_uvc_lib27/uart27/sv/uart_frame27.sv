/*-------------------------------------------------------------------------
File27 name   : uart_frame27.sv
Title27       : TX27 frame27 file for uart27 uvc27
Project27     :
Created27     :
Description27 : Describes27 UART27 Transmit27 Frame27 data structure27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH27
`define UART_FRAME_SVH27

// Parity27 Type27 Control27 knob27
typedef enum bit {GOOD_PARITY27, BAD_PARITY27} parity_e27;

class uart_frame27 extends uvm_sequence_item;  //lab1_note127
  // UART27 Frame27
  rand bit start_bit27;
  rand bit [7:0] payload27;
  bit parity27;
  rand bit [1:0] stop_bits27;
  rand bit [3:0] error_bits27;
 
  // Control27 Knobs27
  rand parity_e27 parity_type27;
  rand int transmit_delay27;

  // Default constraints  //lab1_note227
  constraint default_txmit_delay27 {transmit_delay27 >= 0; transmit_delay27 < 20;}
  constraint default_start_bit27 { start_bit27 == 1'b0;}
  constraint default_stop_bits27 { stop_bits27 == 2'b11;}
  constraint default_parity_type27 { parity_type27==GOOD_PARITY27;}
  constraint default_error_bits27 { error_bits27 == 4'b0000;}

  // These27 declarations27 implement the create() and get_type_name() 
  // and enable automation27 of the uart_frame27's fields     //lab1_note327
  `uvm_object_utils_begin(uart_frame27)   
    `uvm_field_int(start_bit27, UVM_DEFAULT)
    `uvm_field_int(payload27, UVM_DEFAULT)  
    `uvm_field_int(parity27, UVM_DEFAULT)  
    `uvm_field_int(stop_bits27, UVM_DEFAULT)
    `uvm_field_int(error_bits27, UVM_DEFAULT)
    `uvm_field_enum(parity_e27,parity_type27, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay27, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor27 - required27 UVM syntax27  //lab1_note427
  function new(string name = "uart_frame27");
    super.new(name);
  endfunction 
   
  // This27 method calculates27 the parity27
  function bit calc_parity27(int unsigned num_of_data_bits27=8,
                           bit[1:0] ParityMode27=0);
    bit temp_parity27;

    if (num_of_data_bits27 == 6)
      temp_parity27 = ^payload27[5:0];  
    else if (num_of_data_bits27 == 7)
      temp_parity27 = ^payload27[6:0];  
    else
      temp_parity27 = ^payload27;  

    case(ParityMode27[0])
      0: temp_parity27 = ~temp_parity27;
      1: temp_parity27 = temp_parity27;
    endcase
    case(ParityMode27[1])
      0: temp_parity27 = temp_parity27;
      1: temp_parity27 = ~ParityMode27[0];
    endcase
    if (parity_type27 == BAD_PARITY27)
      calc_parity27 = ~temp_parity27;
    else 
      calc_parity27 = temp_parity27;
  endfunction 

  // Parity27 is calculated27 in the post_randomize() method   //lab1_note527
  function void post_randomize();
   parity27 = calc_parity27();
  endfunction : post_randomize

endclass

`endif
