/*-------------------------------------------------------------------------
File22 name   : reg_to_ahb_adapter22.sv
Title22       : Register Operations22 to AHB22 Transactions22 Adapter Sequence
Project22     :
Created22     :
Description22 : UVM_REG - Adapter Sequence converts22 UVM register operations22
            : to AHB22 bus transactions
Notes22       : This22 example22 does not provide22 any random transfer22 delay
            : for the transaction.  This22 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright22 1999-2011 Cadence22 Design22 Systems22, Inc22.
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

class reg_to_ahb_adapter22 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter22)

  function new(string name="reg_to_ahb_adapter22");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer22 transfer22;
    transfer22 = ahb_transfer22::type_id::create("transfer22");
    transfer22.address = rw.addr;
    transfer22.data = rw.data;
    transfer22.direction22 = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer22);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer22 transfer22;
    if (!$cast(transfer22, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE22",
       "Provided bus_item is not of the correct22 type. Expecting22 ahb_transfer22")
       return;
    end
    rw.kind =  (transfer22.direction22 == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer22.address;
    rw.data = transfer22.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter22
