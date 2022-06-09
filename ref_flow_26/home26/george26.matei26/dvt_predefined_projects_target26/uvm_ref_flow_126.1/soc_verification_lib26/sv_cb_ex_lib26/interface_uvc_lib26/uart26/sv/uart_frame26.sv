/*-------------------------------------------------------------------------
File26 name   : uart_frame26.sv
Title26       : TX26 frame26 file for uart26 uvc26
Project26     :
Created26     :
Description26 : Describes26 UART26 Transmit26 Frame26 data structure26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH26
`define UART_FRAME_SVH26

// Parity26 Type26 Control26 knob26
typedef enum bit {GOOD_PARITY26, BAD_PARITY26} parity_e26;

class uart_frame26 extends uvm_sequence_item;  //lab1_note126
  // UART26 Frame26
  rand bit start_bit26;
  rand bit [7:0] payload26;
  bit parity26;
  rand bit [1:0] stop_bits26;
  rand bit [3:0] error_bits26;
 
  // Control26 Knobs26
  rand parity_e26 parity_type26;
  rand int transmit_delay26;

  // Default constraints  //lab1_note226
  constraint default_txmit_delay26 {transmit_delay26 >= 0; transmit_delay26 < 20;}
  constraint default_start_bit26 { start_bit26 == 1'b0;}
  constraint default_stop_bits26 { stop_bits26 == 2'b11;}
  constraint default_parity_type26 { parity_type26==GOOD_PARITY26;}
  constraint default_error_bits26 { error_bits26 == 4'b0000;}

  // These26 declarations26 implement the create() and get_type_name() 
  // and enable automation26 of the uart_frame26's fields     //lab1_note326
  `uvm_object_utils_begin(uart_frame26)   
    `uvm_field_int(start_bit26, UVM_DEFAULT)
    `uvm_field_int(payload26, UVM_DEFAULT)  
    `uvm_field_int(parity26, UVM_DEFAULT)  
    `uvm_field_int(stop_bits26, UVM_DEFAULT)
    `uvm_field_int(error_bits26, UVM_DEFAULT)
    `uvm_field_enum(parity_e26,parity_type26, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay26, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor26 - required26 UVM syntax26  //lab1_note426
  function new(string name = "uart_frame26");
    super.new(name);
  endfunction 
   
  // This26 method calculates26 the parity26
  function bit calc_parity26(int unsigned num_of_data_bits26=8,
                           bit[1:0] ParityMode26=0);
    bit temp_parity26;

    if (num_of_data_bits26 == 6)
      temp_parity26 = ^payload26[5:0];  
    else if (num_of_data_bits26 == 7)
      temp_parity26 = ^payload26[6:0];  
    else
      temp_parity26 = ^payload26;  

    case(ParityMode26[0])
      0: temp_parity26 = ~temp_parity26;
      1: temp_parity26 = temp_parity26;
    endcase
    case(ParityMode26[1])
      0: temp_parity26 = temp_parity26;
      1: temp_parity26 = ~ParityMode26[0];
    endcase
    if (parity_type26 == BAD_PARITY26)
      calc_parity26 = ~temp_parity26;
    else 
      calc_parity26 = temp_parity26;
  endfunction 

  // Parity26 is calculated26 in the post_randomize() method   //lab1_note526
  function void post_randomize();
   parity26 = calc_parity26();
  endfunction : post_randomize

endclass

`endif
