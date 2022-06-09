/*-------------------------------------------------------------------------
File6 name   : uart_frame6.sv
Title6       : TX6 frame6 file for uart6 uvc6
Project6     :
Created6     :
Description6 : Describes6 UART6 Transmit6 Frame6 data structure6
Notes6       :  
----------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH6
`define UART_FRAME_SVH6

// Parity6 Type6 Control6 knob6
typedef enum bit {GOOD_PARITY6, BAD_PARITY6} parity_e6;

class uart_frame6 extends uvm_sequence_item;  //lab1_note16
  // UART6 Frame6
  rand bit start_bit6;
  rand bit [7:0] payload6;
  bit parity6;
  rand bit [1:0] stop_bits6;
  rand bit [3:0] error_bits6;
 
  // Control6 Knobs6
  rand parity_e6 parity_type6;
  rand int transmit_delay6;

  // Default constraints  //lab1_note26
  constraint default_txmit_delay6 {transmit_delay6 >= 0; transmit_delay6 < 20;}
  constraint default_start_bit6 { start_bit6 == 1'b0;}
  constraint default_stop_bits6 { stop_bits6 == 2'b11;}
  constraint default_parity_type6 { parity_type6==GOOD_PARITY6;}
  constraint default_error_bits6 { error_bits6 == 4'b0000;}

  // These6 declarations6 implement the create() and get_type_name() 
  // and enable automation6 of the uart_frame6's fields     //lab1_note36
  `uvm_object_utils_begin(uart_frame6)   
    `uvm_field_int(start_bit6, UVM_DEFAULT)
    `uvm_field_int(payload6, UVM_DEFAULT)  
    `uvm_field_int(parity6, UVM_DEFAULT)  
    `uvm_field_int(stop_bits6, UVM_DEFAULT)
    `uvm_field_int(error_bits6, UVM_DEFAULT)
    `uvm_field_enum(parity_e6,parity_type6, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay6, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor6 - required6 UVM syntax6  //lab1_note46
  function new(string name = "uart_frame6");
    super.new(name);
  endfunction 
   
  // This6 method calculates6 the parity6
  function bit calc_parity6(int unsigned num_of_data_bits6=8,
                           bit[1:0] ParityMode6=0);
    bit temp_parity6;

    if (num_of_data_bits6 == 6)
      temp_parity6 = ^payload6[5:0];  
    else if (num_of_data_bits6 == 7)
      temp_parity6 = ^payload6[6:0];  
    else
      temp_parity6 = ^payload6;  

    case(ParityMode6[0])
      0: temp_parity6 = ~temp_parity6;
      1: temp_parity6 = temp_parity6;
    endcase
    case(ParityMode6[1])
      0: temp_parity6 = temp_parity6;
      1: temp_parity6 = ~ParityMode6[0];
    endcase
    if (parity_type6 == BAD_PARITY6)
      calc_parity6 = ~temp_parity6;
    else 
      calc_parity6 = temp_parity6;
  endfunction 

  // Parity6 is calculated6 in the post_randomize() method   //lab1_note56
  function void post_randomize();
   parity6 = calc_parity6();
  endfunction : post_randomize

endclass

`endif
