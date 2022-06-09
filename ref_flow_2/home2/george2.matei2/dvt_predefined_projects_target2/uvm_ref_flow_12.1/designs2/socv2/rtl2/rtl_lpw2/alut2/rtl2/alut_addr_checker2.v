//File2 name   : alut_addr_checker2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

// compiler2 directives2
`include "alut_defines2.v"


module alut_addr_checker2
(   
   // Inputs2
   pclk2,
   n_p_reset2,
   command,
   mac_addr2,
   d_addr2,
   s_addr2,
   s_port2,
   curr_time2,
   mem_read_data_add2,
   age_confirmed2,
   age_ok2,
   clear_reused2,

   //outputs2
   d_port2,
   add_check_active2,
   mem_addr_add2,
   mem_write_add2,
   mem_write_data_add2,
   lst_inv_addr_nrm2,
   lst_inv_port_nrm2,
   check_age2,
   last_accessed2,
   reused2
);



   input               pclk2;               // APB2 clock2                           
   input               n_p_reset2;          // Reset2                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr2;           // address of the switch2              
   input [47:0]        d_addr2;             // address of frame2 to be checked2     
   input [47:0]        s_addr2;             // address of frame2 to be stored2      
   input [1:0]         s_port2;             // source2 port of current frame2       
   input [31:0]        curr_time2;          // current time,for storing2 in mem    
   input [82:0]        mem_read_data_add2;  // read data from mem                 
   input               age_confirmed2;      // valid flag2 from age2 checker        
   input               age_ok2;             // result from age2 checker 
   input               clear_reused2;       // read/clear flag2 for reused2 signal2           

   output [4:0]        d_port2;             // calculated2 destination2 port for tx2 
   output              add_check_active2;   // bit 0 of status register           
   output [7:0]        mem_addr_add2;       // hash2 address for R/W2 to memory     
   output              mem_write_add2;      // R/W2 flag2 (write = high2)            
   output [82:0]       mem_write_data_add2; // write data for memory             
   output [47:0]       lst_inv_addr_nrm2;   // last invalidated2 addr normal2 op    
   output [1:0]        lst_inv_port_nrm2;   // last invalidated2 port normal2 op    
   output              check_age2;          // request flag2 for age2 check
   output [31:0]       last_accessed2;      // time field sent2 for age2 check
   output              reused2;             // indicates2 ALUT2 location2 overwritten2

   reg   [2:0]         add_chk_state2;      // current address checker state
   reg   [2:0]         nxt_add_chk_state2;  // current address checker state
   reg   [4:0]         d_port2;             // calculated2 destination2 port for tx2 
   reg   [3:0]         port_mem2;           // bitwise2 conversion2 of 2bit port
   reg   [7:0]         mem_addr_add2;       // hash2 address for R/W2 to memory
   reg                 mem_write_add2;      // R/W2 flag2 (write = high2)            
   reg                 reused2;             // indicates2 ALUT2 location2 overwritten2
   reg   [47:0]        lst_inv_addr_nrm2;   // last invalidated2 addr normal2 op    
   reg   [1:0]         lst_inv_port_nrm2;   // last invalidated2 port normal2 op    
   reg                 check_age2;          // request flag2 for age2 checker
   reg   [31:0]        last_accessed2;      // time field sent2 for age2 check


   wire   [7:0]        s_addr_hash2;        // hash2 of address for storing2
   wire   [7:0]        d_addr_hash2;        // hash2 of address for checking
   wire   [82:0]       mem_write_data_add2; // write data for memory  
   wire                add_check_active2;   // bit 0 of status register           


// Parameters2 for Address Checking2 FSM2 states2
   parameter idle2           = 3'b000;
   parameter mac_addr_chk2   = 3'b001;
   parameter read_dest_add2  = 3'b010;
   parameter valid_chk2      = 3'b011;
   parameter age_chk2        = 3'b100;
   parameter addr_chk2       = 3'b101;
   parameter read_src_add2   = 3'b110;
   parameter write_src2      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash2 conversion2 of source2 and destination2 addresses2
// -----------------------------------------------------------------------------
   assign s_addr_hash2 = s_addr2[7:0] ^ s_addr2[15:8] ^ s_addr2[23:16] ^
                        s_addr2[31:24] ^ s_addr2[39:32] ^ s_addr2[47:40];

   assign d_addr_hash2 = d_addr2[7:0] ^ d_addr2[15:8] ^ d_addr2[23:16] ^
                        d_addr2[31:24] ^ d_addr2[39:32] ^ d_addr2[47:40];



// -----------------------------------------------------------------------------
//   State2 Machine2 For2 handling2 the destination2 address checking process and
//   and storing2 of new source2 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state2 or age_confirmed2 or age_ok2)
   begin
      case (add_chk_state2)
      
      idle2:
         if (command == 2'b01)
            nxt_add_chk_state2 = mac_addr_chk2;
         else
            nxt_add_chk_state2 = idle2;

      mac_addr_chk2:   // check if destination2 address match MAC2 switch2 address
         if (d_addr2 == mac_addr2)
            nxt_add_chk_state2 = idle2;  // return dest2 port as 5'b1_0000
         else
            nxt_add_chk_state2 = read_dest_add2;

      read_dest_add2:       // read data from memory using hash2 of destination2 address
            nxt_add_chk_state2 = valid_chk2;

      valid_chk2:      // check if read data had2 valid bit set
         nxt_add_chk_state2 = age_chk2;

      age_chk2:        // request age2 checker to check if still in date2
         if (age_confirmed2)
            nxt_add_chk_state2 = addr_chk2;
         else
            nxt_add_chk_state2 = age_chk2; 

      addr_chk2:       // perform2 compare between dest2 and read addresses2
            nxt_add_chk_state2 = read_src_add2; // return read port from ALUT2 mem

      read_src_add2:   // read from memory location2 about2 to be overwritten2
            nxt_add_chk_state2 = write_src2; 

      write_src2:      // write new source2 data (addr and port) to memory
            nxt_add_chk_state2 = idle2; 

      default:
            nxt_add_chk_state2 = idle2;
      endcase
   end


// destination2 check FSM2 current state
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      add_chk_state2 <= idle2;
   else
      add_chk_state2 <= nxt_add_chk_state2;
   end



// -----------------------------------------------------------------------------
//   Generate2 returned value of port for sending2 new frame2 to
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      d_port2 <= 5'b0_1111;
   else if ((add_chk_state2 == mac_addr_chk2) & (d_addr2 == mac_addr2))
      d_port2 <= 5'b1_0000;
   else if (((add_chk_state2 == valid_chk2) & ~mem_read_data_add2[82]) |
            ((add_chk_state2 == age_chk2) & ~(age_confirmed2 & age_ok2)) |
            ((add_chk_state2 == addr_chk2) & (d_addr2 != mem_read_data_add2[47:0])))
      d_port2 <= 5'b0_1111 & ~( 1 << s_port2 );
   else if ((add_chk_state2 == addr_chk2) & (d_addr2 == mem_read_data_add2[47:0]))
      d_port2 <= {1'b0, port_mem2} & ~( 1 << s_port2 );
   else
      d_port2 <= d_port2;
   end


// -----------------------------------------------------------------------------
//   convert read port source2 value from 2bits to bitwise2 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      port_mem2 <= 4'b1111;
   else begin
      case (mem_read_data_add2[49:48])
         2'b00: port_mem2 <= 4'b0001;
         2'b01: port_mem2 <= 4'b0010;
         2'b10: port_mem2 <= 4'b0100;
         2'b11: port_mem2 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded2 off2 add_chk_state2
// -----------------------------------------------------------------------------
assign add_check_active2 = (add_chk_state2 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate2 memory addressing2 signals2.
//   The check address command will be taken2 as the indication2 from SW2 that the 
//   source2 fields (address and port) can be written2 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2) 
   begin
       mem_write_add2 <= 1'b0;
       mem_addr_add2  <= 8'd0;
   end
   else if (add_chk_state2 == read_dest_add2)
   begin
       mem_write_add2 <= 1'b0;
       mem_addr_add2  <= d_addr_hash2;
   end
// Need2 to set address two2 cycles2 before check
   else if ( (add_chk_state2 == age_chk2) && age_confirmed2 )
   begin
       mem_write_add2 <= 1'b0;
       mem_addr_add2  <= s_addr_hash2;
   end
   else if (add_chk_state2 == write_src2)
   begin
       mem_write_add2 <= 1'b1;
       mem_addr_add2  <= s_addr_hash2;
   end
   else
   begin
       mem_write_add2 <= 1'b0;
       mem_addr_add2  <= d_addr_hash2;
   end
   end


// -----------------------------------------------------------------------------
//   Generate2 databus2 for writing to memory
//   Data written2 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add2 = {1'b1, curr_time2, s_port2, s_addr2};



// -----------------------------------------------------------------------------
//   Evaluate2 read back data that is about2 to be overwritten2 with new source2 
//   address and port values. Decide2 whether2 the reused2 flag2 must be set and
//   last_inval2 address and port values updated.
//   reused2 needs2 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2) 
   begin
      reused2 <= 1'b0;
      lst_inv_addr_nrm2 <= 48'd0;
      lst_inv_port_nrm2 <= 2'd0;
   end
   else if ((add_chk_state2 == read_src_add2) & mem_read_data_add2[82] &
            (s_addr2 != mem_read_data_add2[47:0]))
   begin
      reused2 <= 1'b1;
      lst_inv_addr_nrm2 <= mem_read_data_add2[47:0];
      lst_inv_port_nrm2 <= mem_read_data_add2[49:48];
   end
   else if (clear_reused2)
   begin
      reused2 <= 1'b0;
      lst_inv_addr_nrm2 <= lst_inv_addr_nrm2;
      lst_inv_port_nrm2 <= lst_inv_addr_nrm2;
   end
   else 
   begin
      reused2 <= reused2;
      lst_inv_addr_nrm2 <= lst_inv_addr_nrm2;
      lst_inv_port_nrm2 <= lst_inv_addr_nrm2;
   end
   end


// -----------------------------------------------------------------------------
//   Generate2 signals2 for age2 checker to perform2 in-date2 check
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2) 
   begin
      check_age2 <= 1'b0;  
      last_accessed2 <= 32'd0;
   end
   else if (check_age2)
   begin
      check_age2 <= 1'b0;  
      last_accessed2 <= mem_read_data_add2[81:50];
   end
   else if (add_chk_state2 == age_chk2)
   begin
      check_age2 <= 1'b1;  
      last_accessed2 <= mem_read_data_add2[81:50];
   end
   else 
   begin
      check_age2 <= 1'b0;  
      last_accessed2 <= 32'd0;
   end
   end


`ifdef ABV_ON2

// psl2 default clock2 = (posedge pclk2);

// ASSERTION2 CHECKS2
/* Commented2 out as also checking in toplevel2
// it should never be possible2 for the destination2 port to indicate2 the MAC2
// switch2 address and one of the other 4 Ethernets2
// psl2 assert_valid_dest_port2 : assert never (d_port2[4] & |{d_port2[3:0]});


// COVER2 SANITY2 CHECKS2
// check all values of destination2 port can be returned.
// psl2 cover_d_port_02 : cover { d_port2 == 5'b0_0001 };
// psl2 cover_d_port_12 : cover { d_port2 == 5'b0_0010 };
// psl2 cover_d_port_22 : cover { d_port2 == 5'b0_0100 };
// psl2 cover_d_port_32 : cover { d_port2 == 5'b0_1000 };
// psl2 cover_d_port_42 : cover { d_port2 == 5'b1_0000 };
// psl2 cover_d_port_all2 : cover { d_port2 == 5'b0_1111 };
*/
`endif


endmodule 









