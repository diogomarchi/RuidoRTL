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
	 i_LIMIAR1      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 1 ruido sal
  	 i_LIMIAR2      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- LIMIAR 2 ruido sal
	 i_SELECAO_RUIDO: IN  STD_LOGIC;                    -- seleciona entre os tipos de ruido
	 -- i_DATA_RUIDO_G : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from GAUSS memory
    -- i_DATA_RUIDO_S : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input from Salt memory
    -- i_DATA_IMG     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- data input
	 -- o_READ_ENABLE  : OUT STD_LOGIC;                    -- output read enable rom 
	 -- o_WRITE_ENABLE : OUT STD_LOGIC;                    -- output write enable ram 
	 -- o_READ_PIX_ADDR: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr in image
	 -- o_WRITE_PIX_ADDR: OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
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
      i_SELECAO_RUIDO: IN  STD_LOGIC;                    -- seleciona entre os tipos de ruido
      o_NEXT         : OUT STD_LOGIC;                    -- data output continue
      o_READ_ENABLE  : OUT STD_LOGIC;                    -- output read enable in rom memory  
      o_WRITE_ENABLE : OUT STD_LOGIC;                    -- output write enable ram 
      o_ADDR         : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
      o_ADDR_GAUSS   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr gauss noise
      o_ADDR_SAL     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr sal noise
      o_PIXEL        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- data output
    );
  END component;
  
  component memoria_gauss IS
	PORT
	(
		address  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC; 
		rden		: IN STD_LOGIC;
		q		   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
  END component;
  
  component sal_e_pimenta IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC;
		rden		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
  END component;
  
  component memoria_entrada IS
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC;
		rden		: IN STD_LOGIC;
		q		   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
  END component;
  
  
  component memoria_saida IS
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
  END component;



  signal w_NEXT, w_RESET_CNT, w_INC_CONT, w_WRITE_ENA, w_READ_ENA, w_o_DP_READ_ENA, w_o_DP_WRITE_ENA :  STD_LOGIC;
  signal w_DATA_RUIDO_G, w_DATA_RUIDO_S, w_i_PIX, w_o_PIX : STD_LOGIC_VECTOR(7 DOWNTO 0); -- data 
  
  signal w_ADDR         : STD_LOGIC_VECTOR(19 DOWNTO 0);-- addr out image
  signal w_ADDR_GAUSS   : STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr gauss noise
  signal w_ADDR_SAL     : STD_LOGIC_VECTOR(7 DOWNTO 0); -- addr sal noise
  signal w_PIXEL        : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data output
  signal w_o_PIX_RAM    : STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data output from RAM (not used)

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

  u_DATAPATH : bloco_operacional PORT MAP (
    i_CLK          => i_CLK,
    i_CLR_N        => i_CLR_n,
    i_INC_ADDR     => w_INC_CONT,
    i_RESET        => w_RESET_CNT,
    i_DATA_IMG     => w_i_PIX,
    i_DATA_RUIDO_G => w_DATA_RUIDO_G,
    i_DATA_RUIDO_S => w_DATA_RUIDO_S,
    i_LIMIAR1      => i_LIMIAR1,
    i_LIMIAR2      => i_LIMIAR2,
    i_READ_ENABLE  => w_READ_ENA,
    i_WRITE_ENABLE => w_WRITE_ENA,
    i_SELECAO_RUIDO=> i_SELECAO_RUIDO,
    o_NEXT         => w_NEXT,
    o_READ_ENABLE  => w_o_DP_READ_ENA, 
    o_WRITE_ENABLE => w_o_DP_WRITE_ENA,
    o_ADDR         => w_ADDR,
    o_ADDR_GAUSS   => w_ADDR_GAUSS,
    o_ADDR_SAL     => w_ADDR_SAL,
    o_PIXEL        => w_PIXEL
  );

  u_MEMORIA_GAUSS : memoria_gauss PORT MAP (
    address => w_ADDR_GAUSS,
    clock	=> i_CLK,
    rden		=> w_o_DP_READ_ENA,
    q		   => w_DATA_RUIDO_G
  );
  
  u_MEMORIA_SAL_E_PIMENTA : sal_e_pimenta PORT MAP (
    address => w_ADDR_SAL,
    clock	=> i_CLK,
    rden		=> w_o_DP_READ_ENA,
    q		   => w_DATA_RUIDO_S
  );
  
  u_MEMORIA_ENTRADA : memoria_entrada PORT MAP (
    address		=> w_ADDR (15 downto 0),
    clock		=> i_CLK,
    rden		   => w_o_DP_READ_ENA,
    q		      => w_i_PIX
  );
  
  u_MEMORIA_SAIDA : memoria_saida PORT MAP (
    address		=> w_ADDR (15 downto 0),
    clock		=> i_CLK,
    data		   => w_PIXEL,
    wren		   => w_o_DP_WRITE_ENA,
    q		      => w_o_PIX_RAM
  );
  

END rtl;
