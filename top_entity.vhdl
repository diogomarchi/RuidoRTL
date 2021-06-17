------------------------------------------------
-- Design: top_entity
-- Entity: top_entity
-- Author: Diogo & George
-- Rev. : 1.0
-- Date : 06/16/2021
------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.STD_LOGIC_UNSIGNED.ALL;

ENTITY top_entity IS
  PORT (
    i_CLK          : IN  STD_LOGIC;
    i_CLR_N        : IN  STD_LOGIC;
    i_GO           : IN  STD_LOGIC;                    -- enable contador
    i_CONTINUE     : IN  STD_LOGIC;                    -- clear contador
    i_DATA_IMG     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
	 o_READ_ENABLE  : OUT STD_LOGIC;                    -- output read enable rom 
	 o_WRITE_ENABLE : OUT STD_LOGIC;                    -- output write enable ram 
	 o_READ_PIX_ADDR: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr in image
	 o_WRITE_PIX_ADDR: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
	 o_READY        : OUT STD_LOGIC -- addr sal noise
  );
END top_entity;

ARCHITECTURE rtl OF top_entity IS


component bloco_controle IS
  PORT (
    i_CLK        : IN  STD_LOGIC; -- input clock
    i_CLR_n      : IN  STD_LOGIC; -- input clear/reset
    i_GO         : IN  STD_LOGIC; -- go 
    i_CONTINUE   : IN  STD_LOGIC; -- input start
	 i_NEXT       : IN  STD_LOGIC; -- input addres
    o_CLR_CONT   : OUT STD_LOGIC; -- output clear
    o_READY      : OUT STD_LOGIC; -- output larger or less that 4096
    o_INC_CONT   : OUT STD_LOGIC; -- output inc contador
    o_R_EN_ROM   : OUT STD_LOGIC; -- output read enable in rom memory
    o_WR_EN_RAM  : OUT STD_LOGIC  -- output write enable in ram memory
  );
END component;


component bloco_operacional IS
  PORT (
    i_CLK          : IN  STD_LOGIC;
    i_CLR_N        : IN  STD_LOGIC;
    i_INC_ADDR     : IN  STD_LOGIC;                    -- enable contador
    i_RESET        : IN  STD_LOGIC;                    -- clear contador
    i_DATA_IMG     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
	 i_DATA_RUIDO_G : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from GAUSS memory
	 i_DATA_RUIDO_S : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from Salt memory
	 i_LIMIAR1      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 1
	 i_LIMIAR2      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 2
    i_READ_ENABLE  : IN  STD_LOGIC;                    -- input read enable in rom memory
    i_WRITE_ENABLE : IN  STD_LOGIC;                    -- data input 
	 i_SELECAO_RUIDO: IN  STD_LOGIC;                    -- seleciona entre os tipo de ruido
    o_NEXT         : OUT STD_LOGIC;                    -- data output continue
    o_READ_ENABLE  : OUT STD_LOGIC;                    -- output read enable in rom memory  
    o_WRITE_ENABLE : OUT STD_LOGIC;                    -- output write enable ram 
	 o_ADDR         : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
	 o_ADDR_GAUSS   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr gauss noise
	 o_ADDR_SAL     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr sal noise
	 o_PIXEL        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- data output
  );
END component;



signal w_NEXT, w_RESET_CNT, w_INC_CONT, w_WRITE_ENA, w_READ_ENA :  STD_LOGIC;

  

BEGIN


  u_CTRL: bloco_controle PORT MAP (
    i_CLK        => i_CLK,
    i_CLR_n      => i_CLR_n,
    i_GO         => i_GO,
    i_CONTINUE   => i_CONTINUE,
	 i_NEXT       => w_NEXT,
    o_CLR_CONT   => w_RESET_CNT,
    o_READY      => o_READY,
    o_INC_CONT   => w_INC_CONT,
    o_R_EN_ROM   => w_READ_ENA,
    o_WR_EN_RAM  => w_WRITE_ENA    
  );


  
  o_READ_ENABLE  <= i_READ_ENABLE;
  o_WRITE_ENABLE <= i_WRITE_ENABLE;
	
  o_ADDR       <= w_o_CNT_ADDR;
  o_ADDR_GAUSS <= w_o_CNT_ADDR(7 downto 0);
  o_ADDR_SAL   <= w_o_CNT_ADDR(7 downto 0);
  o_PIXEL      <= w_o_MUX7;
    

END rtl;
