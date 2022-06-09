/*-------------------------------------------------------------------------
File8 name   : uart_frame8.sv
Title8       : TX8 frame8 file for uart8 uvc8
Project8     :
Created8     :
Description8 : Describes8 UART8 Transmit8 Frame8 data structure8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH8
`define UART_FRAME_SVH8

// Parity8 Type8 Control8 knob8
typedef enum bit {GOOD_PARITY8, BAD_PARITY8} parity_e8;

class uart_frame8 extends uvm_sequence_item;  //lab1_note18
  // UART8 Frame8
  rand bit start_bit8;
  rand bit [7:0] payload8;
  bit parity8;
  rand bit [1:0] stop_bits8;
  rand bit [3:0] error_bits8;
 
  // Control8 Knobs8
  rand parity_e8 parity_type8;
  rand int transmit_delay8;

  // Default constraints  //lab1_note28
  constraint default_txmit_delay8 {transmit_delay8 >= 0; transmit_delay8 < 20;}
  constraint default_start_bit8 { start_bit8 == 1'b0;}
  constraint default_stop_bits8 { stop_bits8 == 2'b11;}
  constraint default_parity_type8 { parity_type8==GOOD_PARITY8;}
  constraint default_error_bits8 { error_bits8 == 4'b0000;}

  // These8 declarations8 implement the create() and get_type_name() 
  // and enable automation8 of the uart_frame8's fields     //lab1_note38
  `uvm_object_utils_begin(uart_frame8)   
    `uvm_field_int(start_bit8, UVM_DEFAULT)
    `uvm_field_int(payload8, UVM_DEFAULT)  
    `uvm_field_int(parity8, UVM_DEFAULT)  
    `uvm_field_int(stop_bits8, UVM_DEFAULT)
    `uvm_field_int(error_bits8, UVM_DEFAULT)
    `uvm_field_enum(parity_e8,parity_type8, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay8, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor8 - required8 UVM syntax8  //lab1_note48
  function new(string name = "uart_frame8");
    super.new(name);
  endfunction 
   
  // This8 method calculates8 the parity8
  function bit calc_parity8(int unsigned num_of_data_bits8=8,
                           bit[1:0] ParityMode8=0);
    bit temp_parity8;

    if (num_of_data_bits8 == 6)
      temp_parity8 = ^payload8[5:0];  
    else if (num_of_data_bits8 == 7)
      temp_parity8 = ^payload8[6:0];  
    else
      temp_parity8 = ^payload8;  

    case(ParityMode8[0])
      0: temp_parity8 = ~temp_parity8;
      1: temp_parity8 = temp_parity8;
    endcase
    case(ParityMode8[1])
      0: temp_parity8 = temp_parity8;
      1: temp_parity8 = ~ParityMode8[0];
    endcase
    if (parity_type8 == BAD_PARITY8)
      calc_parity8 = ~temp_parity8;
    else 
      calc_parity8 = temp_parity8;
  endfunction 

  // Parity8 is calculated8 in the post_randomize() method   //lab1_note58
  function void post_randomize();
   parity8 = calc_parity8();
  endfunction : post_randomize

endclass

`endif
