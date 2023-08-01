package kr.happyjob.study.stats.service;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.stats.model.StatsModel;


public interface StatsService {

	List<StatsModel> noticeList(Map<String, Object> paramMap);

	int noticeTotalCnt(Map<String, Object> paramMap);

	StatsModel detailNotice(Map<String, Object> paramMap);



}