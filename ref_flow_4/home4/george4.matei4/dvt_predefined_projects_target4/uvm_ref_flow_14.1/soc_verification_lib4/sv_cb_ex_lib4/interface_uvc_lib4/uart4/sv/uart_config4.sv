/*-------------------------------------------------------------------------
File4 name   : uart_config4.sv
Title4       : configuration file
Project4     :
Created4     :
Description4 : This4 file contains4 configuration information for the UART4
              device4
Notes4       :  
----------------------------------------------------------------------*/
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV4
`define UART_CONFIG_SV4

class uart_config4 extends uvm_object;
  //UART4 topology parameters4
  uvm_active_passive_enum  is_tx_active4 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active4 = UVM_PASSIVE;

  // UART4 device4 parameters4
  rand bit [7:0]    baud_rate_gen4;  // Baud4 Rate4 Generator4 Register
  rand bit [7:0]    baud_rate_div4;  // Baud4 Rate4 Divider4 Register

  // Line4 Control4 Register Fields
  rand bit [1:0]    char_length4; // Character4 length (ua_lcr4[1:0])
  rand bit          nbstop4;        // Number4 stop bits (ua_lcr4[2])
  rand bit          parity_en4 ;    // Parity4 Enable4    (ua_lcr4[3])
  rand bit [1:0]    parity_mode4;   // Parity4 Mode4      (ua_lcr4[5:4])

  int unsigned chrl4;  
  int unsigned stop_bt4;  

  // Control4 Register Fields
  rand bit          cts_en4 ;
  rand bit          rts_en4 ;

 // Calculated4 in post_randomize() so not randomized4
  byte unsigned char_len_val4;      // (8, 7 or 6)
  byte unsigned stop_bit_val4;      // (1, 1.5 or 2)

  // These4 default constraints can be overriden4
  // Constrain4 configuration based on UVC4/RTL4 capabilities4
//  constraint c_num_stop_bits4  { nbstop4      inside {[0:1]};}
  constraint c_bgen4          { baud_rate_gen4       == 1;}
  constraint c_brgr4          { baud_rate_div4       == 0;}
  constraint c_rts_en4         { rts_en4      == 0;}
  constraint c_cts_en4         { cts_en4      == 0;}

  // These4 declarations4 implement the create() and get_type_name()
  // as well4 as enable automation4 of the tx_frame4's fields   
  `uvm_object_utils_begin(uart_config4)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active4, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active4, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen4, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div4, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length4, UVM_DEFAULT)
    `uvm_field_int(nbstop4, UVM_DEFAULT )  
    `uvm_field_int(parity_en4, UVM_DEFAULT)
    `uvm_field_int(parity_mode4, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This4 requires for registration4 of the ptp_tx_frame4   
  function new(string name = "uart_config4");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl4();
    ConvToIntStpBt4();
  endfunction 

  // Function4 to convert the 2 bit Character4 length to integer
  function void ConvToIntChrl4();
    case(char_length4)
      2'b00 : char_len_val4 = 5;
      2'b01 : char_len_val4 = 6;
      2'b10 : char_len_val4 = 7;
      2'b11 : char_len_val4 = 8;
      default : char_len_val4 = 8;
    endcase
  endfunction : ConvToIntChrl4
    
  // Function4 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt4();
    case(nbstop4)
      2'b00 : stop_bit_val4 = 1;
      2'b01 : stop_bit_val4 = 2;
      default : stop_bit_val4 = 2;
    endcase
  endfunction : ConvToIntStpBt4
    
endclass
`endif  // UART_CONFIG_SV4
