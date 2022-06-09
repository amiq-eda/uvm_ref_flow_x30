/*******************************************************************************
  FILE : apb_slave_seq_lib27.sv
*******************************************************************************/
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV27
`define APB_SLAVE_SEQ_LIB_SV27

//------------------------------------------------------------------------------
// SEQUENCE27: simple_response_seq27
//------------------------------------------------------------------------------

class simple_response_seq27 extends uvm_sequence #(apb_transfer27);

  function new(string name="simple_response_seq27");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq27)
  `uvm_declare_p_sequencer(apb_slave_sequencer27)

  apb_transfer27 req;
  apb_transfer27 util_transfer27;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port27.peek(util_transfer27);
      if((util_transfer27.direction27 == APB_READ27) && 
        (p_sequencer.cfg.check_address_range27(util_transfer27.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range27 Matching27 read.  Responding27...", util_transfer27.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction27 == APB_READ27; } )
      end
    end
  endtask : body

endclass : simple_response_seq27

//------------------------------------------------------------------------------
// SEQUENCE27: mem_response_seq27
//------------------------------------------------------------------------------
class mem_response_seq27 extends uvm_sequence #(apb_transfer27);

  function new(string name="mem_response_seq27");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data27;

  `uvm_object_utils(mem_response_seq27)
  `uvm_declare_p_sequencer(apb_slave_sequencer27)

  //simple27 assoc27 array to hold27 values
  logic [31:0] slave_mem27[int];

  apb_transfer27 req;
  apb_transfer27 util_transfer27;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port27.peek(util_transfer27);
      if((util_transfer27.direction27 == APB_READ27) && 
        (p_sequencer.cfg.check_address_range27(util_transfer27.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range27 Matching27 APB_READ27.  Responding27...", util_transfer27.addr), UVM_MEDIUM);
        if (slave_mem27.exists(util_transfer27.addr))
        `uvm_do_with(req, { req.direction27 == APB_READ27;
                            req.addr == util_transfer27.addr;
                            req.data == slave_mem27[util_transfer27.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction27 == APB_READ27;
                            req.addr == util_transfer27.addr;
                            req.data == mem_data27; } )
         mem_data27++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range27(util_transfer27.addr) == 1) begin
        slave_mem27[util_transfer27.addr] = util_transfer27.data;
        // DUMMY27 response with same information
        `uvm_do_with(req, { req.direction27 == APB_WRITE27;
                            req.addr == util_transfer27.addr;
                            req.data == util_transfer27.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq27

`endif // APB_SLAVE_SEQ_LIB_SV27
