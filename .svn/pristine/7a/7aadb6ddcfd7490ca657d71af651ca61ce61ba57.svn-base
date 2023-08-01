<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:forEach items="${noticelist}" var="list">
	<c:if test="${list.is_delete eq 2}">
		<tr>
			<td>${list.notice_no}</td>
			<td><a href="javascript:openDetail(${list.notice_no})">${list.notice_title}</a></td>
			<td>${list.writer}</td>
			<td>${list.reg_date}</td>
			<td>${list.notice_count}</td>
		</tr>
	</c:if>
</c:forEach>

<input type="hidden" id="totcnt" name="totcnt" value="${countnoticelist}"/>


