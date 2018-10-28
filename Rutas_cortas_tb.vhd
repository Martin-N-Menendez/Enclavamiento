library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity Rutas_cortas_tb is
end;

architecture Rutas_cortas_tb_arq of Rutas_cortas_tb is
	-- Parte declarativa
	component FSM_Belgrano is
		generic( N: natural := 12; N_SM: natural := 16 );
		port(
			Circuito_Via: in std_logic_vector(N-1 downto 0);
			clock,reset: in std_logic;
			--ruta: in integer; 
			ruta: in ruta_array;
			--Semaforos: out SEMAFORO;
			Semaforos: out std_logic_vector(N_SM-1 downto 0);
			Maquina: out std_logic;
			PaN: out std_logic
		);
	end component;
	
	constant N_tb: natural := 12;
	constant N_SM_tb: natural := 16;
	constant delay: time := 100 ns;
	
	signal Circuito_Via_tb: std_logic_vector(N_tb-1 downto 0) := (N_tb-1 downto 0 => '1');
	signal ruta_tb: ruta_array := (2-1 downto 0 => 0);
	signal clock_tb: std_logic := '0';
	signal reset_tb: std_logic := '0';
	--signal Semaforos_tb: SEMAFORO;
	signal Semaforos_tb: std_logic_vector(N_SM_tb-1 downto 0) := (N_SM_tb-1 downto 0 => '0');
	signal Maquina_tb: std_logic;
	signal PaN_tb: std_logic;
	
	type rutas is (RUTA0,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA12,RUTA13,RUTA14);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_A,SEM_B,SEM_C,SEM_D,SEM_E,SEM_F,SEM_G,SEM_H,SEM_I,SEM_J,SEM_K,SEM_L,SEM_M,SEM_N,SEM_O,SEM_P,SEM_Q);

	constant OCUPADO: std_logic := '0';
	constant LIBRE: std_logic := '1';
	--constant ROJO: SM_ESTADO := "00";		--  0
	--constant AMARILLO: SM_ESTADO := "01";	-- +1
	--constant VERDE: SM_ESTADO := "11";		-- -1
	constant ROJO: std_logic := '0';		--  0
	constant AMARILLO: std_logic := '1';	-- +1
	constant VERDE: std_logic := '1';		-- -1
	constant NORMAL: std_logic := '0';
	constant REVERSA: std_logic := '1';
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';
		
begin
	clock_tb <= not clock_tb after 10 ns;
	
	BOOTING: process
	begin
		wait for 10 ns;
		reset_tb <= '1';
		wait for 10 ns;
		reset_tb <= '0';
		wait for 5000 ns;
	end process BOOTING;
	
	CVS: process 
	begin
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC1)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC1)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC5)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC5)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC2)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC2)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC9)) <= OCUPADO;
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC9)) <= LIBRE;
		wait for 2000 ns;
	end process CVS;
	
	RUTAS_gen: process 
	begin
		wait for delay;
		ruta_tb(0) <= 1;
		wait for 3*delay;
		ruta_tb(0) <= 2;
		wait for 3*delay;
		ruta_tb(0) <= 0;
		ruta_tb(1) <= 3;
		wait for 3*delay;
		ruta_tb(1) <= 4;
		wait for 3*delay;
		ruta_tb(0) <= 5;
		ruta_tb(1) <= 5;
		wait for 3*delay;
		ruta_tb(0) <= 6;
		ruta_tb(1) <= 6;
		wait for 3*delay;
		ruta_tb(0) <= 0;
		ruta_tb(1) <= 0;
		wait for 2000 ns;
	end process RUTAS_gen;

	DUT: FSM_Belgrano
		port map(
			Circuito_Via => Circuito_Via_tb,
			ruta => ruta_tb,
			clock => clock_tb,
			reset => reset_tb,
			Semaforos => Semaforos_tb,
			Maquina => Maquina_tb,
			PaN => PaN_tb
		);
end;