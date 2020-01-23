package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;
	private int endPage;
	private boolean prev,next;
	
	private int total;
	private Criteria cri;
	
	//startEnd 계산 - > 
	//realEnd 계산    - > 123개의 글  페이지당 보여주기로 한 갯수    123 *1.0  -> 총갯수/총 보여주기로한 갯수  123.0 / 10 - > 12.3  거기서 ceil함수를 쓰면 그럼 진짜 끝나야할 페이지는 13페이지가됨.
	//endPage 계산    - > 컨트롤러에서 요청한 페이지넘  cri.getPageNum()  예를들어 5면   5/10.0  ceil(0.5)  ->  1 *10  - > 그럼 endPage는 10페이지까지 
	// 그런데 endPage가 만약 realEnd보다 크다 그러면 endPage는 realEnd가 되야함.	예를들어 지금 endPage가 20인데 realEnd가 13이면 EndPage는 20 이어야
	
	//startPage는 endPage에서 무조건 -9
	//prev	startPage가 >1보다 크면   무조건 prev    논리적으로   1 11 21 31 로 갈것이기 때문.   
	//next   endPage보다 realEnd가 더 크면    20/13   계속 prev할수있다.
	
	public PageDTO(Criteria cri , int total) {
		this.cri = cri;
		this.total=total;
		
		this.endPage= (int)(Math.ceil(cri.getPageNum()/10.0))*10;										
		this.startPage = this.endPage-9;								
		int realEnd = (int)(Math.ceil(total*1.0/cri.getAmount()));  	
		if(this.endPage > realEnd) {	//16 < 20									
			this.endPage = realEnd;										
			
		}
		
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
		
	}
	
}
