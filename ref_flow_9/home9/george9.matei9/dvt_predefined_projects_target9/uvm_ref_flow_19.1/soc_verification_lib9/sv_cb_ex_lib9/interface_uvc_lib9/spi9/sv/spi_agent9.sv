/*-------------------------------------------------------------------------
File9 name   : spi_agent9.sv
Title9       : SPI9 SystemVerilog9 UVM UVC9
Project9     : UVM SystemVerilog9 Cluster9 Level9 Verification9
Created9     :
Description9 : 
Notes9       :  
---------------------------------------------------------------------------*/
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV9
`define SPI_AGENT_SV9

class spi_agent9 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id9;

  spi_driver9 driver;
  spi_sequencer9 sequencer;
  spi_monitor9 monitor9;

  // Provide9 implementations9 of virtual methods9 such9 as get_type_name and create
  `uvm_component_utils_begin(spi_agent9)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id9, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor9 = spi_monitor9::type_id::create("monitor9", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer9::type_id::create("sequencer", this);
      driver = spi_driver9::type_id::create("driver", this);
      driver.monitor9 = monitor9;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr9 of the agent9's cheldren9
  function void assign_csr9(spi_csr_s9 csr_s9);
    monitor9.csr_s9 = csr_s9;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s9 = csr_s9;
    end
  endfunction : assign_csr9

endclass : spi_agent9

`endif // SPI_AGENT_SV9

