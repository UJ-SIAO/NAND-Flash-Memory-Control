onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test/top/clk
add wave -noupdate /test/top/rst
add wave -noupdate /test/top/F_CLE_B
add wave -noupdate /test/top/F_WEN_B
add wave -noupdate /test/top/F_ALE_B
add wave -noupdate /test/top/F_REN_B
add wave -noupdate /test/top/F_IO_B
add wave -noupdate /test/top/F_OUT_B
add wave -noupdate /test/top/F_RB_B
add wave -noupdate /test/top/conter_B
add wave -noupdate /test/top/recive_data_cnt_B
add wave -noupdate /test/top/conter_B__initi
add wave -noupdate -expand /test/top/recive_data
add wave -noupdate -radix unsigned /test/top/recive_data_cnt
add wave -noupdate /test/top/conter_initi
add wave -noupdate /test/top/conter
add wave -noupdate /test/top/done
add wave -noupdate /test/top/isout_A
add wave -noupdate /test/top/isout_B
add wave -noupdate /test/top/F_CLE_A
add wave -noupdate /test/top/F_WEN_A
add wave -noupdate /test/top/F_ALE_A
add wave -noupdate /test/top/F_REN_A
add wave -noupdate /test/top/F_IO_A
add wave -noupdate /test/top/F_OUT_A
add wave -noupdate /test/top/F_RB_A
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1775400 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2747 ns} {3402800 ps}
