/*-------------------------------------------------------------------------
File30 name   : uart_config30.sv
Title30       : configuration file
Project30     :
Created30     :
Description30 : This30 file contains30 configuration information for the UART30
              device30
Notes30       :  
----------------------------------------------------------------------*/
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV30
`define UART_CONFIG_SV30

class uart_config30 extends uvm_object;
  //UART30 topology parameters30
  uvm_active_passive_enum  is_tx_active30 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active30 = UVM_PASSIVE;

  // UART30 device30 parameters30
  rand bit [7:0]    baud_rate_gen30;  // Baud30 Rate30 Generator30 Register
  rand bit [7:0]    baud_rate_div30;  // Baud30 Rate30 Divider30 Register

  // Line30 Control30 Register Fields
  rand bit [1:0]    char_length30; // Character30 length (ua_lcr30[1:0])
  rand bit          nbstop30;        // Number30 stop bits (ua_lcr30[2])
  rand bit          parity_en30 ;    // Parity30 Enable30    (ua_lcr30[3])
  rand bit [1:0]    parity_mode30;   // Parity30 Mode30      (ua_lcr30[5:4])

  int unsigned chrl30;  
  int unsigned stop_bt30;  

  // Control30 Register Fields
  rand bit          cts_en30 ;
  rand bit          rts_en30 ;

 // Calculated30 in post_randomize() so not randomized30
  byte unsigned char_len_val30;      // (8, 7 or 6)
  byte unsigned stop_bit_val30;      // (1, 1.5 or 2)

  // These30 default constraints can be overriden30
  // Constrain30 configuration based on UVC30/RTL30 capabilities30
//  constraint c_num_stop_bits30  { nbstop30      inside {[0:1]};}
  constraint c_bgen30          { baud_rate_gen30       == 1;}
  constraint c_brgr30          { baud_rate_div30       == 0;}
  constraint c_rts_en30         { rts_en30      == 0;}
  constraint c_cts_en30         { cts_en30      == 0;}

  // These30 declarations30 implement the create() and get_type_name()
  // as well30 as enable automation30 of the tx_frame30's fields   
  `uvm_object_utils_begin(uart_config30)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active30, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active30, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen30, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div30, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length30, UVM_DEFAULT)
    `uvm_field_int(nbstop30, UVM_DEFAULT )  
    `uvm_field_int(parity_en30, UVM_DEFAULT)
    `uvm_field_int(parity_mode30, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This30 requires for registration30 of the ptp_tx_frame30   
  function new(string name = "uart_config30");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl30();
    ConvToIntStpBt30();
  endfunction 

  // Function30 to convert the 2 bit Character30 length to integer
  function void ConvToIntChrl30();
    case(char_length30)
      2'b00 : char_len_val30 = 5;
      2'b01 : char_len_val30 = 6;
      2'b10 : char_len_val30 = 7;
      2'b11 : char_len_val30 = 8;
      default : char_len_val30 = 8;
    endcase
  endfunction : ConvToIntChrl30
    
  // Function30 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt30();
    case(nbstop30)
      2'b00 : stop_bit_val30 = 1;
      2'b01 : stop_bit_val30 = 2;
      default : stop_bit_val30 = 2;
    endcase
  endfunction : ConvToIntStpBt30
    
endclass
`endif  // UART_CONFIG_SV30
