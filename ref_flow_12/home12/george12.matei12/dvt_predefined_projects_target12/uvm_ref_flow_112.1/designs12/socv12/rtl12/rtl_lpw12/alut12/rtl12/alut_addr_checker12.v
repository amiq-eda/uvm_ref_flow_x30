//File12 name   : alut_addr_checker12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
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

// compiler12 directives12
`include "alut_defines12.v"


module alut_addr_checker12
(   
   // Inputs12
   pclk12,
   n_p_reset12,
   command,
   mac_addr12,
   d_addr12,
   s_addr12,
   s_port12,
   curr_time12,
   mem_read_data_add12,
   age_confirmed12,
   age_ok12,
   clear_reused12,

   //outputs12
   d_port12,
   add_check_active12,
   mem_addr_add12,
   mem_write_add12,
   mem_write_data_add12,
   lst_inv_addr_nrm12,
   lst_inv_port_nrm12,
   check_age12,
   last_accessed12,
   reused12
);



   input               pclk12;               // APB12 clock12                           
   input               n_p_reset12;          // Reset12                               
   input [1:0]         command;            // command bus                        
   input [47:0]        mac_addr12;           // address of the switch12              
   input [47:0]        d_addr12;             // address of frame12 to be checked12     
   input [47:0]        s_addr12;             // address of frame12 to be stored12      
   input [1:0]         s_port12;             // source12 port of current frame12       
   input [31:0]        curr_time12;          // current time,for storing12 in mem    
   input [82:0]        mem_read_data_add12;  // read data from mem                 
   input               age_confirmed12;      // valid flag12 from age12 checker        
   input               age_ok12;             // result from age12 checker 
   input               clear_reused12;       // read/clear flag12 for reused12 signal12           

   output [4:0]        d_port12;             // calculated12 destination12 port for tx12 
   output              add_check_active12;   // bit 0 of status register           
   output [7:0]        mem_addr_add12;       // hash12 address for R/W12 to memory     
   output              mem_write_add12;      // R/W12 flag12 (write = high12)            
   output [82:0]       mem_write_data_add12; // write data for memory             
   output [47:0]       lst_inv_addr_nrm12;   // last invalidated12 addr normal12 op    
   output [1:0]        lst_inv_port_nrm12;   // last invalidated12 port normal12 op    
   output              check_age12;          // request flag12 for age12 check
   output [31:0]       last_accessed12;      // time field sent12 for age12 check
   output              reused12;             // indicates12 ALUT12 location12 overwritten12

   reg   [2:0]         add_chk_state12;      // current address checker state
   reg   [2:0]         nxt_add_chk_state12;  // current address checker state
   reg   [4:0]         d_port12;             // calculated12 destination12 port for tx12 
   reg   [3:0]         port_mem12;           // bitwise12 conversion12 of 2bit port
   reg   [7:0]         mem_addr_add12;       // hash12 address for R/W12 to memory
   reg                 mem_write_add12;      // R/W12 flag12 (write = high12)            
   reg                 reused12;             // indicates12 ALUT12 location12 overwritten12
   reg   [47:0]        lst_inv_addr_nrm12;   // last invalidated12 addr normal12 op    
   reg   [1:0]         lst_inv_port_nrm12;   // last invalidated12 port normal12 op    
   reg                 check_age12;          // request flag12 for age12 checker
   reg   [31:0]        last_accessed12;      // time field sent12 for age12 check


   wire   [7:0]        s_addr_hash12;        // hash12 of address for storing12
   wire   [7:0]        d_addr_hash12;        // hash12 of address for checking
   wire   [82:0]       mem_write_data_add12; // write data for memory  
   wire                add_check_active12;   // bit 0 of status register           


// Parameters12 for Address Checking12 FSM12 states12
   parameter idle12           = 3'b000;
   parameter mac_addr_chk12   = 3'b001;
   parameter read_dest_add12  = 3'b010;
   parameter valid_chk12      = 3'b011;
   parameter age_chk12        = 3'b100;
   parameter addr_chk12       = 3'b101;
   parameter read_src_add12   = 3'b110;
   parameter write_src12      = 3'b111;


// -----------------------------------------------------------------------------
//   Hash12 conversion12 of source12 and destination12 addresses12
// -----------------------------------------------------------------------------
   assign s_addr_hash12 = s_addr12[7:0] ^ s_addr12[15:8] ^ s_addr12[23:16] ^
                        s_addr12[31:24] ^ s_addr12[39:32] ^ s_addr12[47:40];

   assign d_addr_hash12 = d_addr12[7:0] ^ d_addr12[15:8] ^ d_addr12[23:16] ^
                        d_addr12[31:24] ^ d_addr12[39:32] ^ d_addr12[47:40];



// -----------------------------------------------------------------------------
//   State12 Machine12 For12 handling12 the destination12 address checking process and
//   and storing12 of new source12 address and port values.
// -----------------------------------------------------------------------------
always @ (command or add_chk_state12 or age_confirmed12 or age_ok12)
   begin
      case (add_chk_state12)
      
      idle12:
         if (command == 2'b01)
            nxt_add_chk_state12 = mac_addr_chk12;
         else
            nxt_add_chk_state12 = idle12;

      mac_addr_chk12:   // check if destination12 address match MAC12 switch12 address
         if (d_addr12 == mac_addr12)
            nxt_add_chk_state12 = idle12;  // return dest12 port as 5'b1_0000
         else
            nxt_add_chk_state12 = read_dest_add12;

      read_dest_add12:       // read data from memory using hash12 of destination12 address
            nxt_add_chk_state12 = valid_chk12;

      valid_chk12:      // check if read data had12 valid bit set
         nxt_add_chk_state12 = age_chk12;

      age_chk12:        // request age12 checker to check if still in date12
         if (age_confirmed12)
            nxt_add_chk_state12 = addr_chk12;
         else
            nxt_add_chk_state12 = age_chk12; 

      addr_chk12:       // perform12 compare between dest12 and read addresses12
            nxt_add_chk_state12 = read_src_add12; // return read port from ALUT12 mem

      read_src_add12:   // read from memory location12 about12 to be overwritten12
            nxt_add_chk_state12 = write_src12; 

      write_src12:      // write new source12 data (addr and port) to memory
            nxt_add_chk_state12 = idle12; 

      default:
            nxt_add_chk_state12 = idle12;
      endcase
   end


// destination12 check FSM12 current state
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      add_chk_state12 <= idle12;
   else
      add_chk_state12 <= nxt_add_chk_state12;
   end



// -----------------------------------------------------------------------------
//   Generate12 returned value of port for sending12 new frame12 to
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      d_port12 <= 5'b0_1111;
   else if ((add_chk_state12 == mac_addr_chk12) & (d_addr12 == mac_addr12))
      d_port12 <= 5'b1_0000;
   else if (((add_chk_state12 == valid_chk12) & ~mem_read_data_add12[82]) |
            ((add_chk_state12 == age_chk12) & ~(age_confirmed12 & age_ok12)) |
            ((add_chk_state12 == addr_chk12) & (d_addr12 != mem_read_data_add12[47:0])))
      d_port12 <= 5'b0_1111 & ~( 1 << s_port12 );
   else if ((add_chk_state12 == addr_chk12) & (d_addr12 == mem_read_data_add12[47:0]))
      d_port12 <= {1'b0, port_mem12} & ~( 1 << s_port12 );
   else
      d_port12 <= d_port12;
   end


// -----------------------------------------------------------------------------
//   convert read port source12 value from 2bits to bitwise12 4 bits
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      port_mem12 <= 4'b1111;
   else begin
      case (mem_read_data_add12[49:48])
         2'b00: port_mem12 <= 4'b0001;
         2'b01: port_mem12 <= 4'b0010;
         2'b10: port_mem12 <= 4'b0100;
         2'b11: port_mem12 <= 4'b1000;
      endcase
   end
   end
   


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded12 off12 add_chk_state12
// -----------------------------------------------------------------------------
assign add_check_active12 = (add_chk_state12 != 3'b000);


// -----------------------------------------------------------------------------
//   Generate12 memory addressing12 signals12.
//   The check address command will be taken12 as the indication12 from SW12 that the 
//   source12 fields (address and port) can be written12 to memory. 
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12) 
   begin
       mem_write_add12 <= 1'b0;
       mem_addr_add12  <= 8'd0;
   end
   else if (add_chk_state12 == read_dest_add12)
   begin
       mem_write_add12 <= 1'b0;
       mem_addr_add12  <= d_addr_hash12;
   end
// Need12 to set address two12 cycles12 before check
   else if ( (add_chk_state12 == age_chk12) && age_confirmed12 )
   begin
       mem_write_add12 <= 1'b0;
       mem_addr_add12  <= s_addr_hash12;
   end
   else if (add_chk_state12 == write_src12)
   begin
       mem_write_add12 <= 1'b1;
       mem_addr_add12  <= s_addr_hash12;
   end
   else
   begin
       mem_write_add12 <= 1'b0;
       mem_addr_add12  <= d_addr_hash12;
   end
   end


// -----------------------------------------------------------------------------
//   Generate12 databus12 for writing to memory
//   Data written12 to memory from address checker will always be valid
// -----------------------------------------------------------------------------
assign mem_write_data_add12 = {1'b1, curr_time12, s_port12, s_addr12};



// -----------------------------------------------------------------------------
//   Evaluate12 read back data that is about12 to be overwritten12 with new source12 
//   address and port values. Decide12 whether12 the reused12 flag12 must be set and
//   last_inval12 address and port values updated.
//   reused12 needs12 to be implemented as read and clear
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12) 
   begin
      reused12 <= 1'b0;
      lst_inv_addr_nrm12 <= 48'd0;
      lst_inv_port_nrm12 <= 2'd0;
   end
   else if ((add_chk_state12 == read_src_add12) & mem_read_data_add12[82] &
            (s_addr12 != mem_read_data_add12[47:0]))
   begin
      reused12 <= 1'b1;
      lst_inv_addr_nrm12 <= mem_read_data_add12[47:0];
      lst_inv_port_nrm12 <= mem_read_data_add12[49:48];
   end
   else if (clear_reused12)
   begin
      reused12 <= 1'b0;
      lst_inv_addr_nrm12 <= lst_inv_addr_nrm12;
      lst_inv_port_nrm12 <= lst_inv_addr_nrm12;
   end
   else 
   begin
      reused12 <= reused12;
      lst_inv_addr_nrm12 <= lst_inv_addr_nrm12;
      lst_inv_port_nrm12 <= lst_inv_addr_nrm12;
   end
   end


// -----------------------------------------------------------------------------
//   Generate12 signals12 for age12 checker to perform12 in-date12 check
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12) 
   begin
      check_age12 <= 1'b0;  
      last_accessed12 <= 32'd0;
   end
   else if (check_age12)
   begin
      check_age12 <= 1'b0;  
      last_accessed12 <= mem_read_data_add12[81:50];
   end
   else if (add_chk_state12 == age_chk12)
   begin
      check_age12 <= 1'b1;  
      last_accessed12 <= mem_read_data_add12[81:50];
   end
   else 
   begin
      check_age12 <= 1'b0;  
      last_accessed12 <= 32'd0;
   end
   end


`ifdef ABV_ON12

// psl12 default clock12 = (posedge pclk12);

// ASSERTION12 CHECKS12
/* Commented12 out as also checking in toplevel12
// it should never be possible12 for the destination12 port to indicate12 the MAC12
// switch12 address and one of the other 4 Ethernets12
// psl12 assert_valid_dest_port12 : assert never (d_port12[4] & |{d_port12[3:0]});


// COVER12 SANITY12 CHECKS12
// check all values of destination12 port can be returned.
// psl12 cover_d_port_012 : cover { d_port12 == 5'b0_0001 };
// psl12 cover_d_port_112 : cover { d_port12 == 5'b0_0010 };
// psl12 cover_d_port_212 : cover { d_port12 == 5'b0_0100 };
// psl12 cover_d_port_312 : cover { d_port12 == 5'b0_1000 };
// psl12 cover_d_port_412 : cover { d_port12 == 5'b1_0000 };
// psl12 cover_d_port_all12 : cover { d_port12 == 5'b0_1111 };
*/
`endif


endmodule 









