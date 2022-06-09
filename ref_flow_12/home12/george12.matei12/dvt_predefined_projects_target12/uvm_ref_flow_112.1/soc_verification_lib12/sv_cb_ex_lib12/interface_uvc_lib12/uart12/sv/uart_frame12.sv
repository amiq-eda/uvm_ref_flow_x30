/*-------------------------------------------------------------------------
File12 name   : uart_frame12.sv
Title12       : TX12 frame12 file for uart12 uvc12
Project12     :
Created12     :
Description12 : Describes12 UART12 Transmit12 Frame12 data structure12
Notes12       :  
----------------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH12
`define UART_FRAME_SVH12

// Parity12 Type12 Control12 knob12
typedef enum bit {GOOD_PARITY12, BAD_PARITY12} parity_e12;

class uart_frame12 extends uvm_sequence_item;  //lab1_note112
  // UART12 Frame12
  rand bit start_bit12;
  rand bit [7:0] payload12;
  bit parity12;
  rand bit [1:0] stop_bits12;
  rand bit [3:0] error_bits12;
 
  // Control12 Knobs12
  rand parity_e12 parity_type12;
  rand int transmit_delay12;

  // Default constraints  //lab1_note212
  constraint default_txmit_delay12 {transmit_delay12 >= 0; transmit_delay12 < 20;}
  constraint default_start_bit12 { start_bit12 == 1'b0;}
  constraint default_stop_bits12 { stop_bits12 == 2'b11;}
  constraint default_parity_type12 { parity_type12==GOOD_PARITY12;}
  constraint default_error_bits12 { error_bits12 == 4'b0000;}

  // These12 declarations12 implement the create() and get_type_name() 
  // and enable automation12 of the uart_frame12's fields     //lab1_note312
  `uvm_object_utils_begin(uart_frame12)   
    `uvm_field_int(start_bit12, UVM_DEFAULT)
    `uvm_field_int(payload12, UVM_DEFAULT)  
    `uvm_field_int(parity12, UVM_DEFAULT)  
    `uvm_field_int(stop_bits12, UVM_DEFAULT)
    `uvm_field_int(error_bits12, UVM_DEFAULT)
    `uvm_field_enum(parity_e12,parity_type12, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay12, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor12 - required12 UVM syntax12  //lab1_note412
  function new(string name = "uart_frame12");
    super.new(name);
  endfunction 
   
  // This12 method calculates12 the parity12
  function bit calc_parity12(int unsigned num_of_data_bits12=8,
                           bit[1:0] ParityMode12=0);
    bit temp_parity12;

    if (num_of_data_bits12 == 6)
      temp_parity12 = ^payload12[5:0];  
    else if (num_of_data_bits12 == 7)
      temp_parity12 = ^payload12[6:0];  
    else
      temp_parity12 = ^payload12;  

    case(ParityMode12[0])
      0: temp_parity12 = ~temp_parity12;
      1: temp_parity12 = temp_parity12;
    endcase
    case(ParityMode12[1])
      0: temp_parity12 = temp_parity12;
      1: temp_parity12 = ~ParityMode12[0];
    endcase
    if (parity_type12 == BAD_PARITY12)
      calc_parity12 = ~temp_parity12;
    else 
      calc_parity12 = temp_parity12;
  endfunction 

  // Parity12 is calculated12 in the post_randomize() method   //lab1_note512
  function void post_randomize();
   parity12 = calc_parity12();
  endfunction : post_randomize

endclass

`endif
