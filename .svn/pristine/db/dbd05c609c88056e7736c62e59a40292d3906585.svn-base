package kr.happyjob.study.community.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.happyjob.study.community.model.NoticeModel;
import kr.happyjob.study.community.service.NoticeService;

@Controller
@RequestMapping("/community/")
public class NoticeController {

	@Autowired
	NoticeService noticeService;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	// private final String className = this.getClass().toString();

	@RequestMapping("notice.do")
	public String notice(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		model.addAttribute("loginId", (String) session.getAttribute("loginId"));
		model.addAttribute("userNm", (String) session.getAttribute("userNm"));

		return "community/notice/notice";
	}

	@RequestMapping("noticelist.do")
	public String noticelist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("   - paramMap : " + paramMap);
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));
		int cpage = Integer.parseInt((String) paramMap.get("cpage"));
		int pageindex = (cpage - 1) * pageSize;
		
		paramMap.put("pageindex", pageindex);
		paramMap.put("pageSize", pageSize);
		
		List<NoticeModel> noticelist = noticeService.noticelist(paramMap);
		int countnoticelist = noticeService.countnoticelist(paramMap);
		
		model.addAttribute("noticelist", noticelist);
		model.addAttribute("countnoticelist", countnoticelist);

		return "community/notice/noticeList";
	}
	
	@RequestMapping("pluswatch.do")
	@ResponseBody	
	public Map<String, Object> pluswatch(@RequestParam Map<String, Object> paramMap) throws Exception{
		logger.info("   - paramMap : " + paramMap);
		
		noticeService.pluswatch(paramMap);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("result", "SUCCESS");

		return returnMap;
	}

	@RequestMapping("noticesavefile.do")
	@ResponseBody
	public Map<String, Object> noticesave(Model model, @RequestParam Map<String, Object> paramMap,
			@RequestParam("addfile") List<MultipartFile> multiFile, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		logger.info("   - paramMap : " + paramMap);
		logger.info("   - request : " + request);

		paramMap.put("loginId", session.getAttribute("loginId"));

		String action = (String) paramMap.get("action");

		if ("I".equals(action)) {
//			noticeService.noticenewsave(paramMap);
			noticeService.noticenewsavefile(paramMap, request, multiFile);
		}
		 else if("U".equals(action)){
//			 noticeService.noticeupdate(paramMap);
			 noticeService.noticenewupdatefile(paramMap, request, multiFile);
		 }
		 else if("D".equals(action)) {
			 noticeService.noticedelete(paramMap);
		 }

		Map<String, Object> returnMap = new HashMap<String, Object>();

		returnMap.put("result", "SUCCESS");

		return returnMap;
	}

	@RequestMapping("noticedetail.do")
	@ResponseBody
	public Map<String, Object> noticedetail(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("   - paramMap : " + paramMap);
		
		NoticeModel detail = noticeService.noticedetail(paramMap);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();

		returnMap.put("detail", detail);
		
		logger.info("   - returnMap : " + returnMap);
		
		return returnMap;
	}

}
