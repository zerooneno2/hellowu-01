package kr.co.hellowu.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class ViewsController {
	
	@GetMapping("/")
	public String goHome() {
		return "/views/index";
	}
	
	@GetMapping("/views/**")
	public String goJsp(HttpServletRequest request) {
		
		return request.getRequestURI();
	}
	
	
}
