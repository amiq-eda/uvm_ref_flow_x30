/*-------------------------------------------------------------------------
File25 name   : uart_frame25.sv
Title25       : TX25 frame25 file for uart25 uvc25
Project25     :
Created25     :
Description25 : Describes25 UART25 Transmit25 Frame25 data structure25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH25
`define UART_FRAME_SVH25

// Parity25 Type25 Control25 knob25
typedef enum bit {GOOD_PARITY25, BAD_PARITY25} parity_e25;

class uart_frame25 extends uvm_sequence_item;  //lab1_note125
  // UART25 Frame25
  rand bit start_bit25;
  rand bit [7:0] payload25;
  bit parity25;
  rand bit [1:0] stop_bits25;
  rand bit [3:0] error_bits25;
 
  // Control25 Knobs25
  rand parity_e25 parity_type25;
  rand int transmit_delay25;

  // Default constraints  //lab1_note225
  constraint default_txmit_delay25 {transmit_delay25 >= 0; transmit_delay25 < 20;}
  constraint default_start_bit25 { start_bit25 == 1'b0;}
  constraint default_stop_bits25 { stop_bits25 == 2'b11;}
  constraint default_parity_type25 { parity_type25==GOOD_PARITY25;}
  constraint default_error_bits25 { error_bits25 == 4'b0000;}

  // These25 declarations25 implement the create() and get_type_name() 
  // and enable automation25 of the uart_frame25's fields     //lab1_note325
  `uvm_object_utils_begin(uart_frame25)   
    `uvm_field_int(start_bit25, UVM_DEFAULT)
    `uvm_field_int(payload25, UVM_DEFAULT)  
    `uvm_field_int(parity25, UVM_DEFAULT)  
    `uvm_field_int(stop_bits25, UVM_DEFAULT)
    `uvm_field_int(error_bits25, UVM_DEFAULT)
    `uvm_field_enum(parity_e25,parity_type25, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay25, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor25 - required25 UVM syntax25  //lab1_note425
  function new(string name = "uart_frame25");
    super.new(name);
  endfunction 
   
  // This25 method calculates25 the parity25
  function bit calc_parity25(int unsigned num_of_data_bits25=8,
                           bit[1:0] ParityMode25=0);
    bit temp_parity25;

    if (num_of_data_bits25 == 6)
      temp_parity25 = ^payload25[5:0];  
    else if (num_of_data_bits25 == 7)
      temp_parity25 = ^payload25[6:0];  
    else
      temp_parity25 = ^payload25;  

    case(ParityMode25[0])
      0: temp_parity25 = ~temp_parity25;
      1: temp_parity25 = temp_parity25;
    endcase
    case(ParityMode25[1])
      0: temp_parity25 = temp_parity25;
      1: temp_parity25 = ~ParityMode25[0];
    endcase
    if (parity_type25 == BAD_PARITY25)
      calc_parity25 = ~temp_parity25;
    else 
      calc_parity25 = temp_parity25;
  endfunction 

  // Parity25 is calculated25 in the post_randomize() method   //lab1_note525
  function void post_randomize();
   parity25 = calc_parity25();
  endfunction : post_randomize

endclass

`endif
