package org.zerock.domain;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@Getter
public class ReplyPageDTO {

	private int replyCnt;
	private List<ReplyVO> list;
	private Map<String,Object> map= new HashMap<String, Object>();

	
	public ReplyPageDTO(int replyCnt, List<ReplyVO> list, int pageNum){
		System.out.println(replyCnt+"!!!!!!!!!");
		
		this.list= list;
		this.replyCnt = replyCnt;
		int endPage = (int)(Math.ceil(pageNum / 10.0))*10;
		int startPage = endPage -9;
										//12.3    
		int realEnd = (int)(Math.ceil(replyCnt/10.0));
		System.out.println(realEnd);
		if(realEnd < endPage) {
			endPage = realEnd;
		}
		
		boolean previous = startPage != 1;
		boolean next = endPage < realEnd;
		
		
		this.map.put("replyCnt",replyCnt);
		this.map.put("pageNum",pageNum);
		this.map.put("startPage",startPage);
		this.map.put("endPage",endPage);
		this.map.put("realEnd",realEnd);
		this.map.put("next",next);
		this.map.put("previous",previous);

		
	}
	
}
