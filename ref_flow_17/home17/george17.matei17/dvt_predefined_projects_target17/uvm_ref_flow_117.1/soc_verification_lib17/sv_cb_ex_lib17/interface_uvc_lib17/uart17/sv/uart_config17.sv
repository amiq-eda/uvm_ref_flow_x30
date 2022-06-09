/*-------------------------------------------------------------------------
File17 name   : uart_config17.sv
Title17       : configuration file
Project17     :
Created17     :
Description17 : This17 file contains17 configuration information for the UART17
              device17
Notes17       :  
----------------------------------------------------------------------*/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef UART_CONFIG_SV17
`define UART_CONFIG_SV17

class uart_config17 extends uvm_object;
  //UART17 topology parameters17
  uvm_active_passive_enum  is_tx_active17 = UVM_ACTIVE;
  uvm_active_passive_enum  is_rx_active17 = UVM_PASSIVE;

  // UART17 device17 parameters17
  rand bit [7:0]    baud_rate_gen17;  // Baud17 Rate17 Generator17 Register
  rand bit [7:0]    baud_rate_div17;  // Baud17 Rate17 Divider17 Register

  // Line17 Control17 Register Fields
  rand bit [1:0]    char_length17; // Character17 length (ua_lcr17[1:0])
  rand bit          nbstop17;        // Number17 stop bits (ua_lcr17[2])
  rand bit          parity_en17 ;    // Parity17 Enable17    (ua_lcr17[3])
  rand bit [1:0]    parity_mode17;   // Parity17 Mode17      (ua_lcr17[5:4])

  int unsigned chrl17;  
  int unsigned stop_bt17;  

  // Control17 Register Fields
  rand bit          cts_en17 ;
  rand bit          rts_en17 ;

 // Calculated17 in post_randomize() so not randomized17
  byte unsigned char_len_val17;      // (8, 7 or 6)
  byte unsigned stop_bit_val17;      // (1, 1.5 or 2)

  // These17 default constraints can be overriden17
  // Constrain17 configuration based on UVC17/RTL17 capabilities17
//  constraint c_num_stop_bits17  { nbstop17      inside {[0:1]};}
  constraint c_bgen17          { baud_rate_gen17       == 1;}
  constraint c_brgr17          { baud_rate_div17       == 0;}
  constraint c_rts_en17         { rts_en17      == 0;}
  constraint c_cts_en17         { cts_en17      == 0;}

  // These17 declarations17 implement the create() and get_type_name()
  // as well17 as enable automation17 of the tx_frame17's fields   
  `uvm_object_utils_begin(uart_config17)
    `uvm_field_enum(uvm_active_passive_enum, is_tx_active17, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_rx_active17, UVM_DEFAULT)
    `uvm_field_int(baud_rate_gen17, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(baud_rate_div17, UVM_DEFAULT + UVM_DEC)
    `uvm_field_int(char_length17, UVM_DEFAULT)
    `uvm_field_int(nbstop17, UVM_DEFAULT )  
    `uvm_field_int(parity_en17, UVM_DEFAULT)
    `uvm_field_int(parity_mode17, UVM_DEFAULT)
  `uvm_object_utils_end
     
  // This17 requires for registration17 of the ptp_tx_frame17   
  function new(string name = "uart_config17");
    super.new(name);
  endfunction 
   
  function void post_randomize();
    ConvToIntChrl17();
    ConvToIntStpBt17();
  endfunction 

  // Function17 to convert the 2 bit Character17 length to integer
  function void ConvToIntChrl17();
    case(char_length17)
      2'b00 : char_len_val17 = 5;
      2'b01 : char_len_val17 = 6;
      2'b10 : char_len_val17 = 7;
      2'b11 : char_len_val17 = 8;
      default : char_len_val17 = 8;
    endcase
  endfunction : ConvToIntChrl17
    
  // Function17 to convert the 2 bit stop bit to integer
  function void ConvToIntStpBt17();
    case(nbstop17)
      2'b00 : stop_bit_val17 = 1;
      2'b01 : stop_bit_val17 = 2;
      default : stop_bit_val17 = 2;
    endcase
  endfunction : ConvToIntStpBt17
    
endclass
`endif  // UART_CONFIG_SV17
