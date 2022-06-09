/*-------------------------------------------------------------------------
File19 name   : uart_frame19.sv
Title19       : TX19 frame19 file for uart19 uvc19
Project19     :
Created19     :
Description19 : Describes19 UART19 Transmit19 Frame19 data structure19
Notes19       :  
----------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH19
`define UART_FRAME_SVH19

// Parity19 Type19 Control19 knob19
typedef enum bit {GOOD_PARITY19, BAD_PARITY19} parity_e19;

class uart_frame19 extends uvm_sequence_item;  //lab1_note119
  // UART19 Frame19
  rand bit start_bit19;
  rand bit [7:0] payload19;
  bit parity19;
  rand bit [1:0] stop_bits19;
  rand bit [3:0] error_bits19;
 
  // Control19 Knobs19
  rand parity_e19 parity_type19;
  rand int transmit_delay19;

  // Default constraints  //lab1_note219
  constraint default_txmit_delay19 {transmit_delay19 >= 0; transmit_delay19 < 20;}
  constraint default_start_bit19 { start_bit19 == 1'b0;}
  constraint default_stop_bits19 { stop_bits19 == 2'b11;}
  constraint default_parity_type19 { parity_type19==GOOD_PARITY19;}
  constraint default_error_bits19 { error_bits19 == 4'b0000;}

  // These19 declarations19 implement the create() and get_type_name() 
  // and enable automation19 of the uart_frame19's fields     //lab1_note319
  `uvm_object_utils_begin(uart_frame19)   
    `uvm_field_int(start_bit19, UVM_DEFAULT)
    `uvm_field_int(payload19, UVM_DEFAULT)  
    `uvm_field_int(parity19, UVM_DEFAULT)  
    `uvm_field_int(stop_bits19, UVM_DEFAULT)
    `uvm_field_int(error_bits19, UVM_DEFAULT)
    `uvm_field_enum(parity_e19,parity_type19, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay19, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor19 - required19 UVM syntax19  //lab1_note419
  function new(string name = "uart_frame19");
    super.new(name);
  endfunction 
   
  // This19 method calculates19 the parity19
  function bit calc_parity19(int unsigned num_of_data_bits19=8,
                           bit[1:0] ParityMode19=0);
    bit temp_parity19;

    if (num_of_data_bits19 == 6)
      temp_parity19 = ^payload19[5:0];  
    else if (num_of_data_bits19 == 7)
      temp_parity19 = ^payload19[6:0];  
    else
      temp_parity19 = ^payload19;  

    case(ParityMode19[0])
      0: temp_parity19 = ~temp_parity19;
      1: temp_parity19 = temp_parity19;
    endcase
    case(ParityMode19[1])
      0: temp_parity19 = temp_parity19;
      1: temp_parity19 = ~ParityMode19[0];
    endcase
    if (parity_type19 == BAD_PARITY19)
      calc_parity19 = ~temp_parity19;
    else 
      calc_parity19 = temp_parity19;
  endfunction 

  // Parity19 is calculated19 in the post_randomize() method   //lab1_note519
  function void post_randomize();
   parity19 = calc_parity19();
  endfunction : post_randomize

endclass

`endif
