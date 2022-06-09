/*-------------------------------------------------------------------------
File20 name   : uart_config20.sv
Title20       : configuration file
Project20     :
Created20     :
Description20 : This20 file contains20 configuration information for the UART20
              device20
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


`ifndef UART_CONFIG_SV20
`define UART_CONFIG_SV20

class uart_config20 extends uvm_object;
  //UART20 topology parameters20
  uvm_active_passive_enum  is_tx_active20 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active20 = UVM_PASSIVE;

  // UART20 device20 parameters20
  rand bit [7:0]    baud_rate_gen20;  // Baud20 Rate20 Generator20 Register
  rand bit [7:0]    baud_rate_div20;  // Baud20 Rate20 Divider20 Register

  // Line20 Control20 Register Fields
  rand bit [1:0]    char_length20; // Character20 length (ua_lcr20[1:0])
  rand bit          nbstop20;        // Number20 stop bits (ua_lcr20[2])
  rand bit          parity_en20 ;    // Parity20 Enable20    (ua_lcr20[3])
  rand bit [1:0]    parity_mode20;   // Parity20 Mode20      (ua_lcr20[5:4])

  int unsigned chrl20;  
  int unsigned stop_bt20;  

  // Control20 Register Fields
  rand bit          cts_en20 ;
  rand bit          rts_en20 ;

 // Calculated20 in post_randomize() so not randomized20
  byte unsigned char_len_val20;      // (8, 7 or 6)
  byte unsigned stop_bit_val20;      // (1, 1.5 or 2)

  // These20 default constraints can be overriden20
  // Constrain20 configuration based on UVC20/RTL20 capabilities20
//  constraint c_num_stop_bits20  { nbstop20      inside {[0:1]};}
  constraint c_bgen20          { baud_rate_gen20       == 1;}
  constraint c_brgr20          { baud_rate_div20       == 0;}
  constraint c_rts_en20         { rts_en20      == 0;}
  constraint c_cts_en20         { cts_en20      == 0;}

  // These20 declarations20 implement the create() and get_type_name()
  // as well20 as enable automation20 of the tx_frame20's fields   
  `uvm_object_utils_begin(uart_config20)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active20, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active20, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen20, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div20, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length20, UVM_DEFAULT)
    `uvm_field_int(nbstop20, UVM_DEFAULT )  
    `uvm_field_int(parity_en20, UVM_DEFAULT)
    `uvm_field_int(parity_mode20, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This20 requires for registration20 of the ptp_tx_frame20   
  function new(string name = "uart_config20");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl20();
    ConvToIntStpBt20();
  endfunction 

  // Function20 to convert the 2 bit Character20 length to integer
  function void ConvToIntChrl20();
    case(char_length20)
      2'b00 : char_len_val20 = 5;
      2'b01 : char_len_val20 = 6;
      2'b10 : char_len_val20 = 7;
      2'b11 : char_len_val20 = 8;
      default : char_len_val20 = 8;
    endcase
  endfunction : ConvToIntChrl20
    
  // Function20 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt20();
    case(nbstop20)
      2'b00 : stop_bit_val20 = 1;
      2'b01 : stop_bit_val20 = 2;
      default : stop_bit_val20 = 2;
    endcase
  endfunction : ConvToIntStpBt20
    
endclass
`endif  // UART_CONFIG_SV20
