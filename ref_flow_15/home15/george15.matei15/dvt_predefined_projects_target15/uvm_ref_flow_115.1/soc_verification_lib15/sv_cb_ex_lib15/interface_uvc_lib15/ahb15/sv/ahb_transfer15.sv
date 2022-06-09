// IVB15 checksum15: 2173772784
/*-----------------------------------------------------------------
File15 name     : ahb_transfer15.sv
Created15       : Wed15 May15 19 15:42:20 2010
Description15   :  This15 file declares15 the OVC15 transfer15. It is
              :  used by both master15 and slave15.
Notes15         :
-----------------------------------------------------------------*/
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV15
`define AHB_TRANSFER_SV15

//------------------------------------------------------------------------------
//
// ahb15 transfer15 enums15, parameters15, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE15 = 0,
		HALFWORD15 = 1,
		WORD15 = 2,
		TWO_WORDS15 = 3,
		FOUR_WORDS15 = 4,
		EIGHT_WORDS15 = 5,
		SIXTEEN_WORDS15 = 6,
		K_BITS15 = 7
} ahb_transfer_size15;
typedef enum logic[1:0]  {
		IDLE15 = 0,
		BUSY15 = 1,
		NONSEQ15 = 2,
		SEQ = 3
} ahb_transfer_kind15;
typedef enum logic[1:0]  {
		OKAY15 = 0,
		ERROR15 = 1,
		RETRY15 = 2,
		SPLIT15 = 3
} ahb_response_kind15;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction15;
typedef enum logic[2:0]  {
		SINGLE15 = 0,
		INCR = 1,
		WRAP415 = 2,
		INCR415 = 3,
		WRAP815 = 4,
		INCR815 = 5,
		WRAP1615 = 6,
		INCR1615 = 7
} ahb_burst_kind15;
 
//------------------------------------------------------------------------------
//
// CLASS15: ahb_transfer15
//
//------------------------------------------------------------------------------

class ahb_transfer15 extends uvm_sequence_item;

  /***************************************************************************
   IVB15-NOTE15 : REQUIRED15 : transfer15 definitions15 : Item15 definitions15
   ---------------------------------------------------------------------------
   Adjust15 the transfer15 attribute15 names as required15 and add any 
   necessary15 attributes15.
   Note15 that if you change an attribute15 name, you must change it in all of your15
   OVC15 files.
   Make15 sure15 to edit15 the uvm_object_utils_begin to get various15 utilities15 (like15
   print and copy) for each attribute15 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH15-1:0] data;
  rand logic [`AHB_ADDR_WIDTH15-1:0] address;
  rand ahb_direction15 direction15 ;
  rand ahb_transfer_size15  hsize15;
  rand ahb_burst_kind15  burst;
  rand logic [3:0] prot15 ;
 
  `uvm_object_utils_begin(ahb_transfer15)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction15,direction15, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size15,hsize15, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind15,burst, UVM_ALL_ON)
    `uvm_field_int(prot15, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor15 - required15 syntax15 for UVM automation15 and utilities15
  function new (string name = "unnamed15-ahb_transfer15");
    super.new(name);
  endfunction : new

endclass : ahb_transfer15

`endif // AHB_TRANSFER_SV15

