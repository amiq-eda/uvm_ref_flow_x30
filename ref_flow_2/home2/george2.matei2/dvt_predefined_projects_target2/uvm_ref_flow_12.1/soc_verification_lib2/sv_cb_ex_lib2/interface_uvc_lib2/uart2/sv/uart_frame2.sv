/*-------------------------------------------------------------------------
File2 name   : uart_frame2.sv
Title2       : TX2 frame2 file for uart2 uvc2
Project2     :
Created2     :
Description2 : Describes2 UART2 Transmit2 Frame2 data structure2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH2
`define UART_FRAME_SVH2

// Parity2 Type2 Control2 knob2
typedef enum bit {GOOD_PARITY2, BAD_PARITY2} parity_e2;

class uart_frame2 extends uvm_sequence_item;  //lab1_note12
  // UART2 Frame2
  rand bit start_bit2;
  rand bit [7:0] payload2;
  bit parity2;
  rand bit [1:0] stop_bits2;
  rand bit [3:0] error_bits2;
 
  // Control2 Knobs2
  rand parity_e2 parity_type2;
  rand int transmit_delay2;

  // Default constraints  //lab1_note22
  constraint default_txmit_delay2 {transmit_delay2 >= 0; transmit_delay2 < 20;}
  constraint default_start_bit2 { start_bit2 == 1'b0;}
  constraint default_stop_bits2 { stop_bits2 == 2'b11;}
  constraint default_parity_type2 { parity_type2==GOOD_PARITY2;}
  constraint default_error_bits2 { error_bits2 == 4'b0000;}

  // These2 declarations2 implement the create() and get_type_name() 
  // and enable automation2 of the uart_frame2's fields     //lab1_note32
  `uvm_object_utils_begin(uart_frame2)   
    `uvm_field_int(start_bit2, UVM_DEFAULT)
    `uvm_field_int(payload2, UVM_DEFAULT)  
    `uvm_field_int(parity2, UVM_DEFAULT)  
    `uvm_field_int(stop_bits2, UVM_DEFAULT)
    `uvm_field_int(error_bits2, UVM_DEFAULT)
    `uvm_field_enum(parity_e2,parity_type2, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay2, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor2 - required2 UVM syntax2  //lab1_note42
  function new(string name = "uart_frame2");
    super.new(name);
  endfunction 
   
  // This2 method calculates2 the parity2
  function bit calc_parity2(int unsigned num_of_data_bits2=8,
                           bit[1:0] ParityMode2=0);
    bit temp_parity2;

    if (num_of_data_bits2 == 6)
      temp_parity2 = ^payload2[5:0];  
    else if (num_of_data_bits2 == 7)
      temp_parity2 = ^payload2[6:0];  
    else
      temp_parity2 = ^payload2;  

    case(ParityMode2[0])
      0: temp_parity2 = ~temp_parity2;
      1: temp_parity2 = temp_parity2;
    endcase
    case(ParityMode2[1])
      0: temp_parity2 = temp_parity2;
      1: temp_parity2 = ~ParityMode2[0];
    endcase
    if (parity_type2 == BAD_PARITY2)
      calc_parity2 = ~temp_parity2;
    else 
      calc_parity2 = temp_parity2;
  endfunction 

  // Parity2 is calculated2 in the post_randomize() method   //lab1_note52
  function void post_randomize();
   parity2 = calc_parity2();
  endfunction : post_randomize

endclass

`endif
