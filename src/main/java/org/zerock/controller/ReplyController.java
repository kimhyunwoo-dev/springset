package org.zerock.controller;

import java.util.Date;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.domain.SampleDTO;
import org.zerock.service.ReplyPageDTO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {

	private ReplyService service;
	
	@GetMapping(value="/today" , produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,MediaType.APPLICATION_XML_VALUE})
	public Date getDate() {
		return new Date();		//json xml은 date타입을  날짜로 표기안하고, 값으로 표기함.
	}
	
	@PostMapping(value="/new", consumes="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){		//JSON 데이터로 요청 ReplyVO 로 변환.
		log.info("ReplyVO : " +  vo);
		
		int insertCount = service.register(vo);
		log.info("Reply Insert Count  : " +insertCount);		
		return insertCount ==1 ? new ResponseEntity<String>("success create",HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);

	}
	
	/*
	 * @GetMapping(value="/pages/{bno}/{page}" ,produces=
	 * {MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE})
	 * public ResponseEntity<List<ReplyVO>> getList(@PathVariable("bno") Long
	 * bno,@PathVariable("page") int page ){ log.info("getList......"); Criteria cri
	 * = new Criteria(page,10); log.info(cri); return new
	 * ResponseEntity<List<ReplyVO>>(service.getList(cri, bno),HttpStatus.OK); }
	 */
	
	@GetMapping(value="/pages/{bno}/{page}", produces= {MediaType.APPLICATION_ATOM_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable ("page") int page , @PathVariable ("bno") Long bno){
		Criteria cri = new Criteria(page, 10 );
		log.info("get Reply List bno : " + bno);
		log.info("cri  : " + cri);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListPage(cri, bno),HttpStatus.OK);
	} 
	
	@GetMapping(value="/{rno}", produces= {MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get : " + rno);
		return new ResponseEntity<ReplyVO>(service.get(rno),HttpStatus.OK);
		
	}

	@DeleteMapping(value="{rno}",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("remove : " + rno );
		
		return service.remove(rno)==1? new ResponseEntity<String>("success remove",HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@RequestMapping(method= {RequestMethod.PUT,RequestMethod.PATCH},
			value="/{rno}",
			consumes="application/json",
			produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){		
		//RequestBody json 데이터로 온것을 ReplyVO로 컨버트. pathVariable url을 파라미터로 수집  consumes application/json은 json데이터를 쓰겠다.
		//produces mediatType은 이것으로 리턴한다. value="/{rno}" url이 이것으로 맵핑되어있음을 의미.
		log.info("vo : " + vo);
		vo.setRno(rno);
		//log.info("rno : " + rno);
		log.info("vo : " + vo);
		
		return service.modify(vo)==1 ? new ResponseEntity<String>("success" , HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	


}
