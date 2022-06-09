/*-------------------------------------------------------------------------
File25 name   : uart_ctrl_scoreboard25.sv
Title25       : APB25 - UART25 Scoreboard25
Project25     :
Created25     :
Description25 : Scoreboard25 for data integrity25 check between APB25 UVC25 and UART25 UVC25
Notes25       : Two25 similar25 scoreboards25 one for read and one for write
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

`uvm_analysis_imp_decl(_apb25)
`uvm_analysis_imp_decl(_uart25)

class uart_ctrl_tx_scbd25 extends uvm_scoreboard;
  bit [7:0] data_to_apb25[$];
  bit [7:0] temp125;
  bit div_en25;

  // Hooks25 to cause in scoroboard25 check errors25
  // This25 resulting25 failure25 is used in MDV25 workshop25 for failure25 analysis25
  `ifdef UVM_WKSHP25
    bit apb_error25;
  `endif

  // Config25 Information25 
  uart_pkg25::uart_config25 uart_cfg25;
  apb_pkg25::apb_slave_config25 slave_cfg25;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd25)
     `uvm_field_object(uart_cfg25, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg25, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb25 #(apb_pkg25::apb_transfer25, uart_ctrl_tx_scbd25) apb_match25;
  uvm_analysis_imp_uart25 #(uart_pkg25::uart_frame25, uart_ctrl_tx_scbd25) uart_add25;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add25  = new("uart_add25", this);
    apb_match25 = new("apb_match25", this);
  endfunction : new

  // implement UART25 Tx25 analysis25 port from reference model
  virtual function void write_uart25(uart_pkg25::uart_frame25 frame25);
    data_to_apb25.push_back(frame25.payload25);	
  endfunction : write_uart25
     
  // implement APB25 READ analysis25 port from reference model
  virtual function void write_apb25(input apb_pkg25::apb_transfer25 transfer25);

    if (transfer25.addr == (slave_cfg25.start_address25 + `LINE_CTRL25)) begin
      div_en25 = transfer25.data[7];
      `uvm_info("SCRBD25",
              $psprintf("LINE_CTRL25 Write with addr = 'h%0h and data = 'h%0h div_en25 = %0b",
              transfer25.addr, transfer25.data, div_en25 ), UVM_HIGH)
    end

    if (!div_en25) begin
    if ((transfer25.addr ==   (slave_cfg25.start_address25 + `RX_FIFO_REG25)) && (transfer25.direction25 == apb_pkg25::APB_READ25))
      begin
       `ifdef UVM_WKSHP25
          corrupt_data25(transfer25);
       `endif
          temp125 = data_to_apb25.pop_front();
       
        if (temp125 == transfer25.data ) 
          `uvm_info("SCRBD25", $psprintf("####### PASS25 : APB25 RECEIVED25 CORRECT25 DATA25 from %s  expected = 'h%0h, received25 = 'h%0h", slave_cfg25.name, temp125, transfer25.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD25", $psprintf("####### FAIL25 : APB25 RECEIVED25 WRONG25 DATA25 from %s", slave_cfg25.name))
          `uvm_info("SCRBD25", $psprintf("expected = 'h%0h, received25 = 'h%0h", temp125, transfer25.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb25
   
  function void assign_cfg25(uart_pkg25::uart_config25 u_cfg25);
    uart_cfg25 = u_cfg25;
  endfunction : assign_cfg25

  function void update_config25(uart_pkg25::uart_config25 u_cfg25);
    `uvm_info(get_type_name(), {"Updating Config25\n", u_cfg25.sprint}, UVM_HIGH)
    uart_cfg25 = u_cfg25;
  endfunction : update_config25

 `ifdef UVM_WKSHP25
    function void corrupt_data25 (apb_pkg25::apb_transfer25 transfer25);
      if (!randomize(apb_error25) with {apb_error25 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL25", $psprintf("Randomization failed for apb_error25"))
      `uvm_info("SCRBD25",(""), UVM_HIGH)
      transfer25.data+=apb_error25;    	
    endfunction : corrupt_data25
  `endif

  // Add task run to debug25 TLM connectivity25 -- dbg_lab625
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG25", "SB: Verify connections25 TX25 of scorebboard25 - using debug_provided_to", UVM_NONE)
      // Implement25 here25 the checks25 
    apb_match25.debug_provided_to();
    uart_add25.debug_provided_to();
      `uvm_info("TX_SCRB_DBG25", "SB: Verify connections25 of TX25 scorebboard25 - using debug_connected_to", UVM_NONE)
      // Implement25 here25 the checks25 
    apb_match25.debug_connected_to();
    uart_add25.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd25

class uart_ctrl_rx_scbd25 extends uvm_scoreboard;
  bit [7:0] data_from_apb25[$];
  bit [7:0] data_to_apb25[$]; // Relevant25 for Remoteloopback25 case only
  bit div_en25;

  bit [7:0] temp125;
  bit [7:0] mask;

  // Hooks25 to cause in scoroboard25 check errors25
  // This25 resulting25 failure25 is used in MDV25 workshop25 for failure25 analysis25
  `ifdef UVM_WKSHP25
    bit uart_error25;
  `endif

  uart_pkg25::uart_config25 uart_cfg25;
  apb_pkg25::apb_slave_config25 slave_cfg25;

  `uvm_component_utils(uart_ctrl_rx_scbd25)
  uvm_analysis_imp_apb25 #(apb_pkg25::apb_transfer25, uart_ctrl_rx_scbd25) apb_add25;
  uvm_analysis_imp_uart25 #(uart_pkg25::uart_frame25, uart_ctrl_rx_scbd25) uart_match25;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match25 = new("uart_match25", this);
    apb_add25    = new("apb_add25", this);
  endfunction : new
   
  // implement APB25 WRITE analysis25 port from reference model
  virtual function void write_apb25(input apb_pkg25::apb_transfer25 transfer25);
    `uvm_info("SCRBD25",
              $psprintf("write_apb25 called with addr = 'h%0h and data = 'h%0h",
              transfer25.addr, transfer25.data), UVM_HIGH)
    if ((transfer25.addr == (slave_cfg25.start_address25 + `LINE_CTRL25)) &&
        (transfer25.direction25 == apb_pkg25::APB_WRITE25)) begin
      div_en25 = transfer25.data[7];
      `uvm_info("SCRBD25",
              $psprintf("LINE_CTRL25 Write with addr = 'h%0h and data = 'h%0h div_en25 = %0b",
              transfer25.addr, transfer25.data, div_en25 ), UVM_HIGH)
    end

    if (!div_en25) begin
      if ((transfer25.addr == (slave_cfg25.start_address25 + `TX_FIFO_REG25)) &&
          (transfer25.direction25 == apb_pkg25::APB_WRITE25)) begin 
        `uvm_info("SCRBD25",
               $psprintf("write_apb25 called pushing25 into queue with data = 'h%0h",
               transfer25.data ), UVM_HIGH)
        data_from_apb25.push_back(transfer25.data);
      end
    end
  endfunction : write_apb25
   
  // implement UART25 Rx25 analysis25 port from reference model
  virtual function void write_uart25( uart_pkg25::uart_frame25 frame25);
    mask = calc_mask25();

    //In case of remote25 loopback25, the data does not get into the rx25/fifo and it gets25 
    // loopbacked25 to ua_txd25. 
    data_to_apb25.push_back(frame25.payload25);	

      temp125 = data_from_apb25.pop_front();

    `ifdef UVM_WKSHP25
        corrupt_payload25 (frame25);
    `endif 
    if ((temp125 & mask) == frame25.payload25) 
      `uvm_info("SCRBD25", $psprintf("####### PASS25 : %s RECEIVED25 CORRECT25 DATA25 expected = 'h%0h, received25 = 'h%0h", slave_cfg25.name, (temp125 & mask), frame25.payload25), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD25", $psprintf("####### FAIL25 : %s RECEIVED25 WRONG25 DATA25", slave_cfg25.name))
      `uvm_info("SCRBD25", $psprintf("expected = 'h%0h, received25 = 'h%0h", temp125, frame25.payload25), UVM_LOW)
    end
  endfunction : write_uart25
   
  function void assign_cfg25(uart_pkg25::uart_config25 u_cfg25);
     uart_cfg25 = u_cfg25;
  endfunction : assign_cfg25
   
  function void update_config25(uart_pkg25::uart_config25 u_cfg25);
   `uvm_info(get_type_name(), {"Updating Config25\n", u_cfg25.sprint}, UVM_HIGH)
    uart_cfg25 = u_cfg25;
  endfunction : update_config25

  function bit[7:0] calc_mask25();
    case (uart_cfg25.char_len_val25)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask25

  `ifdef UVM_WKSHP25
   function void corrupt_payload25 (uart_pkg25::uart_frame25 frame25);
      if(!randomize(uart_error25) with {uart_error25 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL25", $psprintf("Randomization failed for apb_error25"))
      `uvm_info("SCRBD25",(""), UVM_HIGH)
      frame25.payload25+=uart_error25;    	
   endfunction : corrupt_payload25

  `endif

  // Add task run to debug25 TLM connectivity25
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist25;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG25", "SB: Verify connections25 RX25 of scorebboard25 - using debug_provided_to", UVM_NONE)
      // Implement25 here25 the checks25 
    apb_add25.debug_provided_to();
    uart_match25.debug_provided_to();
      `uvm_info("RX_SCRB_DBG25", "SB: Verify connections25 of RX25 scorebboard25 - using debug_connected_to", UVM_NONE)
      // Implement25 here25 the checks25 
    apb_add25.debug_connected_to();
    uart_match25.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd25
