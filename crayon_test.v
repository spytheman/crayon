import crayon

fn test_template(){
	assert crayon.color("{bold Hello world}") == "\e[1mHello world\e[0m"
	assert crayon.color("{bold.cyan Hello world}") == "\e[36;1mHello world\e[0m"
	assert crayon.color("{bold.cyan.reverse Hello world}") == "\e[36;1;7mHello world\e[0m"
	assert crayon.color("{bold Hello world} {red.reverse Hello again}") == "\e[36;1;7mHello world\e[0m \e[31;7mHello again\e[0m"
	assert crayon.color("{}") == "{}"
	assert crayon.color("{{{{bold Hello world}}}}") == "\e[1m{{{Hello world}}}\e[0m"
	assert crayon.color("{rgb(10,10,10) Hello world}") == "\e[38;2;10;10;10mHello world\e[0m"
}