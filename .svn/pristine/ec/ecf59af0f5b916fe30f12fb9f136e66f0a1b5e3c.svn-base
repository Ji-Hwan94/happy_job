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
 
	$(function() {
		buttonClickEvent();
		searchnotice();
	});

	function buttonClickEvent() {
		$("a[name=btn]").click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr("id");

			switch (btnId) {
			case "btnSavefile":
				savefile();
				break;
			case "btnDeletefile":
				$("#action").val("D");
				savefile();
				break;
			case "btnClosefile":
				searchnotice();
				gfCloseModal();
				break;
			}
		});
		
		// 파일 미리보기
		var upfile = document.getElementById("addfile");
		upfile.addEventListener("change", function(event){
			$("#fileview").empty();
			var image = event.target;
			var imgpath = "";
			if(image.files[0]){
				imgpath = window.URL.createObjectURL(image.files[0]);
				
				var filearr = $("#addfile").val().split(".");
				
				// 미리보기를 위해 html태그를 생성할꺼임
				var previewhtml = "";
				
				console.log(filearr);
				
				if(filearr[1] == "jpg" || filearr[1] == "png"){
					previewhtml = "<img src='" + imgpath + "' style='width: 200px; height: 130px;' />";
				}
				$("#fileview").empty().append(previewhtml);
				
			}
		});
		
	}

	// 공지사항 불러오기
	function searchnotice(cpage) {
		
		cpage = cpage || 1;
		
		var param = {
			srctitle : $("#srctitle").val(),
			srcsdate : $("#srcsdate").val(),
			srcedate : $("#srcedate").val(),
			pageSize : pageSize,
			cpage : cpage
		}

		var listcallback = function(res) {

			$("#listNotice").empty().append(res);
			
			var countnoticelist = $("#totcnt").val();
			console.log(countnoticelist);
			var paging = getPaginationHtml(cpage, countnoticelist, pageSize, pageBlockSize, 'searchnotice');
			
			$("#noticePagination").empty().append(paging);
			
			$("#currentpage").val(cpage);
		}

		callAjax("/community/noticelist.do", "post", "text", "false", param,
				listcallback);
	}

	// 공지사항 팝업 오픈
	function openPop() {
		initpopup();
		gfModalPop("#noticeregfile");
	}

	// 등록 / 수정 팝업 초기 데이터 설정
	function initpopup(object) {
		
		// 저장 버튼을 눌렀을때 팝업에 데이터가 없게 한다.
		if(object == "" || object == null || object == undefined) {
			
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
			
			if( file_name == "" || file_name == null || file_name == undefined) {
				previewhtml = "";
			} else {
				
				filearr = file_name.split(".");
				console.log(filearr);
				
				
				if (filearr[1] == "jpg" || filearr[1] == "png") {
					previewhtml = "<a href='javascript:fn_downaload()'>   <img src='" + object.detail.file_nadd + "' style='width: 200px; height: 130px;' />  </a>";
				} else {
					previewhtml = "<a href='javascript:fn_downaload()'>" + object.detail.file_name  + "</a>";
				}
			}
			
			$("#fileview").empty().append(previewhtml);
			
			var justcallback = function(res){
				console.log(res);
			}
			
			callAjax("/community/pluswatch.do", "post", "json", "false", param, justcallback);
			
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
	function savefile(){
		var frm = document.getElementById("myForm");
		frm.enctype = "multipart/form-data";
		var param = new FormData(frm);
		
		var savecallback = function(res){
			if(res.result == "SUCCESS"){
				alert("저장되었습니다.");
				gfCloseModal();
				searchnotice();
			}
		}
		
		callAjaxFileUploadSetFormData("/community/noticesavefile.do", "post", "json", true, param, savecallback);
	}
	
	function openDetail(noticeNum){
		var param = {
				noticeno : noticeNum
			}
		
		var detailcallback = function(res){
			console.log(res)
			initpopup(res);
			
			gfModalPop("#noticeregfile");
		}
		
		callAjax("/community/noticedetail.do", "post", "json", "false", param, detailcallback);
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="action" id="action" value=""> <input
			type="hidden" name="loginId" id="loginId" value="${loginId}">
		<input type="hidden" name="userNm" id="userNm" value="${userNm}">
		<input type="hidden" name="noticeno" id="noticeno" value=""> <input
			type="hidden" name="currentpage" id="currentpage" value="">
			<input
			type="hidden" name="filecd" id="filecd" value="">

		<!-- 모달 배경 -->
		<div id="mask"></div>

		<div id="wrap_area">

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
								<span class="fr"> 제목 <input type="text" id="srctitle"
									name="srctitle" /> <input type="date" id="srcsdate"
									name="srcsdate" /> ~ <input type="date" id="srcedate"
									name="srcedate" /> <a class="btnType blue"
									href="javascript:searchnotice();" name="modal"><span>검색</span></a>
									<c:if test="${sessionScope.userType eq 'A'}">
										<a class="btnType blue" href="javascript:openPop();" name="modal"><span>등록</span></a>
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
									<tbody id="listNotice"></tbody>
								</table>
							</div>

							<div class="paging_area" id="noticePagination"></div>

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
									name="writerfile" id="writerfile" readonly /></td>
								<th scope="row">작성일자 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100"
									name="notice_datefile" id="notice_datefile" readonly /></td>
							</tr>
							<tr>
								<th scope="row">제목 <span class="font_red">*</span></th>
								<td colspan="3"><input type="text" class="inputTxt p100"
									name="notice_titlefile" id="notice_titlefile" /></td>
							</tr>

							<tr>
								<th scope="row">내용 <span class="font_red">*</span></th>
								<td colspan="3"><textarea class="inputTxt p100"
										name="notice_detfile" id="notice_detfile"> </textarea></td>
							</tr>

							<tr>
								<th scope="row">파일 <span class="font_red">*</span></th>
								<td>
									<!-- input type="file" class="inputTxt p100" name="addfile" id="addfile"  onChange="fn_filechange(event)"  / -->
									<input multiple="multiple" type="file" class="btnType blue" name="addfile"
									id="addfile" />
								</td>
								<td colspan="2"><div id="fileview"></div></td>
							</tr>

						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a>
						<a href="" class="btnType blue" id="btnDeletefile" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnClosefile" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>

	</form>
</body>
</html>