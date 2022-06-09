/*-------------------------------------------------------------------------
File14 name   : uart_frame14.sv
Title14       : TX14 frame14 file for uart14 uvc14
Project14     :
Created14     :
Description14 : Describes14 UART14 Transmit14 Frame14 data structure14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH14
`define UART_FRAME_SVH14

// Parity14 Type14 Control14 knob14
typedef enum bit {GOOD_PARITY14, BAD_PARITY14} parity_e14;

class uart_frame14 extends uvm_sequence_item;  //lab1_note114
  // UART14 Frame14
  rand bit start_bit14;
  rand bit [7:0] payload14;
  bit parity14;
  rand bit [1:0] stop_bits14;
  rand bit [3:0] error_bits14;
 
  // Control14 Knobs14
  rand parity_e14 parity_type14;
  rand int transmit_delay14;

  // Default constraints  //lab1_note214
  constraint default_txmit_delay14 {transmit_delay14 >= 0; transmit_delay14 < 20;}
  constraint default_start_bit14 { start_bit14 == 1'b0;}
  constraint default_stop_bits14 { stop_bits14 == 2'b11;}
  constraint default_parity_type14 { parity_type14==GOOD_PARITY14;}
  constraint default_error_bits14 { error_bits14 == 4'b0000;}

  // These14 declarations14 implement the create() and get_type_name() 
  // and enable automation14 of the uart_frame14's fields     //lab1_note314
  `uvm_object_utils_begin(uart_frame14)   
    `uvm_field_int(start_bit14, UVM_DEFAULT)
    `uvm_field_int(payload14, UVM_DEFAULT)  
    `uvm_field_int(parity14, UVM_DEFAULT)  
    `uvm_field_int(stop_bits14, UVM_DEFAULT)
    `uvm_field_int(error_bits14, UVM_DEFAULT)
    `uvm_field_enum(parity_e14,parity_type14, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay14, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor14 - required14 UVM syntax14  //lab1_note414
  function new(string name = "uart_frame14");
    super.new(name);
  endfunction 
   
  // This14 method calculates14 the parity14
  function bit calc_parity14(int unsigned num_of_data_bits14=8,
                           bit[1:0] ParityMode14=0);
    bit temp_parity14;

    if (num_of_data_bits14 == 6)
      temp_parity14 = ^payload14[5:0];  
    else if (num_of_data_bits14 == 7)
      temp_parity14 = ^payload14[6:0];  
    else
      temp_parity14 = ^payload14;  

    case(ParityMode14[0])
      0: temp_parity14 = ~temp_parity14;
      1: temp_parity14 = temp_parity14;
    endcase
    case(ParityMode14[1])
      0: temp_parity14 = temp_parity14;
      1: temp_parity14 = ~ParityMode14[0];
    endcase
    if (parity_type14 == BAD_PARITY14)
      calc_parity14 = ~temp_parity14;
    else 
      calc_parity14 = temp_parity14;
  endfunction 

  // Parity14 is calculated14 in the post_randomize() method   //lab1_note514
  function void post_randomize();
   parity14 = calc_parity14();
  endfunction : post_randomize

endclass

`endif
