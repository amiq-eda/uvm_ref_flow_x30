/*-------------------------------------------------------------------------
File29 name   : uart_frame29.sv
Title29       : TX29 frame29 file for uart29 uvc29
Project29     :
Created29     :
Description29 : Describes29 UART29 Transmit29 Frame29 data structure29
Notes29       :  
----------------------------------------------------------------------*/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH29
`define UART_FRAME_SVH29

// Parity29 Type29 Control29 knob29
typedef enum bit {GOOD_PARITY29, BAD_PARITY29} parity_e29;

class uart_frame29 extends uvm_sequence_item;  //lab1_note129
  // UART29 Frame29
  rand bit start_bit29;
  rand bit [7:0] payload29;
  bit parity29;
  rand bit [1:0] stop_bits29;
  rand bit [3:0] error_bits29;
 
  // Control29 Knobs29
  rand parity_e29 parity_type29;
  rand int transmit_delay29;

  // Default constraints  //lab1_note229
  constraint default_txmit_delay29 {transmit_delay29 >= 0; transmit_delay29 < 20;}
  constraint default_start_bit29 { start_bit29 == 1'b0;}
  constraint default_stop_bits29 { stop_bits29 == 2'b11;}
  constraint default_parity_type29 { parity_type29==GOOD_PARITY29;}
  constraint default_error_bits29 { error_bits29 == 4'b0000;}

  // These29 declarations29 implement the create() and get_type_name() 
  // and enable automation29 of the uart_frame29's fields     //lab1_note329
  `uvm_object_utils_begin(uart_frame29)   
    `uvm_field_int(start_bit29, UVM_DEFAULT)
    `uvm_field_int(payload29, UVM_DEFAULT)  
    `uvm_field_int(parity29, UVM_DEFAULT)  
    `uvm_field_int(stop_bits29, UVM_DEFAULT)
    `uvm_field_int(error_bits29, UVM_DEFAULT)
    `uvm_field_enum(parity_e29,parity_type29, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay29, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor29 - required29 UVM syntax29  //lab1_note429
  function new(string name = "uart_frame29");
    super.new(name);
  endfunction 
   
  // This29 method calculates29 the parity29
  function bit calc_parity29(int unsigned num_of_data_bits29=8,
                           bit[1:0] ParityMode29=0);
    bit temp_parity29;

    if (num_of_data_bits29 == 6)
      temp_parity29 = ^payload29[5:0];  
    else if (num_of_data_bits29 == 7)
      temp_parity29 = ^payload29[6:0];  
    else
      temp_parity29 = ^payload29;  

    case(ParityMode29[0])
      0: temp_parity29 = ~temp_parity29;
      1: temp_parity29 = temp_parity29;
    endcase
    case(ParityMode29[1])
      0: temp_parity29 = temp_parity29;
      1: temp_parity29 = ~ParityMode29[0];
    endcase
    if (parity_type29 == BAD_PARITY29)
      calc_parity29 = ~temp_parity29;
    else 
      calc_parity29 = temp_parity29;
  endfunction 

  // Parity29 is calculated29 in the post_randomize() method   //lab1_note529
  function void post_randomize();
   parity29 = calc_parity29();
  endfunction : post_randomize

endclass

`endif
