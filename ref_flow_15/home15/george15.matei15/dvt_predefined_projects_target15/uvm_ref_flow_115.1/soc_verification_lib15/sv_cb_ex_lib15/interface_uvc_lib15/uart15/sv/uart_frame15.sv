/*-------------------------------------------------------------------------
File15 name   : uart_frame15.sv
Title15       : TX15 frame15 file for uart15 uvc15
Project15     :
Created15     :
Description15 : Describes15 UART15 Transmit15 Frame15 data structure15
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH15
`define UART_FRAME_SVH15

// Parity15 Type15 Control15 knob15
typedef enum bit {GOOD_PARITY15, BAD_PARITY15} parity_e15;

class uart_frame15 extends uvm_sequence_item;  //lab1_note115
  // UART15 Frame15
  rand bit start_bit15;
  rand bit [7:0] payload15;
  bit parity15;
  rand bit [1:0] stop_bits15;
  rand bit [3:0] error_bits15;
 
  // Control15 Knobs15
  rand parity_e15 parity_type15;
  rand int transmit_delay15;

  // Default constraints  //lab1_note215
  constraint default_txmit_delay15 {transmit_delay15 >= 0; transmit_delay15 < 20;}
  constraint default_start_bit15 { start_bit15 == 1'b0;}
  constraint default_stop_bits15 { stop_bits15 == 2'b11;}
  constraint default_parity_type15 { parity_type15==GOOD_PARITY15;}
  constraint default_error_bits15 { error_bits15 == 4'b0000;}

  // These15 declarations15 implement the create() and get_type_name() 
  // and enable automation15 of the uart_frame15's fields     //lab1_note315
  `uvm_object_utils_begin(uart_frame15)   
    `uvm_field_int(start_bit15, UVM_DEFAULT)
    `uvm_field_int(payload15, UVM_DEFAULT)  
    `uvm_field_int(parity15, UVM_DEFAULT)  
    `uvm_field_int(stop_bits15, UVM_DEFAULT)
    `uvm_field_int(error_bits15, UVM_DEFAULT)
    `uvm_field_enum(parity_e15,parity_type15, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay15, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor15 - required15 UVM syntax15  //lab1_note415
  function new(string name = "uart_frame15");
    super.new(name);
  endfunction 
   
  // This15 method calculates15 the parity15
  function bit calc_parity15(int unsigned num_of_data_bits15=8,
                           bit[1:0] ParityMode15=0);
    bit temp_parity15;

    if (num_of_data_bits15 == 6)
      temp_parity15 = ^payload15[5:0];  
    else if (num_of_data_bits15 == 7)
      temp_parity15 = ^payload15[6:0];  
    else
      temp_parity15 = ^payload15;  

    case(ParityMode15[0])
      0: temp_parity15 = ~temp_parity15;
      1: temp_parity15 = temp_parity15;
    endcase
    case(ParityMode15[1])
      0: temp_parity15 = temp_parity15;
      1: temp_parity15 = ~ParityMode15[0];
    endcase
    if (parity_type15 == BAD_PARITY15)
      calc_parity15 = ~temp_parity15;
    else 
      calc_parity15 = temp_parity15;
  endfunction 

  // Parity15 is calculated15 in the post_randomize() method   //lab1_note515
  function void post_randomize();
   parity15 = calc_parity15();
  endfunction : post_randomize

endclass

`endif
