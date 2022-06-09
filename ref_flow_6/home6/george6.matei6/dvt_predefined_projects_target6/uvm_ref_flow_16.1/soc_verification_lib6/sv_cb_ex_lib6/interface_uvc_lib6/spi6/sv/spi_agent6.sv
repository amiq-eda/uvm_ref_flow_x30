/*-------------------------------------------------------------------------
File6 name   : spi_agent6.sv
Title6       : SPI6 SystemVerilog6 UVM UVC6
Project6     : UVM SystemVerilog6 Cluster6 Level6 Verification6
Created6     :
Description6 : 
Notes6       :  
---------------------------------------------------------------------------*/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV6
`define SPI_AGENT_SV6

class spi_agent6 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id6;

  spi_driver6 driver;
  spi_sequencer6 sequencer;
  spi_monitor6 monitor6;

  // Provide6 implementations6 of virtual methods6 such6 as get_type_name and create
  `uvm_component_utils_begin(spi_agent6)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id6, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor6 = spi_monitor6::type_id::create("monitor6", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer6::type_id::create("sequencer", this);
      driver = spi_driver6::type_id::create("driver", this);
      driver.monitor6 = monitor6;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr6 of the agent6's cheldren6
  function void assign_csr6(spi_csr_s6 csr_s6);
    monitor6.csr_s6 = csr_s6;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s6 = csr_s6;
    end
  endfunction : assign_csr6

endclass : spi_agent6

`endif // SPI_AGENT_SV6

