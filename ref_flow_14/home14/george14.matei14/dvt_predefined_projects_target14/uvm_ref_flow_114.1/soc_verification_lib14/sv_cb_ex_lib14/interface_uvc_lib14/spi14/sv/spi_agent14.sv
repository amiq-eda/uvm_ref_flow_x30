/*-------------------------------------------------------------------------
File14 name   : spi_agent14.sv
Title14       : SPI14 SystemVerilog14 UVM UVC14
Project14     : UVM SystemVerilog14 Cluster14 Level14 Verification14
Created14     :
Description14 : 
Notes14       :  
---------------------------------------------------------------------------*/
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


`ifndef SPI_AGENT_SV14
`define SPI_AGENT_SV14

class spi_agent14 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id14;

  spi_driver14 driver;
  spi_sequencer14 sequencer;
  spi_monitor14 monitor14;

  // Provide14 implementations14 of virtual methods14 such14 as get_type_name and create
  `uvm_component_utils_begin(spi_agent14)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id14, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor14 = spi_monitor14::type_id::create("monitor14", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer14::type_id::create("sequencer", this);
      driver = spi_driver14::type_id::create("driver", this);
      driver.monitor14 = monitor14;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr14 of the agent14's cheldren14
  function void assign_csr14(spi_csr_s14 csr_s14);
    monitor14.csr_s14 = csr_s14;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s14 = csr_s14;
    end
  endfunction : assign_csr14

endclass : spi_agent14

`endif // SPI_AGENT_SV14

