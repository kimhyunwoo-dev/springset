<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>/sample/admin page</h1>
<!-- 
	private String password;
	private final String username;
	private final Set<GrantedAuthority> authorities;
 -->

<p>principal : <sec:authentication property="principal"/></p>
<p>사용자아이디 : <sec:authentication property="principal.username"/></p>
<p>MemberVO : <sec:authentication property="principal.member"/></p>
<!-- 패스워드는 protected -->
<p>사용자 패스워드 : <sec:authentication property="principal.password"/></p>	
<!-- Authorities -->
<p>사용자 권한 리스트 : <sec:authentication property="principal.authorities"/></p>




<a href="/customLogout">Logout</a>

</body>
</html>