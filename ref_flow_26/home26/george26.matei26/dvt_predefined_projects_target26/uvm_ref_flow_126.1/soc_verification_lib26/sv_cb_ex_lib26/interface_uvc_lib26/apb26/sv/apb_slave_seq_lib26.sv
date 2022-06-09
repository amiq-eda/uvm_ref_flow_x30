/*******************************************************************************
  FILE : apb_slave_seq_lib26.sv
*******************************************************************************/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV26
`define APB_SLAVE_SEQ_LIB_SV26

//------------------------------------------------------------------------------
// SEQUENCE26: simple_response_seq26
//------------------------------------------------------------------------------

class simple_response_seq26 extends uvm_sequence #(apb_transfer26);

  function new(string name="simple_response_seq26");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq26)
  `uvm_declare_p_sequencer(apb_slave_sequencer26)

  apb_transfer26 req;
  apb_transfer26 util_transfer26;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port26.peek(util_transfer26);
      if((util_transfer26.direction26 == APB_READ26) && 
        (p_sequencer.cfg.check_address_range26(util_transfer26.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range26 Matching26 read.  Responding26...", util_transfer26.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction26 == APB_READ26; } )
      end
    end
  endtask : body

endclass : simple_response_seq26

//------------------------------------------------------------------------------
// SEQUENCE26: mem_response_seq26
//------------------------------------------------------------------------------
class mem_response_seq26 extends uvm_sequence #(apb_transfer26);

  function new(string name="mem_response_seq26");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data26;

  `uvm_object_utils(mem_response_seq26)
  `uvm_declare_p_sequencer(apb_slave_sequencer26)

  //simple26 assoc26 array to hold26 values
  logic [31:0] slave_mem26[int];

  apb_transfer26 req;
  apb_transfer26 util_transfer26;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port26.peek(util_transfer26);
      if((util_transfer26.direction26 == APB_READ26) && 
        (p_sequencer.cfg.check_address_range26(util_transfer26.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range26 Matching26 APB_READ26.  Responding26...", util_transfer26.addr), UVM_MEDIUM);
        if (slave_mem26.exists(util_transfer26.addr))
        `uvm_do_with(req, { req.direction26 == APB_READ26;
                            req.addr == util_transfer26.addr;
                            req.data == slave_mem26[util_transfer26.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction26 == APB_READ26;
                            req.addr == util_transfer26.addr;
                            req.data == mem_data26; } )
         mem_data26++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range26(util_transfer26.addr) == 1) begin
        slave_mem26[util_transfer26.addr] = util_transfer26.data;
        // DUMMY26 response with same information
        `uvm_do_with(req, { req.direction26 == APB_WRITE26;
                            req.addr == util_transfer26.addr;
                            req.data == util_transfer26.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq26

`endif // APB_SLAVE_SEQ_LIB_SV26
