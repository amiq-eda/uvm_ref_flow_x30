/*-------------------------------------------------------------------------
File23 name   : uart_frame23.sv
Title23       : TX23 frame23 file for uart23 uvc23
Project23     :
Created23     :
Description23 : Describes23 UART23 Transmit23 Frame23 data structure23
Notes23       :  
----------------------------------------------------------------------*/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH23
`define UART_FRAME_SVH23

// Parity23 Type23 Control23 knob23
typedef enum bit {GOOD_PARITY23, BAD_PARITY23} parity_e23;

class uart_frame23 extends uvm_sequence_item;  //lab1_note123
  // UART23 Frame23
  rand bit start_bit23;
  rand bit [7:0] payload23;
  bit parity23;
  rand bit [1:0] stop_bits23;
  rand bit [3:0] error_bits23;
 
  // Control23 Knobs23
  rand parity_e23 parity_type23;
  rand int transmit_delay23;

  // Default constraints  //lab1_note223
  constraint default_txmit_delay23 {transmit_delay23 >= 0; transmit_delay23 < 20;}
  constraint default_start_bit23 { start_bit23 == 1'b0;}
  constraint default_stop_bits23 { stop_bits23 == 2'b11;}
  constraint default_parity_type23 { parity_type23==GOOD_PARITY23;}
  constraint default_error_bits23 { error_bits23 == 4'b0000;}

  // These23 declarations23 implement the create() and get_type_name() 
  // and enable automation23 of the uart_frame23's fields     //lab1_note323
  `uvm_object_utils_begin(uart_frame23)   
    `uvm_field_int(start_bit23, UVM_DEFAULT)
    `uvm_field_int(payload23, UVM_DEFAULT)  
    `uvm_field_int(parity23, UVM_DEFAULT)  
    `uvm_field_int(stop_bits23, UVM_DEFAULT)
    `uvm_field_int(error_bits23, UVM_DEFAULT)
    `uvm_field_enum(parity_e23,parity_type23, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay23, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor23 - required23 UVM syntax23  //lab1_note423
  function new(string name = "uart_frame23");
    super.new(name);
  endfunction 
   
  // This23 method calculates23 the parity23
  function bit calc_parity23(int unsigned num_of_data_bits23=8,
                           bit[1:0] ParityMode23=0);
    bit temp_parity23;

    if (num_of_data_bits23 == 6)
      temp_parity23 = ^payload23[5:0];  
    else if (num_of_data_bits23 == 7)
      temp_parity23 = ^payload23[6:0];  
    else
      temp_parity23 = ^payload23;  

    case(ParityMode23[0])
      0: temp_parity23 = ~temp_parity23;
      1: temp_parity23 = temp_parity23;
    endcase
    case(ParityMode23[1])
      0: temp_parity23 = temp_parity23;
      1: temp_parity23 = ~ParityMode23[0];
    endcase
    if (parity_type23 == BAD_PARITY23)
      calc_parity23 = ~temp_parity23;
    else 
      calc_parity23 = temp_parity23;
  endfunction 

  // Parity23 is calculated23 in the post_randomize() method   //lab1_note523
  function void post_randomize();
   parity23 = calc_parity23();
  endfunction : post_randomize

endclass

`endif
