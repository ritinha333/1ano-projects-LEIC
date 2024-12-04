transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/ritam/OneDrive/Ambiente de Trabalho/LEIC 2 ANO/2semestre/LIC/LSD/test/tests.vhd}

