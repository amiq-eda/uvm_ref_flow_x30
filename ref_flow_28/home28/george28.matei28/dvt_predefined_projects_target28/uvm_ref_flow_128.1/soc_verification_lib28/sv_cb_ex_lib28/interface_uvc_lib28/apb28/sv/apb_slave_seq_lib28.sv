/*******************************************************************************
  FILE : apb_slave_seq_lib28.sv
*******************************************************************************/
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


`ifndef APB_SLAVE_SEQ_LIB_SV28
`define APB_SLAVE_SEQ_LIB_SV28

//------------------------------------------------------------------------------
// SEQUENCE28: simple_response_seq28
//------------------------------------------------------------------------------

class simple_response_seq28 extends uvm_sequence #(apb_transfer28);

  function new(string name="simple_response_seq28");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq28)
  `uvm_declare_p_sequencer(apb_slave_sequencer28)

  apb_transfer28 req;
  apb_transfer28 util_transfer28;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port28.peek(util_transfer28);
      if((util_transfer28.direction28 == APB_READ28) && 
        (p_sequencer.cfg.check_address_range28(util_transfer28.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range28 Matching28 read.  Responding28...", util_transfer28.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction28 == APB_READ28; } )
      end
    end
  endtask : body

endclass : simple_response_seq28

//------------------------------------------------------------------------------
// SEQUENCE28: mem_response_seq28
//------------------------------------------------------------------------------
class mem_response_seq28 extends uvm_sequence #(apb_transfer28);

  function new(string name="mem_response_seq28");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data28;

  `uvm_object_utils(mem_response_seq28)
  `uvm_declare_p_sequencer(apb_slave_sequencer28)

  //simple28 assoc28 array to hold28 values
  logic [31:0] slave_mem28[int];

  apb_transfer28 req;
  apb_transfer28 util_transfer28;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port28.peek(util_transfer28);
      if((util_transfer28.direction28 == APB_READ28) && 
        (p_sequencer.cfg.check_address_range28(util_transfer28.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range28 Matching28 APB_READ28.  Responding28...", util_transfer28.addr), UVM_MEDIUM);
        if (slave_mem28.exists(util_transfer28.addr))
        `uvm_do_with(req, { req.direction28 == APB_READ28;
                            req.addr == util_transfer28.addr;
                            req.data == slave_mem28[util_transfer28.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction28 == APB_READ28;
                            req.addr == util_transfer28.addr;
                            req.data == mem_data28; } )
         mem_data28++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range28(util_transfer28.addr) == 1) begin
        slave_mem28[util_transfer28.addr] = util_transfer28.data;
        // DUMMY28 response with same information
        `uvm_do_with(req, { req.direction28 == APB_WRITE28;
                            req.addr == util_transfer28.addr;
                            req.data == util_transfer28.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq28

`endif // APB_SLAVE_SEQ_LIB_SV28
