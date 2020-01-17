package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
//	@Test
//	public void testInsert() {
//		BoardVO board = new BoardVO();
//		board.setTitle("새로 작성하는 글");
//		board.setContent("새로 작성하는 내용");
//		board.setWriter("newBie");
//		mapper.insert(board);
//		
//		log.info("testInsert@@@@@ :  " +board);
//		
//	}
	
	/*
	 * @Test public void testInsertSelectKey() { BoardVO board = new BoardVO();
	 * board.setTitle("새로 작성하는 글 Select Key");
	 * board.setContent("새로 작성하는 내용 Select key"); board.setWriter("newBie");
	 * mapper.insertSelectKey(board);
	 * 
	 * log.info("testInsertSelectKey@@@@@ :  " +board); }
	 */	
//	@Test
//	public void TestRead() {
//		BoardVO board = mapper.read(5l);
//		log.info(board);
//	}
//	@Test
//	public void testDelete() {
//		log.info("DELETE COUNT : " + mapper.delete(3l));
//	}
//	@Test 
//	public void testUpdate() {
//		BoardVO board = new BoardVO();
//		board.setBno(5l);
//		board.setTitle("수정된 제목");
//		board.setContent("수정된 내용");
//		board.setWriter("user00");
//		int count  = mapper.update(board);
//		log.info("UPDATE COUNT : " + count);
//		
//	}
//	
	
	/*
	 * @Test public void testGetList() { mapper.getList().forEach(board ->
	 * log.info(board)); }
	 */
//	@Test
//	public void testPaging() {
//		Criteria cri =new Criteria();
//		cri.setPageNum(2);				
//		cri.setAmount(100);	//61~ 90 				
//		List<BoardVO> list = mapper.getListWithPaging(cri);
//		list.forEach(action-> log.info(action + " : " +action.getBno()));
//		
//	}

	@Test
	public void testSearch() {
		Criteria cri = new Criteria();
		cri.setKeyword("hh");
		cri.setType("TC");
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(action->log.info(action));
	}
}
