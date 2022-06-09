/*-------------------------------------------------------------------------
File10 name   : uart_config10.sv
Title10       : configuration file
Project10     :
Created10     :
Description10 : This10 file contains10 configuration information for the UART10
              device10
Notes10       :  
----------------------------------------------------------------------*/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV10
`define UART_CONFIG_SV10

class uart_config10 extends uvm_object;
  //UART10 topology parameters10
  uvm_active_passive_enum  is_tx_active10 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active10 = UVM_PASSIVE;

  // UART10 device10 parameters10
  rand bit [7:0]    baud_rate_gen10;  // Baud10 Rate10 Generator10 Register
  rand bit [7:0]    baud_rate_div10;  // Baud10 Rate10 Divider10 Register

  // Line10 Control10 Register Fields
  rand bit [1:0]    char_length10; // Character10 length (ua_lcr10[1:0])
  rand bit          nbstop10;        // Number10 stop bits (ua_lcr10[2])
  rand bit          parity_en10 ;    // Parity10 Enable10    (ua_lcr10[3])
  rand bit [1:0]    parity_mode10;   // Parity10 Mode10      (ua_lcr10[5:4])

  int unsigned chrl10;  
  int unsigned stop_bt10;  

  // Control10 Register Fields
  rand bit          cts_en10 ;
  rand bit          rts_en10 ;

 // Calculated10 in post_randomize() so not randomized10
  byte unsigned char_len_val10;      // (8, 7 or 6)
  byte unsigned stop_bit_val10;      // (1, 1.5 or 2)

  // These10 default constraints can be overriden10
  // Constrain10 configuration based on UVC10/RTL10 capabilities10
//  constraint c_num_stop_bits10  { nbstop10      inside {[0:1]};}
  constraint c_bgen10          { baud_rate_gen10       == 1;}
  constraint c_brgr10          { baud_rate_div10       == 0;}
  constraint c_rts_en10         { rts_en10      == 0;}
  constraint c_cts_en10         { cts_en10      == 0;}

  // These10 declarations10 implement the create() and get_type_name()
  // as well10 as enable automation10 of the tx_frame10's fields   
  `uvm_object_utils_begin(uart_config10)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active10, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active10, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen10, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div10, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length10, UVM_DEFAULT)
    `uvm_field_int(nbstop10, UVM_DEFAULT )  
    `uvm_field_int(parity_en10, UVM_DEFAULT)
    `uvm_field_int(parity_mode10, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This10 requires for registration10 of the ptp_tx_frame10   
  function new(string name = "uart_config10");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl10();
    ConvToIntStpBt10();
  endfunction 

  // Function10 to convert the 2 bit Character10 length to integer
  function void ConvToIntChrl10();
    case(char_length10)
      2'b00 : char_len_val10 = 5;
      2'b01 : char_len_val10 = 6;
      2'b10 : char_len_val10 = 7;
      2'b11 : char_len_val10 = 8;
      default : char_len_val10 = 8;
    endcase
  endfunction : ConvToIntChrl10
    
  // Function10 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt10();
    case(nbstop10)
      2'b00 : stop_bit_val10 = 1;
      2'b01 : stop_bit_val10 = 2;
      default : stop_bit_val10 = 2;
    endcase
  endfunction : ConvToIntStpBt10
    
endclass
`endif  // UART_CONFIG_SV10
