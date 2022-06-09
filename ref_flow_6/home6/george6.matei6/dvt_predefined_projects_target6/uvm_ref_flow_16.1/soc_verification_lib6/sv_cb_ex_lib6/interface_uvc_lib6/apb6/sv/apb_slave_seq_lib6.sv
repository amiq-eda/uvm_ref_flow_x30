/*******************************************************************************
  FILE : apb_slave_seq_lib6.sv
*******************************************************************************/
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`ifndef APB_SLAVE_SEQ_LIB_SV6
`define APB_SLAVE_SEQ_LIB_SV6

//------------------------------------------------------------------------------
// SEQUENCE6: simple_response_seq6
//------------------------------------------------------------------------------

class simple_response_seq6 extends uvm_sequence #(apb_transfer6);

  function new(string name="simple_response_seq6");
    super.new(name);
  endfunction

  `uvm_object_utils(simple_response_seq6)
  `uvm_declare_p_sequencer(apb_slave_sequencer6)

  apb_transfer6 req;
  apb_transfer6 util_transfer6;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port6.peek(util_transfer6);
      if((util_transfer6.direction6 == APB_READ6) && 
        (p_sequencer.cfg.check_address_range6(util_transfer6.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range6 Matching6 read.  Responding6...", util_transfer6.addr), UVM_MEDIUM);
        `uvm_do_with(req, { req.direction6 == APB_READ6; } )
      end
    end
  endtask : body

endclass : simple_response_seq6

//------------------------------------------------------------------------------
// SEQUENCE6: mem_response_seq6
//------------------------------------------------------------------------------
class mem_response_seq6 extends uvm_sequence #(apb_transfer6);

  function new(string name="mem_response_seq6");
    super.new(name);
  endfunction

  rand logic [31:0] mem_data6;

  `uvm_object_utils(mem_response_seq6)
  `uvm_declare_p_sequencer(apb_slave_sequencer6)

  //simple6 assoc6 array to hold6 values
  logic [31:0] slave_mem6[int];

  apb_transfer6 req;
  apb_transfer6 util_transfer6;

  virtual task body();
    `uvm_info(get_type_name(), "Starting...", UVM_MEDIUM)
    forever begin
      p_sequencer.addr_trans_port6.peek(util_transfer6);
      if((util_transfer6.direction6 == APB_READ6) && 
        (p_sequencer.cfg.check_address_range6(util_transfer6.addr) == 1)) begin
        `uvm_info(get_type_name(), $psprintf("Address:%h Range6 Matching6 APB_READ6.  Responding6...", util_transfer6.addr), UVM_MEDIUM);
        if (slave_mem6.exists(util_transfer6.addr))
        `uvm_do_with(req, { req.direction6 == APB_READ6;
                            req.addr == util_transfer6.addr;
                            req.data == slave_mem6[util_transfer6.addr]; } )
        else  begin
        `uvm_do_with(req, { req.direction6 == APB_READ6;
                            req.addr == util_transfer6.addr;
                            req.data == mem_data6; } )
         mem_data6++; 
        end
      end
      else begin
        if (p_sequencer.cfg.check_address_range6(util_transfer6.addr) == 1) begin
        slave_mem6[util_transfer6.addr] = util_transfer6.data;
        // DUMMY6 response with same information
        `uvm_do_with(req, { req.direction6 == APB_WRITE6;
                            req.addr == util_transfer6.addr;
                            req.data == util_transfer6.data; } )
       end
      end
    end
  endtask : body

endclass : mem_response_seq6

`endif // APB_SLAVE_SEQ_LIB_SV6
