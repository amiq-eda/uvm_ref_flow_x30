/*-------------------------------------------------------------------------
File11 name   : uart_frame11.sv
Title11       : TX11 frame11 file for uart11 uvc11
Project11     :
Created11     :
Description11 : Describes11 UART11 Transmit11 Frame11 data structure11
Notes11       :  
----------------------------------------------------------------------*/
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH11
`define UART_FRAME_SVH11

// Parity11 Type11 Control11 knob11
typedef enum bit {GOOD_PARITY11, BAD_PARITY11} parity_e11;

class uart_frame11 extends uvm_sequence_item;  //lab1_note111
  // UART11 Frame11
  rand bit start_bit11;
  rand bit [7:0] payload11;
  bit parity11;
  rand bit [1:0] stop_bits11;
  rand bit [3:0] error_bits11;
 
  // Control11 Knobs11
  rand parity_e11 parity_type11;
  rand int transmit_delay11;

  // Default constraints  //lab1_note211
  constraint default_txmit_delay11 {transmit_delay11 >= 0; transmit_delay11 < 20;}
  constraint default_start_bit11 { start_bit11 == 1'b0;}
  constraint default_stop_bits11 { stop_bits11 == 2'b11;}
  constraint default_parity_type11 { parity_type11==GOOD_PARITY11;}
  constraint default_error_bits11 { error_bits11 == 4'b0000;}

  // These11 declarations11 implement the create() and get_type_name() 
  // and enable automation11 of the uart_frame11's fields     //lab1_note311
  `uvm_object_utils_begin(uart_frame11)   
    `uvm_field_int(start_bit11, UVM_DEFAULT)
    `uvm_field_int(payload11, UVM_DEFAULT)  
    `uvm_field_int(parity11, UVM_DEFAULT)  
    `uvm_field_int(stop_bits11, UVM_DEFAULT)
    `uvm_field_int(error_bits11, UVM_DEFAULT)
    `uvm_field_enum(parity_e11,parity_type11, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay11, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor11 - required11 UVM syntax11  //lab1_note411
  function new(string name = "uart_frame11");
    super.new(name);
  endfunction 
   
  // This11 method calculates11 the parity11
  function bit calc_parity11(int unsigned num_of_data_bits11=8,
                           bit[1:0] ParityMode11=0);
    bit temp_parity11;

    if (num_of_data_bits11 == 6)
      temp_parity11 = ^payload11[5:0];  
    else if (num_of_data_bits11 == 7)
      temp_parity11 = ^payload11[6:0];  
    else
      temp_parity11 = ^payload11;  

    case(ParityMode11[0])
      0: temp_parity11 = ~temp_parity11;
      1: temp_parity11 = temp_parity11;
    endcase
    case(ParityMode11[1])
      0: temp_parity11 = temp_parity11;
      1: temp_parity11 = ~ParityMode11[0];
    endcase
    if (parity_type11 == BAD_PARITY11)
      calc_parity11 = ~temp_parity11;
    else 
      calc_parity11 = temp_parity11;
  endfunction 

  // Parity11 is calculated11 in the post_randomize() method   //lab1_note511
  function void post_randomize();
   parity11 = calc_parity11();
  endfunction : post_randomize

endclass

`endif
