/*-------------------------------------------------------------------------
File25 name   : uart_config25.sv
Title25       : configuration file
Project25     :
Created25     :
Description25 : This25 file contains25 configuration information for the UART25
              device25
Notes25       :  
----------------------------------------------------------------------*/
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV25
`define UART_CONFIG_SV25

class uart_config25 extends uvm_object;
  //UART25 topology parameters25
  uvm_active_passive_enum  is_tx_active25 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active25 = UVM_PASSIVE;

  // UART25 device25 parameters25
  rand bit [7:0]    baud_rate_gen25;  // Baud25 Rate25 Generator25 Register
  rand bit [7:0]    baud_rate_div25;  // Baud25 Rate25 Divider25 Register

  // Line25 Control25 Register Fields
  rand bit [1:0]    char_length25; // Character25 length (ua_lcr25[1:0])
  rand bit          nbstop25;        // Number25 stop bits (ua_lcr25[2])
  rand bit          parity_en25 ;    // Parity25 Enable25    (ua_lcr25[3])
  rand bit [1:0]    parity_mode25;   // Parity25 Mode25      (ua_lcr25[5:4])

  int unsigned chrl25;  
  int unsigned stop_bt25;  

  // Control25 Register Fields
  rand bit          cts_en25 ;
  rand bit          rts_en25 ;

 // Calculated25 in post_randomize() so not randomized25
  byte unsigned char_len_val25;      // (8, 7 or 6)
  byte unsigned stop_bit_val25;      // (1, 1.5 or 2)

  // These25 default constraints can be overriden25
  // Constrain25 configuration based on UVC25/RTL25 capabilities25
//  constraint c_num_stop_bits25  { nbstop25      inside {[0:1]};}
  constraint c_bgen25          { baud_rate_gen25       == 1;}
  constraint c_brgr25          { baud_rate_div25       == 0;}
  constraint c_rts_en25         { rts_en25      == 0;}
  constraint c_cts_en25         { cts_en25      == 0;}

  // These25 declarations25 implement the create() and get_type_name()
  // as well25 as enable automation25 of the tx_frame25's fields   
  `uvm_object_utils_begin(uart_config25)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active25, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active25, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen25, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div25, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length25, UVM_DEFAULT)
    `uvm_field_int(nbstop25, UVM_DEFAULT )  
    `uvm_field_int(parity_en25, UVM_DEFAULT)
    `uvm_field_int(parity_mode25, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This25 requires for registration25 of the ptp_tx_frame25   
  function new(string name = "uart_config25");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl25();
    ConvToIntStpBt25();
  endfunction 

  // Function25 to convert the 2 bit Character25 length to integer
  function void ConvToIntChrl25();
    case(char_length25)
      2'b00 : char_len_val25 = 5;
      2'b01 : char_len_val25 = 6;
      2'b10 : char_len_val25 = 7;
      2'b11 : char_len_val25 = 8;
      default : char_len_val25 = 8;
    endcase
  endfunction : ConvToIntChrl25
    
  // Function25 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt25();
    case(nbstop25)
      2'b00 : stop_bit_val25 = 1;
      2'b01 : stop_bit_val25 = 2;
      default : stop_bit_val25 = 2;
    endcase
  endfunction : ConvToIntStpBt25
    
endclass
`endif  // UART_CONFIG_SV25
