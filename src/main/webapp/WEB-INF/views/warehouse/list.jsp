<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>창고 목록 및 위치 조회</title>

  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a&libraries=services"></script>

  <style>
    /* 지도 컨테이너 크기 필수 지정 */
    #map { width: 100%; height: 500px; margin-bottom: 20px; }
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background-color: #f4f4f4; }
    a { text-decoration: none; color: blue; }

    /* 마커 위 이름 표시 스타일 */
    .marker-label {
      background-color: #fff;
      border: 1px solid #000;
      padding: 2px 5px;
      font-size: 12px;
      font-weight: bold;
      color: #000;
      text-align: center;
      border-radius: 3px;
      box-shadow: 2px 2px 2px rgba(0,0,0,0.3);
      white-space: nowrap;
      cursor: pointer; /* 클릭 가능하도록 커서 변경 */
    }
  </style>
</head>
<body>
<h1>창고 목록 및 위치 조회</h1>

<button onclick="location.href='${pageContext.request.contextPath}/admin/warehouses/register'" style="margin-bottom: 15px;">
  새로운 창고 등록
</button>

<div id="map"></div>

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
  var jsonString = '${jsWarehouseData}';
  var warehouseData = [];
  try {
    if (jsonString && jsonString.trim().length > 0) {
      // JSON 파싱 시 'jsWarehouseData' 변수에 유효한 JSON 문자열이 담겨야 합니다.
      warehouseData = JSON.parse(jsonString.replace(/&quot;/g, '"')); // 혹시 모를 HTML 엔티티 치환 처리
    }
  } catch(e) {
    console.error("창고 데이터 JSON 파싱 오류:", e);
  }

  // 카카오 지도 로드 및 초기화
  kakao.maps.load(function() {
    var container = document.getElementById('map');
    if (!container) {
      console.error("지도 컨테이너(map)를 찾을 수 없습니다.");
      return;
    }

    var defaultCenter = new kakao.maps.LatLng(37.5665, 126.9780); // 서울 시청
    var options = { center: defaultCenter, level: 7 };
    var map = new kakao.maps.Map(container, options);

    var bounds = new kakao.maps.LatLngBounds();
    var hasValidCoords = false;

    if (Array.isArray(warehouseData)) {
      warehouseData.forEach(function(wh) {
        var lat = Number(wh.latitude);
        var lng = Number(wh.longitude);

        // 유효한 좌표가 아니면 건너뛰기
        if (isNaN(lat) || isNaN(lng) || lat === 0 || lng === 0) return;

        hasValidCoords = true;
        var position = new kakao.maps.LatLng(lat, lng);

        // 1. 마커 생성
        var marker = new kakao.maps.Marker({ position: position, map: map });

        // 2. CustomOverlay로 창고 이름 표시 (마커 위에 바로 보이게 함)
        // yAnchor: 1 은 마커의 바로 위에 오버레이가 위치하도록 설정합니다.
        var overlay = new kakao.maps.CustomOverlay({
          position: position,
          content: `<div class="marker-label">${wh.name}</div>`,
          map: map,
          yAnchor: 1
        });

        // 3. InfoWindow 생성
        var infowindow = new kakao.maps.InfoWindow({
          content: `<div style="padding:5px; font-weight:bold;">${wh.name}<br/>${wh.address}</div>`
        });

        // 4. 마커 및 오버레이 클릭 시 InfoWindow 열기
        kakao.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map, marker);
        });
        // 오버레이 클릭 시 마커를 기준으로 InfoWindow 열기
        kakao.maps.event.addListener(overlay, 'click', function() {
          infowindow.open(map, marker);
        });

        // 지도 범위에 좌표 추가
        bounds.extend(position);
      });
    }

    // 창고가 하나라도 유효한 좌표를 가지고 있으면 해당 범위로 지도 이동
    if (hasValidCoords) {
      map.setBounds(bounds);
    } else {
      // 유효한 좌표가 없으면 기본 위치로 설정
      map.setCenter(defaultCenter);
    }
  });
</script>
</body>
</html>