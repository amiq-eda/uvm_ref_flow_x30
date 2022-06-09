/*-------------------------------------------------------------------------
File15 name   : uart_config15.sv
Title15       : configuration file
Project15     :
Created15     :
Description15 : This15 file contains15 configuration information for the UART15
              device15
Notes15       :  
----------------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV15
`define UART_CONFIG_SV15

class uart_config15 extends uvm_object;
  //UART15 topology parameters15
  uvm_active_passive_enum  is_tx_active15 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active15 = UVM_PASSIVE;

  // UART15 device15 parameters15
  rand bit [7:0]    baud_rate_gen15;  // Baud15 Rate15 Generator15 Register
  rand bit [7:0]    baud_rate_div15;  // Baud15 Rate15 Divider15 Register

  // Line15 Control15 Register Fields
  rand bit [1:0]    char_length15; // Character15 length (ua_lcr15[1:0])
  rand bit          nbstop15;        // Number15 stop bits (ua_lcr15[2])
  rand bit          parity_en15 ;    // Parity15 Enable15    (ua_lcr15[3])
  rand bit [1:0]    parity_mode15;   // Parity15 Mode15      (ua_lcr15[5:4])

  int unsigned chrl15;  
  int unsigned stop_bt15;  

  // Control15 Register Fields
  rand bit          cts_en15 ;
  rand bit          rts_en15 ;

 // Calculated15 in post_randomize() so not randomized15
  byte unsigned char_len_val15;      // (8, 7 or 6)
  byte unsigned stop_bit_val15;      // (1, 1.5 or 2)

  // These15 default constraints can be overriden15
  // Constrain15 configuration based on UVC15/RTL15 capabilities15
//  constraint c_num_stop_bits15  { nbstop15      inside {[0:1]};}
  constraint c_bgen15          { baud_rate_gen15       == 1;}
  constraint c_brgr15          { baud_rate_div15       == 0;}
  constraint c_rts_en15         { rts_en15      == 0;}
  constraint c_cts_en15         { cts_en15      == 0;}

  // These15 declarations15 implement the create() and get_type_name()
  // as well15 as enable automation15 of the tx_frame15's fields   
  `uvm_object_utils_begin(uart_config15)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active15, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active15, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen15, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div15, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length15, UVM_DEFAULT)
    `uvm_field_int(nbstop15, UVM_DEFAULT )  
    `uvm_field_int(parity_en15, UVM_DEFAULT)
    `uvm_field_int(parity_mode15, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This15 requires for registration15 of the ptp_tx_frame15   
  function new(string name = "uart_config15");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl15();
    ConvToIntStpBt15();
  endfunction 

  // Function15 to convert the 2 bit Character15 length to integer
  function void ConvToIntChrl15();
    case(char_length15)
      2'b00 : char_len_val15 = 5;
      2'b01 : char_len_val15 = 6;
      2'b10 : char_len_val15 = 7;
      2'b11 : char_len_val15 = 8;
      default : char_len_val15 = 8;
    endcase
  endfunction : ConvToIntChrl15
    
  // Function15 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt15();
    case(nbstop15)
      2'b00 : stop_bit_val15 = 1;
      2'b01 : stop_bit_val15 = 2;
      default : stop_bit_val15 = 2;
    endcase
  endfunction : ConvToIntStpBt15
    
endclass
`endif  // UART_CONFIG_SV15
