/*-------------------------------------------------------------------------
File4 name   : reg_to_apb_adapter4.sv
Title4       : Register Operations4 to APB4 Transactions4 Adapter Sequence
Project4     :
Created4     :
Description4 : UVM_REG - Adapter Sequence converts4 UVM register operations4
            : to APB4 bus transactions
Notes4       : This4 example4 does not provide4 any random transfer4 delay
            : for the transaction.  This4 could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright4 1999-2011 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

class reg_to_apb_adapter4 extends uvm_reg_adapter;

`uvm_object_utils(reg_to_apb_adapter4)

  function new(string name="reg_to_apb_adapter4");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_transfer4 transfer4;
    transfer4 = apb_transfer4::type_id::create("transfer4");
    transfer4.addr = rw.addr;
    transfer4.data = rw.data;
    transfer4.direction4 = (rw.kind == UVM_READ) ? APB_READ4 : APB_WRITE4;
    return (transfer4);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    apb_transfer4 transfer4;
    if (!$cast(transfer4, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE4",
       "Provided bus_item is not of the correct4 type. Expecting4 apb_transfer4")
       return;
    end
    rw.kind =  (transfer4.direction4 == APB_READ4) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer4.addr;
    rw.data = transfer4.data;
    //rw.byte_en = 'h0;   // Set this to -1 or DO4 NOT4 SET IT4 AT4 ALL4 - 
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_apb_adapter4
