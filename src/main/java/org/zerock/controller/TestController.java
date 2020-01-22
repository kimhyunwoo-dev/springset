package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.zerock.domain.SampleDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/test/*")

public class TestController {

	@GetMapping("/ex01")
	public String ex04(SampleDTO dto , @ModelAttribute("page") int page) {
	
		log.info("dto : "+ dto);
		log.info("page : " + page);
		return "/ex01";
	}
}
