//File21 name   : alut_addr_checker21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
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

// compiler21 directives21
`include "alut_defines21.v"


module alut_addr_checker21
(   
   // Inputs21
   pclk21,
   n_p_reset21,
   command,
   mac_addr21,
   d_addr21,
   s_addr21,
   s_port21,
   curr_time21,
   mem_read_data_add21,
   age_confirmed21,
   age_ok21,
   clear_reused21,

   //outputs21
   d_port21,
   add_check_active21,
   mem_addr_add21,
   mem_write_add21,
   mem_write_data_add21,
   lst_inv_addr_nrm21,
   lst_inv_port_nrm21,
   check_age21,
   last_accessed21,
   reused21
);



   input               pclk21;               // APB21 clock21                           
   input               n_p_reset21;          // Reset21                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr21;           // address of the switch21              
   input [47:0]        d_addr21;             // address of frame21 to be checked21     
   input [47:0]        s_addr21;             // address of frame21 to be stored21      
   input [1:0]         s_port21;             // source21 port of current frame21       
   input [31:0]        curr_time21;          // current time,for storing21 in mem    
   input [82:0]        mem_read_data_add21;  // read data from mem                 
   input               age_confirmed21;      // valid flag21 from age21 checker        
   input               age_ok21;             // result from age21 checker 
   input               clear_reused21;       // read/clear flag21 for reused21 signal21           

   output [4:0]        d_port21;             // calculated21 destination21 port for tx21 
   output              add_check_active21;   // bit 0 of status register           
   output [7:0]        mem_addr_add21;       // hash21 address for R/W21 to memory     
   output              mem_write_add21;      // R/W21 flag21 (write = high21)            
   output [82:0]       mem_write_data_add21; // write data for memory             
   output [47:0]       lst_inv_addr_nrm21;   // last invalidated21 addr normal21 op    
   output [1:0]        lst_inv_port_nrm21;   // last invalidated21 port normal21 op    
   output              check_age21;          // request flag21 for age21 check
   output [31:0]       last_accessed21;      // time field sent21 for age21 check
   output              reused21;             // indicates21 ALUT21 location21 overwritten21

   reg   [2:0]         add_chk_state21;      // current address checker state
   reg   [2:0]         nxt_add_chk_state21;  // current address checker state
   reg   [4:0]         d_port21;             // calculated21 destination21 port for tx21 
   reg   [3:0]         port_mem21;           // bitwise21 conversion21 of 2bit port
   reg   [7:0]         mem_addr_add21;       // hash21 address for R/W21 to memory
   reg                 mem_write_add21;      // R/W21 flag21 (write = high21)            
   reg                 reused21;             // indicates21 ALUT21 location21 overwritten21
   reg   [47:0]        lst_inv_addr_nrm21;   // last invalidated21 addr normal21 op    
   reg   [1:0]         lst_inv_port_nrm21;   // last invalidated21 port normal21 op    
   reg                 check_age21;          // request flag21 for age21 checker
   reg   [31:0]        last_accessed21;      // time field sent21 for age21 check


   wire   [7:0]        s_addr_hash21;        // hash21 of address for storing21
   wire   [7:0]        d_addr_hash21;        // hash21 of address for checking
   wire   [82:0]       mem_write_data_add21; // write data for memory  
   wire                add_check_active21;   // bit 0 of status register           


// Parameters21 for Address Checking21 FSM21 states21
   parameter idle21           = 3'b000;
   parameter mac_addr_chk21   = 3'b001;
   parameter read_dest_add21  = 3'b010;
   parameter valid_chk21      = 3'b011;
   parameter age_chk21        = 3'b100;
   parameter addr_chk21       = 3'b101;
   parameter read_src_add21   = 3'b110;
   parameter write_src21      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash21 conversion21 of source21 and destination21 addresses21
// -----------------------------------------------------------------------------
   assign s_addr_hash21 = s_addr21[7:0] ^ s_addr21[15:8] ^ s_addr21[23:16] ^
                        s_addr21[31:24] ^ s_addr21[39:32] ^ s_addr21[47:40];

   assign d_addr_hash21 = d_addr21[7:0] ^ d_addr21[15:8] ^ d_addr21[23:16] ^
                        d_addr21[31:24] ^ d_addr21[39:32] ^ d_addr21[47:40];



// -----------------------------------------------------------------------------
//   State21 Machine21 For21 handling21 the destination21 address checking process and
//   and storing21 of new source21 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state21 or age_confirmed21 or age_ok21)
   begin
      case (add_chk_state21)
      
      idle21:
         if (command == 2'b01)
            nxt_add_chk_state21 = mac_addr_chk21;
         else
            nxt_add_chk_state21 = idle21;

      mac_addr_chk21:   // check if destination21 address match MAC21 switch21 address
         if (d_addr21 == mac_addr21)
            nxt_add_chk_state21 = idle21;  // return dest21 port as 5'b1_0000
         else
            nxt_add_chk_state21 = read_dest_add21;

      read_dest_add21:       // read data from memory using hash21 of destination21 address
            nxt_add_chk_state21 = valid_chk21;

      valid_chk21:      // check if read data had21 valid bit set
         nxt_add_chk_state21 = age_chk21;

      age_chk21:        // request age21 checker to check if still in date21
         if (age_confirmed21)
            nxt_add_chk_state21 = addr_chk21;
         else
            nxt_add_chk_state21 = age_chk21; 

      addr_chk21:       // perform21 compare between dest21 and read addresses21
            nxt_add_chk_state21 = read_src_add21; // return read port from ALUT21 mem

      read_src_add21:   // read from memory location21 about21 to be overwritten21
            nxt_add_chk_state21 = write_src21; 

      write_src21:      // write new source21 data (addr and port) to memory
            nxt_add_chk_state21 = idle21; 

      default:
            nxt_add_chk_state21 = idle21;
      endcase
   end


// destination21 check FSM21 current state
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      add_chk_state21 <= idle21;
   else
      add_chk_state21 <= nxt_add_chk_state21;
   end



// -----------------------------------------------------------------------------
//   Generate21 returned value of port for sending21 new frame21 to
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      d_port21 <= 5'b0_1111;
   else if ((add_chk_state21 == mac_addr_chk21) & (d_addr21 == mac_addr21))
      d_port21 <= 5'b1_0000;
   else if (((add_chk_state21 == valid_chk21) & ~mem_read_data_add21[82]) |
            ((add_chk_state21 == age_chk21) & ~(age_confirmed21 & age_ok21)) |
            ((add_chk_state21 == addr_chk21) & (d_addr21 != mem_read_data_add21[47:0])))
      d_port21 <= 5'b0_1111 & ~( 1 << s_port21 );
   else if ((add_chk_state21 == addr_chk21) & (d_addr21 == mem_read_data_add21[47:0]))
      d_port21 <= {1'b0, port_mem21} & ~( 1 << s_port21 );
   else
      d_port21 <= d_port21;
   end


// -----------------------------------------------------------------------------
//   convert read port source21 value from 2bits to bitwise21 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      port_mem21 <= 4'b1111;
   else begin
      case (mem_read_data_add21[49:48])
         2'b00: port_mem21 <= 4'b0001;
         2'b01: port_mem21 <= 4'b0010;
         2'b10: port_mem21 <= 4'b0100;
         2'b11: port_mem21 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded21 off21 add_chk_state21
// -----------------------------------------------------------------------------
assign add_check_active21 = (add_chk_state21 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate21 memory addressing21 signals21.
//   The check address command will be taken21 as the indication21 from SW21 that the 
//   source21 fields (address and port) can be written21 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21) 
   begin
       mem_write_add21 <= 1'b0;
       mem_addr_add21  <= 8'd0;
   end
   else if (add_chk_state21 == read_dest_add21)
   begin
       mem_write_add21 <= 1'b0;
       mem_addr_add21  <= d_addr_hash21;
   end
// Need21 to set address two21 cycles21 before check
   else if ( (add_chk_state21 == age_chk21) && age_confirmed21 )
   begin
       mem_write_add21 <= 1'b0;
       mem_addr_add21  <= s_addr_hash21;
   end
   else if (add_chk_state21 == write_src21)
   begin
       mem_write_add21 <= 1'b1;
       mem_addr_add21  <= s_addr_hash21;
   end
   else
   begin
       mem_write_add21 <= 1'b0;
       mem_addr_add21  <= d_addr_hash21;
   end
   end


// -----------------------------------------------------------------------------
//   Generate21 databus21 for writing to memory
//   Data written21 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add21 = {1'b1, curr_time21, s_port21, s_addr21};



// -----------------------------------------------------------------------------
//   Evaluate21 read back data that is about21 to be overwritten21 with new source21 
//   address and port values. Decide21 whether21 the reused21 flag21 must be set and
//   last_inval21 address and port values updated.
//   reused21 needs21 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21) 
   begin
      reused21 <= 1'b0;
      lst_inv_addr_nrm21 <= 48'd0;
      lst_inv_port_nrm21 <= 2'd0;
   end
   else if ((add_chk_state21 == read_src_add21) & mem_read_data_add21[82] &
            (s_addr21 != mem_read_data_add21[47:0]))
   begin
      reused21 <= 1'b1;
      lst_inv_addr_nrm21 <= mem_read_data_add21[47:0];
      lst_inv_port_nrm21 <= mem_read_data_add21[49:48];
   end
   else if (clear_reused21)
   begin
      reused21 <= 1'b0;
      lst_inv_addr_nrm21 <= lst_inv_addr_nrm21;
      lst_inv_port_nrm21 <= lst_inv_addr_nrm21;
   end
   else 
   begin
      reused21 <= reused21;
      lst_inv_addr_nrm21 <= lst_inv_addr_nrm21;
      lst_inv_port_nrm21 <= lst_inv_addr_nrm21;
   end
   end


// -----------------------------------------------------------------------------
//   Generate21 signals21 for age21 checker to perform21 in-date21 check
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21) 
   begin
      check_age21 <= 1'b0;  
      last_accessed21 <= 32'd0;
   end
   else if (check_age21)
   begin
      check_age21 <= 1'b0;  
      last_accessed21 <= mem_read_data_add21[81:50];
   end
   else if (add_chk_state21 == age_chk21)
   begin
      check_age21 <= 1'b1;  
      last_accessed21 <= mem_read_data_add21[81:50];
   end
   else 
   begin
      check_age21 <= 1'b0;  
      last_accessed21 <= 32'd0;
   end
   end


`ifdef ABV_ON21

// psl21 default clock21 = (posedge pclk21);

// ASSERTION21 CHECKS21
/* Commented21 out as also checking in toplevel21
// it should never be possible21 for the destination21 port to indicate21 the MAC21
// switch21 address and one of the other 4 Ethernets21
// psl21 assert_valid_dest_port21 : assert never (d_port21[4] & |{d_port21[3:0]});


// COVER21 SANITY21 CHECKS21
// check all values of destination21 port can be returned.
// psl21 cover_d_port_021 : cover { d_port21 == 5'b0_0001 };
// psl21 cover_d_port_121 : cover { d_port21 == 5'b0_0010 };
// psl21 cover_d_port_221 : cover { d_port21 == 5'b0_0100 };
// psl21 cover_d_port_321 : cover { d_port21 == 5'b0_1000 };
// psl21 cover_d_port_421 : cover { d_port21 == 5'b1_0000 };
// psl21 cover_d_port_all21 : cover { d_port21 == 5'b0_1111 };
*/
`endif


endmodule 









