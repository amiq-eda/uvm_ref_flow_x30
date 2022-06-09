/*-------------------------------------------------------------------------
File10 name   : uart_frame10.sv
Title10       : TX10 frame10 file for uart10 uvc10
Project10     :
Created10     :
Description10 : Describes10 UART10 Transmit10 Frame10 data structure10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH10
`define UART_FRAME_SVH10

// Parity10 Type10 Control10 knob10
typedef enum bit {GOOD_PARITY10, BAD_PARITY10} parity_e10;

class uart_frame10 extends uvm_sequence_item;  //lab1_note110
  // UART10 Frame10
  rand bit start_bit10;
  rand bit [7:0] payload10;
  bit parity10;
  rand bit [1:0] stop_bits10;
  rand bit [3:0] error_bits10;
 
  // Control10 Knobs10
  rand parity_e10 parity_type10;
  rand int transmit_delay10;

  // Default constraints  //lab1_note210
  constraint default_txmit_delay10 {transmit_delay10 >= 0; transmit_delay10 < 20;}
  constraint default_start_bit10 { start_bit10 == 1'b0;}
  constraint default_stop_bits10 { stop_bits10 == 2'b11;}
  constraint default_parity_type10 { parity_type10==GOOD_PARITY10;}
  constraint default_error_bits10 { error_bits10 == 4'b0000;}

  // These10 declarations10 implement the create() and get_type_name() 
  // and enable automation10 of the uart_frame10's fields     //lab1_note310
  `uvm_object_utils_begin(uart_frame10)   
    `uvm_field_int(start_bit10, UVM_DEFAULT)
    `uvm_field_int(payload10, UVM_DEFAULT)  
    `uvm_field_int(parity10, UVM_DEFAULT)  
    `uvm_field_int(stop_bits10, UVM_DEFAULT)
    `uvm_field_int(error_bits10, UVM_DEFAULT)
    `uvm_field_enum(parity_e10,parity_type10, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay10, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor10 - required10 UVM syntax10  //lab1_note410
  function new(string name = "uart_frame10");
    super.new(name);
  endfunction 
   
  // This10 method calculates10 the parity10
  function bit calc_parity10(int unsigned num_of_data_bits10=8,
                           bit[1:0] ParityMode10=0);
    bit temp_parity10;

    if (num_of_data_bits10 == 6)
      temp_parity10 = ^payload10[5:0];  
    else if (num_of_data_bits10 == 7)
      temp_parity10 = ^payload10[6:0];  
    else
      temp_parity10 = ^payload10;  

    case(ParityMode10[0])
      0: temp_parity10 = ~temp_parity10;
      1: temp_parity10 = temp_parity10;
    endcase
    case(ParityMode10[1])
      0: temp_parity10 = temp_parity10;
      1: temp_parity10 = ~ParityMode10[0];
    endcase
    if (parity_type10 == BAD_PARITY10)
      calc_parity10 = ~temp_parity10;
    else 
      calc_parity10 = temp_parity10;
  endfunction 

  // Parity10 is calculated10 in the post_randomize() method   //lab1_note510
  function void post_randomize();
   parity10 = calc_parity10();
  endfunction : post_randomize

endclass

`endif
