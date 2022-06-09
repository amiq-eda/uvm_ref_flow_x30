/*-------------------------------------------------------------------------
File3 name   : uart_frame3.sv
Title3       : TX3 frame3 file for uart3 uvc3
Project3     :
Created3     :
Description3 : Describes3 UART3 Transmit3 Frame3 data structure3
Notes3       :  
----------------------------------------------------------------------*/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH3
`define UART_FRAME_SVH3

// Parity3 Type3 Control3 knob3
typedef enum bit {GOOD_PARITY3, BAD_PARITY3} parity_e3;

class uart_frame3 extends uvm_sequence_item;  //lab1_note13
  // UART3 Frame3
  rand bit start_bit3;
  rand bit [7:0] payload3;
  bit parity3;
  rand bit [1:0] stop_bits3;
  rand bit [3:0] error_bits3;
 
  // Control3 Knobs3
  rand parity_e3 parity_type3;
  rand int transmit_delay3;

  // Default constraints  //lab1_note23
  constraint default_txmit_delay3 {transmit_delay3 >= 0; transmit_delay3 < 20;}
  constraint default_start_bit3 { start_bit3 == 1'b0;}
  constraint default_stop_bits3 { stop_bits3 == 2'b11;}
  constraint default_parity_type3 { parity_type3==GOOD_PARITY3;}
  constraint default_error_bits3 { error_bits3 == 4'b0000;}

  // These3 declarations3 implement the create() and get_type_name() 
  // and enable automation3 of the uart_frame3's fields     //lab1_note33
  `uvm_object_utils_begin(uart_frame3)   
    `uvm_field_int(start_bit3, UVM_DEFAULT)
    `uvm_field_int(payload3, UVM_DEFAULT)  
    `uvm_field_int(parity3, UVM_DEFAULT)  
    `uvm_field_int(stop_bits3, UVM_DEFAULT)
    `uvm_field_int(error_bits3, UVM_DEFAULT)
    `uvm_field_enum(parity_e3,parity_type3, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay3, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor3 - required3 UVM syntax3  //lab1_note43
  function new(string name = "uart_frame3");
    super.new(name);
  endfunction 
   
  // This3 method calculates3 the parity3
  function bit calc_parity3(int unsigned num_of_data_bits3=8,
                           bit[1:0] ParityMode3=0);
    bit temp_parity3;

    if (num_of_data_bits3 == 6)
      temp_parity3 = ^payload3[5:0];  
    else if (num_of_data_bits3 == 7)
      temp_parity3 = ^payload3[6:0];  
    else
      temp_parity3 = ^payload3;  

    case(ParityMode3[0])
      0: temp_parity3 = ~temp_parity3;
      1: temp_parity3 = temp_parity3;
    endcase
    case(ParityMode3[1])
      0: temp_parity3 = temp_parity3;
      1: temp_parity3 = ~ParityMode3[0];
    endcase
    if (parity_type3 == BAD_PARITY3)
      calc_parity3 = ~temp_parity3;
    else 
      calc_parity3 = temp_parity3;
  endfunction 

  // Parity3 is calculated3 in the post_randomize() method   //lab1_note53
  function void post_randomize();
   parity3 = calc_parity3();
  endfunction : post_randomize

endclass

`endif
