/*-------------------------------------------------------------------------
File22 name   : uart_config22.sv
Title22       : configuration file
Project22     :
Created22     :
Description22 : This22 file contains22 configuration information for the UART22
              device22
Notes22       :  
----------------------------------------------------------------------*/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV22
`define UART_CONFIG_SV22

class uart_config22 extends uvm_object;
  //UART22 topology parameters22
  uvm_active_passive_enum  is_tx_active22 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active22 = UVM_PASSIVE;

  // UART22 device22 parameters22
  rand bit [7:0]    baud_rate_gen22;  // Baud22 Rate22 Generator22 Register
  rand bit [7:0]    baud_rate_div22;  // Baud22 Rate22 Divider22 Register

  // Line22 Control22 Register Fields
  rand bit [1:0]    char_length22; // Character22 length (ua_lcr22[1:0])
  rand bit          nbstop22;        // Number22 stop bits (ua_lcr22[2])
  rand bit          parity_en22 ;    // Parity22 Enable22    (ua_lcr22[3])
  rand bit [1:0]    parity_mode22;   // Parity22 Mode22      (ua_lcr22[5:4])

  int unsigned chrl22;  
  int unsigned stop_bt22;  

  // Control22 Register Fields
  rand bit          cts_en22 ;
  rand bit          rts_en22 ;

 // Calculated22 in post_randomize() so not randomized22
  byte unsigned char_len_val22;      // (8, 7 or 6)
  byte unsigned stop_bit_val22;      // (1, 1.5 or 2)

  // These22 default constraints can be overriden22
  // Constrain22 configuration based on UVC22/RTL22 capabilities22
//  constraint c_num_stop_bits22  { nbstop22      inside {[0:1]};}
  constraint c_bgen22          { baud_rate_gen22       == 1;}
  constraint c_brgr22          { baud_rate_div22       == 0;}
  constraint c_rts_en22         { rts_en22      == 0;}
  constraint c_cts_en22         { cts_en22      == 0;}

  // These22 declarations22 implement the create() and get_type_name()
  // as well22 as enable automation22 of the tx_frame22's fields   
  `uvm_object_utils_begin(uart_config22)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active22, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active22, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen22, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div22, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length22, UVM_DEFAULT)
    `uvm_field_int(nbstop22, UVM_DEFAULT )  
    `uvm_field_int(parity_en22, UVM_DEFAULT)
    `uvm_field_int(parity_mode22, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This22 requires for registration22 of the ptp_tx_frame22   
  function new(string name = "uart_config22");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl22();
    ConvToIntStpBt22();
  endfunction 

  // Function22 to convert the 2 bit Character22 length to integer
  function void ConvToIntChrl22();
    case(char_length22)
      2'b00 : char_len_val22 = 5;
      2'b01 : char_len_val22 = 6;
      2'b10 : char_len_val22 = 7;
      2'b11 : char_len_val22 = 8;
      default : char_len_val22 = 8;
    endcase
  endfunction : ConvToIntChrl22
    
  // Function22 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt22();
    case(nbstop22)
      2'b00 : stop_bit_val22 = 1;
      2'b01 : stop_bit_val22 = 2;
      default : stop_bit_val22 = 2;
    endcase
  endfunction : ConvToIntStpBt22
    
endclass
`endif  // UART_CONFIG_SV22
