<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	  <!-- Core CSS - Include with every page -->
    <link href="/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="/resources/font-awesome/css/font-awesome.css" rel="stylesheet">

    <!-- Page-Level Plugin CSS - Tables -->
    <!-- <link href="/resources/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet"> -->

    <!-- SB Admin CSS - Include with every page -->
    <link href="/resources/css/sb-admin.css" rel="stylesheet">
	 <link href="/resources/font-awesome/css/font-awesome.min.css" rel="stylesheet">
</head>
<body>

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Please Sign In</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" method="post" action="/login">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="userid" name="username" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Password" name="password" type="password" value="">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input name="remember-me" type="checkbox" value="Remember Me">Remember Me
                                    </label>
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>


	<%-- <h1>Custom Login Page</h1>
	<h2><c:out value="${error}"/></h2>
	<h2><c:out value="${logout}"/></h2>
	
	<form method="post" action="/login">
		<div>
			<input type="text" name="username" value="admin">
		</div>
		<div>
			<input type="password" name="password" value="admin">
		</div>
		<div>
			<input type="checkbox" name="remember-me"> Remember Me
		</div>
		<div>
			<input type="submit">
		</div>
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form> --%>
	    <!-- Core Scripts - Include with every page -->
  

    <script src="/resources/js/jquery-1.10.2.js"></script>
    <script src="/resources/js/bootstrap.min.js"></script>
    <script src="/resources/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/resources/js/sb-admin.js"></script>
	
	<script>
		$(".btn-success").on("click",function(e){
			e.preventDefault();
			$("form").submit();
		});
	</script>
</body>
</html>