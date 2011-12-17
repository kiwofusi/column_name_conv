=begin
start:1854
end:1915(21m)
end:1925(31m) リファクタリング＆バグ修正

26**0 => 1
A=>1
AA=> (26**1 * 1) + (26**0 * 1)
BA=> (26**1 * 2) + (26**0 * 1)
BB=> (26**1 * 2) + (26**0 * 2)
AAA=> (26**2 * 1) + (26**1 * 1) + (26**0 * 1)
XFD=> (26**2 * 24) + (26**1 * 6) + (26**0 * 4) => 16384
=end

column_name = ARGV[0]
result = 0
column_name.split(//).reverse.each_with_index do |char, place| # split忘れず！
	num_of = {'A'=>1, 'B'=>2, 'C'=>3, 'D'=>4, 'E'=>5, 'F'=>6, 'G'=>7, 'H'=>8, 'I'=>9, 'J'=>10, 'K'=>11, 'L'=>12, 'M'=>13, 'N'=>14, 'O'=>15, 'P'=>16, 'Q'=>17, 'R'=>18, 'S'=>19, 'T'=>20, 'U'=>21, 'V'=>22, 'W'=>23, 'X'=>24, 'Y'=>25, 'Z'=>26} # num_table.size のおかげでタイプミスに気づいた（UがNだった）
	result += (num_of.size**place) * num_of[char]
end
puts result