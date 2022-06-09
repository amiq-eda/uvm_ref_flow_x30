/*******************************************************************************
  FILE : apb_slave_seq_lib17.sv
*******************************************************************************/
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV17
`define APB_SLAVE_SEQ_LIB_SV17

//------------------------------------------------------------------------------
// SEQUENCE17: simple_response_seq17
//------------------------------------------------------------------------------

class simple_response_seq17 extends uvm_sequence #(apb_transfer17);

  function new(string name="simple_response_seq17");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq17)
  `uvm_declare_p_sequencer(apb_slave_sequencer17)

  apb_transfer17 req;
  apb_transfer17 util_transfer17;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port17.peek(util_transfer17);
      if((util_transfer17.direction17 == APB_READ17) && 
        (p_sequencer.cfg.check_address_range17(util_transfer17.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range17 Matching17 read.  Responding17...", util_transfer17.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction17 == APB_READ17; } )
      end
    end
  endtask : body

endclass : simple_response_seq17

//------------------------------------------------------------------------------
// SEQUENCE17: mem_response_seq17
//------------------------------------------------------------------------------
class mem_response_seq17 extends uvm_sequence #(apb_transfer17);

  function new(string name="mem_response_seq17");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data17;

  `uvm_object_utils(mem_response_seq17)
  `uvm_declare_p_sequencer(apb_slave_sequencer17)

  //simple17 assoc17 array to hold17 values
  logic [31:0] slave_mem17[int];

  apb_transfer17 req;
  apb_transfer17 util_transfer17;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port17.peek(util_transfer17);
      if((util_transfer17.direction17 == APB_READ17) && 
        (p_sequencer.cfg.check_address_range17(util_transfer17.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range17 Matching17 APB_READ17.  Responding17...", util_transfer17.addr), UVM_MEDIUM);
        if (slave_mem17.exists(util_transfer17.addr))
        `uvm_do_with(req, { req.direction17 == APB_READ17;
                            req.addr == util_transfer17.addr;
                            req.data == slave_mem17[util_transfer17.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction17 == APB_READ17;
                            req.addr == util_transfer17.addr;
                            req.data == mem_data17; } )
         mem_data17++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range17(util_transfer17.addr) == 1) begin
        slave_mem17[util_transfer17.addr] = util_transfer17.data;
        // DUMMY17 response with same information
        `uvm_do_with(req, { req.direction17 == APB_WRITE17;
                            req.addr == util_transfer17.addr;
                            req.data == util_transfer17.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq17

`endif // APB_SLAVE_SEQ_LIB_SV17
