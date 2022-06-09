/*-------------------------------------------------------------------------
File2 name   : spi_agent2.sv
Title2       : SPI2 SystemVerilog2 UVM UVC2
Project2     : UVM SystemVerilog2 Cluster2 Level2 Verification2
Created2     :
Description2 : 
Notes2       :  
---------------------------------------------------------------------------*/
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`ifndef SPI_AGENT_SV2
`define SPI_AGENT_SV2

class spi_agent2 extends uvm_agent;

  uvm_active_passive_enum is_active = UVM_ACTIVE;
  int agent_id2;

  spi_driver2 driver;
  spi_sequencer2 sequencer;
  spi_monitor2 monitor2;

  // Provide2 implementations2 of virtual methods2 such2 as get_type_name and create
  `uvm_component_utils_begin(spi_agent2)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(agent_id2, UVM_ALL_ON)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor2 = spi_monitor2::type_id::create("monitor2", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = spi_sequencer2::type_id::create("sequencer", this);
      driver = spi_driver2::type_id::create("driver", this);
      driver.monitor2 = monitor2;
    end
  endfunction : build_phase

  // connect
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

  // assign csr2 of the agent2's cheldren2
  function void assign_csr2(spi_csr_s2 csr_s2);
    monitor2.csr_s2 = csr_s2;
    if (is_active == UVM_ACTIVE) begin
      driver.csr_s2 = csr_s2;
    end
  endfunction : assign_csr2

endclass : spi_agent2

`endif // SPI_AGENT_SV2

