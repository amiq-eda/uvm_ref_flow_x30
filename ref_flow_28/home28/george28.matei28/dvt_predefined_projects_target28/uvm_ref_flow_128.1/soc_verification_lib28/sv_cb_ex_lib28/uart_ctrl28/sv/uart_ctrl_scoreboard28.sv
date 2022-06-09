/*-------------------------------------------------------------------------
File28 name   : uart_ctrl_scoreboard28.sv
Title28       : APB28 - UART28 Scoreboard28
Project28     :
Created28     :
Description28 : Scoreboard28 for data integrity28 check between APB28 UVC28 and UART28 UVC28
Notes28       : Two28 similar28 scoreboards28 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb28)
`uvm_analysis_imp_decl(_uart28)

class uart_ctrl_tx_scbd28 extends uvm_scoreboard;
  bit [7:0] data_to_apb28[$];
  bit [7:0] temp128;
  bit div_en28;

  // Hooks28 to cause in scoroboard28 check errors28
  // This28 resulting28 failure28 is used in MDV28 workshop28 for failure28 analysis28
  `ifdef UVM_WKSHP28
    bit apb_error28;
  `endif

  // Config28 Information28 
  uart_pkg28::uart_config28 uart_cfg28;
  apb_pkg28::apb_slave_config28 slave_cfg28;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd28)
     `uvm_field_object(uart_cfg28, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg28, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb28 #(apb_pkg28::apb_transfer28, uart_ctrl_tx_scbd28) apb_match28;
  uvm_analysis_imp_uart28 #(uart_pkg28::uart_frame28, uart_ctrl_tx_scbd28) uart_add28;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add28  = new("uart_add28", this);
    apb_match28 = new("apb_match28", this);
  endfunction : new

  // implement UART28 Tx28 analysis28 port from reference model
  virtual function void write_uart28(uart_pkg28::uart_frame28 frame28);
    data_to_apb28.push_back(frame28.payload28);	
  endfunction : write_uart28
     
  // implement APB28 READ analysis28 port from reference model
  virtual function void write_apb28(input apb_pkg28::apb_transfer28 transfer28);

    if (transfer28.addr == (slave_cfg28.start_address28 + `LINE_CTRL28)) begin
      div_en28 = transfer28.data[7];
      `uvm_info("SCRBD28",
              $psprintf("LINE_CTRL28 Write with addr = 'h%0h and data = 'h%0h div_en28 = %0b",
              transfer28.addr, transfer28.data, div_en28 ), UVM_HIGH)
    end

    if (!div_en28) begin
    if ((transfer28.addr ==   (slave_cfg28.start_address28 + `RX_FIFO_REG28)) && (transfer28.direction28 == apb_pkg28::APB_READ28))
      begin
       `ifdef UVM_WKSHP28
          corrupt_data28(transfer28);
       `endif
          temp128 = data_to_apb28.pop_front();
       
        if (temp128 == transfer28.data ) 
          `uvm_info("SCRBD28", $psprintf("####### PASS28 : APB28 RECEIVED28 CORRECT28 DATA28 from %s  expected = 'h%0h, received28 = 'h%0h", slave_cfg28.name, temp128, transfer28.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD28", $psprintf("####### FAIL28 : APB28 RECEIVED28 WRONG28 DATA28 from %s", slave_cfg28.name))
          `uvm_info("SCRBD28", $psprintf("expected = 'h%0h, received28 = 'h%0h", temp128, transfer28.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb28
   
  function void assign_cfg28(uart_pkg28::uart_config28 u_cfg28);
    uart_cfg28 = u_cfg28;
  endfunction : assign_cfg28

  function void update_config28(uart_pkg28::uart_config28 u_cfg28);
    `uvm_info(get_type_name(), {"Updating Config28\n", u_cfg28.sprint}, UVM_HIGH)
    uart_cfg28 = u_cfg28;
  endfunction : update_config28

 `ifdef UVM_WKSHP28
    function void corrupt_data28 (apb_pkg28::apb_transfer28 transfer28);
      if (!randomize(apb_error28) with {apb_error28 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL28", $psprintf("Randomization failed for apb_error28"))
      `uvm_info("SCRBD28",(""), UVM_HIGH)
      transfer28.data+=apb_error28;    	
    endfunction : corrupt_data28
  `endif

  // Add task run to debug28 TLM connectivity28 -- dbg_lab628
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG28", "SB: Verify connections28 TX28 of scorebboard28 - using debug_provided_to", UVM_NONE)
      // Implement28 here28 the checks28 
    apb_match28.debug_provided_to();
    uart_add28.debug_provided_to();
      `uvm_info("TX_SCRB_DBG28", "SB: Verify connections28 of TX28 scorebboard28 - using debug_connected_to", UVM_NONE)
      // Implement28 here28 the checks28 
    apb_match28.debug_connected_to();
    uart_add28.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd28

class uart_ctrl_rx_scbd28 extends uvm_scoreboard;
  bit [7:0] data_from_apb28[$];
  bit [7:0] data_to_apb28[$]; // Relevant28 for Remoteloopback28 case only
  bit div_en28;

  bit [7:0] temp128;
  bit [7:0] mask;

  // Hooks28 to cause in scoroboard28 check errors28
  // This28 resulting28 failure28 is used in MDV28 workshop28 for failure28 analysis28
  `ifdef UVM_WKSHP28
    bit uart_error28;
  `endif

  uart_pkg28::uart_config28 uart_cfg28;
  apb_pkg28::apb_slave_config28 slave_cfg28;

  `uvm_component_utils(uart_ctrl_rx_scbd28)
  uvm_analysis_imp_apb28 #(apb_pkg28::apb_transfer28, uart_ctrl_rx_scbd28) apb_add28;
  uvm_analysis_imp_uart28 #(uart_pkg28::uart_frame28, uart_ctrl_rx_scbd28) uart_match28;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match28 = new("uart_match28", this);
    apb_add28    = new("apb_add28", this);
  endfunction : new
   
  // implement APB28 WRITE analysis28 port from reference model
  virtual function void write_apb28(input apb_pkg28::apb_transfer28 transfer28);
    `uvm_info("SCRBD28",
              $psprintf("write_apb28 called with addr = 'h%0h and data = 'h%0h",
              transfer28.addr, transfer28.data), UVM_HIGH)
    if ((transfer28.addr == (slave_cfg28.start_address28 + `LINE_CTRL28)) &&
        (transfer28.direction28 == apb_pkg28::APB_WRITE28)) begin
      div_en28 = transfer28.data[7];
      `uvm_info("SCRBD28",
              $psprintf("LINE_CTRL28 Write with addr = 'h%0h and data = 'h%0h div_en28 = %0b",
              transfer28.addr, transfer28.data, div_en28 ), UVM_HIGH)
    end

    if (!div_en28) begin
      if ((transfer28.addr == (slave_cfg28.start_address28 + `TX_FIFO_REG28)) &&
          (transfer28.direction28 == apb_pkg28::APB_WRITE28)) begin 
        `uvm_info("SCRBD28",
               $psprintf("write_apb28 called pushing28 into queue with data = 'h%0h",
               transfer28.data ), UVM_HIGH)
        data_from_apb28.push_back(transfer28.data);
      end
    end
  endfunction : write_apb28
   
  // implement UART28 Rx28 analysis28 port from reference model
  virtual function void write_uart28( uart_pkg28::uart_frame28 frame28);
    mask = calc_mask28();

    //In case of remote28 loopback28, the data does not get into the rx28/fifo and it gets28 
    // loopbacked28 to ua_txd28. 
    data_to_apb28.push_back(frame28.payload28);	

      temp128 = data_from_apb28.pop_front();

    `ifdef UVM_WKSHP28
        corrupt_payload28 (frame28);
    `endif 
    if ((temp128 & mask) == frame28.payload28) 
      `uvm_info("SCRBD28", $psprintf("####### PASS28 : %s RECEIVED28 CORRECT28 DATA28 expected = 'h%0h, received28 = 'h%0h", slave_cfg28.name, (temp128 & mask), frame28.payload28), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD28", $psprintf("####### FAIL28 : %s RECEIVED28 WRONG28 DATA28", slave_cfg28.name))
      `uvm_info("SCRBD28", $psprintf("expected = 'h%0h, received28 = 'h%0h", temp128, frame28.payload28), UVM_LOW)
    end
  endfunction : write_uart28
   
  function void assign_cfg28(uart_pkg28::uart_config28 u_cfg28);
     uart_cfg28 = u_cfg28;
  endfunction : assign_cfg28
   
  function void update_config28(uart_pkg28::uart_config28 u_cfg28);
   `uvm_info(get_type_name(), {"Updating Config28\n", u_cfg28.sprint}, UVM_HIGH)
    uart_cfg28 = u_cfg28;
  endfunction : update_config28

  function bit[7:0] calc_mask28();
    case (uart_cfg28.char_len_val28)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask28

  `ifdef UVM_WKSHP28
   function void corrupt_payload28 (uart_pkg28::uart_frame28 frame28);
      if(!randomize(uart_error28) with {uart_error28 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL28", $psprintf("Randomization failed for apb_error28"))
      `uvm_info("SCRBD28",(""), UVM_HIGH)
      frame28.payload28+=uart_error28;    	
   endfunction : corrupt_payload28

  `endif

  // Add task run to debug28 TLM connectivity28
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist28;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG28", "SB: Verify connections28 RX28 of scorebboard28 - using debug_provided_to", UVM_NONE)
      // Implement28 here28 the checks28 
    apb_add28.debug_provided_to();
    uart_match28.debug_provided_to();
      `uvm_info("RX_SCRB_DBG28", "SB: Verify connections28 of RX28 scorebboard28 - using debug_connected_to", UVM_NONE)
      // Implement28 here28 the checks28 
    apb_add28.debug_connected_to();
    uart_match28.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd28
