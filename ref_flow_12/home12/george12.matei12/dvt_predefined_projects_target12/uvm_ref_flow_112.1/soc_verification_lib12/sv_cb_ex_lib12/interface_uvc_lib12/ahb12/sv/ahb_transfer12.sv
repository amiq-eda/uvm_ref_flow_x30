// IVB12 checksum12: 2173772784
/*-----------------------------------------------------------------
File12 name     : ahb_transfer12.sv
Created12       : Wed12 May12 19 15:42:20 2010
Description12   :  This12 file declares12 the OVC12 transfer12. It is
              :  used by both master12 and slave12.
Notes12         :
-----------------------------------------------------------------*/
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
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


`ifndef AHB_TRANSFER_SV12
`define AHB_TRANSFER_SV12

//------------------------------------------------------------------------------
//
// ahb12 transfer12 enums12, parameters12, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE12 = 0,
		HALFWORD12 = 1,
		WORD12 = 2,
		TWO_WORDS12 = 3,
		FOUR_WORDS12 = 4,
		EIGHT_WORDS12 = 5,
		SIXTEEN_WORDS12 = 6,
		K_BITS12 = 7
} ahb_transfer_size12;
typedef enum logic[1:0]  {
		IDLE12 = 0,
		BUSY12 = 1,
		NONSEQ12 = 2,
		SEQ = 3
} ahb_transfer_kind12;
typedef enum logic[1:0]  {
		OKAY12 = 0,
		ERROR12 = 1,
		RETRY12 = 2,
		SPLIT12 = 3
} ahb_response_kind12;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction12;
typedef enum logic[2:0]  {
		SINGLE12 = 0,
		INCR = 1,
		WRAP412 = 2,
		INCR412 = 3,
		WRAP812 = 4,
		INCR812 = 5,
		WRAP1612 = 6,
		INCR1612 = 7
} ahb_burst_kind12;
 
//------------------------------------------------------------------------------
//
// CLASS12: ahb_transfer12
//
//------------------------------------------------------------------------------

class ahb_transfer12 extends uvm_sequence_item;

  /***************************************************************************
   IVB12-NOTE12 : REQUIRED12 : transfer12 definitions12 : Item12 definitions12
   ---------------------------------------------------------------------------
   Adjust12 the transfer12 attribute12 names as required12 and add any 
   necessary12 attributes12.
   Note12 that if you change an attribute12 name, you must change it in all of your12
   OVC12 files.
   Make12 sure12 to edit12 the uvm_object_utils_begin to get various12 utilities12 (like12
   print and copy) for each attribute12 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH12-1:0] data;
  rand logic [`AHB_ADDR_WIDTH12-1:0] address;
  rand ahb_direction12 direction12 ;
  rand ahb_transfer_size12  hsize12;
  rand ahb_burst_kind12  burst;
  rand logic [3:0] prot12 ;
 
  `uvm_object_utils_begin(ahb_transfer12)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction12,direction12, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size12,hsize12, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind12,burst, UVM_ALL_ON)
    `uvm_field_int(prot12, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor12 - required12 syntax12 for UVM automation12 and utilities12
  function new (string name = "unnamed12-ahb_transfer12");
    super.new(name);
  endfunction : new

endclass : ahb_transfer12

`endif // AHB_TRANSFER_SV12

