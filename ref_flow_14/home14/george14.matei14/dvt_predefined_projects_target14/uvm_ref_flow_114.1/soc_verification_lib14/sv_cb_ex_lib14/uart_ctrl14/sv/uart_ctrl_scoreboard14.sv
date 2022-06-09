/*-------------------------------------------------------------------------
File14 name   : uart_ctrl_scoreboard14.sv
Title14       : APB14 - UART14 Scoreboard14
Project14     :
Created14     :
Description14 : Scoreboard14 for data integrity14 check between APB14 UVC14 and UART14 UVC14
Notes14       : Two14 similar14 scoreboards14 one for read and one for write
----------------------------------------------------------------------*/
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb14)
`uvm_analysis_imp_decl(_uart14)

class uart_ctrl_tx_scbd14 extends uvm_scoreboard;
  bit [7:0] data_to_apb14[$];
  bit [7:0] temp114;
  bit div_en14;

  // Hooks14 to cause in scoroboard14 check errors14
  // This14 resulting14 failure14 is used in MDV14 workshop14 for failure14 analysis14
  `ifdef UVM_WKSHP14
    bit apb_error14;
  `endif

  // Config14 Information14 
  uart_pkg14::uart_config14 uart_cfg14;
  apb_pkg14::apb_slave_config14 slave_cfg14;

  `uvm_component_utils_begin(uart_ctrl_tx_scbd14)
     `uvm_field_object(uart_cfg14, UVM_ALL_ON | UVM_REFERENCE)
     `uvm_field_object(slave_cfg14, UVM_ALL_ON | UVM_REFERENCE)
  `uvm_component_utils_end

  uvm_analysis_imp_apb14 #(apb_pkg14::apb_transfer14, uart_ctrl_tx_scbd14) apb_match14;
  uvm_analysis_imp_uart14 #(uart_pkg14::uart_frame14, uart_ctrl_tx_scbd14) uart_add14;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_add14  = new("uart_add14", this);
    apb_match14 = new("apb_match14", this);
  endfunction : new

  // implement UART14 Tx14 analysis14 port from reference model
  virtual function void write_uart14(uart_pkg14::uart_frame14 frame14);
    data_to_apb14.push_back(frame14.payload14);	
  endfunction : write_uart14
     
  // implement APB14 READ analysis14 port from reference model
  virtual function void write_apb14(input apb_pkg14::apb_transfer14 transfer14);

    if (transfer14.addr == (slave_cfg14.start_address14 + `LINE_CTRL14)) begin
      div_en14 = transfer14.data[7];
      `uvm_info("SCRBD14",
              $psprintf("LINE_CTRL14 Write with addr = 'h%0h and data = 'h%0h div_en14 = %0b",
              transfer14.addr, transfer14.data, div_en14 ), UVM_HIGH)
    end

    if (!div_en14) begin
    if ((transfer14.addr ==   (slave_cfg14.start_address14 + `RX_FIFO_REG14)) && (transfer14.direction14 == apb_pkg14::APB_READ14))
      begin
       `ifdef UVM_WKSHP14
          corrupt_data14(transfer14);
       `endif
          temp114 = data_to_apb14.pop_front();
       
        if (temp114 == transfer14.data ) 
          `uvm_info("SCRBD14", $psprintf("####### PASS14 : APB14 RECEIVED14 CORRECT14 DATA14 from %s  expected = 'h%0h, received14 = 'h%0h", slave_cfg14.name, temp114, transfer14.data), UVM_MEDIUM)
        else
        begin
          `uvm_error("SCRBD14", $psprintf("####### FAIL14 : APB14 RECEIVED14 WRONG14 DATA14 from %s", slave_cfg14.name))
          `uvm_info("SCRBD14", $psprintf("expected = 'h%0h, received14 = 'h%0h", temp114, transfer14.data), UVM_LOW)
        end
      end
    end
  endfunction : write_apb14
   
  function void assign_cfg14(uart_pkg14::uart_config14 u_cfg14);
    uart_cfg14 = u_cfg14;
  endfunction : assign_cfg14

  function void update_config14(uart_pkg14::uart_config14 u_cfg14);
    `uvm_info(get_type_name(), {"Updating Config14\n", u_cfg14.sprint}, UVM_HIGH)
    uart_cfg14 = u_cfg14;
  endfunction : update_config14

 `ifdef UVM_WKSHP14
    function void corrupt_data14 (apb_pkg14::apb_transfer14 transfer14);
      if (!randomize(apb_error14) with {apb_error14 dist {1:=30,0:=70};})
        `uvm_fatal("RNDFAIL14", $psprintf("Randomization failed for apb_error14"))
      `uvm_info("SCRBD14",(""), UVM_HIGH)
      transfer14.data+=apb_error14;    	
    endfunction : corrupt_data14
  `endif

  // Add task run to debug14 TLM connectivity14 -- dbg_lab614
/*
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  `uvm_info("TX_SCRB_DBG14", "SB: Verify connections14 TX14 of scorebboard14 - using debug_provided_to", UVM_NONE)
      // Implement14 here14 the checks14 
    apb_match14.debug_provided_to();
    uart_add14.debug_provided_to();
      `uvm_info("TX_SCRB_DBG14", "SB: Verify connections14 of TX14 scorebboard14 - using debug_connected_to", UVM_NONE)
      // Implement14 here14 the checks14 
    apb_match14.debug_connected_to();
    uart_add14.debug_connected_to();
   endtask
*/

endclass : uart_ctrl_tx_scbd14

class uart_ctrl_rx_scbd14 extends uvm_scoreboard;
  bit [7:0] data_from_apb14[$];
  bit [7:0] data_to_apb14[$]; // Relevant14 for Remoteloopback14 case only
  bit div_en14;

  bit [7:0] temp114;
  bit [7:0] mask;

  // Hooks14 to cause in scoroboard14 check errors14
  // This14 resulting14 failure14 is used in MDV14 workshop14 for failure14 analysis14
  `ifdef UVM_WKSHP14
    bit uart_error14;
  `endif

  uart_pkg14::uart_config14 uart_cfg14;
  apb_pkg14::apb_slave_config14 slave_cfg14;

  `uvm_component_utils(uart_ctrl_rx_scbd14)
  uvm_analysis_imp_apb14 #(apb_pkg14::apb_transfer14, uart_ctrl_rx_scbd14) apb_add14;
  uvm_analysis_imp_uart14 #(uart_pkg14::uart_frame14, uart_ctrl_rx_scbd14) uart_match14;
   
  function new (string name = "", uvm_component parent = null);
    super.new(name, parent);
    uart_match14 = new("uart_match14", this);
    apb_add14    = new("apb_add14", this);
  endfunction : new
   
  // implement APB14 WRITE analysis14 port from reference model
  virtual function void write_apb14(input apb_pkg14::apb_transfer14 transfer14);
    `uvm_info("SCRBD14",
              $psprintf("write_apb14 called with addr = 'h%0h and data = 'h%0h",
              transfer14.addr, transfer14.data), UVM_HIGH)
    if ((transfer14.addr == (slave_cfg14.start_address14 + `LINE_CTRL14)) &&
        (transfer14.direction14 == apb_pkg14::APB_WRITE14)) begin
      div_en14 = transfer14.data[7];
      `uvm_info("SCRBD14",
              $psprintf("LINE_CTRL14 Write with addr = 'h%0h and data = 'h%0h div_en14 = %0b",
              transfer14.addr, transfer14.data, div_en14 ), UVM_HIGH)
    end

    if (!div_en14) begin
      if ((transfer14.addr == (slave_cfg14.start_address14 + `TX_FIFO_REG14)) &&
          (transfer14.direction14 == apb_pkg14::APB_WRITE14)) begin 
        `uvm_info("SCRBD14",
               $psprintf("write_apb14 called pushing14 into queue with data = 'h%0h",
               transfer14.data ), UVM_HIGH)
        data_from_apb14.push_back(transfer14.data);
      end
    end
  endfunction : write_apb14
   
  // implement UART14 Rx14 analysis14 port from reference model
  virtual function void write_uart14( uart_pkg14::uart_frame14 frame14);
    mask = calc_mask14();

    //In case of remote14 loopback14, the data does not get into the rx14/fifo and it gets14 
    // loopbacked14 to ua_txd14. 
    data_to_apb14.push_back(frame14.payload14);	

      temp114 = data_from_apb14.pop_front();

    `ifdef UVM_WKSHP14
        corrupt_payload14 (frame14);
    `endif 
    if ((temp114 & mask) == frame14.payload14) 
      `uvm_info("SCRBD14", $psprintf("####### PASS14 : %s RECEIVED14 CORRECT14 DATA14 expected = 'h%0h, received14 = 'h%0h", slave_cfg14.name, (temp114 & mask), frame14.payload14), UVM_MEDIUM)
    else
    begin
      `uvm_error("SCRBD14", $psprintf("####### FAIL14 : %s RECEIVED14 WRONG14 DATA14", slave_cfg14.name))
      `uvm_info("SCRBD14", $psprintf("expected = 'h%0h, received14 = 'h%0h", temp114, frame14.payload14), UVM_LOW)
    end
  endfunction : write_uart14
   
  function void assign_cfg14(uart_pkg14::uart_config14 u_cfg14);
     uart_cfg14 = u_cfg14;
  endfunction : assign_cfg14
   
  function void update_config14(uart_pkg14::uart_config14 u_cfg14);
   `uvm_info(get_type_name(), {"Updating Config14\n", u_cfg14.sprint}, UVM_HIGH)
    uart_cfg14 = u_cfg14;
  endfunction : update_config14

  function bit[7:0] calc_mask14();
    case (uart_cfg14.char_len_val14)
      6: return 8'b00111111;
      7: return 8'b01111111;
      8: return 8'b11111111;
      default: return 8'hff;
    endcase
  endfunction : calc_mask14

  `ifdef UVM_WKSHP14
   function void corrupt_payload14 (uart_pkg14::uart_frame14 frame14);
      if(!randomize(uart_error14) with {uart_error14 dist {1:=5,0:=95};})
        `uvm_fatal("RNDFAIL14", $psprintf("Randomization failed for apb_error14"))
      `uvm_info("SCRBD14",(""), UVM_HIGH)
      frame14.payload14+=uart_error14;    	
   endfunction : corrupt_payload14

  `endif

  // Add task run to debug14 TLM connectivity14
/*
  task run_phase(uvm_phase phase);
	  uvm_port_list plist14;

	  super.run_phase(phase);
	  `uvm_info("RX_SCRB_DBG14", "SB: Verify connections14 RX14 of scorebboard14 - using debug_provided_to", UVM_NONE)
      // Implement14 here14 the checks14 
    apb_add14.debug_provided_to();
    uart_match14.debug_provided_to();
      `uvm_info("RX_SCRB_DBG14", "SB: Verify connections14 of RX14 scorebboard14 - using debug_connected_to", UVM_NONE)
      // Implement14 here14 the checks14 
    apb_add14.debug_connected_to();
    uart_match14.debug_connected_to();
   endtask : run_phase
*/

endclass : uart_ctrl_rx_scbd14
