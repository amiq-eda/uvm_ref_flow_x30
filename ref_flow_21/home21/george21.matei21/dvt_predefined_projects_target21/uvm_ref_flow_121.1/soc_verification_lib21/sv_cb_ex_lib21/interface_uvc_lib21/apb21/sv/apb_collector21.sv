/*******************************************************************************
  FILE : apb_collector21.sv
*******************************************************************************/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef APB_COLLECTOR_SV21
`define APB_COLLECTOR_SV21

//------------------------------------------------------------------------------
// CLASS21: apb_collector21
//------------------------------------------------------------------------------

class apb_collector21 extends uvm_component;

  // The virtual interface used to view21 HDL signals21.
  virtual apb_if21 vif21;

  // APB21 configuration information
  apb_config21 cfg;

  // Property21 indicating the number21 of transactions occuring21 on the apb21.
  protected int unsigned num_transactions21 = 0;

  // The following21 two21 bits are used to control21 whether21 checks21 and coverage21 are
  // done both in the collector21 class and the interface.
  bit checks_enable21 = 1; 
  bit coverage_enable21 = 1;

  // TLM Ports21 - transfer21 collected21 for monitor21 other components21
  uvm_analysis_port #(apb_transfer21) item_collected_port21;

  // TLM Port21 - Allows21 sequencer access to transfer21 during address phase
  uvm_blocking_peek_imp#(apb_transfer21,apb_collector21) addr_trans_export21;
  event addr_trans_grabbed21;

  // The following21 property holds21 the transaction information currently
  // being captured21 (by the collect_address_phase21 and data_phase21 methods21). 
  apb_transfer21 trans_collected21;

  //Adding pseudo21-memory leakage21 for heap21 analysis21 lab21
  `ifdef HEAP21
  static apb_transfer21 runq21[$];
  `endif

  // Provide21 implementations21 of virtual methods21 such21 as get_type_name and create
  `uvm_component_utils_begin(apb_collector21)
    `uvm_field_object(cfg, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_int(checks_enable21, UVM_DEFAULT)
    `uvm_field_int(coverage_enable21, UVM_DEFAULT)
    `uvm_field_int(num_transactions21, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected21 = apb_transfer21::type_id::create("trans_collected21");
    // TLM ports21 are created here21
    item_collected_port21 = new("item_collected_port21", this);
    addr_trans_export21 = new("addr_trans_export21", this);
  endfunction : new

  // Additional21 class methods21
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_transactions21();
  extern task peek(output apb_transfer21 trans21);
  extern virtual function void report_phase(uvm_phase phase);

endclass : apb_collector21

// UVM build_phase
function void apb_collector21::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (cfg == null)
      if (!uvm_config_db#(apb_config21)::get(this, "", "cfg", cfg))
      `uvm_error("NOCONFIG21", "apb_config21 not set for this component")
endfunction : build_phase

// UVM connect_phase
function void apb_collector21::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if21)::get(this, "", "vif21", vif21))
      `uvm_error("NOVIF21", {"virtual interface must be set for: ", get_full_name(), ".vif21"})
endfunction : connect_phase


// UVM run_phase()
task apb_collector21::run_phase(uvm_phase phase);
    @(posedge vif21.preset21);
    `uvm_info(get_type_name(), "Detected21 Reset21 Done21", UVM_LOW)
    collect_transactions21();
endtask : run_phase

// collect_transactions21
task apb_collector21::collect_transactions21();
  forever begin
    @(posedge vif21.pclock21 iff (vif21.psel21 != 0));
    void'(this.begin_tr(trans_collected21,"apb_collector21","UVM Debug21","APB21 collector21 transaction inside collect_transactions21()"));
    trans_collected21.addr = vif21.paddr21;
    trans_collected21.master21 = cfg.master_config21.name;
    trans_collected21.slave21 = cfg.get_slave_name_by_addr21(trans_collected21.addr);
    case (vif21.prwd21)
      1'b0 : trans_collected21.direction21 = APB_READ21;
      1'b1 : trans_collected21.direction21 = APB_WRITE21;
    endcase
      @(posedge vif21.pclock21);
    if(trans_collected21.direction21 == APB_READ21)
      trans_collected21.data = vif21.prdata21;
    if (trans_collected21.direction21 == APB_WRITE21)
      trans_collected21.data = vif21.pwdata21;
    -> addr_trans_grabbed21;
    @(posedge vif21.pclock21);
    if(trans_collected21.direction21 == APB_READ21) begin
        if(vif21.pready21 != 1'b1)
          @(posedge vif21.pclock21);
      trans_collected21.data = vif21.prdata21;
      end
    this.end_tr(trans_collected21);
    item_collected_port21.write(trans_collected21);
    `uvm_info(get_type_name(), $psprintf("Transfer21 collected21 :\n%s",
              trans_collected21.sprint()), UVM_MEDIUM)
      `ifdef HEAP21
      runq21.push_back(trans_collected21);
      `endif
     num_transactions21++;
    end
endtask : collect_transactions21

task apb_collector21::peek(output apb_transfer21 trans21);
  @addr_trans_grabbed21;
  trans21 = trans_collected21;
endtask : peek

function void apb_collector21::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report21: APB21 collector21 collected21 %0d transfers21", num_transactions21), UVM_LOW);
endfunction : report_phase

`endif // APB_COLLECTOR_SV21
