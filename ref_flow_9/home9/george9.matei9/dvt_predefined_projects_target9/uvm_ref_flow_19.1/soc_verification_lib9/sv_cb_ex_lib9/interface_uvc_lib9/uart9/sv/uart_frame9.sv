/*-------------------------------------------------------------------------
File9 name   : uart_frame9.sv
Title9       : TX9 frame9 file for uart9 uvc9
Project9     :
Created9     :
Description9 : Describes9 UART9 Transmit9 Frame9 data structure9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH9
`define UART_FRAME_SVH9

// Parity9 Type9 Control9 knob9
typedef enum bit {GOOD_PARITY9, BAD_PARITY9} parity_e9;

class uart_frame9 extends uvm_sequence_item;  //lab1_note19
  // UART9 Frame9
  rand bit start_bit9;
  rand bit [7:0] payload9;
  bit parity9;
  rand bit [1:0] stop_bits9;
  rand bit [3:0] error_bits9;
 
  // Control9 Knobs9
  rand parity_e9 parity_type9;
  rand int transmit_delay9;

  // Default constraints  //lab1_note29
  constraint default_txmit_delay9 {transmit_delay9 >= 0; transmit_delay9 < 20;}
  constraint default_start_bit9 { start_bit9 == 1'b0;}
  constraint default_stop_bits9 { stop_bits9 == 2'b11;}
  constraint default_parity_type9 { parity_type9==GOOD_PARITY9;}
  constraint default_error_bits9 { error_bits9 == 4'b0000;}

  // These9 declarations9 implement the create() and get_type_name() 
  // and enable automation9 of the uart_frame9's fields     //lab1_note39
  `uvm_object_utils_begin(uart_frame9)   
    `uvm_field_int(start_bit9, UVM_DEFAULT)
    `uvm_field_int(payload9, UVM_DEFAULT)  
    `uvm_field_int(parity9, UVM_DEFAULT)  
    `uvm_field_int(stop_bits9, UVM_DEFAULT)
    `uvm_field_int(error_bits9, UVM_DEFAULT)
    `uvm_field_enum(parity_e9,parity_type9, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay9, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor9 - required9 UVM syntax9  //lab1_note49
  function new(string name = "uart_frame9");
    super.new(name);
  endfunction 
   
  // This9 method calculates9 the parity9
  function bit calc_parity9(int unsigned num_of_data_bits9=8,
                           bit[1:0] ParityMode9=0);
    bit temp_parity9;

    if (num_of_data_bits9 == 6)
      temp_parity9 = ^payload9[5:0];  
    else if (num_of_data_bits9 == 7)
      temp_parity9 = ^payload9[6:0];  
    else
      temp_parity9 = ^payload9;  

    case(ParityMode9[0])
      0: temp_parity9 = ~temp_parity9;
      1: temp_parity9 = temp_parity9;
    endcase
    case(ParityMode9[1])
      0: temp_parity9 = temp_parity9;
      1: temp_parity9 = ~ParityMode9[0];
    endcase
    if (parity_type9 == BAD_PARITY9)
      calc_parity9 = ~temp_parity9;
    else 
      calc_parity9 = temp_parity9;
  endfunction 

  // Parity9 is calculated9 in the post_randomize() method   //lab1_note59
  function void post_randomize();
   parity9 = calc_parity9();
  endfunction : post_randomize

endclass

`endif
