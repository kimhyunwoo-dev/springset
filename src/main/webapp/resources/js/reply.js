/**
 * 
 */


//https://araikuma.tistory.com/640
console.log("Reply Module...12.");

var replyService=(function(){		//replyService는  익명함수인데 add함수를 가지고 있는 객체를 리턴한다.  get.jsp에서는 replyService.add(reply,callback); 으로 호출
									//그리고 매개변수로는 reply json    callback이 리턴될 콜백함수.    $.ajax에서 success시 callback으로 간다.
	
	
	function add(reply,callback){
		//console.log(reply);
		//console.log(callback);		//callback이 결국 add를 호출한쪽에서 add매개변수자리에 callback함수를 넣음.
		//$.ajax(setting);
		$.ajax({
			type:"post",
			url:"/replies/new",
			data :JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success : function(result,status,xhr){
				if(callback){		
					//console.log(result,status,xhr);		//success create , success , xhr 객체
					//result는 서버의 응답결과 ReplyController의 결과값 리턴 success create. status는 상태 success function자리니 success로  리턴함. xhr객체 리턴. 
					callback(result);
				}
			},
			error : function(xhr,status,errorThrown){
				if(xhr.statusText=='error'){
					alert("등록실패");
				}
			}
		});	
	}
	
	//$.getJson(url,callback)	
	function getList(param,callback,error){
		var bno = param.bno;
		var page = param.page || 1;
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",	
			function(data){
				if(callback){
					//console.log(data);
					//callback(data);
					console.log(data);
					callback(data.replyCnt,data.list,data.map);
				}
			}
		).fail(function(xhr,status,error){
				if(error){
					error();
				}
			});
	}
	
	function remove(rno,callback,error){
		$.ajax({
			type: "delete",
			url : "/replies/" + rno,
			success : function(deleteResult,status,xhr){
				if(callback){
					//console.log(deleteResult + "@@");
					callback(deleteResult);
				}
			},
			error : function(xhr,status,er){
				if(error){
					error(er);
				}
			}
		});
	}
	function update(reply,callback,error){
		//console.log("RNO : " + reply.rno);
		$.ajax({
			type: "put",
			url : "/replies/" + reply.rno,
			data : JSON.stringify(reply),
			contentType :"application/json; charset=utf-8",
			success : function(result,status,xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr,status,er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	function get(rno,callback,error){
		
/*		$.ajax({
			type:"get",
			url: "/replies/"+rno+".json",
			success : function(result){
				if(callback){
					
					callback(result);
				}
			},
			error : function(xhr,status,er){
				if(error){
					error(er);
				}
			}
		
		});*/
		
		
		$.get("/replies/"+rno+".json",function(result){
			if(callback){
				callback(result);
			}
		}).fail(function(xhr,status,err){
			if(error){
				error();
			}
		});
	}
	
	function displayTime(timeValue){
		
		var today = new Date();
		var gap = today.getTime()-timeValue;
		
		//console.log(today.getTime(),timeValue);
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap<(1000 * 60 * 60 * 24)){		// 1000*60*60*24 는 하루를 의미함.  1000은 milsecond단위    즉 하루 이하일때
			var hh= dateObj.getHours();
			var mi= dateObj.getMinutes();
			var ss= dateObj.getSeconds();
			
			return [
					(hh>9 ? '' : '0') + hh,
					':',
					(mi > 9 ? '' : '0') + mi,
					':', 
					(ss > 9 ? '' : '0') + ss
					].join(''); 
		}else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1;
			var dd = dateObj.getDate();
			
			return [
				yy,
				'/',
				(mm>9 ? '' : '0') +mm,
				'/', 
				(dd > 9 ? '' : '0') + dd
			].join('');
		}
		
		
	}
	
	
	return{
			add:add,
			getList:getList,
			remove :remove,
			update : update,
			get : get,
			displayTime : displayTime
		};
	
	
})();