package org.zerock.service;

import java.util.List;

import org.zerock.domain.ReplyVO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO {

	private int replyCnt;
	private List<ReplyVO> list;
}
