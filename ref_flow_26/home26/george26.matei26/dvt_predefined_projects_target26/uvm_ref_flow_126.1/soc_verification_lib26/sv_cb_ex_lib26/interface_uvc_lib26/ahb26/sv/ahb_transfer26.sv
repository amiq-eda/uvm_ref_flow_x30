// IVB26 checksum26: 2173772784
/*-----------------------------------------------------------------
File26 name     : ahb_transfer26.sv
Created26       : Wed26 May26 19 15:42:20 2010
Description26   :  This26 file declares26 the OVC26 transfer26. It is
              :  used by both master26 and slave26.
Notes26         :
-----------------------------------------------------------------*/
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`ifndef AHB_TRANSFER_SV26
`define AHB_TRANSFER_SV26

//------------------------------------------------------------------------------
//
// ahb26 transfer26 enums26, parameters26, and events
//
//------------------------------------------------------------------------------

typedef enum logic[2:0]  {
		BYTE26 = 0,
		HALFWORD26 = 1,
		WORD26 = 2,
		TWO_WORDS26 = 3,
		FOUR_WORDS26 = 4,
		EIGHT_WORDS26 = 5,
		SIXTEEN_WORDS26 = 6,
		K_BITS26 = 7
} ahb_transfer_size26;
typedef enum logic[1:0]  {
		IDLE26 = 0,
		BUSY26 = 1,
		NONSEQ26 = 2,
		SEQ = 3
} ahb_transfer_kind26;
typedef enum logic[1:0]  {
		OKAY26 = 0,
		ERROR26 = 1,
		RETRY26 = 2,
		SPLIT26 = 3
} ahb_response_kind26;
typedef enum logic  {
		READ = 0,
		WRITE = 1
} ahb_direction26;
typedef enum logic[2:0]  {
		SINGLE26 = 0,
		INCR = 1,
		WRAP426 = 2,
		INCR426 = 3,
		WRAP826 = 4,
		INCR826 = 5,
		WRAP1626 = 6,
		INCR1626 = 7
} ahb_burst_kind26;
 
//------------------------------------------------------------------------------
//
// CLASS26: ahb_transfer26
//
//------------------------------------------------------------------------------

class ahb_transfer26 extends uvm_sequence_item;

  /***************************************************************************
   IVB26-NOTE26 : REQUIRED26 : transfer26 definitions26 : Item26 definitions26
   ---------------------------------------------------------------------------
   Adjust26 the transfer26 attribute26 names as required26 and add any 
   necessary26 attributes26.
   Note26 that if you change an attribute26 name, you must change it in all of your26
   OVC26 files.
   Make26 sure26 to edit26 the uvm_object_utils_begin to get various26 utilities26 (like26
   print and copy) for each attribute26 that you add.
  ***************************************************************************/           
  rand logic [`AHB_DATA_WIDTH26-1:0] data;
  rand logic [`AHB_ADDR_WIDTH26-1:0] address;
  rand ahb_direction26 direction26 ;
  rand ahb_transfer_size26  hsize26;
  rand ahb_burst_kind26  burst;
  rand logic [3:0] prot26 ;
 
  `uvm_object_utils_begin(ahb_transfer26)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(address, UVM_ALL_ON)
    `uvm_field_enum(ahb_direction26,direction26, UVM_ALL_ON)
    `uvm_field_enum(ahb_transfer_size26,hsize26, UVM_ALL_ON)
    `uvm_field_enum(ahb_burst_kind26,burst, UVM_ALL_ON)
    `uvm_field_int(prot26, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor26 - required26 syntax26 for UVM automation26 and utilities26
  function new (string name = "unnamed26-ahb_transfer26");
    super.new(name);
  endfunction : new

endclass : ahb_transfer26

`endif // AHB_TRANSFER_SV26

