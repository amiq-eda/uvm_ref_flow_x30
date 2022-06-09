/*-------------------------------------------------------------------------
File24 name   : uart_frame24.sv
Title24       : TX24 frame24 file for uart24 uvc24
Project24     :
Created24     :
Description24 : Describes24 UART24 Transmit24 Frame24 data structure24
Notes24       :  
----------------------------------------------------------------------*/
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH24
`define UART_FRAME_SVH24

// Parity24 Type24 Control24 knob24
typedef enum bit {GOOD_PARITY24, BAD_PARITY24} parity_e24;

class uart_frame24 extends uvm_sequence_item;  //lab1_note124
  // UART24 Frame24
  rand bit start_bit24;
  rand bit [7:0] payload24;
  bit parity24;
  rand bit [1:0] stop_bits24;
  rand bit [3:0] error_bits24;
 
  // Control24 Knobs24
  rand parity_e24 parity_type24;
  rand int transmit_delay24;

  // Default constraints  //lab1_note224
  constraint default_txmit_delay24 {transmit_delay24 >= 0; transmit_delay24 < 20;}
  constraint default_start_bit24 { start_bit24 == 1'b0;}
  constraint default_stop_bits24 { stop_bits24 == 2'b11;}
  constraint default_parity_type24 { parity_type24==GOOD_PARITY24;}
  constraint default_error_bits24 { error_bits24 == 4'b0000;}

  // These24 declarations24 implement the create() and get_type_name() 
  // and enable automation24 of the uart_frame24's fields     //lab1_note324
  `uvm_object_utils_begin(uart_frame24)   
    `uvm_field_int(start_bit24, UVM_DEFAULT)
    `uvm_field_int(payload24, UVM_DEFAULT)  
    `uvm_field_int(parity24, UVM_DEFAULT)  
    `uvm_field_int(stop_bits24, UVM_DEFAULT)
    `uvm_field_int(error_bits24, UVM_DEFAULT)
    `uvm_field_enum(parity_e24,parity_type24, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay24, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor24 - required24 UVM syntax24  //lab1_note424
  function new(string name = "uart_frame24");
    super.new(name);
  endfunction 
   
  // This24 method calculates24 the parity24
  function bit calc_parity24(int unsigned num_of_data_bits24=8,
                           bit[1:0] ParityMode24=0);
    bit temp_parity24;

    if (num_of_data_bits24 == 6)
      temp_parity24 = ^payload24[5:0];  
    else if (num_of_data_bits24 == 7)
      temp_parity24 = ^payload24[6:0];  
    else
      temp_parity24 = ^payload24;  

    case(ParityMode24[0])
      0: temp_parity24 = ~temp_parity24;
      1: temp_parity24 = temp_parity24;
    endcase
    case(ParityMode24[1])
      0: temp_parity24 = temp_parity24;
      1: temp_parity24 = ~ParityMode24[0];
    endcase
    if (parity_type24 == BAD_PARITY24)
      calc_parity24 = ~temp_parity24;
    else 
      calc_parity24 = temp_parity24;
  endfunction 

  // Parity24 is calculated24 in the post_randomize() method   //lab1_note524
  function void post_randomize();
   parity24 = calc_parity24();
  endfunction : post_randomize

endclass

`endif
