/*-------------------------------------------------------------------------
File2 name   : uart_config2.sv
Title2       : configuration file
Project2     :
Created2     :
Description2 : This2 file contains2 configuration information for the UART2
              device2
Notes2       :  
----------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV2
`define UART_CONFIG_SV2

class uart_config2 extends uvm_object;
  //UART2 topology parameters2
  uvm_active_passive_enum  is_tx_active2 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active2 = UVM_PASSIVE;

  // UART2 device2 parameters2
  rand bit [7:0]    baud_rate_gen2;  // Baud2 Rate2 Generator2 Register
  rand bit [7:0]    baud_rate_div2;  // Baud2 Rate2 Divider2 Register

  // Line2 Control2 Register Fields
  rand bit [1:0]    char_length2; // Character2 length (ua_lcr2[1:0])
  rand bit          nbstop2;        // Number2 stop bits (ua_lcr2[2])
  rand bit          parity_en2 ;    // Parity2 Enable2    (ua_lcr2[3])
  rand bit [1:0]    parity_mode2;   // Parity2 Mode2      (ua_lcr2[5:4])

  int unsigned chrl2;  
  int unsigned stop_bt2;  

  // Control2 Register Fields
  rand bit          cts_en2 ;
  rand bit          rts_en2 ;

 // Calculated2 in post_randomize() so not randomized2
  byte unsigned char_len_val2;      // (8, 7 or 6)
  byte unsigned stop_bit_val2;      // (1, 1.5 or 2)

  // These2 default constraints can be overriden2
  // Constrain2 configuration based on UVC2/RTL2 capabilities2
//  constraint c_num_stop_bits2  { nbstop2      inside {[0:1]};}
  constraint c_bgen2          { baud_rate_gen2       == 1;}
  constraint c_brgr2          { baud_rate_div2       == 0;}
  constraint c_rts_en2         { rts_en2      == 0;}
  constraint c_cts_en2         { cts_en2      == 0;}

  // These2 declarations2 implement the create() and get_type_name()
  // as well2 as enable automation2 of the tx_frame2's fields   
  `uvm_object_utils_begin(uart_config2)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active2, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active2, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen2, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div2, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length2, UVM_DEFAULT)
    `uvm_field_int(nbstop2, UVM_DEFAULT )  
    `uvm_field_int(parity_en2, UVM_DEFAULT)
    `uvm_field_int(parity_mode2, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This2 requires for registration2 of the ptp_tx_frame2   
  function new(string name = "uart_config2");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl2();
    ConvToIntStpBt2();
  endfunction 

  // Function2 to convert the 2 bit Character2 length to integer
  function void ConvToIntChrl2();
    case(char_length2)
      2'b00 : char_len_val2 = 5;
      2'b01 : char_len_val2 = 6;
      2'b10 : char_len_val2 = 7;
      2'b11 : char_len_val2 = 8;
      default : char_len_val2 = 8;
    endcase
  endfunction : ConvToIntChrl2
    
  // Function2 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt2();
    case(nbstop2)
      2'b00 : stop_bit_val2 = 1;
      2'b01 : stop_bit_val2 = 2;
      default : stop_bit_val2 = 2;
    endcase
  endfunction : ConvToIntStpBt2
    
endclass
`endif  // UART_CONFIG_SV2
