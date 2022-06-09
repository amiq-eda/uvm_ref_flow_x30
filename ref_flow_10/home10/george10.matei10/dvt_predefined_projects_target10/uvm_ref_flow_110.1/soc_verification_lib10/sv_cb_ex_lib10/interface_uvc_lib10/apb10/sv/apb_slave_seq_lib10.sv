/*******************************************************************************
  FILE : apb_slave_seq_lib10.sv
*******************************************************************************/
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV10
`define APB_SLAVE_SEQ_LIB_SV10

//------------------------------------------------------------------------------
// SEQUENCE10: simple_response_seq10
//------------------------------------------------------------------------------

class simple_response_seq10 extends uvm_sequence #(apb_transfer10);

  function new(string name="simple_response_seq10");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq10)
  `uvm_declare_p_sequencer(apb_slave_sequencer10)

  apb_transfer10 req;
  apb_transfer10 util_transfer10;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port10.peek(util_transfer10);
      if((util_transfer10.direction10 == APB_READ10) && 
        (p_sequencer.cfg.check_address_range10(util_transfer10.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range10 Matching10 read.  Responding10...", util_transfer10.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction10 == APB_READ10; } )
      end
    end
  endtask : body

endclass : simple_response_seq10

//------------------------------------------------------------------------------
// SEQUENCE10: mem_response_seq10
//------------------------------------------------------------------------------
class mem_response_seq10 extends uvm_sequence #(apb_transfer10);

  function new(string name="mem_response_seq10");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data10;

  `uvm_object_utils(mem_response_seq10)
  `uvm_declare_p_sequencer(apb_slave_sequencer10)

  //simple10 assoc10 array to hold10 values
  logic [31:0] slave_mem10[int];

  apb_transfer10 req;
  apb_transfer10 util_transfer10;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port10.peek(util_transfer10);
      if((util_transfer10.direction10 == APB_READ10) && 
        (p_sequencer.cfg.check_address_range10(util_transfer10.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range10 Matching10 APB_READ10.  Responding10...", util_transfer10.addr), UVM_MEDIUM);
        if (slave_mem10.exists(util_transfer10.addr))
        `uvm_do_with(req, { req.direction10 == APB_READ10;
                            req.addr == util_transfer10.addr;
                            req.data == slave_mem10[util_transfer10.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction10 == APB_READ10;
                            req.addr == util_transfer10.addr;
                            req.data == mem_data10; } )
         mem_data10++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range10(util_transfer10.addr) == 1) begin
        slave_mem10[util_transfer10.addr] = util_transfer10.data;
        // DUMMY10 response with same information
        `uvm_do_with(req, { req.direction10 == APB_WRITE10;
                            req.addr == util_transfer10.addr;
                            req.data == util_transfer10.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq10

`endif // APB_SLAVE_SEQ_LIB_SV10
