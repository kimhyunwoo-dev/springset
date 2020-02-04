package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;


import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName){
		Resource resource = new FileSystemResource("c:\\upload\\"+fileName);
		log.info("download file : " + fileName);	//download file : 2020\01\30/2eb451ae-8706-4e97-9742-644bcd8bbe96_gg.pptx	1.원본 요청
		log.info("resource : " + resource);		// resource : file [c:upload\2020\01\30\2eb451ae-8706-4e97-9742-644bcd8bbe96_gg.pptx] 2.resource객체변환
			
		
		if(resource.exists()==false) { return new
		  ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		 
		String resourceName = resource.getFilename();		
		log.info("resourceName 변수 : " + resourceName);			//resourceName 변수 : 2eb451ae-8706-4e97-9742-644bcd8bbe96_gg.pptx

		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);		//indexOf _ 을 정규식표현식으로 바꿔보기 으로바꾸기
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				//IE
				log.info("IE BROWSER");
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			}else if(userAgent.contains("Edge")){
				//EDGE
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
				log.info("EDGE BROWSER");
			}else {
				//CROME
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
				log.info("CROME BROWSER");
				
			}	
			log.info("downloadName : " + downloadName);
			headers.add("Content-Disposition", "attachment; filename="+downloadName);
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource , headers , HttpStatus.OK);
	}
	
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		
		String uploadFolder = "C:\\upload";
		
		for(MultipartFile multipartFile : uploadFile) {
		
			log.info("-------------------------------------------------");
			log.info("upload File Name : " + multipartFile.getOriginalFilename());
			log.info("upload File Size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder , multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	
		}	
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
		
	}
	
	@PostMapping(value ="/uploadAjaxAction",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		List<AttachFileDTO> list = new ArrayList<>();
		
		
		String uploadFolder = "C:\\upload";
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder , getFolder());
		
		if(uploadPath.exists() ==false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();

			String uploadFileName=null;
			uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);		//IE는 전체파일경로가 리턴되므로 IE용 코드./
			attachDTO.setFileName(uploadFileName);															//attach객체

			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			File saveFile = new File(uploadPath , uploadFileName);
			try {
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());															//attach객체
				attachDTO.setUploadPath(uploadFolderPath);
				
				//checkImageType file
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					thumbnail.close();
			
				}
				
				list.add(attachDTO);
				
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
					
		}
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
	
	private String getFolder() {		//2020/01/29 같은 날짜형식리턴
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try {
			/*
			 * log.info("file.toPath() 함수 호출 : " + file.toPath() );
			 * log.info("Files.probeContentType(file.toPath()) 함수 호출 : " +
			 * Files.probeContentType(file.toPath()) );
			 */
			String contentType = Files.probeContentType(file.toPath());		//probeContentType은 무슨 타입인지 알기위해 쓰는것같다.
			return contentType.startsWith("image");		//특정글자가 imaga로 시작하는지 물음.
		}catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		File file = new File("c:\\upload\\"+fileName);
		ResponseEntity<byte[]> result = null;
		HttpHeaders header = new HttpHeaders();
		try {
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result=new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;	
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		
		log.info("-------------deleteFile 함수 호출 -----------");
		
		File file;
		
			try {
				file=new File("c:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
				file.delete();
				
				if(type.equals("image")) {
					String largeFileName = file.getAbsolutePath().replace("s_", "");
					log.info("largeFileName : " + largeFileName);
					
					file= new File(largeFileName);
					file.delete();	
				}
				
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
			}
		
		log.info("-------------deleteFile 함수 호출 -----------");
		
		return new ResponseEntity<String>("delete",HttpStatus.OK);
	}
	

}
