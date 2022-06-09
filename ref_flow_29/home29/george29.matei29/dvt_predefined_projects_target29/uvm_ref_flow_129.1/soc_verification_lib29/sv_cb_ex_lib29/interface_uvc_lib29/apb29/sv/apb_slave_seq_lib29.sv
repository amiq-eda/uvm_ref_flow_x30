/*******************************************************************************
  FILE : apb_slave_seq_lib29.sv
*******************************************************************************/
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV29
`define APB_SLAVE_SEQ_LIB_SV29

//------------------------------------------------------------------------------
// SEQUENCE29: simple_response_seq29
//------------------------------------------------------------------------------

class simple_response_seq29 extends uvm_sequence #(apb_transfer29);

  function new(string name="simple_response_seq29");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq29)
  `uvm_declare_p_sequencer(apb_slave_sequencer29)

  apb_transfer29 req;
  apb_transfer29 util_transfer29;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port29.peek(util_transfer29);
      if((util_transfer29.direction29 == APB_READ29) && 
        (p_sequencer.cfg.check_address_range29(util_transfer29.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range29 Matching29 read.  Responding29...", util_transfer29.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction29 == APB_READ29; } )
      end
    end
  endtask : body

endclass : simple_response_seq29

//------------------------------------------------------------------------------
// SEQUENCE29: mem_response_seq29
//------------------------------------------------------------------------------
class mem_response_seq29 extends uvm_sequence #(apb_transfer29);

  function new(string name="mem_response_seq29");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data29;

  `uvm_object_utils(mem_response_seq29)
  `uvm_declare_p_sequencer(apb_slave_sequencer29)

  //simple29 assoc29 array to hold29 values
  logic [31:0] slave_mem29[int];

  apb_transfer29 req;
  apb_transfer29 util_transfer29;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port29.peek(util_transfer29);
      if((util_transfer29.direction29 == APB_READ29) && 
        (p_sequencer.cfg.check_address_range29(util_transfer29.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range29 Matching29 APB_READ29.  Responding29...", util_transfer29.addr), UVM_MEDIUM);
        if (slave_mem29.exists(util_transfer29.addr))
        `uvm_do_with(req, { req.direction29 == APB_READ29;
                            req.addr == util_transfer29.addr;
                            req.data == slave_mem29[util_transfer29.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction29 == APB_READ29;
                            req.addr == util_transfer29.addr;
                            req.data == mem_data29; } )
         mem_data29++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range29(util_transfer29.addr) == 1) begin
        slave_mem29[util_transfer29.addr] = util_transfer29.data;
        // DUMMY29 response with same information
        `uvm_do_with(req, { req.direction29 == APB_WRITE29;
                            req.addr == util_transfer29.addr;
                            req.data == util_transfer29.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq29

`endif // APB_SLAVE_SEQ_LIB_SV29
