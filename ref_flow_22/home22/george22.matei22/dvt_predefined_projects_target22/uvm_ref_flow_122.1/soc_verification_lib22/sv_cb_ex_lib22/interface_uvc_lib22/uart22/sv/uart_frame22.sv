/*-------------------------------------------------------------------------
File22 name   : uart_frame22.sv
Title22       : TX22 frame22 file for uart22 uvc22
Project22     :
Created22     :
Description22 : Describes22 UART22 Transmit22 Frame22 data structure22
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH22
`define UART_FRAME_SVH22

// Parity22 Type22 Control22 knob22
typedef enum bit {GOOD_PARITY22, BAD_PARITY22} parity_e22;

class uart_frame22 extends uvm_sequence_item;  //lab1_note122
  // UART22 Frame22
  rand bit start_bit22;
  rand bit [7:0] payload22;
  bit parity22;
  rand bit [1:0] stop_bits22;
  rand bit [3:0] error_bits22;
 
  // Control22 Knobs22
  rand parity_e22 parity_type22;
  rand int transmit_delay22;

  // Default constraints  //lab1_note222
  constraint default_txmit_delay22 {transmit_delay22 >= 0; transmit_delay22 < 20;}
  constraint default_start_bit22 { start_bit22 == 1'b0;}
  constraint default_stop_bits22 { stop_bits22 == 2'b11;}
  constraint default_parity_type22 { parity_type22==GOOD_PARITY22;}
  constraint default_error_bits22 { error_bits22 == 4'b0000;}

  // These22 declarations22 implement the create() and get_type_name() 
  // and enable automation22 of the uart_frame22's fields     //lab1_note322
  `uvm_object_utils_begin(uart_frame22)   
    `uvm_field_int(start_bit22, UVM_DEFAULT)
    `uvm_field_int(payload22, UVM_DEFAULT)  
    `uvm_field_int(parity22, UVM_DEFAULT)  
    `uvm_field_int(stop_bits22, UVM_DEFAULT)
    `uvm_field_int(error_bits22, UVM_DEFAULT)
    `uvm_field_enum(parity_e22,parity_type22, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay22, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor22 - required22 UVM syntax22  //lab1_note422
  function new(string name = "uart_frame22");
    super.new(name);
  endfunction 
   
  // This22 method calculates22 the parity22
  function bit calc_parity22(int unsigned num_of_data_bits22=8,
                           bit[1:0] ParityMode22=0);
    bit temp_parity22;

    if (num_of_data_bits22 == 6)
      temp_parity22 = ^payload22[5:0];  
    else if (num_of_data_bits22 == 7)
      temp_parity22 = ^payload22[6:0];  
    else
      temp_parity22 = ^payload22;  

    case(ParityMode22[0])
      0: temp_parity22 = ~temp_parity22;
      1: temp_parity22 = temp_parity22;
    endcase
    case(ParityMode22[1])
      0: temp_parity22 = temp_parity22;
      1: temp_parity22 = ~ParityMode22[0];
    endcase
    if (parity_type22 == BAD_PARITY22)
      calc_parity22 = ~temp_parity22;
    else 
      calc_parity22 = temp_parity22;
  endfunction 

  // Parity22 is calculated22 in the post_randomize() method   //lab1_note522
  function void post_randomize();
   parity22 = calc_parity22();
  endfunction : post_randomize

endclass

`endif
