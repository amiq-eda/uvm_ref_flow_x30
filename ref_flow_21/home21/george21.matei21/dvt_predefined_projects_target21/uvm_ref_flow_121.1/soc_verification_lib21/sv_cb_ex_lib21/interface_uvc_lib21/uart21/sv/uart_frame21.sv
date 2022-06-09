/*-------------------------------------------------------------------------
File21 name   : uart_frame21.sv
Title21       : TX21 frame21 file for uart21 uvc21
Project21     :
Created21     :
Description21 : Describes21 UART21 Transmit21 Frame21 data structure21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_FRAME_SVH21
`define UART_FRAME_SVH21

// Parity21 Type21 Control21 knob21
typedef enum bit {GOOD_PARITY21, BAD_PARITY21} parity_e21;

class uart_frame21 extends uvm_sequence_item;  //lab1_note121
  // UART21 Frame21
  rand bit start_bit21;
  rand bit [7:0] payload21;
  bit parity21;
  rand bit [1:0] stop_bits21;
  rand bit [3:0] error_bits21;
 
  // Control21 Knobs21
  rand parity_e21 parity_type21;
  rand int transmit_delay21;

  // Default constraints  //lab1_note221
  constraint default_txmit_delay21 {transmit_delay21 >= 0; transmit_delay21 < 20;}
  constraint default_start_bit21 { start_bit21 == 1'b0;}
  constraint default_stop_bits21 { stop_bits21 == 2'b11;}
  constraint default_parity_type21 { parity_type21==GOOD_PARITY21;}
  constraint default_error_bits21 { error_bits21 == 4'b0000;}

  // These21 declarations21 implement the create() and get_type_name() 
  // and enable automation21 of the uart_frame21's fields     //lab1_note321
  `uvm_object_utils_begin(uart_frame21)   
    `uvm_field_int(start_bit21, UVM_DEFAULT)
    `uvm_field_int(payload21, UVM_DEFAULT)  
    `uvm_field_int(parity21, UVM_DEFAULT)  
    `uvm_field_int(stop_bits21, UVM_DEFAULT)
    `uvm_field_int(error_bits21, UVM_DEFAULT)
    `uvm_field_enum(parity_e21,parity_type21, UVM_DEFAULT + UVM_NOCOMPARE) 
    `uvm_field_int(transmit_delay21, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor21 - required21 UVM syntax21  //lab1_note421
  function new(string name = "uart_frame21");
    super.new(name);
  endfunction 
   
  // This21 method calculates21 the parity21
  function bit calc_parity21(int unsigned num_of_data_bits21=8,
                           bit[1:0] ParityMode21=0);
    bit temp_parity21;

    if (num_of_data_bits21 == 6)
      temp_parity21 = ^payload21[5:0];  
    else if (num_of_data_bits21 == 7)
      temp_parity21 = ^payload21[6:0];  
    else
      temp_parity21 = ^payload21;  

    case(ParityMode21[0])
      0: temp_parity21 = ~temp_parity21;
      1: temp_parity21 = temp_parity21;
    endcase
    case(ParityMode21[1])
      0: temp_parity21 = temp_parity21;
      1: temp_parity21 = ~ParityMode21[0];
    endcase
    if (parity_type21 == BAD_PARITY21)
      calc_parity21 = ~temp_parity21;
    else 
      calc_parity21 = temp_parity21;
  endfunction 

  // Parity21 is calculated21 in the post_randomize() method   //lab1_note521
  function void post_randomize();
   parity21 = calc_parity21();
  endfunction : post_randomize

endclass

`endif
