/*-------------------------------------------------------------------------
File16 name   : uart_ctrl_scoreboard16.sv
Title16       : APB16 - UART16 Scoreboard16
Project16     :
Created16     :
Description16 : Scoreboard16 for data integrity16 check between APB16 UVC16 and UART16 UVC16
Notes16       : Two16 similar16 scoreboards16 one for read and one for write
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

`uvm_analysis_imp_decl(_apb16)
`uvm_analysis_imp_decl(_uart16)

class uart_ctrl_tx_scbd16 extends uvm_scoreboard;
  bit [7:0] data_to_apb16[$];
  bit [7:0] temp116;
  bit div_en16;

  // Hooks16 to cause in scoroboard16 check errors16
  // This16 resulting16 failure16 is used in MDV16 workshop16 for failure16 analysis16
  `ifdef UVM_WKSHP16
    bit apb_error16;
  `endif

  // Config16 Information16 
  uart_pkg16::uart_config16 uart_cfg16;
  apb_pkg16::apb_slave_config16 slave_cfg16;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd16)
     `uvm_field_object(uart_cfg16, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg16, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb16 #(apb_pkg16::apb_transfer16, uart_ctrl_tx_scbd16) apb_match16;
  uvm_analysis_imp_uart16 #(uart_pkg16::uart_frame16, uart_ctrl_tx_scbd16) uart_add16;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add16  = new("uart_add16", this);
    apb_match16 = new("apb_match16", this);
  endfunction : new

  // implement UART16 Tx16 analysis16 port from reference model
  virtual function void write_uart16(uart_pkg16::uart_frame16 frame16);
    data_to_apb16.push_back(frame16.payload16);	
  endfunction : write_uart16
     
  // implement APB16 READ analysis16 port from reference model
  virtual function void write_apb16(input apb_pkg16::apb_transfer16 transfer16);

    if (transfer16.addr == (slave_cfg16.start_address16 + `LINE_CTRL16)) begin
      div_en16 = transfer16.data[7];
      `uvm_info("SCRBD16",
              $psprintf("LINE_CTRL16 Write with addr = 'h%0h and data = 'h%0h div_en16 = %0b",
              transfer16.addr, transfer16.data, div_en16 ), UVM_HIGH)
    end

    if (!div_en16) begin
    if ((transfer16.addr ==   (slave_cfg16.start_address16 + `RX_FIFO_REG16)) && (transfer16.direction16 == apb_pkg16::APB_READ16))
      begin
       `ifdef UVM_WKSHP16
          corrupt_data16(transfer16);
       `endif
          temp116 = data_to_apb16.pop_front();
       
        if (temp116 == transfer16.data ) 
          `uvm_info("SCRBD16", $psprintf("####### PASS16 : APB16 RECEIVED16 CORRECT16 DATA16 from %s  expected = 'h%0h, received16 = 'h%0h", slave_cfg16.name, temp116, transfer16.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD16", $psprintf("####### FAIL16 : APB16 RECEIVED16 WRONG16 DATA16 from %s", slave_cfg16.name))
          `uvm_info("SCRBD16", $psprintf("expected = 'h%0h, received16 = 'h%0h", temp116, transfer16.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb16
   
  function void assign_cfg16(uart_pkg16::uart_config16 u_cfg16);
    uart_cfg16 = u_cfg16;
  endfunction : assign_cfg16

  function void update_config16(uart_pkg16::uart_config16 u_cfg16);
    `uvm_info(get_type_name(), {"Updating Config16\n", u_cfg16.sprint}, UVM_HIGH)
    uart_cfg16 = u_cfg16;
  endfunction : update_config16

 `ifdef UVM_WKSHP16
    function void corrupt_data16 (apb_pkg16::apb_transfer16 transfer16);
      if (!randomize(apb_error16) with {apb_error16 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL16", $psprintf("Randomization failed for apb_error16"))
      `uvm_info("SCRBD16",(""), UVM_HIGH)
      transfer16.data+=apb_error16;    	
    endfunction : corrupt_data16
  `endif

  // Add task run to debug16 TLM connectivity16 -- dbg_lab616
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG16", "SB: Verify connections16 TX16 of scorebboard16 - using debug_provided_to", UVM_NONE)
      // Implement16 here16 the checks16 
    apb_match16.debug_provided_to();
    uart_add16.debug_provided_to();
      `uvm_info("TX_SCRB_DBG16", "SB: Verify connections16 of TX16 scorebboard16 - using debug_connected_to", UVM_NONE)
      // Implement16 here16 the checks16 
    apb_match16.debug_connected_to();
    uart_add16.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd16

class uart_ctrl_rx_scbd16 extends uvm_scoreboard;
  bit [7:0] data_from_apb16[$];
  bit [7:0] data_to_apb16[$]; // Relevant16 for Remoteloopback16 case only
  bit div_en16;

  bit [7:0] temp116;
  bit [7:0] mask;

  // Hooks16 to cause in scoroboard16 check errors16
  // This16 resulting16 failure16 is used in MDV16 workshop16 for failure16 analysis16
  `ifdef UVM_WKSHP16
    bit uart_error16;
  `endif

  uart_pkg16::uart_config16 uart_cfg16;
  apb_pkg16::apb_slave_config16 slave_cfg16;

  `uvm_component_utils(uart_ctrl_rx_scbd16)
  uvm_analysis_imp_apb16 #(apb_pkg16::apb_transfer16, uart_ctrl_rx_scbd16) apb_add16;
  uvm_analysis_imp_uart16 #(uart_pkg16::uart_frame16, uart_ctrl_rx_scbd16) uart_match16;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match16 = new("uart_match16", this);
    apb_add16    = new("apb_add16", this);
  endfunction : new
   
  // implement APB16 WRITE analysis16 port from reference model
  virtual function void write_apb16(input apb_pkg16::apb_transfer16 transfer16);
    `uvm_info("SCRBD16",
              $psprintf("write_apb16 called with addr = 'h%0h and data = 'h%0h",
              transfer16.addr, transfer16.data), UVM_HIGH)
    if ((transfer16.addr == (slave_cfg16.start_address16 + `LINE_CTRL16)) &&
        (transfer16.direction16 == apb_pkg16::APB_WRITE16)) begin
      div_en16 = transfer16.data[7];
      `uvm_info("SCRBD16",
              $psprintf("LINE_CTRL16 Write with addr = 'h%0h and data = 'h%0h div_en16 = %0b",
              transfer16.addr, transfer16.data, div_en16 ), UVM_HIGH)
    end

    if (!div_en16) begin
      if ((transfer16.addr == (slave_cfg16.start_address16 + `TX_FIFO_REG16)) &&
          (transfer16.direction16 == apb_pkg16::APB_WRITE16)) begin 
        `uvm_info("SCRBD16",
               $psprintf("write_apb16 called pushing16 into queue with data = 'h%0h",
               transfer16.data ), UVM_HIGH)
        data_from_apb16.push_back(transfer16.data);
      end
    end
  endfunction : write_apb16
   
  // implement UART16 Rx16 analysis16 port from reference model
  virtual function void write_uart16( uart_pkg16::uart_frame16 frame16);
    mask = calc_mask16();

    //In case of remote16 loopback16, the data does not get into the rx16/fifo and it gets16 
    // loopbacked16 to ua_txd16. 
    data_to_apb16.push_back(frame16.payload16);	

      temp116 = data_from_apb16.pop_front();

    `ifdef UVM_WKSHP16
        corrupt_payload16 (frame16);
    `endif 
    if ((temp116 & mask) == frame16.payload16) 
      `uvm_info("SCRBD16", $psprintf("####### PASS16 : %s RECEIVED16 CORRECT16 DATA16 expected = 'h%0h, received16 = 'h%0h", slave_cfg16.name, (temp116 & mask), frame16.payload16), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD16", $psprintf("####### FAIL16 : %s RECEIVED16 WRONG16 DATA16", slave_cfg16.name))
      `uvm_info("SCRBD16", $psprintf("expected = 'h%0h, received16 = 'h%0h", temp116, frame16.payload16), UVM_LOW)
    end
  endfunction : write_uart16
   
  function void assign_cfg16(uart_pkg16::uart_config16 u_cfg16);
     uart_cfg16 = u_cfg16;
  endfunction : assign_cfg16
   
  function void update_config16(uart_pkg16::uart_config16 u_cfg16);
   `uvm_info(get_type_name(), {"Updating Config16\n", u_cfg16.sprint}, UVM_HIGH)
    uart_cfg16 = u_cfg16;
  endfunction : update_config16

  function bit[7:0] calc_mask16();
    case (uart_cfg16.char_len_val16)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask16

  `ifdef UVM_WKSHP16
   function void corrupt_payload16 (uart_pkg16::uart_frame16 frame16);
      if(!randomize(uart_error16) with {uart_error16 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL16", $psprintf("Randomization failed for apb_error16"))
      `uvm_info("SCRBD16",(""), UVM_HIGH)
      frame16.payload16+=uart_error16;    	
   endfunction : corrupt_payload16

  `endif

  // Add task run to debug16 TLM connectivity16
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist16;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG16", "SB: Verify connections16 RX16 of scorebboard16 - using debug_provided_to", UVM_NONE)
      // Implement16 here16 the checks16 
    apb_add16.debug_provided_to();
    uart_match16.debug_provided_to();
      `uvm_info("RX_SCRB_DBG16", "SB: Verify connections16 of RX16 scorebboard16 - using debug_connected_to", UVM_NONE)
      // Implement16 here16 the checks16 
    apb_add16.debug_connected_to();
    uart_match16.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd16
