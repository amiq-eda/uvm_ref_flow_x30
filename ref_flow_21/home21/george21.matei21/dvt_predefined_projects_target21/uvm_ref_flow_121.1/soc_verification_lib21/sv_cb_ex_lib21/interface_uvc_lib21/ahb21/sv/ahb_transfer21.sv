// IVB21 checksum21: 2173772784
/*-----------------------------------------------------------------
File21 name     : ahb_transfer21.sv
Created21       : Wed21 May21 19 15:42:20 2010
Description21   :  This21 file declares21 the OVC21 transfer21. It is
              :  used by both master21 and slave21.
Notes21         :
-----------------------------------------------------------------*/
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV21
`define AHB_TRANSFER_SV21

//------------------------------------------------------------------------------
//
// ahb21 transfer21 enums21, parameters21, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE21 = 0,
		HALFWORD21 = 1,
		WORD21 = 2,
		TWO_WORDS21 = 3,
		FOUR_WORDS21 = 4,
		EIGHT_WORDS21 = 5,
		SIXTEEN_WORDS21 = 6,
		K_BITS21 = 7
} ahb_transfer_size21;
typedef enum logic[1:0]  {
		IDLE21 = 0,
		BUSY21 = 1,
		NONSEQ21 = 2,
		SEQ = 3
} ahb_transfer_kind21;
typedef enum logic[1:0]  {
		OKAY21 = 0,
		ERROR21 = 1,
		RETRY21 = 2,
		SPLIT21 = 3
} ahb_response_kind21;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction21;
typedef enum logic[2:0]  {
		SINGLE21 = 0,
		INCR = 1,
		WRAP421 = 2,
		INCR421 = 3,
		WRAP821 = 4,
		INCR821 = 5,
		WRAP1621 = 6,
		INCR1621 = 7
} ahb_burst_kind21;
 
//------------------------------------------------------------------------------
//
// CLASS21: ahb_transfer21
//
//------------------------------------------------------------------------------

class ahb_transfer21 extends uvm_sequence_item;

  /***************************************************************************
   IVB21-NOTE21 : REQUIRED21 : transfer21 definitions21 : Item21 definitions21
   ---------------------------------------------------------------------------
   Adjust21 the transfer21 attribute21 names as required21 and add any 
   necessary21 attributes21.
   Note21 that if you change an attribute21 name, you must change it in all of your21
   OVC21 files.
   Make21 sure21 to edit21 the uvm_object_utils_begin to get various21 utilities21 (like21
   print and copy) for each attribute21 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH21-1:0] data;
  rand logic [`AHB_ADDR_WIDTH21-1:0] address;
  rand ahb_direction21 direction21 ;
  rand ahb_transfer_size21  hsize21;
  rand ahb_burst_kind21  burst;
  rand logic [3:0] prot21 ;
 
  `uvm_object_utils_begin(ahb_transfer21)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction21,direction21, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size21,hsize21, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind21,burst, UVM_ALL_ON)
    `uvm_field_int(prot21, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor21 - required21 syntax21 for UVM automation21 and utilities21
  function new (string name = "unnamed21-ahb_transfer21");
    super.new(name);
  endfunction : new

endclass : ahb_transfer21

`endif // AHB_TRANSFER_SV21

