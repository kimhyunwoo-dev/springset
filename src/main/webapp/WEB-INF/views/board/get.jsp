<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
</head>
<body>



<%@include file="../includes/header.jsp"%>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<div class="panel-body">
				
					<div class="form-group">
						<label>bno</label><input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Text area</label><textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}"></c:out></textarea>
					</div>
					<div class="form-group">
						<label>Writer</label><input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly" >
					</div>
					<%-- <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					<button data-oper="list" class="btn btn-info" onclick="location.href='/board/list'">List</button> --%>
					<button data-oper="modify" class="btn btn-default">Modify</button>
					<button data-oper="list" class="btn btn-info">List</button>
					<form id="operForm" action="/board/modify" method="get">
						<input type="text" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
						<input type="text" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
						<input type="text" id="amount" name="amount" value="<c:out value='${cri.amount}'/>">
						<input type="hidden" name="type" value="${cri.type }">
			            <input type="hidden" name="keyword" value="${cri.keyword }">
					</form>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
		<!-- 
			<div class="panel-heading">
				<i class="fa fa-comments"></i>Reply
			</div>
		-->
			
			<div class="panel-heading">
			<i class="fa fa-comments fa-fw"></i>Reply
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
			</div>
			
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong>
								<small class="pull-right text-muted">2018-01-01 13:13</small>
							</div>
							<p>Good job!</p>
						</div>
					</li>
				</ul>
			</div>
			<div class="panel-footer">
				
			</div>
		</div>
	</div>
</div>
<%@include file="../includes/footer.jsp"%>


<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="New Reply!!!">
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate" value="">
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
				<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
			</div> 
		</div>
	</div>
</div>

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
$(document).ready(function(){

	var bnoValue="<c:out value='${board.bno}'/>";
 	var replyUL = $(".chat");
 	var pageNum = 1;	  //pageNum 현재 클릭한 댓글페이지번호.
 	var replyPageFooter = $(".panel-footer");
 	
 	
 	//replyCnt 댓글 총갯수
	
 	//필요한 변수 pageNum bnoValue.   pageNum은 pageNation에서 클릭한 href값으로 바뀌거나 맨처음 get.jsp호출시 1번임. bnoValue도 get.jsp로 호출한 board의 bno값.
	function showList(page){
		replyService.getList({bno:bnoValue,page:page||1},function(replyCnt,list,map){

			//page가 -1로 들어오는 경우는 등록했을때 맨 마지막 페이지번호를 보여주게 하기 위해서.
			if(page == -1){
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			var str="";
			if(list==null || list.length==0){
				str+="<li class='left clearfix'>";
				str+=" <div>";
				str+="	<p>댓글이 없습니다.</p>"	
				str+=" </div>";
				str+="</li>";
				
			}
			for(var i=0, len=list.length || 0; i< len; i++){
				str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				str+=" <div>"
				str+="	 <div class='header'>";
				str+="		<strong class='primary-font'>"+list[i].replyer+"</strong>";
				str+="		<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small>";
				str+="   </div>";
				str+="	 <p>"+list[i].reply+"</p>"
				str+=" </div>";
				str+="</li>";
			
			}
			
			replyUL.html(str);
			showReplyPage(replyCnt,map);
		});
	} 
 	
 	
 	
 	//showListPage함수에서 호출하는 함수이다. replyCnt는 총 댓글의 갯수를 의미함.
 	function showReplyPage(replyCnt,map){
 		
 		var str="<ul class='pagination pull-right'>";
 		if(map.prev){
 			str+="<li class='page-item'><a class='page-link' href='"+(map.startPage-1)+"'>Previous</a><li>";
 		}
 		
 		for( var i= map.startPage; i<=map.endPage; i++){
 			var active = pageNum == i ? "active" : "";
 			str+="<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
 				
 		}
 		if(map.next){
				str+="<li class='page-item'><a class='page-link' href='"+(map.endPage+1)+"'>Next</a></li>";
		}
 
 		
 		/* var endNum = Math.ceil(pageNum/10.0)*10;	
 		var startNum = endNum-9;
 		var prev = startNum != 1;			
 		var next = false;
 		
 											//5페이지 입력 ->endNum 10   , 12페이지 입력 ->endNum 20 , 150개 글갯수일때  15페이지밖에 없어야하는데 endPage가 20개나 있으면 문제.
 		if(endNum * 10 >= replyCnt){		//총갯수보다 endNum의*10 갯수가 많다면...   endNum을 바꿔야함.   Math.ceil(총갯수/10.0) 이 최종 endNum이 되어야함.   
 			endNum = Math.ceil(replyCnt/10.0);
 		}
 		
 		if(endNum * 10 < replyCnt){			//endNum * 10 갯수보다 총갯수가 더 많다면.
 			next= true;
 		}
 		
 		var str="<ul class='pagination pull-right'>";
 		if(prev){
 			str+="<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a><li>";
 		}
 		
 		for( var i= startNum; i<=endNum; i++){
 			console.log(i);
 			var active = pageNum == i ? "active" : "";
 			
 			str+="<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
 				
 		}
 		if(next){
				str+="<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
		}
 */ 	
		str+="</ul></div>";
 		replyPageFooter.html(str);
 	}
 	
 	
	showList(pageNum); 

	var modal=$(".modal");
	var modalInputReply=modal.find("input[name='reply']");
	var modalInputReplyer=modal.find("input[name='replyer']");
	var modalInputReplyDate=modal.find("input[name='replyDate']");
	
	var modalModBtn=$("#modalModBtn");
	var modalRemoveBtn=$("#modalRemoveBtn");
	var modalRegisterBtn=$("#modalRegisterBtn");
	var modalCloseBtn=$("#modalCloseBtn");
	
	modalCloseBtn.on("click",function(){
		modal.find("input").val("");
		modal.modal("hide");
	});
	
	
	$("#addReplyBtn").on("click",function(){
		modalInputReplyer.removeAttr("readonly");
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id!='modalCloseBtn']").hide();
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
	});
	
	// 모달창 안에서 register 버튼을 눌렀을때
	modalRegisterBtn.on("click",function(){
		var reply = {
				reply:modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
		};
		replyService.add(reply,function(result){
			alert(result);
			modal.find("input").val("");
			modal.modal("hide");
			showList(-1);
		});
	});	

	// 댓글목록에 보이는 댓글들(li)를 눌렀을때 동작하는 이벤트 reply.js get함수 호출. 
	$(".chat").on("click","li",function(e){

		var rno=$(this).data("rno");
		replyService.get(rno,function(reply){
			modalInputReplyDate.closest("div").show();
			modalInputReplyer.attr("readonly","readonly");
			modalInputReply.val(reply.reply)
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
			modal.data("rno",reply.rno);
			modal.find("button[id!='modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			$(".modal").modal("show");
		});
	});
	
	
	
	//리플 get함수 호출후 모달창 안에서 수정버튼을 눌렀을때
	modalModBtn.on("click",function(){
		alert(modal.data("rno"));
		
		var reply={rno:modal.data("rno") ,bno:bnoValue, reply:modalInputReply.val()};
		replyService.update(reply,function(result){
			alert(result);
			modal.modal("hide");	//모달창 숨기기		modal.modal("hide"); 모달창 보이기 modal.modal("show");
			showList(pageNum);
		},function(err){
			alert("UPDATE ERROR...");
		}
		);
	});
	//  리플 get함수 호출후  모달창안에서의 삭제버튼을 눌렀을때
	modalRemoveBtn.on("click",function(){
		var rno=modal.data("rno");
		
		replyService.remove(rno,function(result){
			alert(result);
			modal.modal("hide");
			showList(pageNum);
		});
		
	});
	//페이지  버튼을 눌렀을때
	replyPageFooter.on("click","li a",function(e){
		e.preventDefault();
		var targetPageNum = $(this).attr("href");
		pageNum = targetPageNum;
		showList(pageNum);
	});
	
});


</script>

<script type="text/javascript">
	$(document).ready(function(){
		var operForm=$("#operForm");
		$("button[data-oper='modify']").on("click",function(e){
			operForm.attr("action","/board/modify").submit();
			
		});
		
		$("button[data-oper='list']").on("click",function(e){
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list");
			operForm.submit();
		});
		
	});
</script>


<!-- 

/* 	replyService.add(
		{reply:"JS TEST",replyer:"tester",bno:bnoValue},
		function(result){
			alert("RESULT : " + result);
		}
	);  */
	
   /*  
	 replyService.getList({bno:bnoValue , page:1}, function(list){
		console.log("list.length||0 : " ,list.length||0);
		for(var i=0, len=list.length||0; i<len; i++){
			console.log(list[i]);
		}
	});  */
 		
/* 
	replyService.remove(47,function(count){
		console.log(count);
		if(count==="success remove"){
			alert("REMOVED");
		}
	},function(error){
		
		alert("REMOVE ERROR...");
	}
	
	); 
 */

/* 	replyService.update({rno:77,bno:bnoValue,reply:"Modifyed reply....수정"},
		function(result){
			if(result==="success"){
				alert("UPDATED");
			}
		},function(err){
			alert("UPDATE ERROR...");
		}
	); 
 */
	
	
	/* replyService.get(10,function(data){
		console.log(data);
	});
	 */

 -->
</body>



