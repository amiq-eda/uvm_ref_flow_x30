/*-------------------------------------------------------------------------
File16 name   : uart_frame16.sv
Title16       : TX16 frame16 file for uart16 uvc16
Project16     :
Created16     :
Description16 : Describes16 UART16 Transmit16 Frame16 data structure16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH16
`define UART_FRAME_SVH16

// Parity16 Type16 Control16 knob16
typedef enum bit {GOOD_PARITY16, BAD_PARITY16} parity_e16;

class uart_frame16 extends uvm_sequence_item;  //lab1_note116
  // UART16 Frame16
  rand bit start_bit16;
  rand bit [7:0] payload16;
  bit parity16;
  rand bit [1:0] stop_bits16;
  rand bit [3:0] error_bits16;
 
  // Control16 Knobs16
  rand parity_e16 parity_type16;
  rand int transmit_delay16;

  // Default constraints  //lab1_note216
  constraint default_txmit_delay16 {transmit_delay16 >= 0; transmit_delay16 < 20;}
  constraint default_start_bit16 { start_bit16 == 1'b0;}
  constraint default_stop_bits16 { stop_bits16 == 2'b11;}
  constraint default_parity_type16 { parity_type16==GOOD_PARITY16;}
  constraint default_error_bits16 { error_bits16 == 4'b0000;}

  // These16 declarations16 implement the create() and get_type_name() 
  // and enable automation16 of the uart_frame16's fields     //lab1_note316
  `uvm_object_utils_begin(uart_frame16)   
    `uvm_field_int(start_bit16, UVM_DEFAULT)
    `uvm_field_int(payload16, UVM_DEFAULT)  
    `uvm_field_int(parity16, UVM_DEFAULT)  
    `uvm_field_int(stop_bits16, UVM_DEFAULT)
    `uvm_field_int(error_bits16, UVM_DEFAULT)
    `uvm_field_enum(parity_e16,parity_type16, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay16, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor16 - required16 UVM syntax16  //lab1_note416
  function new(string name = "uart_frame16");
    super.new(name);
  endfunction 
   
  // This16 method calculates16 the parity16
  function bit calc_parity16(int unsigned num_of_data_bits16=8,
                           bit[1:0] ParityMode16=0);
    bit temp_parity16;

    if (num_of_data_bits16 == 6)
      temp_parity16 = ^payload16[5:0];  
    else if (num_of_data_bits16 == 7)
      temp_parity16 = ^payload16[6:0];  
    else
      temp_parity16 = ^payload16;  

    case(ParityMode16[0])
      0: temp_parity16 = ~temp_parity16;
      1: temp_parity16 = temp_parity16;
    endcase
    case(ParityMode16[1])
      0: temp_parity16 = temp_parity16;
      1: temp_parity16 = ~ParityMode16[0];
    endcase
    if (parity_type16 == BAD_PARITY16)
      calc_parity16 = ~temp_parity16;
    else 
      calc_parity16 = temp_parity16;
  endfunction 

  // Parity16 is calculated16 in the post_randomize() method   //lab1_note516
  function void post_randomize();
   parity16 = calc_parity16();
  endfunction : post_randomize

endclass

`endif
