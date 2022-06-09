/*-------------------------------------------------------------------------
File5 name   : uart_frame5.sv
Title5       : TX5 frame5 file for uart5 uvc5
Project5     :
Created5     :
Description5 : Describes5 UART5 Transmit5 Frame5 data structure5
Notes5       :  
----------------------------------------------------------------------*/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH5
`define UART_FRAME_SVH5

// Parity5 Type5 Control5 knob5
typedef enum bit {GOOD_PARITY5, BAD_PARITY5} parity_e5;

class uart_frame5 extends uvm_sequence_item;  //lab1_note15
  // UART5 Frame5
  rand bit start_bit5;
  rand bit [7:0] payload5;
  bit parity5;
  rand bit [1:0] stop_bits5;
  rand bit [3:0] error_bits5;
 
  // Control5 Knobs5
  rand parity_e5 parity_type5;
  rand int transmit_delay5;

  // Default constraints  //lab1_note25
  constraint default_txmit_delay5 {transmit_delay5 >= 0; transmit_delay5 < 20;}
  constraint default_start_bit5 { start_bit5 == 1'b0;}
  constraint default_stop_bits5 { stop_bits5 == 2'b11;}
  constraint default_parity_type5 { parity_type5==GOOD_PARITY5;}
  constraint default_error_bits5 { error_bits5 == 4'b0000;}

  // These5 declarations5 implement the create() and get_type_name() 
  // and enable automation5 of the uart_frame5's fields     //lab1_note35
  `uvm_object_utils_begin(uart_frame5)   
    `uvm_field_int(start_bit5, UVM_DEFAULT)
    `uvm_field_int(payload5, UVM_DEFAULT)  
    `uvm_field_int(parity5, UVM_DEFAULT)  
    `uvm_field_int(stop_bits5, UVM_DEFAULT)
    `uvm_field_int(error_bits5, UVM_DEFAULT)
    `uvm_field_enum(parity_e5,parity_type5, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay5, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor5 - required5 UVM syntax5  //lab1_note45
  function new(string name = "uart_frame5");
    super.new(name);
  endfunction 
   
  // This5 method calculates5 the parity5
  function bit calc_parity5(int unsigned num_of_data_bits5=8,
                           bit[1:0] ParityMode5=0);
    bit temp_parity5;

    if (num_of_data_bits5 == 6)
      temp_parity5 = ^payload5[5:0];  
    else if (num_of_data_bits5 == 7)
      temp_parity5 = ^payload5[6:0];  
    else
      temp_parity5 = ^payload5;  

    case(ParityMode5[0])
      0: temp_parity5 = ~temp_parity5;
      1: temp_parity5 = temp_parity5;
    endcase
    case(ParityMode5[1])
      0: temp_parity5 = temp_parity5;
      1: temp_parity5 = ~ParityMode5[0];
    endcase
    if (parity_type5 == BAD_PARITY5)
      calc_parity5 = ~temp_parity5;
    else 
      calc_parity5 = temp_parity5;
  endfunction 

  // Parity5 is calculated5 in the post_randomize() method   //lab1_note55
  function void post_randomize();
   parity5 = calc_parity5();
  endfunction : post_randomize

endclass

`endif
