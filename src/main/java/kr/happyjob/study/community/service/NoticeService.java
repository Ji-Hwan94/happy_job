package kr.happyjob.study.community.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.happyjob.study.community.model.NoticeModel;

public interface NoticeService {
	public List<NoticeModel> noticelist(Map<String, Object> paramMap) throws Exception;
	
	public int noticenewsave(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 저장 파일  */
	public int noticenewsavefile(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile) throws Exception;

	public NoticeModel noticedetail(Map<String, Object> paramMap) throws Exception;
	
	public int noticeupdate(Map<String, Object> paramMap) throws Exception;
	
	public int noticedelete(Map<String, Object> paramMap) throws Exception;
	
	public int countnoticelist(Map<String, Object> paramMap) throws Exception;
	
	public int pluswatch(Map<String, Object> paramMap) throws Exception;
	
	/* 곻지사항 수정 파일  */
	public int noticenewupdatefile(Map<String, Object> paramMap, HttpServletRequest request, List<MultipartFile> multiFile) throws Exception;
	
}
