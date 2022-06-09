/*-------------------------------------------------------------------------
File28 name   : uart_frame28.sv
Title28       : TX28 frame28 file for uart28 uvc28
Project28     :
Created28     :
Description28 : Describes28 UART28 Transmit28 Frame28 data structure28
Notes28       :  
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH28
`define UART_FRAME_SVH28

// Parity28 Type28 Control28 knob28
typedef enum bit {GOOD_PARITY28, BAD_PARITY28} parity_e28;

class uart_frame28 extends uvm_sequence_item;  //lab1_note128
  // UART28 Frame28
  rand bit start_bit28;
  rand bit [7:0] payload28;
  bit parity28;
  rand bit [1:0] stop_bits28;
  rand bit [3:0] error_bits28;
 
  // Control28 Knobs28
  rand parity_e28 parity_type28;
  rand int transmit_delay28;

  // Default constraints  //lab1_note228
  constraint default_txmit_delay28 {transmit_delay28 >= 0; transmit_delay28 < 20;}
  constraint default_start_bit28 { start_bit28 == 1'b0;}
  constraint default_stop_bits28 { stop_bits28 == 2'b11;}
  constraint default_parity_type28 { parity_type28==GOOD_PARITY28;}
  constraint default_error_bits28 { error_bits28 == 4'b0000;}

  // These28 declarations28 implement the create() and get_type_name() 
  // and enable automation28 of the uart_frame28's fields     //lab1_note328
  `uvm_object_utils_begin(uart_frame28)   
    `uvm_field_int(start_bit28, UVM_DEFAULT)
    `uvm_field_int(payload28, UVM_DEFAULT)  
    `uvm_field_int(parity28, UVM_DEFAULT)  
    `uvm_field_int(stop_bits28, UVM_DEFAULT)
    `uvm_field_int(error_bits28, UVM_DEFAULT)
    `uvm_field_enum(parity_e28,parity_type28, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay28, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor28 - required28 UVM syntax28  //lab1_note428
  function new(string name = "uart_frame28");
    super.new(name);
  endfunction 
   
  // This28 method calculates28 the parity28
  function bit calc_parity28(int unsigned num_of_data_bits28=8,
                           bit[1:0] ParityMode28=0);
    bit temp_parity28;

    if (num_of_data_bits28 == 6)
      temp_parity28 = ^payload28[5:0];  
    else if (num_of_data_bits28 == 7)
      temp_parity28 = ^payload28[6:0];  
    else
      temp_parity28 = ^payload28;  

    case(ParityMode28[0])
      0: temp_parity28 = ~temp_parity28;
      1: temp_parity28 = temp_parity28;
    endcase
    case(ParityMode28[1])
      0: temp_parity28 = temp_parity28;
      1: temp_parity28 = ~ParityMode28[0];
    endcase
    if (parity_type28 == BAD_PARITY28)
      calc_parity28 = ~temp_parity28;
    else 
      calc_parity28 = temp_parity28;
  endfunction 

  // Parity28 is calculated28 in the post_randomize() method   //lab1_note528
  function void post_randomize();
   parity28 = calc_parity28();
  endfunction : post_randomize

endclass

`endif
