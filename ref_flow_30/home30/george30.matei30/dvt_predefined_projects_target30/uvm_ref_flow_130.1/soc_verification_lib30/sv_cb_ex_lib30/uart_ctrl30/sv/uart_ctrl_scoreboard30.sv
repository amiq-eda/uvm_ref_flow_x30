/*-------------------------------------------------------------------------
File30 name   : uart_ctrl_scoreboard30.sv
Title30       : APB30 - UART30 Scoreboard30
Project30     :
Created30     :
Description30 : Scoreboard30 for data integrity30 check between APB30 UVC30 and UART30 UVC30
Notes30       : Two30 similar30 scoreboards30 one for read and one for write
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

`uvm_analysis_imp_decl(_apb30)
`uvm_analysis_imp_decl(_uart30)

class uart_ctrl_tx_scbd30 extends uvm_scoreboard;
  bit [7:0] data_to_apb30[$];
  bit [7:0] temp130;
  bit div_en30;

  // Hooks30 to cause in scoroboard30 check errors30
  // This30 resulting30 failure30 is used in MDV30 workshop30 for failure30 analysis30
  `ifdef UVM_WKSHP30
    bit apb_error30;
  `endif

  // Config30 Information30 
  uart_pkg30::uart_config30 uart_cfg30;
  apb_pkg30::apb_slave_config30 slave_cfg30;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd30)
     `uvm_field_object(uart_cfg30, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg30, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb30 #(apb_pkg30::apb_transfer30, uart_ctrl_tx_scbd30) apb_match30;
  uvm_analysis_imp_uart30 #(uart_pkg30::uart_frame30, uart_ctrl_tx_scbd30) uart_add30;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add30  = new("uart_add30", this);
    apb_match30 = new("apb_match30", this);
  endfunction : new

  // implement UART30 Tx30 analysis30 port from reference model
  virtual function void write_uart30(uart_pkg30::uart_frame30 frame30);
    data_to_apb30.push_back(frame30.payload30);	
  endfunction : write_uart30
     
  // implement APB30 READ analysis30 port from reference model
  virtual function void write_apb30(input apb_pkg30::apb_transfer30 transfer30);

    if (transfer30.addr == (slave_cfg30.start_address30 + `LINE_CTRL30)) begin
      div_en30 = transfer30.data[7];
      `uvm_info("SCRBD30",
              $psprintf("LINE_CTRL30 Write with addr = 'h%0h and data = 'h%0h div_en30 = %0b",
              transfer30.addr, transfer30.data, div_en30 ), UVM_HIGH)
    end

    if (!div_en30) begin
    if ((transfer30.addr ==   (slave_cfg30.start_address30 + `RX_FIFO_REG30)) && (transfer30.direction30 == apb_pkg30::APB_READ30))
      begin
       `ifdef UVM_WKSHP30
          corrupt_data30(transfer30);
       `endif
          temp130 = data_to_apb30.pop_front();
       
        if (temp130 == transfer30.data ) 
          `uvm_info("SCRBD30", $psprintf("####### PASS30 : APB30 RECEIVED30 CORRECT30 DATA30 from %s  expected = 'h%0h, received30 = 'h%0h", slave_cfg30.name, temp130, transfer30.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD30", $psprintf("####### FAIL30 : APB30 RECEIVED30 WRONG30 DATA30 from %s", slave_cfg30.name))
          `uvm_info("SCRBD30", $psprintf("expected = 'h%0h, received30 = 'h%0h", temp130, transfer30.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb30
   
  function void assign_cfg30(uart_pkg30::uart_config30 u_cfg30);
    uart_cfg30 = u_cfg30;
  endfunction : assign_cfg30

  function void update_config30(uart_pkg30::uart_config30 u_cfg30);
    `uvm_info(get_type_name(), {"Updating Config30\n", u_cfg30.sprint}, UVM_HIGH)
    uart_cfg30 = u_cfg30;
  endfunction : update_config30

 `ifdef UVM_WKSHP30
    function void corrupt_data30 (apb_pkg30::apb_transfer30 transfer30);
      if (!randomize(apb_error30) with {apb_error30 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL30", $psprintf("Randomization failed for apb_error30"))
      `uvm_info("SCRBD30",(""), UVM_HIGH)
      transfer30.data+=apb_error30;    	
    endfunction : corrupt_data30
  `endif

  // Add task run to debug30 TLM connectivity30 -- dbg_lab630
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG30", "SB: Verify connections30 TX30 of scorebboard30 - using debug_provided_to", UVM_NONE)
      // Implement30 here30 the checks30 
    apb_match30.debug_provided_to();
    uart_add30.debug_provided_to();
      `uvm_info("TX_SCRB_DBG30", "SB: Verify connections30 of TX30 scorebboard30 - using debug_connected_to", UVM_NONE)
      // Implement30 here30 the checks30 
    apb_match30.debug_connected_to();
    uart_add30.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd30

class uart_ctrl_rx_scbd30 extends uvm_scoreboard;
  bit [7:0] data_from_apb30[$];
  bit [7:0] data_to_apb30[$]; // Relevant30 for Remoteloopback30 case only
  bit div_en30;

  bit [7:0] temp130;
  bit [7:0] mask;

  // Hooks30 to cause in scoroboard30 check errors30
  // This30 resulting30 failure30 is used in MDV30 workshop30 for failure30 analysis30
  `ifdef UVM_WKSHP30
    bit uart_error30;
  `endif

  uart_pkg30::uart_config30 uart_cfg30;
  apb_pkg30::apb_slave_config30 slave_cfg30;

  `uvm_component_utils(uart_ctrl_rx_scbd30)
  uvm_analysis_imp_apb30 #(apb_pkg30::apb_transfer30, uart_ctrl_rx_scbd30) apb_add30;
  uvm_analysis_imp_uart30 #(uart_pkg30::uart_frame30, uart_ctrl_rx_scbd30) uart_match30;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match30 = new("uart_match30", this);
    apb_add30    = new("apb_add30", this);
  endfunction : new
   
  // implement APB30 WRITE analysis30 port from reference model
  virtual function void write_apb30(input apb_pkg30::apb_transfer30 transfer30);
    `uvm_info("SCRBD30",
              $psprintf("write_apb30 called with addr = 'h%0h and data = 'h%0h",
              transfer30.addr, transfer30.data), UVM_HIGH)
    if ((transfer30.addr == (slave_cfg30.start_address30 + `LINE_CTRL30)) &&
        (transfer30.direction30 == apb_pkg30::APB_WRITE30)) begin
      div_en30 = transfer30.data[7];
      `uvm_info("SCRBD30",
              $psprintf("LINE_CTRL30 Write with addr = 'h%0h and data = 'h%0h div_en30 = %0b",
              transfer30.addr, transfer30.data, div_en30 ), UVM_HIGH)
    end

    if (!div_en30) begin
      if ((transfer30.addr == (slave_cfg30.start_address30 + `TX_FIFO_REG30)) &&
          (transfer30.direction30 == apb_pkg30::APB_WRITE30)) begin 
        `uvm_info("SCRBD30",
               $psprintf("write_apb30 called pushing30 into queue with data = 'h%0h",
               transfer30.data ), UVM_HIGH)
        data_from_apb30.push_back(transfer30.data);
      end
    end
  endfunction : write_apb30
   
  // implement UART30 Rx30 analysis30 port from reference model
  virtual function void write_uart30( uart_pkg30::uart_frame30 frame30);
    mask = calc_mask30();

    //In case of remote30 loopback30, the data does not get into the rx30/fifo and it gets30 
    // loopbacked30 to ua_txd30. 
    data_to_apb30.push_back(frame30.payload30);	

      temp130 = data_from_apb30.pop_front();

    `ifdef UVM_WKSHP30
        corrupt_payload30 (frame30);
    `endif 
    if ((temp130 & mask) == frame30.payload30) 
      `uvm_info("SCRBD30", $psprintf("####### PASS30 : %s RECEIVED30 CORRECT30 DATA30 expected = 'h%0h, received30 = 'h%0h", slave_cfg30.name, (temp130 & mask), frame30.payload30), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD30", $psprintf("####### FAIL30 : %s RECEIVED30 WRONG30 DATA30", slave_cfg30.name))
      `uvm_info("SCRBD30", $psprintf("expected = 'h%0h, received30 = 'h%0h", temp130, frame30.payload30), UVM_LOW)
    end
  endfunction : write_uart30
   
  function void assign_cfg30(uart_pkg30::uart_config30 u_cfg30);
     uart_cfg30 = u_cfg30;
  endfunction : assign_cfg30
   
  function void update_config30(uart_pkg30::uart_config30 u_cfg30);
   `uvm_info(get_type_name(), {"Updating Config30\n", u_cfg30.sprint}, UVM_HIGH)
    uart_cfg30 = u_cfg30;
  endfunction : update_config30

  function bit[7:0] calc_mask30();
    case (uart_cfg30.char_len_val30)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask30

  `ifdef UVM_WKSHP30
   function void corrupt_payload30 (uart_pkg30::uart_frame30 frame30);
      if(!randomize(uart_error30) with {uart_error30 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL30", $psprintf("Randomization failed for apb_error30"))
      `uvm_info("SCRBD30",(""), UVM_HIGH)
      frame30.payload30+=uart_error30;    	
   endfunction : corrupt_payload30

  `endif

  // Add task run to debug30 TLM connectivity30
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist30;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG30", "SB: Verify connections30 RX30 of scorebboard30 - using debug_provided_to", UVM_NONE)
      // Implement30 here30 the checks30 
    apb_add30.debug_provided_to();
    uart_match30.debug_provided_to();
      `uvm_info("RX_SCRB_DBG30", "SB: Verify connections30 of RX30 scorebboard30 - using debug_connected_to", UVM_NONE)
      // Implement30 here30 the checks30 
    apb_add30.debug_connected_to();
    uart_match30.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd30
