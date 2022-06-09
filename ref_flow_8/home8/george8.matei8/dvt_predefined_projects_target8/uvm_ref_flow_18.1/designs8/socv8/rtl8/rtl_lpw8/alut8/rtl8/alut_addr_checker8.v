//File8 name   : alut_addr_checker8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

// compiler8 directives8
`include "alut_defines8.v"


module alut_addr_checker8
(   
   // Inputs8
   pclk8,
   n_p_reset8,
   command,
   mac_addr8,
   d_addr8,
   s_addr8,
   s_port8,
   curr_time8,
   mem_read_data_add8,
   age_confirmed8,
   age_ok8,
   clear_reused8,

   //outputs8
   d_port8,
   add_check_active8,
   mem_addr_add8,
   mem_write_add8,
   mem_write_data_add8,
   lst_inv_addr_nrm8,
   lst_inv_port_nrm8,
   check_age8,
   last_accessed8,
   reused8
);



   input               pclk8;               // APB8 clock8                           
   input               n_p_reset8;          // Reset8                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr8;           // address of the switch8              
   input [47:0]        d_addr8;             // address of frame8 to be checked8     
   input [47:0]        s_addr8;             // address of frame8 to be stored8      
   input [1:0]         s_port8;             // source8 port of current frame8       
   input [31:0]        curr_time8;          // current time,for storing8 in mem    
   input [82:0]        mem_read_data_add8;  // read data from mem                 
   input               age_confirmed8;      // valid flag8 from age8 checker        
   input               age_ok8;             // result from age8 checker 
   input               clear_reused8;       // read/clear flag8 for reused8 signal8           

   output [4:0]        d_port8;             // calculated8 destination8 port for tx8 
   output              add_check_active8;   // bit 0 of status register           
   output [7:0]        mem_addr_add8;       // hash8 address for R/W8 to memory     
   output              mem_write_add8;      // R/W8 flag8 (write = high8)            
   output [82:0]       mem_write_data_add8; // write data for memory             
   output [47:0]       lst_inv_addr_nrm8;   // last invalidated8 addr normal8 op    
   output [1:0]        lst_inv_port_nrm8;   // last invalidated8 port normal8 op    
   output              check_age8;          // request flag8 for age8 check
   output [31:0]       last_accessed8;      // time field sent8 for age8 check
   output              reused8;             // indicates8 ALUT8 location8 overwritten8

   reg   [2:0]         add_chk_state8;      // current address checker state
   reg   [2:0]         nxt_add_chk_state8;  // current address checker state
   reg   [4:0]         d_port8;             // calculated8 destination8 port for tx8 
   reg   [3:0]         port_mem8;           // bitwise8 conversion8 of 2bit port
   reg   [7:0]         mem_addr_add8;       // hash8 address for R/W8 to memory
   reg                 mem_write_add8;      // R/W8 flag8 (write = high8)            
   reg                 reused8;             // indicates8 ALUT8 location8 overwritten8
   reg   [47:0]        lst_inv_addr_nrm8;   // last invalidated8 addr normal8 op    
   reg   [1:0]         lst_inv_port_nrm8;   // last invalidated8 port normal8 op    
   reg                 check_age8;          // request flag8 for age8 checker
   reg   [31:0]        last_accessed8;      // time field sent8 for age8 check


   wire   [7:0]        s_addr_hash8;        // hash8 of address for storing8
   wire   [7:0]        d_addr_hash8;        // hash8 of address for checking
   wire   [82:0]       mem_write_data_add8; // write data for memory  
   wire                add_check_active8;   // bit 0 of status register           


// Parameters8 for Address Checking8 FSM8 states8
   parameter idle8           = 3'b000;
   parameter mac_addr_chk8   = 3'b001;
   parameter read_dest_add8  = 3'b010;
   parameter valid_chk8      = 3'b011;
   parameter age_chk8        = 3'b100;
   parameter addr_chk8       = 3'b101;
   parameter read_src_add8   = 3'b110;
   parameter write_src8      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash8 conversion8 of source8 and destination8 addresses8
// -----------------------------------------------------------------------------
   assign s_addr_hash8 = s_addr8[7:0] ^ s_addr8[15:8] ^ s_addr8[23:16] ^
                        s_addr8[31:24] ^ s_addr8[39:32] ^ s_addr8[47:40];

   assign d_addr_hash8 = d_addr8[7:0] ^ d_addr8[15:8] ^ d_addr8[23:16] ^
                        d_addr8[31:24] ^ d_addr8[39:32] ^ d_addr8[47:40];



// -----------------------------------------------------------------------------
//   State8 Machine8 For8 handling8 the destination8 address checking process and
//   and storing8 of new source8 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state8 or age_confirmed8 or age_ok8)
   begin
      case (add_chk_state8)
      
      idle8:
         if (command == 2'b01)
            nxt_add_chk_state8 = mac_addr_chk8;
         else
            nxt_add_chk_state8 = idle8;

      mac_addr_chk8:   // check if destination8 address match MAC8 switch8 address
         if (d_addr8 == mac_addr8)
            nxt_add_chk_state8 = idle8;  // return dest8 port as 5'b1_0000
         else
            nxt_add_chk_state8 = read_dest_add8;

      read_dest_add8:       // read data from memory using hash8 of destination8 address
            nxt_add_chk_state8 = valid_chk8;

      valid_chk8:      // check if read data had8 valid bit set
         nxt_add_chk_state8 = age_chk8;

      age_chk8:        // request age8 checker to check if still in date8
         if (age_confirmed8)
            nxt_add_chk_state8 = addr_chk8;
         else
            nxt_add_chk_state8 = age_chk8; 

      addr_chk8:       // perform8 compare between dest8 and read addresses8
            nxt_add_chk_state8 = read_src_add8; // return read port from ALUT8 mem

      read_src_add8:   // read from memory location8 about8 to be overwritten8
            nxt_add_chk_state8 = write_src8; 

      write_src8:      // write new source8 data (addr and port) to memory
            nxt_add_chk_state8 = idle8; 

      default:
            nxt_add_chk_state8 = idle8;
      endcase
   end


// destination8 check FSM8 current state
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      add_chk_state8 <= idle8;
   else
      add_chk_state8 <= nxt_add_chk_state8;
   end



// -----------------------------------------------------------------------------
//   Generate8 returned value of port for sending8 new frame8 to
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      d_port8 <= 5'b0_1111;
   else if ((add_chk_state8 == mac_addr_chk8) & (d_addr8 == mac_addr8))
      d_port8 <= 5'b1_0000;
   else if (((add_chk_state8 == valid_chk8) & ~mem_read_data_add8[82]) |
            ((add_chk_state8 == age_chk8) & ~(age_confirmed8 & age_ok8)) |
            ((add_chk_state8 == addr_chk8) & (d_addr8 != mem_read_data_add8[47:0])))
      d_port8 <= 5'b0_1111 & ~( 1 << s_port8 );
   else if ((add_chk_state8 == addr_chk8) & (d_addr8 == mem_read_data_add8[47:0]))
      d_port8 <= {1'b0, port_mem8} & ~( 1 << s_port8 );
   else
      d_port8 <= d_port8;
   end


// -----------------------------------------------------------------------------
//   convert read port source8 value from 2bits to bitwise8 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      port_mem8 <= 4'b1111;
   else begin
      case (mem_read_data_add8[49:48])
         2'b00: port_mem8 <= 4'b0001;
         2'b01: port_mem8 <= 4'b0010;
         2'b10: port_mem8 <= 4'b0100;
         2'b11: port_mem8 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded8 off8 add_chk_state8
// -----------------------------------------------------------------------------
assign add_check_active8 = (add_chk_state8 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate8 memory addressing8 signals8.
//   The check address command will be taken8 as the indication8 from SW8 that the 
//   source8 fields (address and port) can be written8 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8) 
   begin
       mem_write_add8 <= 1'b0;
       mem_addr_add8  <= 8'd0;
   end
   else if (add_chk_state8 == read_dest_add8)
   begin
       mem_write_add8 <= 1'b0;
       mem_addr_add8  <= d_addr_hash8;
   end
// Need8 to set address two8 cycles8 before check
   else if ( (add_chk_state8 == age_chk8) && age_confirmed8 )
   begin
       mem_write_add8 <= 1'b0;
       mem_addr_add8  <= s_addr_hash8;
   end
   else if (add_chk_state8 == write_src8)
   begin
       mem_write_add8 <= 1'b1;
       mem_addr_add8  <= s_addr_hash8;
   end
   else
   begin
       mem_write_add8 <= 1'b0;
       mem_addr_add8  <= d_addr_hash8;
   end
   end


// -----------------------------------------------------------------------------
//   Generate8 databus8 for writing to memory
//   Data written8 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add8 = {1'b1, curr_time8, s_port8, s_addr8};



// -----------------------------------------------------------------------------
//   Evaluate8 read back data that is about8 to be overwritten8 with new source8 
//   address and port values. Decide8 whether8 the reused8 flag8 must be set and
//   last_inval8 address and port values updated.
//   reused8 needs8 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8) 
   begin
      reused8 <= 1'b0;
      lst_inv_addr_nrm8 <= 48'd0;
      lst_inv_port_nrm8 <= 2'd0;
   end
   else if ((add_chk_state8 == read_src_add8) & mem_read_data_add8[82] &
            (s_addr8 != mem_read_data_add8[47:0]))
   begin
      reused8 <= 1'b1;
      lst_inv_addr_nrm8 <= mem_read_data_add8[47:0];
      lst_inv_port_nrm8 <= mem_read_data_add8[49:48];
   end
   else if (clear_reused8)
   begin
      reused8 <= 1'b0;
      lst_inv_addr_nrm8 <= lst_inv_addr_nrm8;
      lst_inv_port_nrm8 <= lst_inv_addr_nrm8;
   end
   else 
   begin
      reused8 <= reused8;
      lst_inv_addr_nrm8 <= lst_inv_addr_nrm8;
      lst_inv_port_nrm8 <= lst_inv_addr_nrm8;
   end
   end


// -----------------------------------------------------------------------------
//   Generate8 signals8 for age8 checker to perform8 in-date8 check
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8) 
   begin
      check_age8 <= 1'b0;  
      last_accessed8 <= 32'd0;
   end
   else if (check_age8)
   begin
      check_age8 <= 1'b0;  
      last_accessed8 <= mem_read_data_add8[81:50];
   end
   else if (add_chk_state8 == age_chk8)
   begin
      check_age8 <= 1'b1;  
      last_accessed8 <= mem_read_data_add8[81:50];
   end
   else 
   begin
      check_age8 <= 1'b0;  
      last_accessed8 <= 32'd0;
   end
   end


`ifdef ABV_ON8

// psl8 default clock8 = (posedge pclk8);

// ASSERTION8 CHECKS8
/* Commented8 out as also checking in toplevel8
// it should never be possible8 for the destination8 port to indicate8 the MAC8
// switch8 address and one of the other 4 Ethernets8
// psl8 assert_valid_dest_port8 : assert never (d_port8[4] & |{d_port8[3:0]});


// COVER8 SANITY8 CHECKS8
// check all values of destination8 port can be returned.
// psl8 cover_d_port_08 : cover { d_port8 == 5'b0_0001 };
// psl8 cover_d_port_18 : cover { d_port8 == 5'b0_0010 };
// psl8 cover_d_port_28 : cover { d_port8 == 5'b0_0100 };
// psl8 cover_d_port_38 : cover { d_port8 == 5'b0_1000 };
// psl8 cover_d_port_48 : cover { d_port8 == 5'b1_0000 };
// psl8 cover_d_port_all8 : cover { d_port8 == 5'b0_1111 };
*/
`endif


endmodule 









