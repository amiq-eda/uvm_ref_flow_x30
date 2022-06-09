/*******************************************************************************
  FILE : apb_slave_seq_lib8.sv
*******************************************************************************/
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV8
`define APB_SLAVE_SEQ_LIB_SV8

//------------------------------------------------------------------------------
// SEQUENCE8: simple_response_seq8
//------------------------------------------------------------------------------

class simple_response_seq8 extends uvm_sequence #(apb_transfer8);

  function new(string name="simple_response_seq8");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq8)
  `uvm_declare_p_sequencer(apb_slave_sequencer8)

  apb_transfer8 req;
  apb_transfer8 util_transfer8;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port8.peek(util_transfer8);
      if((util_transfer8.direction8 == APB_READ8) && 
        (p_sequencer.cfg.check_address_range8(util_transfer8.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range8 Matching8 read.  Responding8...", util_transfer8.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction8 == APB_READ8; } )
      end
    end
  endtask : body

endclass : simple_response_seq8

//------------------------------------------------------------------------------
// SEQUENCE8: mem_response_seq8
//------------------------------------------------------------------------------
class mem_response_seq8 extends uvm_sequence #(apb_transfer8);

  function new(string name="mem_response_seq8");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data8;

  `uvm_object_utils(mem_response_seq8)
  `uvm_declare_p_sequencer(apb_slave_sequencer8)

  //simple8 assoc8 array to hold8 values
  logic [31:0] slave_mem8[int];

  apb_transfer8 req;
  apb_transfer8 util_transfer8;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port8.peek(util_transfer8);
      if((util_transfer8.direction8 == APB_READ8) && 
        (p_sequencer.cfg.check_address_range8(util_transfer8.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range8 Matching8 APB_READ8.  Responding8...", util_transfer8.addr), UVM_MEDIUM);
        if (slave_mem8.exists(util_transfer8.addr))
        `uvm_do_with(req, { req.direction8 == APB_READ8;
                            req.addr == util_transfer8.addr;
                            req.data == slave_mem8[util_transfer8.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction8 == APB_READ8;
                            req.addr == util_transfer8.addr;
                            req.data == mem_data8; } )
         mem_data8++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range8(util_transfer8.addr) == 1) begin
        slave_mem8[util_transfer8.addr] = util_transfer8.data;
        // DUMMY8 response with same information
        `uvm_do_with(req, { req.direction8 == APB_WRITE8;
                            req.addr == util_transfer8.addr;
                            req.data == util_transfer8.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq8

`endif // APB_SLAVE_SEQ_LIB_SV8
