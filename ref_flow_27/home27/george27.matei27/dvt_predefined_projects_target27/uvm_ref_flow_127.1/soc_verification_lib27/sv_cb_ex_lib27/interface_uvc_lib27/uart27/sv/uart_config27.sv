/*-------------------------------------------------------------------------
File27 name   : uart_config27.sv
Title27       : configuration file
Project27     :
Created27     :
Description27 : This27 file contains27 configuration information for the UART27
              device27
Notes27       :  
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV27
`define UART_CONFIG_SV27

class uart_config27 extends uvm_object;
  //UART27 topology parameters27
  uvm_active_passive_enum  is_tx_active27 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active27 = UVM_PASSIVE;

  // UART27 device27 parameters27
  rand bit [7:0]    baud_rate_gen27;  // Baud27 Rate27 Generator27 Register
  rand bit [7:0]    baud_rate_div27;  // Baud27 Rate27 Divider27 Register

  // Line27 Control27 Register Fields
  rand bit [1:0]    char_length27; // Character27 length (ua_lcr27[1:0])
  rand bit          nbstop27;        // Number27 stop bits (ua_lcr27[2])
  rand bit          parity_en27 ;    // Parity27 Enable27    (ua_lcr27[3])
  rand bit [1:0]    parity_mode27;   // Parity27 Mode27      (ua_lcr27[5:4])

  int unsigned chrl27;  
  int unsigned stop_bt27;  

  // Control27 Register Fields
  rand bit          cts_en27 ;
  rand bit          rts_en27 ;

 // Calculated27 in post_randomize() so not randomized27
  byte unsigned char_len_val27;      // (8, 7 or 6)
  byte unsigned stop_bit_val27;      // (1, 1.5 or 2)

  // These27 default constraints can be overriden27
  // Constrain27 configuration based on UVC27/RTL27 capabilities27
//  constraint c_num_stop_bits27  { nbstop27      inside {[0:1]};}
  constraint c_bgen27          { baud_rate_gen27       == 1;}
  constraint c_brgr27          { baud_rate_div27       == 0;}
  constraint c_rts_en27         { rts_en27      == 0;}
  constraint c_cts_en27         { cts_en27      == 0;}

  // These27 declarations27 implement the create() and get_type_name()
  // as well27 as enable automation27 of the tx_frame27's fields   
  `uvm_object_utils_begin(uart_config27)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active27, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active27, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen27, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div27, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length27, UVM_DEFAULT)
    `uvm_field_int(nbstop27, UVM_DEFAULT )  
    `uvm_field_int(parity_en27, UVM_DEFAULT)
    `uvm_field_int(parity_mode27, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This27 requires for registration27 of the ptp_tx_frame27   
  function new(string name = "uart_config27");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl27();
    ConvToIntStpBt27();
  endfunction 

  // Function27 to convert the 2 bit Character27 length to integer
  function void ConvToIntChrl27();
    case(char_length27)
      2'b00 : char_len_val27 = 5;
      2'b01 : char_len_val27 = 6;
      2'b10 : char_len_val27 = 7;
      2'b11 : char_len_val27 = 8;
      default : char_len_val27 = 8;
    endcase
  endfunction : ConvToIntChrl27
    
  // Function27 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt27();
    case(nbstop27)
      2'b00 : stop_bit_val27 = 1;
      2'b01 : stop_bit_val27 = 2;
      default : stop_bit_val27 = 2;
    endcase
  endfunction : ConvToIntStpBt27
    
endclass
`endif  // UART_CONFIG_SV27
