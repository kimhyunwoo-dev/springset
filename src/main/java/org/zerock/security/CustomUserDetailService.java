package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;
import org.zerock.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailService implements UserDetailsService{

	@Setter(onMethod_ =@Autowired)
	private MemberMapper memberMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		
		log.warn("Load User by UserName :" + username );
		
		MemberVO vo= memberMapper.read(username);
		log.warn("queried by member mapper : " + vo);
	
		log.warn(" member vo : " + new CustomUser(vo) );
		return vo == null ? null : new CustomUser(vo);
	}

}
