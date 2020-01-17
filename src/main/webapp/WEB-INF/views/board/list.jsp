<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>

<!DOCTYPE html>
<html>
<head>
</head>
<body>

	
			<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                          Board List page
                          <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>작성일</th>
                                            <th>수정일</th>
                                        </tr>
                                    </thead>
                            		<c:forEach var="board" items="${list}">
                            			<tr>
                            				<td><c:out value="${board.bno}"></c:out></td>
                            				<td><a class="move" href='<c:out value="${board.bno}"/>'><c:out value="${board.title}"></c:out></a></td>
                            				<td><c:out value="${board.writer}"></c:out></td>
                            				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                            				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}"/></td>
                            		
                            			</tr>
                            		</c:forEach>      
                                </table>
                                  <div class='row'>
                               		 <div class="col-lg-6">
                               		 	<div class="pull-left">	
                               		 		<!-- 검색처리시 동작할 폼태그 -->
			                                <form id="searchForm" action="/board/list" method="get">
			                                	<select name="type">
			                                		<option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/> >제목</option>
			                                		<option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
			                                		<option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
			                                		<option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목+내용</option>
			                                		<option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/>>제목+작성자</option>
			                                		<option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ''}"/>>제목+내용+작성자</option>
			                                	</select>
			                                	<input type="text" name="keyword">
			                                	<input type="hidden" name="pageNum" value=${pageMaker.cri.pageNum }>
			                                	<input type="hidden" name="amount" value=${pageMaker.cri.amount }>
			                                	<button class="btn btn-default">Search</button>
			                                </form>
		                                </div>
	                                </div>
	                                <div class="col-lg-6">
		                                <div class="pull-right">
		                                	<ul class="pagination">
		                                		<c:if test="${pageMaker.prev}">
		                                			<li class="paginate_button previous"><a href="${pageMaker.startPage - 1 }">Previous</a></li>
		                                		</c:if>
			                                	<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
			                                		<li class="paginate_button ${pageMaker.cri.pageNum==num ? "active":""}"><a href="${num}">${num}</a></li>
			                                	</c:forEach>
			                                	<c:if test="${pageMaker.next }">
			                                		<li class="paginate_button next"><a href="${pageMaker.endPage+1}">Next</a></li>
			                                	</c:if>
		                                	</ul>
	                                	</div>
                                	</div>
                                </div>
                                
                            	<!-- 페이징 처리시 동작할 actionForm -->
                                <form id="actionForm" action="/board/list" method="get">
		                           <input type="text" name="pageNum" value=${pageMaker.cri.pageNum }>
		                           <input type="text" name="amount" value=${pageMaker.cri.amount }>
		                           <input type="text" name="type" value="${pageMaker.cri.type }">
			                       <input type="text" name="keyword" value="${pageMaker.cri.keyword }">
		                         </form>
		                         
		                         
                                 <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                        </div>
                                        <div class="modal-body">
                                        	처리가 완료되었습니다.  
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            <button type="button" class="btn btn-primary">Save changes</button>
                                        </div>
                                    </div>
                                    <!-- /.modal-content -->
                                </div>
                                <!-- /.modal-dialog -->
                            </div>
                            <!-- /.modal -->
                            </div>
                 			
                     
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->

            
       
        </div>
        <!-- /#page-wrapper -->
	<%@include file="../includes/footer.jsp" %>
	
	<script type="text/javascript">
		$(document).ready(function(){
			var result='<c:out value="${result}"/>';

			checkModal(result);
			history.replaceState({},null,null);
			
			
			/* 처리결과가 있을때 (result 변수에 값이 있을때) 모달창띄움  */
			function checkModal(result){
				if(result==='' || history.state){
					return;
				}
				if(parseInt(result)>0){
					$(".modal-body").html("게시글 " + parseInt(result)+ " 번이 등록되었습니다.");
				}
				$("#myModal").modal("show");
			}
			
			/*등록버튼 부분 */
			$("#regBtn").on("click",function(){
				self.location="/board/register";
			});
			
			var actionForm= $("#actionForm");
			
			$(".paginate_button a").on("click",function(e){
				e.preventDefault();
				console.log("click");
				actionForm.find("input[name='pageNum']").val($(this).attr("href"));
				actionForm.submit();
				
			});
			
			/* title 제목을 클릭했을 시에 작동하는 이벤트.  a태그로 동작하지 않고 a태그에는 번호값만 가지고 있다가 actionForm 의 form태그로 get메소드 동작하게 만듬.*/
			$(".move").on("click",function(e){
				e.preventDefault();
				actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
				actionForm.attr("action","/board/get");
				actionForm.submit();
			});
			
			
			/* 검색 폼을 따로 만들어서 검색폼으로 동작.   /board/list 를 갈때 무조건 pageNum은 1로 요청하게 만든다. */
			var searchForm=$("#searchForm");
			
			$("#searchForm button").on("click",function(e){
				
				if(!searchForm.find("option:selected").val()){
					alert("검색종류를 선택하세요.");
					return false;
				}
				
				if(!searchForm.find("input[name='keyword']").val()){
					alert("키워드를 입력하세요");
					return false;
				}
				
				searchForm.find("input[name='pageNum']").val(1);
				e.preventDefault();
				
				searchForm.submit();
				
			});
		});
	</script>
	
</body>

</html>
