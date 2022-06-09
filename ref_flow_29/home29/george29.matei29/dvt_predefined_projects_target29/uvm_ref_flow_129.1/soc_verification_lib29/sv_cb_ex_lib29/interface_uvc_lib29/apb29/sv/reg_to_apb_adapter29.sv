/*-------------------------------------------------------------------------
File29 name   : reg_to_apb_adapter29.sv
Title29       : Register Operations29 to APB29 Transactions29 Adapter Sequence
Project29     :
Created29     :
Description29 : UVM_REG - Adapter Sequence converts29 UVM register operations29
            : to APB29 bus transactions
Notes29       : This29 example29 does not provide29 any random transfer29 delay
            : for the transaction.  This29 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright29 1999-2011 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

class reg_to_apb_adapter29 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter29)

  function new(string name="reg_to_apb_adapter29");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer29 transfer29;
    transfer29 = apb_transfer29::type_id::create("transfer29");
    transfer29.addr = rw.addr;
    transfer29.data = rw.data;
    transfer29.direction29 = (rw.kind == UVM_READ) ? APB_READ29 : APB_WRITE29;
    return (transfer29);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer29 transfer29;
    if (!$cast(transfer29, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE29",
       "Provided bus_item is not of the correct29 type. Expecting29 apb_transfer29")
       return;
    end
    rw.kind =  (transfer29.direction29 == APB_READ29) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer29.addr;
    rw.data = transfer29.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO29 NOT29 SET IT29 AT29 ALL29 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter29
