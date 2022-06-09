/*-------------------------------------------------------------------------
File14 name   : uart_config14.sv
Title14       : configuration file
Project14     :
Created14     :
Description14 : This14 file contains14 configuration information for the UART14
              device14
Notes14       :  
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV14
`define UART_CONFIG_SV14

class uart_config14 extends uvm_object;
  //UART14 topology parameters14
  uvm_active_passive_enum  is_tx_active14 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active14 = UVM_PASSIVE;

  // UART14 device14 parameters14
  rand bit [7:0]    baud_rate_gen14;  // Baud14 Rate14 Generator14 Register
  rand bit [7:0]    baud_rate_div14;  // Baud14 Rate14 Divider14 Register

  // Line14 Control14 Register Fields
  rand bit [1:0]    char_length14; // Character14 length (ua_lcr14[1:0])
  rand bit          nbstop14;        // Number14 stop bits (ua_lcr14[2])
  rand bit          parity_en14 ;    // Parity14 Enable14    (ua_lcr14[3])
  rand bit [1:0]    parity_mode14;   // Parity14 Mode14      (ua_lcr14[5:4])

  int unsigned chrl14;  
  int unsigned stop_bt14;  

  // Control14 Register Fields
  rand bit          cts_en14 ;
  rand bit          rts_en14 ;

 // Calculated14 in post_randomize() so not randomized14
  byte unsigned char_len_val14;      // (8, 7 or 6)
  byte unsigned stop_bit_val14;      // (1, 1.5 or 2)

  // These14 default constraints can be overriden14
  // Constrain14 configuration based on UVC14/RTL14 capabilities14
//  constraint c_num_stop_bits14  { nbstop14      inside {[0:1]};}
  constraint c_bgen14          { baud_rate_gen14       == 1;}
  constraint c_brgr14          { baud_rate_div14       == 0;}
  constraint c_rts_en14         { rts_en14      == 0;}
  constraint c_cts_en14         { cts_en14      == 0;}

  // These14 declarations14 implement the create() and get_type_name()
  // as well14 as enable automation14 of the tx_frame14's fields   
  `uvm_object_utils_begin(uart_config14)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active14, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active14, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen14, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div14, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length14, UVM_DEFAULT)
    `uvm_field_int(nbstop14, UVM_DEFAULT )  
    `uvm_field_int(parity_en14, UVM_DEFAULT)
    `uvm_field_int(parity_mode14, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This14 requires for registration14 of the ptp_tx_frame14   
  function new(string name = "uart_config14");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl14();
    ConvToIntStpBt14();
  endfunction 

  // Function14 to convert the 2 bit Character14 length to integer
  function void ConvToIntChrl14();
    case(char_length14)
      2'b00 : char_len_val14 = 5;
      2'b01 : char_len_val14 = 6;
      2'b10 : char_len_val14 = 7;
      2'b11 : char_len_val14 = 8;
      default : char_len_val14 = 8;
    endcase
  endfunction : ConvToIntChrl14
    
  // Function14 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt14();
    case(nbstop14)
      2'b00 : stop_bit_val14 = 1;
      2'b01 : stop_bit_val14 = 2;
      default : stop_bit_val14 = 2;
    endcase
  endfunction : ConvToIntStpBt14
    
endclass
`endif  // UART_CONFIG_SV14
