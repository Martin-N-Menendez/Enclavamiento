library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.semaforo_tipo.all;

entity Automatico_tb is
end;

architecture Automatico_tb_arq of Automatico_tb is
	-- Parte declarativa
	component FSM_Belgrano is
		generic( N_CV: natural := 12; N_SM: natural := 11; N_PaN: natural := 3; N_rutas: natural := 13 );
	port(
		Clock,Reset: in std_logic;
		Ruta: in ruta_array;
		Modo: in std_logic;
		Circuito_Via: in std_logic_vector(N_CV-1 downto 0);	
		Semaforos_in: in std_logic_vector(N_SM-1 downto 0);
		Maquina_N: in std_logic;
		Maquina_R: in std_logic;
		PaN_Bajo: in std_logic_vector(N_PaN-1 downto 0);
		PaN_Alto: in std_logic_vector(N_PaN-1 downto 0);
		--Semaforos: out SEMAFORO;
		Semaforos: out std_logic_vector(N_SM-1 downto 0);
		Maquina: out std_logic;
		PaN: out std_logic_vector(N_PaN-1 downto 0)
	);
	end component;
	
	constant N_CV_tb: natural := 12;
	constant N_SM_tb: natural := 11;
	constant N_PaN_tb: natural := 3;
	constant delay: time := 100 ns;
	-- Entradas
	signal Clock_tb: std_logic := '0';
	signal Reset_tb: std_logic := '0';
	signal Ruta_tb: ruta_array := (2-1 downto 0 => 0);
	signal Modo_tb: std_logic := '1';
	signal Circuito_Via_tb: std_logic_vector(N_CV_tb-1 downto 0) := (N_CV_tb-1 downto 0 => '1');
	signal Semaforos_in_tb: std_logic_vector(N_SM_tb-1 downto 0) := (N_SM_tb-1 downto 0 => '0');	
	signal Maquina_N_tb: std_logic := '1';
	signal Maquina_R_tb: std_logic := '0';
	signal PaN_Bajo_tb: std_logic_vector(N_PaN_tb-1 downto 0) := (N_PaN_tb-1 downto 0 => '1');
	signal PaN_Alto_tb: std_logic_vector(N_PaN_tb-1 downto 0) := (N_PaN_tb-1 downto 0 => '0');
	-- Salidas
	signal Semaforos_tb: std_logic_vector(N_SM_tb-1 downto 0);	
	signal Maquina_tb: std_logic;
	signal PaN_tb: std_logic_vector(N_PaN_tb-1 downto 0);
	
	--signal Semaforos_tb: SEMAFORO;
	type rutas is (RUTA_RESET,RUTA1,RUTA2,RUTA3,RUTA4,RUTA5,RUTA6,RUTA7,RUTA8,RUTA9,RUTA10,RUTA11,RUTA_0ASC,RUTA_0DES);
	type rutas_asc is (ASC_0,ASC_1,ASC_2,ASC_3,ASC_4,ASC_5,ASC_10,ASC_11,ASC_RESET);
	type rutas_des is (DES_0,DES_6,DES_7,DES_8,DES_9,DES_10,DES_11,DES_RESET);
	type circuitos_t is (CIRC1,CIRC2,CIRC3,CIRC4,CIRC5,CIRC6,CIRC7,CIRC8,CIRC9,CIRC10,CIRC11,CIRC12);
	type semaforos_t is (SEM_1,SEM_2,SEM_3,SEM_4,SEM_5,SEM_6,SEM_7,SEM_8,SEM_9,SEM_10,SEM_11);
	type sem_asc_t is (SEM_1,SEM_3,SEM_5,SEM_7,SEM_9,SEM_10);
	type sem_des_t is (SEM_2,SEM_4,SEM_6,SEM_8,SEM_11);

	constant SEMIAUTOMATICO: std_logic := '0';
	constant AUTOMATICO: std_logic := '1';
	
	constant ASCENDENTES: integer:= 0;
	constant DESCENDENTES: integer := 1;
	
	constant PAMPA: integer:= 0;
	constant ECHEVERRIA: integer := 1;
	constant JURAMENTO: integer := 2;
	
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
	Clock_tb <= not Clock_tb after 10 ns;
	
	Maquina_N_tb <= Maquina_tb;
	Maquina_R_tb <= not Maquina_tb;
		
	PaN_Bajo_tb(PAMPA) <= PaN_tb(PAMPA);
	PaN_Alto_tb(PAMPA) <= not PaN_tb(PAMPA);
	
	PaN_Bajo_tb(ECHEVERRIA) <= PaN_tb(ECHEVERRIA);
	PaN_Alto_tb(ECHEVERRIA) <= not PaN_tb(ECHEVERRIA);
	
	PaN_Bajo_tb(JURAMENTO) <= PaN_tb(JURAMENTO);
	PaN_Alto_tb(JURAMENTO) <= not PaN_tb(JURAMENTO);
	
	Semaforos_in_tb(semaforos_t'pos(SEM_1)) <= Semaforos_tb(semaforos_t'pos(SEM_1));
	Semaforos_in_tb(semaforos_t'pos(SEM_2)) <= Semaforos_tb(semaforos_t'pos(SEM_2));
	Semaforos_in_tb(semaforos_t'pos(SEM_3)) <= Semaforos_tb(semaforos_t'pos(SEM_3));
	Semaforos_in_tb(semaforos_t'pos(SEM_4)) <= Semaforos_tb(semaforos_t'pos(SEM_4));
	Semaforos_in_tb(semaforos_t'pos(SEM_5)) <= Semaforos_tb(semaforos_t'pos(SEM_5));
	Semaforos_in_tb(semaforos_t'pos(SEM_6)) <= Semaforos_tb(semaforos_t'pos(SEM_6));
	Semaforos_in_tb(semaforos_t'pos(SEM_7)) <= Semaforos_tb(semaforos_t'pos(SEM_7));
	Semaforos_in_tb(semaforos_t'pos(SEM_8)) <= Semaforos_tb(semaforos_t'pos(SEM_8));
	Semaforos_in_tb(semaforos_t'pos(SEM_9)) <= Semaforos_tb(semaforos_t'pos(SEM_9));
	Semaforos_in_tb(semaforos_t'pos(SEM_10)) <= Semaforos_tb(semaforos_t'pos(SEM_10));
	Semaforos_in_tb(semaforos_t'pos(SEM_11)) <= Semaforos_tb(semaforos_t'pos(SEM_11));
	
	BOOTING: process
	begin
		wait for 10 ns;
		Reset_tb <= '1';
		wait for 10 ns;
		Reset_tb <= '0';
		wait for 5500 ns;
	end process BOOTING;
	
	CVS: process 
	begin
		wait for delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC1)) <= OCUPADO;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC3)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC1)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC5)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC3)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC7)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC5)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC9)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC7)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC11)) <= OCUPADO;		
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC9)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC11)) <= LIBRE;
		wait for 5*delay;
		
		Circuito_Via_tb(circuitos_t'pos(CIRC12)) <= OCUPADO;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC10)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC12)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC10)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC6)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC8)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC4)) <= OCUPADO;	
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC6)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC2)) <= OCUPADO;		
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC4)) <= LIBRE;
		wait for 2*delay;
		Circuito_Via_tb(circuitos_t'pos(CIRC2)) <= LIBRE;
		wait for 2000 ns;
	end process CVS;
	
	
	DUT: FSM_Belgrano
		port map(
			Clock => Clock_tb,
			Reset => Reset_tb,
			Ruta => Ruta_tb,
			Modo => Modo_tb,
			Circuito_Via => Circuito_Via_tb,
			Semaforos_in => Semaforos_in_tb,
			Maquina_N => Maquina_N_tb,
			Maquina_R => Maquina_R_tb,
			PaN_Bajo => PaN_Bajo_tb,
			PaN_Alto => PaN_Alto_tb,
			Semaforos => Semaforos_tb,
			Maquina => Maquina_tb,
			PaN => PaN_tb
		);
end;