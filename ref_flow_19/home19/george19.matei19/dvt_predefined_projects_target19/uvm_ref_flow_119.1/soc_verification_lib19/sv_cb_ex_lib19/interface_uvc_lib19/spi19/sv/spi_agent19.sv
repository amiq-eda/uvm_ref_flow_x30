/*-------------------------------------------------------------------------
File19 name   : spi_agent19.sv
Title19       : SPI19 SystemVerilog19 UVM UVC19
Project19     : UVM SystemVerilog19 Cluster19 Level19 Verification19
Created19     :
Description19 : 
Notes19       :  
---------------------------------------------------------------------------*/
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV19
`define SPI_AGENT_SV19

class spi_agent19 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id19;

  spi_driver19 driver;
  spi_sequencer19 sequencer;
  spi_monitor19 monitor19;

  // Provide19 implementations19 of virtual methods19 such19 as get_type_name and create
  `uvm_component_utils_begin(spi_agent19)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id19, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor19 = spi_monitor19::type_id::create("monitor19", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer19::type_id::create("sequencer", this);
      driver = spi_driver19::type_id::create("driver", this);
      driver.monitor19 = monitor19;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr19 of the agent19's cheldren19
  function void assign_csr19(spi_csr_s19 csr_s19);
    monitor19.csr_s19 = csr_s19;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s19 = csr_s19;
    end
  endfunction : assign_csr19

endclass : spi_agent19

`endif // SPI_AGENT_SV19

