library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity Semaforo_tb is
end;

architecture Semaforo_arq of Semaforo_tb is
	-- Parte declarativa
	component FSM_Belgrano is
		generic( N: natural := 12 );
		port(
			Circuito_Via: in std_logic_vector(N-1 downto 0);
			clock,reset: in std_logic;
			ruta: in integer; 
			Semaforos: out SEMAFORO;
			Maquina: out std_logic;
			PaN: out std_logic
		);
	end component;
	
	constant N_tb: natural := 12;
	constant N_SM_tb: natural := 16;
	constant delay: time := 50 ns;
	
	signal Circuito_Via_tb: std_logic_vector(N_tb-1 downto 0) := (N_tb-1 downto 0 => '1');
	signal ruta_tb: integer := 0;
	signal clock_tb: std_logic := '0';
	signal reset_tb: std_logic := '0';
	signal Semaforos_tb: SEMAFORO;
	signal Maquina_tb: std_logic;
	signal PaN_tb: std_logic;
	
	type rutas is (RUTA0,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA12,RUTA13,RUTA14);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_A,SEM_B,SEM_C,SEM_D,SEM_E,SEM_F,SEM_G,SEM_H,SEM_I,SEM_J,SEM_K,SEM_L,SEM_M,SEM_N,SEM_O,SEM_P,SEM_Q);

	constant OCUPADO: std_logic := '0';
	constant LIBRE: std_logic := '1';
	constant ROJO: SM_ESTADO := "00";		--  0
	constant AMARILLO: SM_ESTADO := "01";	-- +1
	constant VERDE: SM_ESTADO := "11";		-- -1
	constant NORMAL: std_logic := '0';
	constant REVERSA: std_logic := '1';
	constant BARRERA_BAJA: std_logic := '0';
	constant BARRERA_ALTA: std_logic := '1';
	
begin
	clock_tb <= not clock_tb after 10 ns;
	reset_tb <= '1' after 5000 ns;
	
	RUTAS_gen: process 
	begin
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_A)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_A)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_B)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_B)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_C)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_C)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_D)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_D)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_E)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_E)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_F)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_F)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_G)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_G)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_H)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_H)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_I)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_I)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_J)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_J)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_K)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_K)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_L)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_L)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_M)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_M)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_N)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_N)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_O)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_O)) <= ROJO;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_P)) <= VERDE;
		wait for delay;
		Semaforos_tb(semaforos_t'pos(SEM_P)) <= ROJO;
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