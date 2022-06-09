/*-------------------------------------------------------------------------
File20 name   : uart_frame20.sv
Title20       : TX20 frame20 file for uart20 uvc20
Project20     :
Created20     :
Description20 : Describes20 UART20 Transmit20 Frame20 data structure20
Notes20       :  
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH20
`define UART_FRAME_SVH20

// Parity20 Type20 Control20 knob20
typedef enum bit {GOOD_PARITY20, BAD_PARITY20} parity_e20;

class uart_frame20 extends uvm_sequence_item;  //lab1_note120
  // UART20 Frame20
  rand bit start_bit20;
  rand bit [7:0] payload20;
  bit parity20;
  rand bit [1:0] stop_bits20;
  rand bit [3:0] error_bits20;
 
  // Control20 Knobs20
  rand parity_e20 parity_type20;
  rand int transmit_delay20;

  // Default constraints  //lab1_note220
  constraint default_txmit_delay20 {transmit_delay20 >= 0; transmit_delay20 < 20;}
  constraint default_start_bit20 { start_bit20 == 1'b0;}
  constraint default_stop_bits20 { stop_bits20 == 2'b11;}
  constraint default_parity_type20 { parity_type20==GOOD_PARITY20;}
  constraint default_error_bits20 { error_bits20 == 4'b0000;}

  // These20 declarations20 implement the create() and get_type_name() 
  // and enable automation20 of the uart_frame20's fields     //lab1_note320
  `uvm_object_utils_begin(uart_frame20)   
    `uvm_field_int(start_bit20, UVM_DEFAULT)
    `uvm_field_int(payload20, UVM_DEFAULT)  
    `uvm_field_int(parity20, UVM_DEFAULT)  
    `uvm_field_int(stop_bits20, UVM_DEFAULT)
    `uvm_field_int(error_bits20, UVM_DEFAULT)
    `uvm_field_enum(parity_e20,parity_type20, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay20, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor20 - required20 UVM syntax20  //lab1_note420
  function new(string name = "uart_frame20");
    super.new(name);
  endfunction 
   
  // This20 method calculates20 the parity20
  function bit calc_parity20(int unsigned num_of_data_bits20=8,
                           bit[1:0] ParityMode20=0);
    bit temp_parity20;

    if (num_of_data_bits20 == 6)
      temp_parity20 = ^payload20[5:0];  
    else if (num_of_data_bits20 == 7)
      temp_parity20 = ^payload20[6:0];  
    else
      temp_parity20 = ^payload20;  

    case(ParityMode20[0])
      0: temp_parity20 = ~temp_parity20;
      1: temp_parity20 = temp_parity20;
    endcase
    case(ParityMode20[1])
      0: temp_parity20 = temp_parity20;
      1: temp_parity20 = ~ParityMode20[0];
    endcase
    if (parity_type20 == BAD_PARITY20)
      calc_parity20 = ~temp_parity20;
    else 
      calc_parity20 = temp_parity20;
  endfunction 

  // Parity20 is calculated20 in the post_randomize() method   //lab1_note520
  function void post_randomize();
   parity20 = calc_parity20();
  endfunction : post_randomize

endclass

`endif
