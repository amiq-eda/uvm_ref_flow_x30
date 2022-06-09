/*-------------------------------------------------------------------------
File20 name   : uart_ctrl_scoreboard20.sv
Title20       : APB20 - UART20 Scoreboard20
Project20     :
Created20     :
Description20 : Scoreboard20 for data integrity20 check between APB20 UVC20 and UART20 UVC20
Notes20       : Two20 similar20 scoreboards20 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb20)
`uvm_analysis_imp_decl(_uart20)

class uart_ctrl_tx_scbd20 extends uvm_scoreboard;
  bit [7:0] data_to_apb20[$];
  bit [7:0] temp120;
  bit div_en20;

  // Hooks20 to cause in scoroboard20 check errors20
  // This20 resulting20 failure20 is used in MDV20 workshop20 for failure20 analysis20
  `ifdef UVM_WKSHP20
    bit apb_error20;
  `endif

  // Config20 Information20 
  uart_pkg20::uart_config20 uart_cfg20;
  apb_pkg20::apb_slave_config20 slave_cfg20;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd20)
     `uvm_field_object(uart_cfg20, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg20, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb20 #(apb_pkg20::apb_transfer20, uart_ctrl_tx_scbd20) apb_match20;
  uvm_analysis_imp_uart20 #(uart_pkg20::uart_frame20, uart_ctrl_tx_scbd20) uart_add20;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add20  = new("uart_add20", this);
    apb_match20 = new("apb_match20", this);
  endfunction : new

  // implement UART20 Tx20 analysis20 port from reference model
  virtual function void write_uart20(uart_pkg20::uart_frame20 frame20);
    data_to_apb20.push_back(frame20.payload20);	
  endfunction : write_uart20
     
  // implement APB20 READ analysis20 port from reference model
  virtual function void write_apb20(input apb_pkg20::apb_transfer20 transfer20);

    if (transfer20.addr == (slave_cfg20.start_address20 + `LINE_CTRL20)) begin
      div_en20 = transfer20.data[7];
      `uvm_info("SCRBD20",
              $psprintf("LINE_CTRL20 Write with addr = 'h%0h and data = 'h%0h div_en20 = %0b",
              transfer20.addr, transfer20.data, div_en20 ), UVM_HIGH)
    end

    if (!div_en20) begin
    if ((transfer20.addr ==   (slave_cfg20.start_address20 + `RX_FIFO_REG20)) && (transfer20.direction20 == apb_pkg20::APB_READ20))
      begin
       `ifdef UVM_WKSHP20
          corrupt_data20(transfer20);
       `endif
          temp120 = data_to_apb20.pop_front();
       
        if (temp120 == transfer20.data ) 
          `uvm_info("SCRBD20", $psprintf("####### PASS20 : APB20 RECEIVED20 CORRECT20 DATA20 from %s  expected = 'h%0h, received20 = 'h%0h", slave_cfg20.name, temp120, transfer20.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD20", $psprintf("####### FAIL20 : APB20 RECEIVED20 WRONG20 DATA20 from %s", slave_cfg20.name))
          `uvm_info("SCRBD20", $psprintf("expected = 'h%0h, received20 = 'h%0h", temp120, transfer20.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb20
   
  function void assign_cfg20(uart_pkg20::uart_config20 u_cfg20);
    uart_cfg20 = u_cfg20;
  endfunction : assign_cfg20

  function void update_config20(uart_pkg20::uart_config20 u_cfg20);
    `uvm_info(get_type_name(), {"Updating Config20\n", u_cfg20.sprint}, UVM_HIGH)
    uart_cfg20 = u_cfg20;
  endfunction : update_config20

 `ifdef UVM_WKSHP20
    function void corrupt_data20 (apb_pkg20::apb_transfer20 transfer20);
      if (!randomize(apb_error20) with {apb_error20 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL20", $psprintf("Randomization failed for apb_error20"))
      `uvm_info("SCRBD20",(""), UVM_HIGH)
      transfer20.data+=apb_error20;    	
    endfunction : corrupt_data20
  `endif

  // Add task run to debug20 TLM connectivity20 -- dbg_lab620
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG20", "SB: Verify connections20 TX20 of scorebboard20 - using debug_provided_to", UVM_NONE)
      // Implement20 here20 the checks20 
    apb_match20.debug_provided_to();
    uart_add20.debug_provided_to();
      `uvm_info("TX_SCRB_DBG20", "SB: Verify connections20 of TX20 scorebboard20 - using debug_connected_to", UVM_NONE)
      // Implement20 here20 the checks20 
    apb_match20.debug_connected_to();
    uart_add20.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd20

class uart_ctrl_rx_scbd20 extends uvm_scoreboard;
  bit [7:0] data_from_apb20[$];
  bit [7:0] data_to_apb20[$]; // Relevant20 for Remoteloopback20 case only
  bit div_en20;

  bit [7:0] temp120;
  bit [7:0] mask;

  // Hooks20 to cause in scoroboard20 check errors20
  // This20 resulting20 failure20 is used in MDV20 workshop20 for failure20 analysis20
  `ifdef UVM_WKSHP20
    bit uart_error20;
  `endif

  uart_pkg20::uart_config20 uart_cfg20;
  apb_pkg20::apb_slave_config20 slave_cfg20;

  `uvm_component_utils(uart_ctrl_rx_scbd20)
  uvm_analysis_imp_apb20 #(apb_pkg20::apb_transfer20, uart_ctrl_rx_scbd20) apb_add20;
  uvm_analysis_imp_uart20 #(uart_pkg20::uart_frame20, uart_ctrl_rx_scbd20) uart_match20;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match20 = new("uart_match20", this);
    apb_add20    = new("apb_add20", this);
  endfunction : new
   
  // implement APB20 WRITE analysis20 port from reference model
  virtual function void write_apb20(input apb_pkg20::apb_transfer20 transfer20);
    `uvm_info("SCRBD20",
              $psprintf("write_apb20 called with addr = 'h%0h and data = 'h%0h",
              transfer20.addr, transfer20.data), UVM_HIGH)
    if ((transfer20.addr == (slave_cfg20.start_address20 + `LINE_CTRL20)) &&
        (transfer20.direction20 == apb_pkg20::APB_WRITE20)) begin
      div_en20 = transfer20.data[7];
      `uvm_info("SCRBD20",
              $psprintf("LINE_CTRL20 Write with addr = 'h%0h and data = 'h%0h div_en20 = %0b",
              transfer20.addr, transfer20.data, div_en20 ), UVM_HIGH)
    end

    if (!div_en20) begin
      if ((transfer20.addr == (slave_cfg20.start_address20 + `TX_FIFO_REG20)) &&
          (transfer20.direction20 == apb_pkg20::APB_WRITE20)) begin 
        `uvm_info("SCRBD20",
               $psprintf("write_apb20 called pushing20 into queue with data = 'h%0h",
               transfer20.data ), UVM_HIGH)
        data_from_apb20.push_back(transfer20.data);
      end
    end
  endfunction : write_apb20
   
  // implement UART20 Rx20 analysis20 port from reference model
  virtual function void write_uart20( uart_pkg20::uart_frame20 frame20);
    mask = calc_mask20();

    //In case of remote20 loopback20, the data does not get into the rx20/fifo and it gets20 
    // loopbacked20 to ua_txd20. 
    data_to_apb20.push_back(frame20.payload20);	

      temp120 = data_from_apb20.pop_front();

    `ifdef UVM_WKSHP20
        corrupt_payload20 (frame20);
    `endif 
    if ((temp120 & mask) == frame20.payload20) 
      `uvm_info("SCRBD20", $psprintf("####### PASS20 : %s RECEIVED20 CORRECT20 DATA20 expected = 'h%0h, received20 = 'h%0h", slave_cfg20.name, (temp120 & mask), frame20.payload20), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD20", $psprintf("####### FAIL20 : %s RECEIVED20 WRONG20 DATA20", slave_cfg20.name))
      `uvm_info("SCRBD20", $psprintf("expected = 'h%0h, received20 = 'h%0h", temp120, frame20.payload20), UVM_LOW)
    end
  endfunction : write_uart20
   
  function void assign_cfg20(uart_pkg20::uart_config20 u_cfg20);
     uart_cfg20 = u_cfg20;
  endfunction : assign_cfg20
   
  function void update_config20(uart_pkg20::uart_config20 u_cfg20);
   `uvm_info(get_type_name(), {"Updating Config20\n", u_cfg20.sprint}, UVM_HIGH)
    uart_cfg20 = u_cfg20;
  endfunction : update_config20

  function bit[7:0] calc_mask20();
    case (uart_cfg20.char_len_val20)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask20

  `ifdef UVM_WKSHP20
   function void corrupt_payload20 (uart_pkg20::uart_frame20 frame20);
      if(!randomize(uart_error20) with {uart_error20 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL20", $psprintf("Randomization failed for apb_error20"))
      `uvm_info("SCRBD20",(""), UVM_HIGH)
      frame20.payload20+=uart_error20;    	
   endfunction : corrupt_payload20

  `endif

  // Add task run to debug20 TLM connectivity20
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist20;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG20", "SB: Verify connections20 RX20 of scorebboard20 - using debug_provided_to", UVM_NONE)
      // Implement20 here20 the checks20 
    apb_add20.debug_provided_to();
    uart_match20.debug_provided_to();
      `uvm_info("RX_SCRB_DBG20", "SB: Verify connections20 of RX20 scorebboard20 - using debug_connected_to", UVM_NONE)
      // Implement20 here20 the checks20 
    apb_add20.debug_connected_to();
    uart_match20.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd20
