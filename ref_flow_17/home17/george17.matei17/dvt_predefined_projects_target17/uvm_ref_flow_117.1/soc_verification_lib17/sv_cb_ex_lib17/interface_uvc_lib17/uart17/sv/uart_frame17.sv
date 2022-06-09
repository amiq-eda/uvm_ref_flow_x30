/*-------------------------------------------------------------------------
File17 name   : uart_frame17.sv
Title17       : TX17 frame17 file for uart17 uvc17
Project17     :
Created17     :
Description17 : Describes17 UART17 Transmit17 Frame17 data structure17
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH17
`define UART_FRAME_SVH17

// Parity17 Type17 Control17 knob17
typedef enum bit {GOOD_PARITY17, BAD_PARITY17} parity_e17;

class uart_frame17 extends uvm_sequence_item;  //lab1_note117
  // UART17 Frame17
  rand bit start_bit17;
  rand bit [7:0] payload17;
  bit parity17;
  rand bit [1:0] stop_bits17;
  rand bit [3:0] error_bits17;
 
  // Control17 Knobs17
  rand parity_e17 parity_type17;
  rand int transmit_delay17;

  // Default constraints  //lab1_note217
  constraint default_txmit_delay17 {transmit_delay17 >= 0; transmit_delay17 < 20;}
  constraint default_start_bit17 { start_bit17 == 1'b0;}
  constraint default_stop_bits17 { stop_bits17 == 2'b11;}
  constraint default_parity_type17 { parity_type17==GOOD_PARITY17;}
  constraint default_error_bits17 { error_bits17 == 4'b0000;}

  // These17 declarations17 implement the create() and get_type_name() 
  // and enable automation17 of the uart_frame17's fields     //lab1_note317
  `uvm_object_utils_begin(uart_frame17)   
    `uvm_field_int(start_bit17, UVM_DEFAULT)
    `uvm_field_int(payload17, UVM_DEFAULT)  
    `uvm_field_int(parity17, UVM_DEFAULT)  
    `uvm_field_int(stop_bits17, UVM_DEFAULT)
    `uvm_field_int(error_bits17, UVM_DEFAULT)
    `uvm_field_enum(parity_e17,parity_type17, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay17, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor17 - required17 UVM syntax17  //lab1_note417
  function new(string name = "uart_frame17");
    super.new(name);
  endfunction 
   
  // This17 method calculates17 the parity17
  function bit calc_parity17(int unsigned num_of_data_bits17=8,
                           bit[1:0] ParityMode17=0);
    bit temp_parity17;

    if (num_of_data_bits17 == 6)
      temp_parity17 = ^payload17[5:0];  
    else if (num_of_data_bits17 == 7)
      temp_parity17 = ^payload17[6:0];  
    else
      temp_parity17 = ^payload17;  

    case(ParityMode17[0])
      0: temp_parity17 = ~temp_parity17;
      1: temp_parity17 = temp_parity17;
    endcase
    case(ParityMode17[1])
      0: temp_parity17 = temp_parity17;
      1: temp_parity17 = ~ParityMode17[0];
    endcase
    if (parity_type17 == BAD_PARITY17)
      calc_parity17 = ~temp_parity17;
    else 
      calc_parity17 = temp_parity17;
  endfunction 

  // Parity17 is calculated17 in the post_randomize() method   //lab1_note517
  function void post_randomize();
   parity17 = calc_parity17();
  endfunction : post_randomize

endclass

`endif
