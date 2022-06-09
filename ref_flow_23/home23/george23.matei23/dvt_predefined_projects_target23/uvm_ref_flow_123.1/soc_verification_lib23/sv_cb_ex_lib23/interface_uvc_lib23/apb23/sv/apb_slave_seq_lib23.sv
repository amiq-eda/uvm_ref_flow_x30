/*******************************************************************************
  FILE : apb_slave_seq_lib23.sv
*******************************************************************************/
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV23
`define APB_SLAVE_SEQ_LIB_SV23

//------------------------------------------------------------------------------
// SEQUENCE23: simple_response_seq23
//------------------------------------------------------------------------------

class simple_response_seq23 extends uvm_sequence #(apb_transfer23);

  function new(string name="simple_response_seq23");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq23)
  `uvm_declare_p_sequencer(apb_slave_sequencer23)

  apb_transfer23 req;
  apb_transfer23 util_transfer23;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port23.peek(util_transfer23);
      if((util_transfer23.direction23 == APB_READ23) && 
        (p_sequencer.cfg.check_address_range23(util_transfer23.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range23 Matching23 read.  Responding23...", util_transfer23.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction23 == APB_READ23; } )
      end
    end
  endtask : body

endclass : simple_response_seq23

//------------------------------------------------------------------------------
// SEQUENCE23: mem_response_seq23
//------------------------------------------------------------------------------
class mem_response_seq23 extends uvm_sequence #(apb_transfer23);

  function new(string name="mem_response_seq23");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data23;

  `uvm_object_utils(mem_response_seq23)
  `uvm_declare_p_sequencer(apb_slave_sequencer23)

  //simple23 assoc23 array to hold23 values
  logic [31:0] slave_mem23[int];

  apb_transfer23 req;
  apb_transfer23 util_transfer23;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port23.peek(util_transfer23);
      if((util_transfer23.direction23 == APB_READ23) && 
        (p_sequencer.cfg.check_address_range23(util_transfer23.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range23 Matching23 APB_READ23.  Responding23...", util_transfer23.addr), UVM_MEDIUM);
        if (slave_mem23.exists(util_transfer23.addr))
        `uvm_do_with(req, { req.direction23 == APB_READ23;
                            req.addr == util_transfer23.addr;
                            req.data == slave_mem23[util_transfer23.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction23 == APB_READ23;
                            req.addr == util_transfer23.addr;
                            req.data == mem_data23; } )
         mem_data23++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range23(util_transfer23.addr) == 1) begin
        slave_mem23[util_transfer23.addr] = util_transfer23.data;
        // DUMMY23 response with same information
        `uvm_do_with(req, { req.direction23 == APB_WRITE23;
                            req.addr == util_transfer23.addr;
                            req.data == util_transfer23.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq23

`endif // APB_SLAVE_SEQ_LIB_SV23
