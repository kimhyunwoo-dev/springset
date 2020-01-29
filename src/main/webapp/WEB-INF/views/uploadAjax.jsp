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
	
	
</style>
</head>
<body>

	<script type="text/javascript">
		
		var regex= new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		
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
			
			var cloneObj = $(".uploadDiv").clone();
			
			$("#uploadBtn").on("click",function(){
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				console.log(files);
				
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
			
					
					if(!obj.image){
						str+="<li><img src='/resources/img/attach.png'>"+obj.fileName+"</li>";	
					}else{
						str +="<li>"+obj.fileName + "</li>";
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
	
	
	
</body>
</html>