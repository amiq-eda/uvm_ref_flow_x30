/*-------------------------------------------------------------------------
File30 name   : uart_frame30.sv
Title30       : TX30 frame30 file for uart30 uvc30
Project30     :
Created30     :
Description30 : Describes30 UART30 Transmit30 Frame30 data structure30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH30
`define UART_FRAME_SVH30

// Parity30 Type30 Control30 knob30
typedef enum bit {GOOD_PARITY30, BAD_PARITY30} parity_e30;

class uart_frame30 extends uvm_sequence_item;  //lab1_note130
  // UART30 Frame30
  rand bit start_bit30;
  rand bit [7:0] payload30;
  bit parity30;
  rand bit [1:0] stop_bits30;
  rand bit [3:0] error_bits30;
 
  // Control30 Knobs30
  rand parity_e30 parity_type30;
  rand int transmit_delay30;

  // Default constraints  //lab1_note230
  constraint default_txmit_delay30 {transmit_delay30 >= 0; transmit_delay30 < 20;}
  constraint default_start_bit30 { start_bit30 == 1'b0;}
  constraint default_stop_bits30 { stop_bits30 == 2'b11;}
  constraint default_parity_type30 { parity_type30==GOOD_PARITY30;}
  constraint default_error_bits30 { error_bits30 == 4'b0000;}

  // These30 declarations30 implement the create() and get_type_name() 
  // and enable automation30 of the uart_frame30's fields     //lab1_note330
  `uvm_object_utils_begin(uart_frame30)   
    `uvm_field_int(start_bit30, UVM_DEFAULT)
    `uvm_field_int(payload30, UVM_DEFAULT)  
    `uvm_field_int(parity30, UVM_DEFAULT)  
    `uvm_field_int(stop_bits30, UVM_DEFAULT)
    `uvm_field_int(error_bits30, UVM_DEFAULT)
    `uvm_field_enum(parity_e30,parity_type30, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay30, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor30 - required30 UVM syntax30  //lab1_note430
  function new(string name = "uart_frame30");
    super.new(name);
  endfunction 
   
  // This30 method calculates30 the parity30
  function bit calc_parity30(int unsigned num_of_data_bits30=8,
                           bit[1:0] ParityMode30=0);
    bit temp_parity30;

    if (num_of_data_bits30 == 6)
      temp_parity30 = ^payload30[5:0];  
    else if (num_of_data_bits30 == 7)
      temp_parity30 = ^payload30[6:0];  
    else
      temp_parity30 = ^payload30;  

    case(ParityMode30[0])
      0: temp_parity30 = ~temp_parity30;
      1: temp_parity30 = temp_parity30;
    endcase
    case(ParityMode30[1])
      0: temp_parity30 = temp_parity30;
      1: temp_parity30 = ~ParityMode30[0];
    endcase
    if (parity_type30 == BAD_PARITY30)
      calc_parity30 = ~temp_parity30;
    else 
      calc_parity30 = temp_parity30;
  endfunction 

  // Parity30 is calculated30 in the post_randomize() method   //lab1_note530
  function void post_randomize();
   parity30 = calc_parity30();
  endfunction : post_randomize

endclass

`endif
