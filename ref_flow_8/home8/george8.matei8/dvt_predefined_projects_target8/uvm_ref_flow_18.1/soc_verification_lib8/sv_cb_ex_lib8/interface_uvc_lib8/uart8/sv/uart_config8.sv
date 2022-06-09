/*-------------------------------------------------------------------------
File8 name   : uart_config8.sv
Title8       : configuration file
Project8     :
Created8     :
Description8 : This8 file contains8 configuration information for the UART8
              device8
Notes8       :  
----------------------------------------------------------------------*/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV8
`define UART_CONFIG_SV8

class uart_config8 extends uvm_object;
  //UART8 topology parameters8
  uvm_active_passive_enum  is_tx_active8 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active8 = UVM_PASSIVE;

  // UART8 device8 parameters8
  rand bit [7:0]    baud_rate_gen8;  // Baud8 Rate8 Generator8 Register
  rand bit [7:0]    baud_rate_div8;  // Baud8 Rate8 Divider8 Register

  // Line8 Control8 Register Fields
  rand bit [1:0]    char_length8; // Character8 length (ua_lcr8[1:0])
  rand bit          nbstop8;        // Number8 stop bits (ua_lcr8[2])
  rand bit          parity_en8 ;    // Parity8 Enable8    (ua_lcr8[3])
  rand bit [1:0]    parity_mode8;   // Parity8 Mode8      (ua_lcr8[5:4])

  int unsigned chrl8;  
  int unsigned stop_bt8;  

  // Control8 Register Fields
  rand bit          cts_en8 ;
  rand bit          rts_en8 ;

 // Calculated8 in post_randomize() so not randomized8
  byte unsigned char_len_val8;      // (8, 7 or 6)
  byte unsigned stop_bit_val8;      // (1, 1.5 or 2)

  // These8 default constraints can be overriden8
  // Constrain8 configuration based on UVC8/RTL8 capabilities8
//  constraint c_num_stop_bits8  { nbstop8      inside {[0:1]};}
  constraint c_bgen8          { baud_rate_gen8       == 1;}
  constraint c_brgr8          { baud_rate_div8       == 0;}
  constraint c_rts_en8         { rts_en8      == 0;}
  constraint c_cts_en8         { cts_en8      == 0;}

  // These8 declarations8 implement the create() and get_type_name()
  // as well8 as enable automation8 of the tx_frame8's fields   
  `uvm_object_utils_begin(uart_config8)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active8, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active8, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen8, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div8, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length8, UVM_DEFAULT)
    `uvm_field_int(nbstop8, UVM_DEFAULT )  
    `uvm_field_int(parity_en8, UVM_DEFAULT)
    `uvm_field_int(parity_mode8, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This8 requires for registration8 of the ptp_tx_frame8   
  function new(string name = "uart_config8");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl8();
    ConvToIntStpBt8();
  endfunction 

  // Function8 to convert the 2 bit Character8 length to integer
  function void ConvToIntChrl8();
    case(char_length8)
      2'b00 : char_len_val8 = 5;
      2'b01 : char_len_val8 = 6;
      2'b10 : char_len_val8 = 7;
      2'b11 : char_len_val8 = 8;
      default : char_len_val8 = 8;
    endcase
  endfunction : ConvToIntChrl8
    
  // Function8 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt8();
    case(nbstop8)
      2'b00 : stop_bit_val8 = 1;
      2'b01 : stop_bit_val8 = 2;
      default : stop_bit_val8 = 2;
    endcase
  endfunction : ConvToIntStpBt8
    
endclass
`endif  // UART_CONFIG_SV8
