/*-------------------------------------------------------------------------
File26 name   : uart_config26.sv
Title26       : configuration file
Project26     :
Created26     :
Description26 : This26 file contains26 configuration information for the UART26
              device26
Notes26       :  
----------------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV26
`define UART_CONFIG_SV26

class uart_config26 extends uvm_object;
  //UART26 topology parameters26
  uvm_active_passive_enum  is_tx_active26 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active26 = UVM_PASSIVE;

  // UART26 device26 parameters26
  rand bit [7:0]    baud_rate_gen26;  // Baud26 Rate26 Generator26 Register
  rand bit [7:0]    baud_rate_div26;  // Baud26 Rate26 Divider26 Register

  // Line26 Control26 Register Fields
  rand bit [1:0]    char_length26; // Character26 length (ua_lcr26[1:0])
  rand bit          nbstop26;        // Number26 stop bits (ua_lcr26[2])
  rand bit          parity_en26 ;    // Parity26 Enable26    (ua_lcr26[3])
  rand bit [1:0]    parity_mode26;   // Parity26 Mode26      (ua_lcr26[5:4])

  int unsigned chrl26;  
  int unsigned stop_bt26;  

  // Control26 Register Fields
  rand bit          cts_en26 ;
  rand bit          rts_en26 ;

 // Calculated26 in post_randomize() so not randomized26
  byte unsigned char_len_val26;      // (8, 7 or 6)
  byte unsigned stop_bit_val26;      // (1, 1.5 or 2)

  // These26 default constraints can be overriden26
  // Constrain26 configuration based on UVC26/RTL26 capabilities26
//  constraint c_num_stop_bits26  { nbstop26      inside {[0:1]};}
  constraint c_bgen26          { baud_rate_gen26       == 1;}
  constraint c_brgr26          { baud_rate_div26       == 0;}
  constraint c_rts_en26         { rts_en26      == 0;}
  constraint c_cts_en26         { cts_en26      == 0;}

  // These26 declarations26 implement the create() and get_type_name()
  // as well26 as enable automation26 of the tx_frame26's fields   
  `uvm_object_utils_begin(uart_config26)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active26, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active26, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen26, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div26, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length26, UVM_DEFAULT)
    `uvm_field_int(nbstop26, UVM_DEFAULT )  
    `uvm_field_int(parity_en26, UVM_DEFAULT)
    `uvm_field_int(parity_mode26, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This26 requires for registration26 of the ptp_tx_frame26   
  function new(string name = "uart_config26");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl26();
    ConvToIntStpBt26();
  endfunction 

  // Function26 to convert the 2 bit Character26 length to integer
  function void ConvToIntChrl26();
    case(char_length26)
      2'b00 : char_len_val26 = 5;
      2'b01 : char_len_val26 = 6;
      2'b10 : char_len_val26 = 7;
      2'b11 : char_len_val26 = 8;
      default : char_len_val26 = 8;
    endcase
  endfunction : ConvToIntChrl26
    
  // Function26 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt26();
    case(nbstop26)
      2'b00 : stop_bit_val26 = 1;
      2'b01 : stop_bit_val26 = 2;
      default : stop_bit_val26 = 2;
    endcase
  endfunction : ConvToIntStpBt26
    
endclass
`endif  // UART_CONFIG_SV26
