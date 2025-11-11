<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>창고 목록 및 위치 조회</title>

  <!-- 카카오 지도 SDK -->
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a&libraries=services"></script>

  <style>
    #map { width: 100%; height: 500px; margin-bottom: 20px; }
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background-color: #f4f4f4; }
    a { text-decoration: none; color: blue; }
  </style>
</head>
<body>
<h1>창고 목록 및 위치 조회</h1>

<!-- 새로운 창고 등록 버튼 -->
<button onclick="location.href='${pageContext.request.contextPath}/admin/warehouses/register'" style="margin-bottom: 15px;">
  새로운 창고 등록
</button>

<!-- 지도 영역 -->
<div id="map"></div>

<!-- 창고 테이블 -->
<table>
  <thead>
  <tr>
    <th>창고 ID</th>
    <th>창고 이름</th>
    <th>창고 주소</th>
    <th>창고 종류</th>
    <th>운영 현황</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="warehouse" items="${warehouseList}">
    <tr>
      <td>${warehouse.warehouseId}</td>
      <td>
        <a href="${pageContext.request.contextPath}/admin/warehouses/${warehouse.warehouseId}">
            ${warehouse.name}
        </a>
      </td>
      <td>${warehouse.address}</td>
      <td>${warehouse.warehouseType}</td>
      <td>
        <c:choose>
          <c:when test="${warehouse.warehouseStatus == 1}">운영 중</c:when>
          <c:otherwise>점검 중</c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty warehouseList}">
    <tr>
      <td colspan="5">등록된 창고가 없습니다.</td>
    </tr>
  </c:if>
  </tbody>
</table>

<script type="text/javascript">
  // 서버에서 전달한 warehouseList JSON 데이터를 JS 객체로 변환
  var warehouseData = ${jsWarehouseData};

  // 지도 초기화
  var container = document.getElementById('map');
  var options = {
    center: new kakao.maps.LatLng(37.5665, 126.9780), // 초기 중심 좌표 (서울)
    level: 5
  };
  var map = new kakao.maps.Map(container, options);

  // 지도 범위를 자동으로 조정할 LatLngBounds 객체 생성
  var bounds = new kakao.maps.LatLngBounds();

  // 마커와 InfoWindow 생성
  warehouseData.forEach(function(wh) {
    if (!wh.latitude || !wh.longitude) {
      console.warn("Invalid coordinates for warehouse:", wh.name);
      return;
    }

    var position = new kakao.maps.LatLng(wh.latitude, wh.longitude);

    // 마커 생성
    var marker = new kakao.maps.Marker({
      position: position,
      map: map,
      title: wh.name
    });

    // InfoWindow 생성
    var infowindow = new kakao.maps.InfoWindow({
      content: `<div style="padding:5px; font-weight:bold;">${wh.name}<br/>${wh.address}</div>`
    });

    // 마커 클릭 시 InfoWindow 열기
    kakao.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
    });

    // bounds에 좌표 추가
    bounds.extend(position);
  });

  // 모든 마커가 보이도록 지도 범위 조정
  map.setBounds(bounds);
</script>

</body>
</html>
