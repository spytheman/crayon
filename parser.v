module crayon

import strconv

fn parse(text string, index int) string {
	start_index := text.index_after("{", index)
	mut end_index := text.index_after("}", start_index)
	
	if start_index >= 0 && end_index > 0 {
		count := num_of_chars(text.substr(end_index, text.len), `}`)
		if count > 1 {end_index += count - 1}

		template := text.substr(start_index + 1, end_index)
		if template.len <= 0 {
			return parse(text, end_index) //move on
		}
		styles := template.substr(0, template.index(" ")).split(".")
		str := template.substr(template.index(" ") + 1, template.len)

		mut c := new(str)
		fg := fg_colors.keys()
		bg := bg_colors.keys() 
		st := style.keys()
		for _, s in styles {
			if s in fg {
				c = c.colorize(s)
			} else if s in bg {
				c = c.bg_colorize(s)
			} else if s in st{
				c = c.stylize(s)
			} else if s.starts_with("rgb(") || s.starts_with("bg_rgb("){
				tag := s.substr(0, s.index("("))
				r,g,b := parse_rgb(s, tag)
				if r < 0 || g < 0 || b < 0 {
					println("Wrong number of arguments in call to '$tag(int,int,int)'")
					break
				}
				c = if tag == "rgb" {c.rgb(r, g, b)} else if tag == "bg_rgb" {c.bg_rgb(r, g, b)} else {c}
			} else {
				println("Wrong style specified: $s")
				break
			}
		}
		next_index := text.last_index(reset)
		return parse(text.replace(text.substr(start_index, end_index + 1), c.str()), next_index)
	}
	return text
}

fn num_of_chars(text string, c byte) int {
	mut i := 0
	for t in text {
		if t == c {
			i++
		} else {break}
	}
	return i
}

fn parse_rgb(s string, name string) (int,int,int){
	clrs := s.replace("$name(", "").replace(")", "").split(",")
	if clrs.len != 3 {
		return -1,-1,-1
	}
	r := strconv.atoi(clrs[0])
	g := strconv.atoi(clrs[1])
	b := strconv.atoi(clrs[2])
	return r,g,b
}