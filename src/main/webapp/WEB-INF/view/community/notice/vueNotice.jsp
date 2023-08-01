<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>공지사항</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	// 페이징 설정을 하는 겁니다 
	var pageSize = 10;
	var pageBlockSize = 5;
	var vueNotice;
	var vueModal;

	$(function() {
		init();
		vueNotice.searchNotice();
	});

	function init() {
		vueNotice = new Vue(
				{
					el : "#wrap_area",
					data : {
						srctitle : "",
						srcsdate : "",
						srcedate : "",

						fileCd : 0,
						action : "",

						noticeNo : "",
						noticeTitle : "",
						writer : "",
						noticeDate : "",
						noticeDet : "",
						groupList : [],
						countNoticeList : 0,
						searchData : "",
						pagingNav : "",
					},
					methods : {
						searchNotice : function(cpage) {
							cpage = cpage || 1;
							var param = {
								srctitle : this.srctitle,
								srcsdate : this.srcsdate,
								srcedate : this.srcedate,
								pageSize : pageSize,
								cpage : cpage
							}

							var listcallback = function(res) {
								vueNotice.groupList = res.vueNoticelist;
								vueNotice.countNoticeList = res.countnoticelist;
								var paging = getPaginationHtml(cpage,
										vueNotice.countNoticeList, pageSize,
										pageBlockSize, 'searchnotice');
								vueNotice.pagingNav = paging;

							}

							callAjax("/community/vueNoticeList.do", "post",
									"json", "false", param, listcallback);
						},
						modalOpen : function(noticeNo) {
							vueModal.detail = {};
							if (noticeNo == "" || noticeNo == null
									|| noticeNo == undefined) {

								vueModal.isUpdate = false;
								vueModal.isDelete = false;
								vueModal.isInsert = true;
								vueModal.isFileShow = false;

								this.action = "I";

							} else {
								var param = {
									noticeno : noticeNo
								}

								vueModal.isUpdate = true;
								vueModal.isDelete = true;
								vueModal.isInsert = false;

								this.noticeNo = noticeNo;
								this.action = "U";
								var detailcallback = function(res) {
									vueModal.detail = {};
									vueModal.detail = res.detail;
									vueModal.writer = res.detail.writer;
									vueModal.date = res.detail.reg_date;
									console.log(res.detail.file_name);
									if (res.detail.file_name == null
											|| res.detail.file_name == "") {
										vueModal.isFileShow = false;
									} else {
										vueModal.isFileShow = true;
										vueModal.previewhtml = "<img src='" + res.detail.file_nadd + "' style='width: 200px; height: 130px;' />";

									}

									this.fileCd = res.detail.file_cd;
								}

								callAjax("/community/noticedetail.do", "post",
										"json", "false", param, detailcallback);
							}
							gfModalPop("#noticeregfile");
						}
					}
				})

		vueModal = new Vue(
				{
					el : "#noticeregfile",
					data : {
						detail : {},
						fileview : "",

						writer : "관리자",
						date : getToday(),

						isUpdate : true,
						isInsert : true,
						isDelete : true,
						isFileShow : false,

						fileWatch : "",
						previewhtml : ""
					},
					methods : {
						insertNotice : function() {
							var frm = document.getElementById("myForm");
							frm.enctype = "multipart/form-data";
							var param = new FormData(frm);

							var savecallback = function(res) {
								if (res.result == "SUCCESS") {
									alert("저장되었습니다.");
									gfCloseModal();
									vueNotice.searchNotice();
								}
							}

							callAjaxFileUploadSetFormData(
									"/community/noticesavefile.do", "post",
									"json", true, param, savecallback);
						},
						updateNotice : function() {

							var frm = document.getElementById("myForm");
							frm.enctype = "multipart/form-data";
							var param = new FormData(frm);

							var updatecallback = function(res) {
								if (res.result == "SUCCESS") {
									alert("수정되었습니다.");
									gfCloseModal();
									vueNotice.searchNotice();
								}
							}

							callAjaxFileUploadSetFormData(
									"/community/noticesavefile.do", "post",
									"json", true, param, updatecallback);
						},
						deleteNotice : function() {
							var frm = document.getElementById("myForm");
							frm.enctype = "multipart/form-data";
							var param = new FormData(frm);
							param.set("action", "D");

							var deleteNotice = function(res) {
								if (res.result == "SUCCESS") {
									alert("삭제되었습니다.");
									gfCloseModal();
									vueNotice.searchNotice();
								}
							};

							callAjaxFileUploadSetFormData(
									"/community/noticesavefile.do", "post",
									"json", true, param, deleteNotice);

						},
						closeNotice : function() {
							gfCloseModal();
						},
						filechange : function() {
							this.isFileShow = true;
							var upfile = document.getElementById("addfile");
							this.fileview = "";
							var image = event.target;
							var imgpath = "";
							if (image.files[0]) {
								imgpath = window.URL
										.createObjectURL(image.files[0]);

								var filearr = $("#addfile").val().split(".");
								console.log(filearr);
								if (filearr[1] == "jpg" || filearr[1] == "png") {
									this.previewhtml = "<img src='" + imgpath + "' style='width: 200px; height: 130px;' />";
								}
							}
						}
					}
				})
	}

	// 공지사항 불러오기
	/* 	function searchnotice(res) {
	 container.searchData = res;
	 console.log(container.searchData);
	 } */

	function buttonClickEvent() {

		// 파일 미리보기
		var upfile = document.getElementById("addfile");
		upfile
				.addEventListener(
						"change",
						function(event) {
							$("#fileview").empty();
							var image = event.target;
							var imgpath = "";
							if (image.files[0]) {
								imgpath = window.URL
										.createObjectURL(image.files[0]);

								var filearr = $("#addfile").val().split(".");

								// 미리보기를 위해 html태그를 생성할꺼임
								var previewhtml = "";

								if (filearr[1] == "jpg" || filearr[1] == "png") {
									previewhtml = "<img src='" + imgpath + "' style='width: 200px; height: 130px;' />";
								}
								$("#fileview").empty().append(previewhtml);

							}
						});

	}

	// 공지사항 팝업 오픈
	function openPop() {
		initpopup();
		gfModalPop("#noticeregfile");
	}

	// 등록 / 수정 팝업 초기 데이터 설정
	function initpopup(object) {

		// 저장 버튼을 눌렀을때 팝업에 데이터가 없게 한다.
		if (object == "" || object == null || object == undefined) {

			$("#btnDeletefile").hide();
			$("#writerfile").val($("#userNm").val());
			$("#notice_datefile").val(getToday());

			$("#notice_titlefile").val("");
			$("#notice_detfile").val("");
			$("#addfile").val("");
			$("#fileview").empty();
			$("#action").val("I");
		} else {
			var param = {
				notice_no : object.detail.notice_no
			}

			$("#btnDeletefile").show();
			$("#notice_titlefile").val(object.detail.notice_title);
			$("#notice_datefile").val(object.detail.reg_date);
			$("#writerfile").val(object.detail.writer);
			$("#notice_detfile").val(object.detail.notice_content);
			$("#noticeno").val(object.detail.notice_no);
			$("#filecd").val(object.detail.file_cd);
			$("#addfile").val("");
			$("#action").val("U");

			// 저장된 파일 미리보기
			var file_name = object.detail.file_name;
			var filearr = [];
			var previewhtml = "";

			if (file_name == "" || file_name == null || file_name == undefined) {
				previewhtml = "";
			} else {

				filearr = file_name.split(".");
				console.log(filearr);

				if (filearr[1] == "jpg" || filearr[1] == "png") {
					previewhtml = "<a href='javascript:fn_downaload()'>   <img src='" + object.detail.file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
				} else {
					previewhtml = "<a href='javascript:fn_downaload()'>"
							+ object.detail.file_name + "</a>";
				}
			}

			$("#fileview").empty().append(previewhtml);

			var justcallback = function(res) {
				console.log(res);
			}

			callAjax("/community/pluswatch.do", "post", "json", "false", param,
					justcallback);

		}

	}

	// 오늘 날짜 가져오는 함수
	function getToday() {
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);

		return year + "-" + month + "-" + day;
	}

	// 공지사항 등록/수정/삭제
	function savefile() {
		var frm = document.getElementById("myForm");
		frm.enctype = "multipart/form-data";
		var param = new FormData(frm);

		var savecallback = function(res) {
			if (res.result == "SUCCESS") {
				alert("저장되었습니다.");
				gfCloseModal();
				searchnotice();
			}
		}

		callAjaxFileUploadSetFormData("/community/noticesavefile.do", "post",
				"json", true, param, savecallback);
	}

	function openDetail(noticeNum) {
		var param = {
			noticeno : noticeNum
		}

		var detailcallback = function(res) {
			console.log(res)
			initpopup(res);

			gfModalPop("#noticeregfile");
		}

		callAjax("/community/noticedetail.do", "post", "json", "false", param,
				detailcallback);
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<!-- 모달 배경 -->
		<div id="mask"></div>

		<div id="wrap_area">
			<input type="hidden" name="action" id="action" :value="action">
			<input type="hidden" name="loginId" id="loginId" value="${loginId}">
			<input type="hidden" name="userNm" id="userNm" value="${userNm}">
			<input type="hidden" name="noticeno" id="noticeno" :value="noticeNo">
			<input type="hidden" name="currentpage" id="currentpage" value="">
			<input type="hidden" name="filecd" id="filecd" :value="fileCd">

			<h2 class="hidden">header 영역</h2>
			<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

			<h2 class="hidden">컨텐츠 영역</h2>
			<div id="container">
				<ul>
					<li class="lnb">
						<!-- lnb 영역 --> <jsp:include
							page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
					</li>
					<li class="contents">
						<!-- contents -->
						<h3 class="hidden">contents 영역</h3> <!-- content -->
						<div class="content">

							<p class="Location">
								<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
								<span class="btn_nav bold">실습</span> <span class="btn_nav bold">공지사항
									관리</span> <a href="../system/notice.do" class="btn_set refresh">새로고침</a>
							</p>
							<p class="conTitle">
								<span class="btn_nav bold">공지사항 </span>
							</p>

							<p>
								<span class="fr"> 제목 <input type="text" name="srctitle"
									v-model="srctitle" /> <input type="date" name="srcsdate"
									v-model="srcsdate" /> ~ <input type="date" name="srcedate"
									v-model="srcedate" /> <a class="btnType blue" href="#"
									@click="searchNotice()" name="modal"><span>검색</span></a> <c:if
										test="${sessionScope.userType eq 'A'}">
										<a class="btnType blue" href="#" @click="modalOpen()"
											name="modal"><span>등록</span></a>
									</c:if>
								</span>
							</p>
							<div class="divComGrpCodList">
								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="6%">
										<col width="40%">
										<col width="17%">
										<col width="20%">
										<col width="6%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">제목</th>
											<th scope="col">작성자</th>
											<th scope="col">날짜</th>
											<th scope="col">조회수</th>
										</tr>
									</thead>
									<template v-if="countNoticeList == 0 ">
									<tbody>
										<tr>
											<td colspan="5">데이터가 존재하지 않습니다.</td>
										</tr>
									</tbody>
									</template>
									<template v-else>
									<tbody v-for="(list,index) in groupList">
										<tr>
											<td>{{list.notice_no}}</td>

											<td><a href="#" @click="modalOpen(list.notice_no)">{{list.notice_title}}</a></td>
											<td>{{list.writer}}</td>
											<td>{{list.reg_date}}</td>
											<td>{{list.notice_count}}</td>
										</tr>
									</tbody>
									</template>
								</table>
							</div>

							<div class="paging_area" id="noticePagination" v-html="pagingNav"></div>

						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>

		<div id="noticeregfile" class="layerPop layerType2"
			style="width: 600px;">
			<dl>
				<dt>
					<strong>공지사항 등록/수정</strong>
				</dt>
				<dd class="content">
					<!-- s : 여기에 내용입력 -->
					<table class="row">
						<caption>caption</caption>
						<colgroup>
							<col width="120px">
							<col width="*">
							<col width="120px">
							<col width="*">
						</colgroup>

						<tbody>
							<tr>
								<th scope="row">작성자 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100"
									v-model="writer" name="writerfile" readonly /></td>
								<th scope="row">작성일자 <span class="font_red">*</span></th>
								<td><input type="text" v-model="date" class="inputTxt p100"
									name="notice_datefile" readonly /></td>
							</tr>
							<tr>
								<th scope="row">제목 <span class="font_red">*</span></th>
								<td colspan="3"><input type="text" class="inputTxt p100"
									name="notice_titlefile" v-model="detail.notice_title" /></td>
							</tr>

							<tr>
								<th scope="row">내용 <span class="font_red">*</span></th>
								<td colspan="3"><textarea class="inputTxt p100"
										name="notice_detfile" v-modal="detail.notice_content">{{ detail.notice_content }}</textarea></td>
							</tr>

							<tr>
								<th scope="row">파일 <span class="font_red">*</span></th>
								<td>
									<!-- input type="file" class="inputTxt p100" name="addfile" id="addfile"  onChange="fn_filechange(event)"  / -->
									<input multiple="multiple" type="file" class="btnType blue"
									name="addfile" id="addfile" @change="filechange" />

								</td>
								<td colspan="2"><div v-show="isFileShow"
										v-html="previewhtml">
										<img :src="detail.file_nadd"
											style='width: 200px; height: 130px;' />
									</div></td>
							</tr>

						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" name="btn" @click="insertNotice()"
							v-show="isInsert"><span>저장</span></a> <a href="#"
							class="btnType blue" name="btn" @click="updateNotice()"
							v-show="isUpdate"><span>수정</span></a> <a href="#"
							class="btnType blue" name="btn" @click="deleteNotice()"
							v-show="isDelete"><span>삭제</span></a> <a href="#"
							class="btnType gray" name="btn" @click.prevent="closeNotice()"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>

	</form>
</body>
</html>