/*-------------------------------------------------------------------------
File16 name   : uart_config16.sv
Title16       : configuration file
Project16     :
Created16     :
Description16 : This16 file contains16 configuration information for the UART16
              device16
Notes16       :  
----------------------------------------------------------------------*/
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV16
`define UART_CONFIG_SV16

class uart_config16 extends uvm_object;
  //UART16 topology parameters16
  uvm_active_passive_enum  is_tx_active16 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active16 = UVM_PASSIVE;

  // UART16 device16 parameters16
  rand bit [7:0]    baud_rate_gen16;  // Baud16 Rate16 Generator16 Register
  rand bit [7:0]    baud_rate_div16;  // Baud16 Rate16 Divider16 Register

  // Line16 Control16 Register Fields
  rand bit [1:0]    char_length16; // Character16 length (ua_lcr16[1:0])
  rand bit          nbstop16;        // Number16 stop bits (ua_lcr16[2])
  rand bit          parity_en16 ;    // Parity16 Enable16    (ua_lcr16[3])
  rand bit [1:0]    parity_mode16;   // Parity16 Mode16      (ua_lcr16[5:4])

  int unsigned chrl16;  
  int unsigned stop_bt16;  

  // Control16 Register Fields
  rand bit          cts_en16 ;
  rand bit          rts_en16 ;

 // Calculated16 in post_randomize() so not randomized16
  byte unsigned char_len_val16;      // (8, 7 or 6)
  byte unsigned stop_bit_val16;      // (1, 1.5 or 2)

  // These16 default constraints can be overriden16
  // Constrain16 configuration based on UVC16/RTL16 capabilities16
//  constraint c_num_stop_bits16  { nbstop16      inside {[0:1]};}
  constraint c_bgen16          { baud_rate_gen16       == 1;}
  constraint c_brgr16          { baud_rate_div16       == 0;}
  constraint c_rts_en16         { rts_en16      == 0;}
  constraint c_cts_en16         { cts_en16      == 0;}

  // These16 declarations16 implement the create() and get_type_name()
  // as well16 as enable automation16 of the tx_frame16's fields   
  `uvm_object_utils_begin(uart_config16)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active16, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active16, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen16, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div16, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length16, UVM_DEFAULT)
    `uvm_field_int(nbstop16, UVM_DEFAULT )  
    `uvm_field_int(parity_en16, UVM_DEFAULT)
    `uvm_field_int(parity_mode16, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This16 requires for registration16 of the ptp_tx_frame16   
  function new(string name = "uart_config16");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl16();
    ConvToIntStpBt16();
  endfunction 

  // Function16 to convert the 2 bit Character16 length to integer
  function void ConvToIntChrl16();
    case(char_length16)
      2'b00 : char_len_val16 = 5;
      2'b01 : char_len_val16 = 6;
      2'b10 : char_len_val16 = 7;
      2'b11 : char_len_val16 = 8;
      default : char_len_val16 = 8;
    endcase
  endfunction : ConvToIntChrl16
    
  // Function16 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt16();
    case(nbstop16)
      2'b00 : stop_bit_val16 = 1;
      2'b01 : stop_bit_val16 = 2;
      default : stop_bit_val16 = 2;
    endcase
  endfunction : ConvToIntStpBt16
    
endclass
`endif  // UART_CONFIG_SV16
