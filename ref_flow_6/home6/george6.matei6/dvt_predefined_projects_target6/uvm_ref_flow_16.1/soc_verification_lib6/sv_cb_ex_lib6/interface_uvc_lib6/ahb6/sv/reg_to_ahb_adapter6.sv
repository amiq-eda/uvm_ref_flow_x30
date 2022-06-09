/*-------------------------------------------------------------------------
File6 name   : reg_to_ahb_adapter6.sv
Title6       : Register Operations6 to AHB6 Transactions6 Adapter Sequence
Project6     :
Created6     :
Description6 : UVM_REG - Adapter Sequence converts6 UVM register operations6
            : to AHB6 bus transactions
Notes6       : This6 example6 does not provide6 any random transfer6 delay
            : for the transaction.  This6 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright6 1999-2011 Cadence6 Design6 Systems6, Inc6.
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

class reg_to_ahb_adapter6 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter6)

  function new(string name="reg_to_ahb_adapter6");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer6 transfer6;
    transfer6 = ahb_transfer6::type_id::create("transfer6");
    transfer6.address = rw.addr;
    transfer6.data = rw.data;
    transfer6.direction6 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer6);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer6 transfer6;
    if (!$cast(transfer6, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE6",
       "Provided bus_item is not of the correct6 type. Expecting6 ahb_transfer6")
       return;
    end
    rw.kind =  (transfer6.direction6 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer6.address;
    rw.data = transfer6.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter6
