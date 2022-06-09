/*******************************************************************************
  FILE : apb_slave_seq_lib22.sv
*******************************************************************************/
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV22
`define APB_SLAVE_SEQ_LIB_SV22

//------------------------------------------------------------------------------
// SEQUENCE22: simple_response_seq22
//------------------------------------------------------------------------------

class simple_response_seq22 extends uvm_sequence #(apb_transfer22);

  function new(string name="simple_response_seq22");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq22)
  `uvm_declare_p_sequencer(apb_slave_sequencer22)

  apb_transfer22 req;
  apb_transfer22 util_transfer22;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port22.peek(util_transfer22);
      if((util_transfer22.direction22 == APB_READ22) && 
        (p_sequencer.cfg.check_address_range22(util_transfer22.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range22 Matching22 read.  Responding22...", util_transfer22.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction22 == APB_READ22; } )
      end
    end
  endtask : body

endclass : simple_response_seq22

//------------------------------------------------------------------------------
// SEQUENCE22: mem_response_seq22
//------------------------------------------------------------------------------
class mem_response_seq22 extends uvm_sequence #(apb_transfer22);

  function new(string name="mem_response_seq22");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data22;

  `uvm_object_utils(mem_response_seq22)
  `uvm_declare_p_sequencer(apb_slave_sequencer22)

  //simple22 assoc22 array to hold22 values
  logic [31:0] slave_mem22[int];

  apb_transfer22 req;
  apb_transfer22 util_transfer22;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port22.peek(util_transfer22);
      if((util_transfer22.direction22 == APB_READ22) && 
        (p_sequencer.cfg.check_address_range22(util_transfer22.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range22 Matching22 APB_READ22.  Responding22...", util_transfer22.addr), UVM_MEDIUM);
        if (slave_mem22.exists(util_transfer22.addr))
        `uvm_do_with(req, { req.direction22 == APB_READ22;
                            req.addr == util_transfer22.addr;
                            req.data == slave_mem22[util_transfer22.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction22 == APB_READ22;
                            req.addr == util_transfer22.addr;
                            req.data == mem_data22; } )
         mem_data22++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range22(util_transfer22.addr) == 1) begin
        slave_mem22[util_transfer22.addr] = util_transfer22.data;
        // DUMMY22 response with same information
        `uvm_do_with(req, { req.direction22 == APB_WRITE22;
                            req.addr == util_transfer22.addr;
                            req.data == util_transfer22.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq22

`endif // APB_SLAVE_SEQ_LIB_SV22
