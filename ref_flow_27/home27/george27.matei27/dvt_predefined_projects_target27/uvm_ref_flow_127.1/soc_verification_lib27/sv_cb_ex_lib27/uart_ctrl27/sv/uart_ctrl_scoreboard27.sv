/*-------------------------------------------------------------------------
File27 name   : uart_ctrl_scoreboard27.sv
Title27       : APB27 - UART27 Scoreboard27
Project27     :
Created27     :
Description27 : Scoreboard27 for data integrity27 check between APB27 UVC27 and UART27 UVC27
Notes27       : Two27 similar27 scoreboards27 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb27)
`uvm_analysis_imp_decl(_uart27)

class uart_ctrl_tx_scbd27 extends uvm_scoreboard;
  bit [7:0] data_to_apb27[$];
  bit [7:0] temp127;
  bit div_en27;

  // Hooks27 to cause in scoroboard27 check errors27
  // This27 resulting27 failure27 is used in MDV27 workshop27 for failure27 analysis27
  `ifdef UVM_WKSHP27
    bit apb_error27;
  `endif

  // Config27 Information27 
  uart_pkg27::uart_config27 uart_cfg27;
  apb_pkg27::apb_slave_config27 slave_cfg27;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd27)
     `uvm_field_object(uart_cfg27, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg27, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb27 #(apb_pkg27::apb_transfer27, uart_ctrl_tx_scbd27) apb_match27;
  uvm_analysis_imp_uart27 #(uart_pkg27::uart_frame27, uart_ctrl_tx_scbd27) uart_add27;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add27  = new("uart_add27", this);
    apb_match27 = new("apb_match27", this);
  endfunction : new

  // implement UART27 Tx27 analysis27 port from reference model
  virtual function void write_uart27(uart_pkg27::uart_frame27 frame27);
    data_to_apb27.push_back(frame27.payload27);	
  endfunction : write_uart27
     
  // implement APB27 READ analysis27 port from reference model
  virtual function void write_apb27(input apb_pkg27::apb_transfer27 transfer27);

    if (transfer27.addr == (slave_cfg27.start_address27 + `LINE_CTRL27)) begin
      div_en27 = transfer27.data[7];
      `uvm_info("SCRBD27",
              $psprintf("LINE_CTRL27 Write with addr = 'h%0h and data = 'h%0h div_en27 = %0b",
              transfer27.addr, transfer27.data, div_en27 ), UVM_HIGH)
    end

    if (!div_en27) begin
    if ((transfer27.addr ==   (slave_cfg27.start_address27 + `RX_FIFO_REG27)) && (transfer27.direction27 == apb_pkg27::APB_READ27))
      begin
       `ifdef UVM_WKSHP27
          corrupt_data27(transfer27);
       `endif
          temp127 = data_to_apb27.pop_front();
       
        if (temp127 == transfer27.data ) 
          `uvm_info("SCRBD27", $psprintf("####### PASS27 : APB27 RECEIVED27 CORRECT27 DATA27 from %s  expected = 'h%0h, received27 = 'h%0h", slave_cfg27.name, temp127, transfer27.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD27", $psprintf("####### FAIL27 : APB27 RECEIVED27 WRONG27 DATA27 from %s", slave_cfg27.name))
          `uvm_info("SCRBD27", $psprintf("expected = 'h%0h, received27 = 'h%0h", temp127, transfer27.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb27
   
  function void assign_cfg27(uart_pkg27::uart_config27 u_cfg27);
    uart_cfg27 = u_cfg27;
  endfunction : assign_cfg27

  function void update_config27(uart_pkg27::uart_config27 u_cfg27);
    `uvm_info(get_type_name(), {"Updating Config27\n", u_cfg27.sprint}, UVM_HIGH)
    uart_cfg27 = u_cfg27;
  endfunction : update_config27

 `ifdef UVM_WKSHP27
    function void corrupt_data27 (apb_pkg27::apb_transfer27 transfer27);
      if (!randomize(apb_error27) with {apb_error27 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL27", $psprintf("Randomization failed for apb_error27"))
      `uvm_info("SCRBD27",(""), UVM_HIGH)
      transfer27.data+=apb_error27;    	
    endfunction : corrupt_data27
  `endif

  // Add task run to debug27 TLM connectivity27 -- dbg_lab627
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG27", "SB: Verify connections27 TX27 of scorebboard27 - using debug_provided_to", UVM_NONE)
      // Implement27 here27 the checks27 
    apb_match27.debug_provided_to();
    uart_add27.debug_provided_to();
      `uvm_info("TX_SCRB_DBG27", "SB: Verify connections27 of TX27 scorebboard27 - using debug_connected_to", UVM_NONE)
      // Implement27 here27 the checks27 
    apb_match27.debug_connected_to();
    uart_add27.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd27

class uart_ctrl_rx_scbd27 extends uvm_scoreboard;
  bit [7:0] data_from_apb27[$];
  bit [7:0] data_to_apb27[$]; // Relevant27 for Remoteloopback27 case only
  bit div_en27;

  bit [7:0] temp127;
  bit [7:0] mask;

  // Hooks27 to cause in scoroboard27 check errors27
  // This27 resulting27 failure27 is used in MDV27 workshop27 for failure27 analysis27
  `ifdef UVM_WKSHP27
    bit uart_error27;
  `endif

  uart_pkg27::uart_config27 uart_cfg27;
  apb_pkg27::apb_slave_config27 slave_cfg27;

  `uvm_component_utils(uart_ctrl_rx_scbd27)
  uvm_analysis_imp_apb27 #(apb_pkg27::apb_transfer27, uart_ctrl_rx_scbd27) apb_add27;
  uvm_analysis_imp_uart27 #(uart_pkg27::uart_frame27, uart_ctrl_rx_scbd27) uart_match27;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match27 = new("uart_match27", this);
    apb_add27    = new("apb_add27", this);
  endfunction : new
   
  // implement APB27 WRITE analysis27 port from reference model
  virtual function void write_apb27(input apb_pkg27::apb_transfer27 transfer27);
    `uvm_info("SCRBD27",
              $psprintf("write_apb27 called with addr = 'h%0h and data = 'h%0h",
              transfer27.addr, transfer27.data), UVM_HIGH)
    if ((transfer27.addr == (slave_cfg27.start_address27 + `LINE_CTRL27)) &&
        (transfer27.direction27 == apb_pkg27::APB_WRITE27)) begin
      div_en27 = transfer27.data[7];
      `uvm_info("SCRBD27",
              $psprintf("LINE_CTRL27 Write with addr = 'h%0h and data = 'h%0h div_en27 = %0b",
              transfer27.addr, transfer27.data, div_en27 ), UVM_HIGH)
    end

    if (!div_en27) begin
      if ((transfer27.addr == (slave_cfg27.start_address27 + `TX_FIFO_REG27)) &&
          (transfer27.direction27 == apb_pkg27::APB_WRITE27)) begin 
        `uvm_info("SCRBD27",
               $psprintf("write_apb27 called pushing27 into queue with data = 'h%0h",
               transfer27.data ), UVM_HIGH)
        data_from_apb27.push_back(transfer27.data);
      end
    end
  endfunction : write_apb27
   
  // implement UART27 Rx27 analysis27 port from reference model
  virtual function void write_uart27( uart_pkg27::uart_frame27 frame27);
    mask = calc_mask27();

    //In case of remote27 loopback27, the data does not get into the rx27/fifo and it gets27 
    // loopbacked27 to ua_txd27. 
    data_to_apb27.push_back(frame27.payload27);	

      temp127 = data_from_apb27.pop_front();

    `ifdef UVM_WKSHP27
        corrupt_payload27 (frame27);
    `endif 
    if ((temp127 & mask) == frame27.payload27) 
      `uvm_info("SCRBD27", $psprintf("####### PASS27 : %s RECEIVED27 CORRECT27 DATA27 expected = 'h%0h, received27 = 'h%0h", slave_cfg27.name, (temp127 & mask), frame27.payload27), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD27", $psprintf("####### FAIL27 : %s RECEIVED27 WRONG27 DATA27", slave_cfg27.name))
      `uvm_info("SCRBD27", $psprintf("expected = 'h%0h, received27 = 'h%0h", temp127, frame27.payload27), UVM_LOW)
    end
  endfunction : write_uart27
   
  function void assign_cfg27(uart_pkg27::uart_config27 u_cfg27);
     uart_cfg27 = u_cfg27;
  endfunction : assign_cfg27
   
  function void update_config27(uart_pkg27::uart_config27 u_cfg27);
   `uvm_info(get_type_name(), {"Updating Config27\n", u_cfg27.sprint}, UVM_HIGH)
    uart_cfg27 = u_cfg27;
  endfunction : update_config27

  function bit[7:0] calc_mask27();
    case (uart_cfg27.char_len_val27)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask27

  `ifdef UVM_WKSHP27
   function void corrupt_payload27 (uart_pkg27::uart_frame27 frame27);
      if(!randomize(uart_error27) with {uart_error27 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL27", $psprintf("Randomization failed for apb_error27"))
      `uvm_info("SCRBD27",(""), UVM_HIGH)
      frame27.payload27+=uart_error27;    	
   endfunction : corrupt_payload27

  `endif

  // Add task run to debug27 TLM connectivity27
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist27;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG27", "SB: Verify connections27 RX27 of scorebboard27 - using debug_provided_to", UVM_NONE)
      // Implement27 here27 the checks27 
    apb_add27.debug_provided_to();
    uart_match27.debug_provided_to();
      `uvm_info("RX_SCRB_DBG27", "SB: Verify connections27 of RX27 scorebboard27 - using debug_connected_to", UVM_NONE)
      // Implement27 here27 the checks27 
    apb_add27.debug_connected_to();
    uart_match27.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd27
