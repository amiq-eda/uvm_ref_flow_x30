/*******************************************************************************
  FILE : apb_slave_seq_lib3.sv
*******************************************************************************/
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV3
`define APB_SLAVE_SEQ_LIB_SV3

//------------------------------------------------------------------------------
// SEQUENCE3: simple_response_seq3
//------------------------------------------------------------------------------

class simple_response_seq3 extends uvm_sequence #(apb_transfer3);

  function new(string name="simple_response_seq3");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq3)
  `uvm_declare_p_sequencer(apb_slave_sequencer3)

  apb_transfer3 req;
  apb_transfer3 util_transfer3;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port3.peek(util_transfer3);
      if((util_transfer3.direction3 == APB_READ3) && 
        (p_sequencer.cfg.check_address_range3(util_transfer3.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range3 Matching3 read.  Responding3...", util_transfer3.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction3 == APB_READ3; } )
      end
    end
  endtask : body

endclass : simple_response_seq3

//------------------------------------------------------------------------------
// SEQUENCE3: mem_response_seq3
//------------------------------------------------------------------------------
class mem_response_seq3 extends uvm_sequence #(apb_transfer3);

  function new(string name="mem_response_seq3");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data3;

  `uvm_object_utils(mem_response_seq3)
  `uvm_declare_p_sequencer(apb_slave_sequencer3)

  //simple3 assoc3 array to hold3 values
  logic [31:0] slave_mem3[int];

  apb_transfer3 req;
  apb_transfer3 util_transfer3;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port3.peek(util_transfer3);
      if((util_transfer3.direction3 == APB_READ3) && 
        (p_sequencer.cfg.check_address_range3(util_transfer3.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range3 Matching3 APB_READ3.  Responding3...", util_transfer3.addr), UVM_MEDIUM);
        if (slave_mem3.exists(util_transfer3.addr))
        `uvm_do_with(req, { req.direction3 == APB_READ3;
                            req.addr == util_transfer3.addr;
                            req.data == slave_mem3[util_transfer3.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction3 == APB_READ3;
                            req.addr == util_transfer3.addr;
                            req.data == mem_data3; } )
         mem_data3++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range3(util_transfer3.addr) == 1) begin
        slave_mem3[util_transfer3.addr] = util_transfer3.data;
        // DUMMY3 response with same information
        `uvm_do_with(req, { req.direction3 == APB_WRITE3;
                            req.addr == util_transfer3.addr;
                            req.data == util_transfer3.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq3

`endif // APB_SLAVE_SEQ_LIB_SV3
