/*-------------------------------------------------------------------------
File9 name   : uart_config9.sv
Title9       : configuration file
Project9     :
Created9     :
Description9 : This9 file contains9 configuration information for the UART9
              device9
Notes9       :  
----------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV9
`define UART_CONFIG_SV9

class uart_config9 extends uvm_object;
  //UART9 topology parameters9
  uvm_active_passive_enum  is_tx_active9 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active9 = UVM_PASSIVE;

  // UART9 device9 parameters9
  rand bit [7:0]    baud_rate_gen9;  // Baud9 Rate9 Generator9 Register
  rand bit [7:0]    baud_rate_div9;  // Baud9 Rate9 Divider9 Register

  // Line9 Control9 Register Fields
  rand bit [1:0]    char_length9; // Character9 length (ua_lcr9[1:0])
  rand bit          nbstop9;        // Number9 stop bits (ua_lcr9[2])
  rand bit          parity_en9 ;    // Parity9 Enable9    (ua_lcr9[3])
  rand bit [1:0]    parity_mode9;   // Parity9 Mode9      (ua_lcr9[5:4])

  int unsigned chrl9;  
  int unsigned stop_bt9;  

  // Control9 Register Fields
  rand bit          cts_en9 ;
  rand bit          rts_en9 ;

 // Calculated9 in post_randomize() so not randomized9
  byte unsigned char_len_val9;      // (8, 7 or 6)
  byte unsigned stop_bit_val9;      // (1, 1.5 or 2)

  // These9 default constraints can be overriden9
  // Constrain9 configuration based on UVC9/RTL9 capabilities9
//  constraint c_num_stop_bits9  { nbstop9      inside {[0:1]};}
  constraint c_bgen9          { baud_rate_gen9       == 1;}
  constraint c_brgr9          { baud_rate_div9       == 0;}
  constraint c_rts_en9         { rts_en9      == 0;}
  constraint c_cts_en9         { cts_en9      == 0;}

  // These9 declarations9 implement the create() and get_type_name()
  // as well9 as enable automation9 of the tx_frame9's fields   
  `uvm_object_utils_begin(uart_config9)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active9, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active9, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen9, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div9, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length9, UVM_DEFAULT)
    `uvm_field_int(nbstop9, UVM_DEFAULT )  
    `uvm_field_int(parity_en9, UVM_DEFAULT)
    `uvm_field_int(parity_mode9, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This9 requires for registration9 of the ptp_tx_frame9   
  function new(string name = "uart_config9");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl9();
    ConvToIntStpBt9();
  endfunction 

  // Function9 to convert the 2 bit Character9 length to integer
  function void ConvToIntChrl9();
    case(char_length9)
      2'b00 : char_len_val9 = 5;
      2'b01 : char_len_val9 = 6;
      2'b10 : char_len_val9 = 7;
      2'b11 : char_len_val9 = 8;
      default : char_len_val9 = 8;
    endcase
  endfunction : ConvToIntChrl9
    
  // Function9 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt9();
    case(nbstop9)
      2'b00 : stop_bit_val9 = 1;
      2'b01 : stop_bit_val9 = 2;
      default : stop_bit_val9 = 2;
    endcase
  endfunction : ConvToIntStpBt9
    
endclass
`endif  // UART_CONFIG_SV9
