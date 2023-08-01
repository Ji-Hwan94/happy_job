package kr.happyjob.study.stats.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.study.stats.dao.StatsDao;
import kr.happyjob.study.stats.model.StatsModel;

@Service
public class StatsServiceImpl implements StatsService {
	
	@Autowired
	StatsDao StatsDao;

	@Override
	public List<StatsModel> noticeList(Map<String, Object> paramMap) {
		List<StatsModel> noticeList=StatsDao.noticeList(paramMap);
		return noticeList;
	}

	@Override
	public int noticeTotalCnt(Map<String, Object> paramMap) {
		int noticeTotalCnt=StatsDao.noticeTotalCnt(paramMap);
		return noticeTotalCnt;
	}

	@Override
	public StatsModel detailNotice(Map<String, Object> paramMap) {
		 StatsModel detailNotice=StatsDao.detailNotice(paramMap);
		return detailNotice;
	}



}