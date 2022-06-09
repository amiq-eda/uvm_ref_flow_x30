/*-------------------------------------------------------------------------
File4 name   : uart_frame4.sv
Title4       : TX4 frame4 file for uart4 uvc4
Project4     :
Created4     :
Description4 : Describes4 UART4 Transmit4 Frame4 data structure4
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH4
`define UART_FRAME_SVH4

// Parity4 Type4 Control4 knob4
typedef enum bit {GOOD_PARITY4, BAD_PARITY4} parity_e4;

class uart_frame4 extends uvm_sequence_item;  //lab1_note14
  // UART4 Frame4
  rand bit start_bit4;
  rand bit [7:0] payload4;
  bit parity4;
  rand bit [1:0] stop_bits4;
  rand bit [3:0] error_bits4;
 
  // Control4 Knobs4
  rand parity_e4 parity_type4;
  rand int transmit_delay4;

  // Default constraints  //lab1_note24
  constraint default_txmit_delay4 {transmit_delay4 >= 0; transmit_delay4 < 20;}
  constraint default_start_bit4 { start_bit4 == 1'b0;}
  constraint default_stop_bits4 { stop_bits4 == 2'b11;}
  constraint default_parity_type4 { parity_type4==GOOD_PARITY4;}
  constraint default_error_bits4 { error_bits4 == 4'b0000;}

  // These4 declarations4 implement the create() and get_type_name() 
  // and enable automation4 of the uart_frame4's fields     //lab1_note34
  `uvm_object_utils_begin(uart_frame4)   
    `uvm_field_int(start_bit4, UVM_DEFAULT)
    `uvm_field_int(payload4, UVM_DEFAULT)  
    `uvm_field_int(parity4, UVM_DEFAULT)  
    `uvm_field_int(stop_bits4, UVM_DEFAULT)
    `uvm_field_int(error_bits4, UVM_DEFAULT)
    `uvm_field_enum(parity_e4,parity_type4, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay4, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor4 - required4 UVM syntax4  //lab1_note44
  function new(string name = "uart_frame4");
    super.new(name);
  endfunction 
   
  // This4 method calculates4 the parity4
  function bit calc_parity4(int unsigned num_of_data_bits4=8,
                           bit[1:0] ParityMode4=0);
    bit temp_parity4;

    if (num_of_data_bits4 == 6)
      temp_parity4 = ^payload4[5:0];  
    else if (num_of_data_bits4 == 7)
      temp_parity4 = ^payload4[6:0];  
    else
      temp_parity4 = ^payload4;  

    case(ParityMode4[0])
      0: temp_parity4 = ~temp_parity4;
      1: temp_parity4 = temp_parity4;
    endcase
    case(ParityMode4[1])
      0: temp_parity4 = temp_parity4;
      1: temp_parity4 = ~ParityMode4[0];
    endcase
    if (parity_type4 == BAD_PARITY4)
      calc_parity4 = ~temp_parity4;
    else 
      calc_parity4 = temp_parity4;
  endfunction 

  // Parity4 is calculated4 in the post_randomize() method   //lab1_note54
  function void post_randomize();
   parity4 = calc_parity4();
  endfunction : post_randomize

endclass

`endif
