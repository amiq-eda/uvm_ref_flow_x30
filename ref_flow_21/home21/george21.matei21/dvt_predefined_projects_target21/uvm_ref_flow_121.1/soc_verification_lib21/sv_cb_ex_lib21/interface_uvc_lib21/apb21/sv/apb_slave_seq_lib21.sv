/*******************************************************************************
  FILE : apb_slave_seq_lib21.sv
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


`ifndef APB_SLAVE_SEQ_LIB_SV21
`define APB_SLAVE_SEQ_LIB_SV21

//------------------------------------------------------------------------------
// SEQUENCE21: simple_response_seq21
//------------------------------------------------------------------------------

class simple_response_seq21 extends uvm_sequence #(apb_transfer21);

  function new(string name="simple_response_seq21");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq21)
  `uvm_declare_p_sequencer(apb_slave_sequencer21)

  apb_transfer21 req;
  apb_transfer21 util_transfer21;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port21.peek(util_transfer21);
      if((util_transfer21.direction21 == APB_READ21) && 
        (p_sequencer.cfg.check_address_range21(util_transfer21.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range21 Matching21 read.  Responding21...", util_transfer21.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction21 == APB_READ21; } )
      end
    end
  endtask : body

endclass : simple_response_seq21

//------------------------------------------------------------------------------
// SEQUENCE21: mem_response_seq21
//------------------------------------------------------------------------------
class mem_response_seq21 extends uvm_sequence #(apb_transfer21);

  function new(string name="mem_response_seq21");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data21;

  `uvm_object_utils(mem_response_seq21)
  `uvm_declare_p_sequencer(apb_slave_sequencer21)

  //simple21 assoc21 array to hold21 values
  logic [31:0] slave_mem21[int];

  apb_transfer21 req;
  apb_transfer21 util_transfer21;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port21.peek(util_transfer21);
      if((util_transfer21.direction21 == APB_READ21) && 
        (p_sequencer.cfg.check_address_range21(util_transfer21.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range21 Matching21 APB_READ21.  Responding21...", util_transfer21.addr), UVM_MEDIUM);
        if (slave_mem21.exists(util_transfer21.addr))
        `uvm_do_with(req, { req.direction21 == APB_READ21;
                            req.addr == util_transfer21.addr;
                            req.data == slave_mem21[util_transfer21.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction21 == APB_READ21;
                            req.addr == util_transfer21.addr;
                            req.data == mem_data21; } )
         mem_data21++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range21(util_transfer21.addr) == 1) begin
        slave_mem21[util_transfer21.addr] = util_transfer21.data;
        // DUMMY21 response with same information
        `uvm_do_with(req, { req.direction21 == APB_WRITE21;
                            req.addr == util_transfer21.addr;
                            req.data == util_transfer21.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq21

`endif // APB_SLAVE_SEQ_LIB_SV21
