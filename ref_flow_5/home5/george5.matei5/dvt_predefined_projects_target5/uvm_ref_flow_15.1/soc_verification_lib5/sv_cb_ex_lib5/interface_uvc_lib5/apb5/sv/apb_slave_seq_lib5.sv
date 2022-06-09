/*******************************************************************************
  FILE : apb_slave_seq_lib5.sv
*******************************************************************************/
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV5
`define APB_SLAVE_SEQ_LIB_SV5

//------------------------------------------------------------------------------
// SEQUENCE5: simple_response_seq5
//------------------------------------------------------------------------------

class simple_response_seq5 extends uvm_sequence #(apb_transfer5);

  function new(string name="simple_response_seq5");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq5)
  `uvm_declare_p_sequencer(apb_slave_sequencer5)

  apb_transfer5 req;
  apb_transfer5 util_transfer5;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port5.peek(util_transfer5);
      if((util_transfer5.direction5 == APB_READ5) && 
        (p_sequencer.cfg.check_address_range5(util_transfer5.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range5 Matching5 read.  Responding5...", util_transfer5.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction5 == APB_READ5; } )
      end
    end
  endtask : body

endclass : simple_response_seq5

//------------------------------------------------------------------------------
// SEQUENCE5: mem_response_seq5
//------------------------------------------------------------------------------
class mem_response_seq5 extends uvm_sequence #(apb_transfer5);

  function new(string name="mem_response_seq5");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data5;

  `uvm_object_utils(mem_response_seq5)
  `uvm_declare_p_sequencer(apb_slave_sequencer5)

  //simple5 assoc5 array to hold5 values
  logic [31:0] slave_mem5[int];

  apb_transfer5 req;
  apb_transfer5 util_transfer5;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port5.peek(util_transfer5);
      if((util_transfer5.direction5 == APB_READ5) && 
        (p_sequencer.cfg.check_address_range5(util_transfer5.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range5 Matching5 APB_READ5.  Responding5...", util_transfer5.addr), UVM_MEDIUM);
        if (slave_mem5.exists(util_transfer5.addr))
        `uvm_do_with(req, { req.direction5 == APB_READ5;
                            req.addr == util_transfer5.addr;
                            req.data == slave_mem5[util_transfer5.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction5 == APB_READ5;
                            req.addr == util_transfer5.addr;
                            req.data == mem_data5; } )
         mem_data5++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range5(util_transfer5.addr) == 1) begin
        slave_mem5[util_transfer5.addr] = util_transfer5.data;
        // DUMMY5 response with same information
        `uvm_do_with(req, { req.direction5 == APB_WRITE5;
                            req.addr == util_transfer5.addr;
                            req.data == util_transfer5.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq5

`endif // APB_SLAVE_SEQ_LIB_SV5
