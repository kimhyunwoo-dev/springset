<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<title>Insert title here</title>

<style>

	.uploadResult{
		width : 100%;
		background-color : gray;
	}
	
	.uploadResult ul{
		display : flex;
		flex-floe : row;
		justify-content : center;
		align-itmes : center;
	}
	
	.uploadResult ul li{
		list-style : none;
		padding : 10px;
	}
	
	.uploadResult ul li img{
		width : 20px;
	}
	
	.bigPictureWrapper{
		position : absolute;
		display : none;
		justify-content : center;
		align-items : center;
		top : 0%;
		width : 100%;
		height : 100%;
		background-color : gray;
		z-index : 100;
		background : rgba(255,255,255,0.5);
	}
	.bigPicture{
		position : relative;
		display : flex;
		justify-content : center;
		align-items : center;
	}
	
	.bigPicture img {
		width : 600px;
	}
	
</style>
</head>
<body>

	<script type="text/javascript">
		
		var regex= new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		
		function showImage(fileCallPath){
			
			$(".bigPictureWrapper").css("display","flex").show();
			
			$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width : '100%',height : '100%'},1000);
			
		}
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			
			return true;
		}
	
	
		$("document").ready(function(e){
			
			$(".uploadResult").on("click","span",function(e){
				var targetFile = $(this).data("file");
				var type =$(this).data("type");
				
				$.ajax({
					url:"/deleteFile",
					data:{fileName:targetFile,type:type},
					dataType: "text",
					type:"POST",
					success : function(result){
						alert(result);
					}
				});
			});
			
			
			$(".bigPictureWrapper").on("click",function(e){
				$(".bigPicture").animate({width:"0%",height : "0%"},1000);
				setTimeout(function(){
					$(".bigPictureWrapper").hide();			
				},1000);
			});
			
			
			var cloneObj = $(".uploadDiv").clone();
			
			$("#uploadBtn").on("click",function(){
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
			
				
				for(var i=0; i < files.length; i++){
					
					if(!checkExtension(files[i].name,files[i].size)){
						return false;
					}
					formData.append("uploadFile" , files[i]);
				}
				
				$.ajax({
					url : "/uploadAjaxAction",
					processData : false,
					contentType : false,
					data : formData,
					type : "POST",
					dataType :'json',
					success : function(result){
						showUploadedFile(result);
						$(".uploadDiv").html(cloneObj.html());
						
					}
				});
				
			});
			
			
			var uploadResult = $(".uploadResult ul");
			
			function showUploadedFile(uploadResultArr){
				var str = "";
				$(uploadResultArr).each(function(i,obj){
				
					if(!obj.image){		//이미지가 아닌경우 (파일)
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/"+obj.uuid + "_"+obj.fileName);
						str+="<li>";
							str+="<div>";
								str+="<a href='/download?fileName="+fileCallPath+"'>";
									str+="<img src='/resources/img/attach.png'>"+obj.fileName;
								str+="</a>";
								str+="<span data-file='"+fileCallPath+"' data-type='file'> x </span>";
							str+="</div>";
						str+="</li>";	
					}else{				//이미지인 경우.
						str +="<li>"+obj.fileName + "</li>";
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);	//섬네일 요청하기 위한 url가	공
						
						var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
	
						originPath = originPath.replace(new RegExp(/\\/g),"/");

										//javascript:showImage('') 형식으로 만들기 위해서 \'  \'를 괄호사이에 넣은것이다. '글자는 앞에 \를 써야먹음.
						str+="<li>";
							str+="<a href=\"javascript:showImage(\'"+originPath+"\')\">";
								str+="<img src='/display?fileName="+fileCallPath+"'>";
							str+="</a>";
							str+="<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span>"; 
						str+="<li>";
						
						console.log("-------------------------------");
						console.log("originPath : " + originPath);
						console.log("fileCallPath : "+ fileCallPath);
						console.log("obj.uploadPath : " + obj.uploadPath)
						console.log("obj.uuid : " + obj.uuid);
						console.log("obj.fileName : " + obj.fileName);
						console.log("-------------------------------");
		
						
					}
				});			
				uploadResult.append(str);
			}
			
		});
	</script>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple="">
	</div>
	<button id="uploadBtn">upload</button>
	
	
	<div class="uploadResult">
		<ul>
			
		</ul>
	</div>
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		
		</div>
	</div>
	
	<a href="javascript:alert('gg')"/>aa</a>
</body>
</html>