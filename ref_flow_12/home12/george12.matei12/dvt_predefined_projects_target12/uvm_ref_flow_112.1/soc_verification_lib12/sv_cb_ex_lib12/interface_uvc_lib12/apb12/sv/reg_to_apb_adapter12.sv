/*-------------------------------------------------------------------------
File12 name   : reg_to_apb_adapter12.sv
Title12       : Register Operations12 to APB12 Transactions12 Adapter Sequence
Project12     :
Created12     :
Description12 : UVM_REG - Adapter Sequence converts12 UVM register operations12
            : to APB12 bus transactions
Notes12       : This12 example12 does not provide12 any random transfer12 delay
            : for the transaction.  This12 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright12 1999-2011 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

class reg_to_apb_adapter12 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter12)

  function new(string name="reg_to_apb_adapter12");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer12 transfer12;
    transfer12 = apb_transfer12::type_id::create("transfer12");
    transfer12.addr = rw.addr;
    transfer12.data = rw.data;
    transfer12.direction12 = (rw.kind == UVM_READ) ? APB_READ12 : APB_WRITE12;
    return (transfer12);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer12 transfer12;
    if (!$cast(transfer12, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE12",
       "Provided bus_item is not of the correct12 type. Expecting12 apb_transfer12")
       return;
    end
    rw.kind =  (transfer12.direction12 == APB_READ12) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer12.addr;
    rw.data = transfer12.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO12 NOT12 SET IT12 AT12 ALL12 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter12
