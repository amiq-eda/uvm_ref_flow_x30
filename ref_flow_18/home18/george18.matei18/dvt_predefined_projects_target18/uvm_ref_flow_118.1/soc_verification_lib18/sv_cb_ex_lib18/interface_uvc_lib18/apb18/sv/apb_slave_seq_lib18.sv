/*******************************************************************************
  FILE : apb_slave_seq_lib18.sv
*******************************************************************************/
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV18
`define APB_SLAVE_SEQ_LIB_SV18

//------------------------------------------------------------------------------
// SEQUENCE18: simple_response_seq18
//------------------------------------------------------------------------------

class simple_response_seq18 extends uvm_sequence #(apb_transfer18);

  function new(string name="simple_response_seq18");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq18)
  `uvm_declare_p_sequencer(apb_slave_sequencer18)

  apb_transfer18 req;
  apb_transfer18 util_transfer18;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port18.peek(util_transfer18);
      if((util_transfer18.direction18 == APB_READ18) && 
        (p_sequencer.cfg.check_address_range18(util_transfer18.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range18 Matching18 read.  Responding18...", util_transfer18.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction18 == APB_READ18; } )
      end
    end
  endtask : body

endclass : simple_response_seq18

//------------------------------------------------------------------------------
// SEQUENCE18: mem_response_seq18
//------------------------------------------------------------------------------
class mem_response_seq18 extends uvm_sequence #(apb_transfer18);

  function new(string name="mem_response_seq18");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data18;

  `uvm_object_utils(mem_response_seq18)
  `uvm_declare_p_sequencer(apb_slave_sequencer18)

  //simple18 assoc18 array to hold18 values
  logic [31:0] slave_mem18[int];

  apb_transfer18 req;
  apb_transfer18 util_transfer18;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port18.peek(util_transfer18);
      if((util_transfer18.direction18 == APB_READ18) && 
        (p_sequencer.cfg.check_address_range18(util_transfer18.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range18 Matching18 APB_READ18.  Responding18...", util_transfer18.addr), UVM_MEDIUM);
        if (slave_mem18.exists(util_transfer18.addr))
        `uvm_do_with(req, { req.direction18 == APB_READ18;
                            req.addr == util_transfer18.addr;
                            req.data == slave_mem18[util_transfer18.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction18 == APB_READ18;
                            req.addr == util_transfer18.addr;
                            req.data == mem_data18; } )
         mem_data18++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range18(util_transfer18.addr) == 1) begin
        slave_mem18[util_transfer18.addr] = util_transfer18.data;
        // DUMMY18 response with same information
        `uvm_do_with(req, { req.direction18 == APB_WRITE18;
                            req.addr == util_transfer18.addr;
                            req.data == util_transfer18.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq18

`endif // APB_SLAVE_SEQ_LIB_SV18
