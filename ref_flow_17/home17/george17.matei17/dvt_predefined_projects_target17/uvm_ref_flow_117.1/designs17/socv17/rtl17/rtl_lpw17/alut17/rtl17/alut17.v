//File17 name   : alut17.v
//Title17       : ALUT17 top level
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
module alut17
(   
   // Inputs17
   pclk17,
   n_p_reset17,
   psel17,            
   penable17,       
   pwrite17,         
   paddr17,           
   pwdata17,          

   // Outputs17
   prdata17  
);

   parameter   DW17 = 83;          // width of data busses17
   parameter   DD17 = 256;         // depth of RAM17


   // APB17 Inputs17
   input             pclk17;               // APB17 clock17                          
   input             n_p_reset17;          // Reset17                              
   input             psel17;               // Module17 select17 signal17               
   input             penable17;            // Enable17 signal17                      
   input             pwrite17;             // Write when HIGH17 and read when LOW17  
   input [6:0]       paddr17;              // Address bus for read write         
   input [31:0]      pwdata17;             // APB17 write bus                      

   output [31:0]     prdata17;             // APB17 read bus                       

   wire              pclk17;               // APB17 clock17                           
   wire [7:0]        mem_addr_add17;       // hash17 address for R/W17 to memory     
   wire              mem_write_add17;      // R/W17 flag17 (write = high17)            
   wire [DW17-1:0]     mem_write_data_add17; // write data for memory             
   wire [7:0]        mem_addr_age17;       // hash17 address for R/W17 to memory     
   wire              mem_write_age17;      // R/W17 flag17 (write = high17)            
   wire [DW17-1:0]     mem_write_data_age17; // write data for memory             
   wire [DW17-1:0]     mem_read_data_add17;  // read data from mem                 
   wire [DW17-1:0]     mem_read_data_age17;  // read data from mem  
   wire [31:0]       curr_time17;          // current time
   wire              active;             // status[0] adress17 checker active
   wire              inval_in_prog17;      // status[1] 
   wire              reused17;             // status[2] ALUT17 location17 overwritten17
   wire [4:0]        d_port17;             // calculated17 destination17 port for tx17
   wire [47:0]       lst_inv_addr_nrm17;   // last invalidated17 addr normal17 op
   wire [1:0]        lst_inv_port_nrm17;   // last invalidated17 port normal17 op
   wire [47:0]       lst_inv_addr_cmd17;   // last invalidated17 addr via cmd17
   wire [1:0]        lst_inv_port_cmd17;   // last invalidated17 port via cmd17
   wire [47:0]       mac_addr17;           // address of the switch17
   wire [47:0]       d_addr17;             // address of frame17 to be checked17
   wire [47:0]       s_addr17;             // address of frame17 to be stored17
   wire [1:0]        s_port17;             // source17 port of current frame17
   wire [31:0]       best_bfr_age17;       // best17 before age17
   wire [7:0]        div_clk17;            // programmed17 clock17 divider17 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata17;             // APB17 read bus
   wire              age_confirmed17;      // valid flag17 from age17 checker        
   wire              age_ok17;             // result from age17 checker 
   wire              clear_reused17;       // read/clear flag17 for reused17 signal17           
   wire              check_age17;          // request flag17 for age17 check
   wire [31:0]       last_accessed17;      // time field sent17 for age17 check




alut_reg_bank17 i_alut_reg_bank17
(   
   // Inputs17
   .pclk17(pclk17),
   .n_p_reset17(n_p_reset17),
   .psel17(psel17),            
   .penable17(penable17),       
   .pwrite17(pwrite17),         
   .paddr17(paddr17),           
   .pwdata17(pwdata17),          
   .curr_time17(curr_time17),
   .add_check_active17(add_check_active17),
   .age_check_active17(age_check_active17),
   .inval_in_prog17(inval_in_prog17),
   .reused17(reused17),
   .d_port17(d_port17),
   .lst_inv_addr_nrm17(lst_inv_addr_nrm17),
   .lst_inv_port_nrm17(lst_inv_port_nrm17),
   .lst_inv_addr_cmd17(lst_inv_addr_cmd17),
   .lst_inv_port_cmd17(lst_inv_port_cmd17),

   // Outputs17
   .mac_addr17(mac_addr17),    
   .d_addr17(d_addr17),   
   .s_addr17(s_addr17),    
   .s_port17(s_port17),    
   .best_bfr_age17(best_bfr_age17),
   .div_clk17(div_clk17),     
   .command(command), 
   .prdata17(prdata17),  
   .clear_reused17(clear_reused17)           
);


alut_addr_checker17 i_alut_addr_checker17
(   
   // Inputs17
   .pclk17(pclk17),
   .n_p_reset17(n_p_reset17),
   .command(command),
   .mac_addr17(mac_addr17),
   .d_addr17(d_addr17),
   .s_addr17(s_addr17),
   .s_port17(s_port17),
   .curr_time17(curr_time17),
   .mem_read_data_add17(mem_read_data_add17),
   .age_confirmed17(age_confirmed17),
   .age_ok17(age_ok17),
   .clear_reused17(clear_reused17),

   //outputs17
   .d_port17(d_port17),
   .add_check_active17(add_check_active17),
   .mem_addr_add17(mem_addr_add17),
   .mem_write_add17(mem_write_add17),
   .mem_write_data_add17(mem_write_data_add17),
   .lst_inv_addr_nrm17(lst_inv_addr_nrm17),
   .lst_inv_port_nrm17(lst_inv_port_nrm17),
   .check_age17(check_age17),
   .last_accessed17(last_accessed17),
   .reused17(reused17)
);


alut_age_checker17 i_alut_age_checker17
(   
   // Inputs17
   .pclk17(pclk17),
   .n_p_reset17(n_p_reset17),
   .command(command),          
   .div_clk17(div_clk17),          
   .mem_read_data_age17(mem_read_data_age17),
   .check_age17(check_age17),        
   .last_accessed17(last_accessed17), 
   .best_bfr_age17(best_bfr_age17),   
   .add_check_active17(add_check_active17),

   // outputs17
   .curr_time17(curr_time17),         
   .mem_addr_age17(mem_addr_age17),      
   .mem_write_age17(mem_write_age17),     
   .mem_write_data_age17(mem_write_data_age17),
   .lst_inv_addr_cmd17(lst_inv_addr_cmd17),  
   .lst_inv_port_cmd17(lst_inv_port_cmd17),  
   .age_confirmed17(age_confirmed17),     
   .age_ok17(age_ok17),
   .inval_in_prog17(inval_in_prog17),            
   .age_check_active17(age_check_active17)
);   


alut_mem17 i_alut_mem17
(   
   // Inputs17
   .pclk17(pclk17),
   .mem_addr_add17(mem_addr_add17),
   .mem_write_add17(mem_write_add17),
   .mem_write_data_add17(mem_write_data_add17),
   .mem_addr_age17(mem_addr_age17),
   .mem_write_age17(mem_write_age17),
   .mem_write_data_age17(mem_write_data_age17),

   .mem_read_data_add17(mem_read_data_add17),  
   .mem_read_data_age17(mem_read_data_age17)
);   



`ifdef ABV_ON17
// psl17 default clock17 = (posedge pclk17);

// ASSUMPTIONS17

// ASSERTION17 CHECKS17
// the invalidate17 aged17 in progress17 flag17 and the active flag17 
// should never both be set.
// psl17 assert_inval_in_prog_active17 : assert never (inval_in_prog17 & active);

// it should never be possible17 for the destination17 port to indicate17 the MAC17
// switch17 address and one of the other 4 Ethernets17
// psl17 assert_valid_dest_port17 : assert never (d_port17[4] & |{d_port17[3:0]});

// COVER17 SANITY17 CHECKS17
// check all values of destination17 port can be returned.
// psl17 cover_d_port_017 : cover { d_port17 == 5'b0_0001 };
// psl17 cover_d_port_117 : cover { d_port17 == 5'b0_0010 };
// psl17 cover_d_port_217 : cover { d_port17 == 5'b0_0100 };
// psl17 cover_d_port_317 : cover { d_port17 == 5'b0_1000 };
// psl17 cover_d_port_417 : cover { d_port17 == 5'b1_0000 };
// psl17 cover_d_port_all17 : cover { d_port17 == 5'b0_1111 };

`endif


endmodule
