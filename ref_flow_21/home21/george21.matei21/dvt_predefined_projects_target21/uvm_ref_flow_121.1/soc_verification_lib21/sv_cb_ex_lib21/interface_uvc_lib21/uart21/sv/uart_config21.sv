/*-------------------------------------------------------------------------
File21 name   : uart_config21.sv
Title21       : configuration file
Project21     :
Created21     :
Description21 : This21 file contains21 configuration information for the UART21
              device21
Notes21       :  
----------------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV21
`define UART_CONFIG_SV21

class uart_config21 extends uvm_object;
  //UART21 topology parameters21
  uvm_active_passive_enum  is_tx_active21 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active21 = UVM_PASSIVE;

  // UART21 device21 parameters21
  rand bit [7:0]    baud_rate_gen21;  // Baud21 Rate21 Generator21 Register
  rand bit [7:0]    baud_rate_div21;  // Baud21 Rate21 Divider21 Register

  // Line21 Control21 Register Fields
  rand bit [1:0]    char_length21; // Character21 length (ua_lcr21[1:0])
  rand bit          nbstop21;        // Number21 stop bits (ua_lcr21[2])
  rand bit          parity_en21 ;    // Parity21 Enable21    (ua_lcr21[3])
  rand bit [1:0]    parity_mode21;   // Parity21 Mode21      (ua_lcr21[5:4])

  int unsigned chrl21;  
  int unsigned stop_bt21;  

  // Control21 Register Fields
  rand bit          cts_en21 ;
  rand bit          rts_en21 ;

 // Calculated21 in post_randomize() so not randomized21
  byte unsigned char_len_val21;      // (8, 7 or 6)
  byte unsigned stop_bit_val21;      // (1, 1.5 or 2)

  // These21 default constraints can be overriden21
  // Constrain21 configuration based on UVC21/RTL21 capabilities21
//  constraint c_num_stop_bits21  { nbstop21      inside {[0:1]};}
  constraint c_bgen21          { baud_rate_gen21       == 1;}
  constraint c_brgr21          { baud_rate_div21       == 0;}
  constraint c_rts_en21         { rts_en21      == 0;}
  constraint c_cts_en21         { cts_en21      == 0;}

  // These21 declarations21 implement the create() and get_type_name()
  // as well21 as enable automation21 of the tx_frame21's fields   
  `uvm_object_utils_begin(uart_config21)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active21, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active21, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen21, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div21, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length21, UVM_DEFAULT)
    `uvm_field_int(nbstop21, UVM_DEFAULT )  
    `uvm_field_int(parity_en21, UVM_DEFAULT)
    `uvm_field_int(parity_mode21, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This21 requires for registration21 of the ptp_tx_frame21   
  function new(string name = "uart_config21");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl21();
    ConvToIntStpBt21();
  endfunction 

  // Function21 to convert the 2 bit Character21 length to integer
  function void ConvToIntChrl21();
    case(char_length21)
      2'b00 : char_len_val21 = 5;
      2'b01 : char_len_val21 = 6;
      2'b10 : char_len_val21 = 7;
      2'b11 : char_len_val21 = 8;
      default : char_len_val21 = 8;
    endcase
  endfunction : ConvToIntChrl21
    
  // Function21 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt21();
    case(nbstop21)
      2'b00 : stop_bit_val21 = 1;
      2'b01 : stop_bit_val21 = 2;
      default : stop_bit_val21 = 2;
    endcase
  endfunction : ConvToIntStpBt21
    
endclass
`endif  // UART_CONFIG_SV21
