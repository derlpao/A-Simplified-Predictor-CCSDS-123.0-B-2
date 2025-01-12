----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/10/01 18:45:43
-- Design Name: 
-- Module Name: axis_header_add - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: （1）下行数据包头中的2711总包计数未添加，后面模块添加。（三路图像数据同时向2711发送，乱序发送，以防止
--        阻塞其他通路，对压缩模块产生影响）
--        （2）增加备份2711 ID号配置
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cmps_out_new is
  port (
    --
    clk : in std_logic;
    rst : in std_logic;--@clk


    w_en        : in  std_logic;
    w_data      : in  std_logic_vector(63 downto 0);
    eob         : in  std_logic;
    byte_cnt    : in  std_logic_vector(30 downto 0);  
    quant_near_i: in  std_logic_vector(7 downto 0);   
    wfifo_ready : out std_logic;             
    --hd_rst : in std_logic;
    --
  --  slv_reg_wr_val      : in  std_logic_vector(2  downto 0);
  --  slv_reg0_wr         : in  std_logic_vector(31 downto 0);
  --  slv_reg1_wr         : in  std_logic_vector(31 downto 0);
  --slv_reg2_wr         : in  std_logic_vector(31 downto 0);  
  --  slv_reg0_rd         : out std_logic_vector(31 downto 0);
  --  slv_reg1_rd         : out std_logic_vector(31 downto 0);
  --slv_reg2_rd         : out std_logic_vector(31 downto 0);
  --
 
    --    
    xc_tdata          : out std_logic_vector(63 downto 0);--xc = 下层
    xc_tkeep          : out std_logic_vector(7  downto 0);
    xc_tvalid         : out std_logic;
    xc_tlast          : out std_logic;
    xc_tready         : in std_logic
  );
end cmps_out_new;

architecture Behavioral of cmps_out_new is

  --备用数据
  signal reserve_byte     : std_logic_vector (31 downto 0);
  --
  -- type state_type is (
  --   st_idle,                     --等待上层来包 
  --   st_header_1beat,             --添加head的第1个beat 
  --   st_header_2beat,             --添加head的第2个beat 
  --   st_header_3beat,             --添加head的第3个beat
  --   st_header_4beat
  --   st_forward_sc                --发送上层的数据
  -- );
  type state_type is (st_idle,st_header_1beat,st_forward_sc,st_forward_end,st_tail_1beat,st_end);
  signal state, next_state : state_type;

  signal sc_data_ready_int : std_logic;

  signal xc_tdata_int  : std_logic_vector(63 downto 0);--xc = 下层            
  signal xc_tkeep_int  : std_logic_vector(7 downto 0);
  signal xc_tvalid_int : std_logic;
  signal xc_tlast_int  : std_logic;

  signal sc_tdata          :  std_logic_vector(103 downto 0);
  signal sc_tkeep          :  std_logic_vector(12  downto 0);

  signal sc_tvalid         :  std_logic;
  signal sc_tlast          :  std_logic;
  signal sc_tready         :  std_logic;


 

  attribute MARK_DEBUG          : string;
  attribute MARK_DEBUG of state : signal is "TRUE";

  COMPONENT axis_data_fifo_out
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(103 DOWNTO 0);
    s_axis_tkeep : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(103 DOWNTO 0);
    m_axis_tkeep : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC
  );
  END COMPONENT;

  signal s_axis_tdata : std_logic_vector(103 downto 0);
  signal s_axis_tkeep : std_logic_vector(12 downto 0);
  signal s_axis_tlast : std_logic;
  signal s_axis_tvalid : std_logic;
  signal prog_full : std_logic;
  signal s_axis_aresetn : std_logic;
  signal tail_cnt  : std_logic_vector(30 downto 0);

begin

s_axis_tdata <=quant_near_i &'0'&byte_cnt&w_data;
s_axis_tkeep <= '1'&x"FFF";
s_axis_tlast <= eob;
s_axis_tvalid<= w_en;
wfifo_ready  <= not prog_full;
s_axis_aresetn <=not rst;
axis_data_fifo_out_inst : axis_data_fifo_out
  PORT MAP (
    s_axis_aresetn =>  s_axis_aresetn,
    s_axis_aclk => clk,
    s_axis_tvalid => s_axis_tvalid,
    s_axis_tready => open,
    s_axis_tdata =>  s_axis_tdata,
    s_axis_tkeep =>  s_axis_tkeep,
    s_axis_tlast =>  s_axis_tlast,
    m_axis_tvalid => sc_tvalid,
    m_axis_tready => sc_tready,
    m_axis_tdata =>  sc_tdata,
    m_axis_tkeep =>  sc_tkeep,
    m_axis_tlast =>  sc_tlast,
    prog_full => prog_full
  );
 

  --Image_Frame_Sub_Cnt   <= sc_tuser(47 downto 32);
  --------------------------------------------------    
  --  添加帧头
  --------------------------------------------------                         

  sc_tready <= sc_data_ready_int;

  sc_data_ready_int <=  ((not xc_tvalid_int) or (xc_tvalid_int and xc_tready)) when (state = st_forward_sc) else
                        '0';

  xc_tdata  <= xc_tdata_int;
  xc_tkeep  <= xc_tkeep_int;
  xc_tvalid <= xc_tvalid_int;
  xc_tlast  <= xc_tlast_int;

  --状态机
  process (clk, rst)
  begin
    if rst = '1' then
      state <= st_idle;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  process (state, xc_tready, xc_tvalid_int, sc_data_ready_int, sc_tvalid, sc_tlast,xc_tlast_int)
  begin
    case state is
      --
      when st_idle =>
        if sc_tvalid = '1' then
          next_state <= st_header_1beat;
        else
          next_state <= state;
        end if;
      --
      when st_header_1beat =>
        if xc_tready = '1' and xc_tvalid_int = '1' then
          next_state <= st_forward_sc;
        else
          next_state <= state;
        end if;
      --
      --when st_header_2beat => --使能head的第1个beat
      --  if xc_tready = '1' and xc_tvalid_int = '1' then
      --    next_state <= st_header_3beat;
      --  else
      --    next_state <= state;
      --  end if;
      --
      --when st_header_3beat => --使能head的第3个beat
      --  if xc_tready = '1' and xc_tvalid_int = '1' then
      --    next_state <= st_header_4beat;
      --  else
      --    next_state <= state;
      --  end if;
      --when st_header_4beat => --使能head的第4个beat
      --  if xc_tready = '1' and xc_tvalid_int = '1' then
      --    next_state <= st_forward_sc;
      --  else
      --    next_state <= state;
      --  end if;
      --  
      when st_forward_sc =>
        if sc_data_ready_int = '1' and sc_tvalid = '1' and sc_tlast = '1' then
          next_state <= st_forward_end;
        else
          next_state <= state;
        end if;
      
      when st_forward_end => --上级stream包发送完成
        if(xc_tready = '1' and xc_tvalid_int = '1')then
          next_state <= st_tail_1beat;
        else
          next_state <= state;
        end if;      
      when st_tail_1beat => --发送子帧当前阶段标志
        if(xc_tready = '1' and xc_tvalid_int = '1')then
          next_state <= st_end;
        else
          next_state <= state;
        end if;
      
      when st_end =>  --发送一帧结束 
         next_state <= st_idle; 
      --  
      when others =>
        next_state <= st_idle;
    end case;
  end process;

  --下层输出

  process (clk, rst)
  begin
    if rst = '1' then
      xc_tdata_int      <= (others => '0');
      xc_tkeep_int    <= (others => '0');
      tail_cnt          <=(others => '0');
    elsif (clk'event and clk = '1') then
      if next_state = st_header_1beat then
        xc_tdata_int    <= x"FFFFFFF0"&x"000000"&sc_tdata(103 downto 96);
        xc_tkeep_int  <= x"ff";
        tail_cnt      <= tail_cnt;
      elsif state = st_forward_sc and sc_data_ready_int = '1' then
        xc_tdata_int <= sc_tdata(63 downto 0);
        xc_tkeep_int <= sc_tkeep(7 downto 0);
        tail_cnt     <= sc_tdata(94 downto 64);
      elsif (state = st_forward_end and next_state = st_tail_1beat) then
        xc_tdata_int <= '0'&tail_cnt&x"FFEEDDC9";
        xc_tkeep_int <= sc_tkeep(7 downto 0);
        tail_cnt      <= tail_cnt;
      else 
        xc_tdata_int <= xc_tdata_int;
        xc_tkeep_int <= xc_tkeep_int;
        tail_cnt      <= tail_cnt;
      end if;
    end if;
  end process;



  process (clk, rst)
  begin
      if rst = '1' then
        xc_tvalid_int <= '0';
      elsif (clk'event and clk = '1') then
        if state = st_idle then
            xc_tvalid_int <= '0';
        elsif (next_state = st_header_1beat)then
            xc_tvalid_int <= '1';
        elsif state = st_header_1beat and next_state = st_forward_sc then
            xc_tvalid_int <= '0';
        elsif (state = st_forward_sc and sc_data_ready_int = '1') then
            xc_tvalid_int <= sc_tvalid;
        elsif(state = st_forward_end and next_state = st_tail_1beat)then
            xc_tvalid_int <= '1';
        elsif(state = st_tail_1beat and next_state = st_end)then
            xc_tvalid_int <= '0';  
        else  
            xc_tvalid_int <= xc_tvalid_int;
        end if;
      end if;
  end process;

  --process (clk, rst)
  --begin
  --  if rst = '1' then
  --    xc_tlast_int <= '0';
  --  elsif (clk'event and clk = '1') then
  --    if state = st_forward_sc and sc_data_ready_int = '1' then
  --      xc_tlast_int <= sc_tlast;
  --    elsif state = st_forward_end and xc_tvalid_int = '1' and xc_tready = '1' then
  --      xc_tlast_int <= '0';
  --    end if;
  --  end if;
  --end process;

    process (clk, rst)
  begin
    if rst = '1' then
      xc_tlast_int <= '0';
    elsif (clk'event and clk = '1') then
      if state = st_forward_end and next_state = st_tail_1beat then
        xc_tlast_int <= '1';
      elsif state = st_tail_1beat and next_state = st_end then
        xc_tlast_int <= '0';
      end if;
    end if;
  end process;
end Behavioral;
