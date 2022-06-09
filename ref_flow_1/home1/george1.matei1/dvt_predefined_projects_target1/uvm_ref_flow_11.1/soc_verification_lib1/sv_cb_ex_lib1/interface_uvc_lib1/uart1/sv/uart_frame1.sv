/*-------------------------------------------------------------------------
File1 name   : uart_frame1.sv
Title1       : TX1 frame1 file for uart1 uvc1
Project1     :
Created1     :
Description1 : Describes1 UART1 Transmit1 Frame1 data structure1
Notes1       :  
----------------------------------------------------------------------*/
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH1
`define UART_FRAME_SVH1

// Parity1 Type1 Control1 knob1
typedef enum bit {GOOD_PARITY1, BAD_PARITY1} parity_e1;

class uart_frame1 extends uvm_sequence_item;  //lab1_note11
  // UART1 Frame1
  rand bit start_bit1;
  rand bit [7:0] payload1;
  bit parity1;
  rand bit [1:0] stop_bits1;
  rand bit [3:0] error_bits1;
 
  // Control1 Knobs1
  rand parity_e1 parity_type1;
  rand int transmit_delay1;

  // Default constraints  //lab1_note21
  constraint default_txmit_delay1 {transmit_delay1 >= 0; transmit_delay1 < 20;}
  constraint default_start_bit1 { start_bit1 == 1'b0;}
  constraint default_stop_bits1 { stop_bits1 == 2'b11;}
  constraint default_parity_type1 { parity_type1==GOOD_PARITY1;}
  constraint default_error_bits1 { error_bits1 == 4'b0000;}

  // These1 declarations1 implement the create() and get_type_name() 
  // and enable automation1 of the uart_frame1's fields     //lab1_note31
  `uvm_object_utils_begin(uart_frame1)   
    `uvm_field_int(start_bit1, UVM_DEFAULT)
    `uvm_field_int(payload1, UVM_DEFAULT)  
    `uvm_field_int(parity1, UVM_DEFAULT)  
    `uvm_field_int(stop_bits1, UVM_DEFAULT)
    `uvm_field_int(error_bits1, UVM_DEFAULT)
    `uvm_field_enum(parity_e1,parity_type1, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay1, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor1 - required1 UVM syntax1  //lab1_note41
  function new(string name = "uart_frame1");
    super.new(name);
  endfunction 
   
  // This1 method calculates1 the parity1
  function bit calc_parity1(int unsigned num_of_data_bits1=8,
                           bit[1:0] ParityMode1=0);
    bit temp_parity1;

    if (num_of_data_bits1 == 6)
      temp_parity1 = ^payload1[5:0];  
    else if (num_of_data_bits1 == 7)
      temp_parity1 = ^payload1[6:0];  
    else
      temp_parity1 = ^payload1;  

    case(ParityMode1[0])
      0: temp_parity1 = ~temp_parity1;
      1: temp_parity1 = temp_parity1;
    endcase
    case(ParityMode1[1])
      0: temp_parity1 = temp_parity1;
      1: temp_parity1 = ~ParityMode1[0];
    endcase
    if (parity_type1 == BAD_PARITY1)
      calc_parity1 = ~temp_parity1;
    else 
      calc_parity1 = temp_parity1;
  endfunction 

  // Parity1 is calculated1 in the post_randomize() method   //lab1_note51
  function void post_randomize();
   parity1 = calc_parity1();
  endfunction : post_randomize

endclass

`endif
