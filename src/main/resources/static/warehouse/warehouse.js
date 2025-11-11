/**
 * warehouse.js
 * 공통 JS 파일: 창고 등록/목록/상세 페이지 지도 및 이름 중복 확인
 */

// ---------------------- 1. 창고 이름 중복 확인 ----------------------
function checkDuplication() {
    const name = $('#name').val().trim();
    const resultElement = $('#nameCheckResult');
    const isNameChecked = $('#isNameChecked');

    if (name === "") {
        resultElement.text("이름을 입력해주세요.").css('color', 'orange');
        isNameChecked.val("false");
        return;
    }

    // CONTEXT_PATH 변수는 JSP 파일에서 <script> 태그 등으로 정의되어 있어야 합니다.
    const url = CONTEXT_PATH + '/api/warehouses/check/name';

    $.ajax({
        url: url,
        type: 'GET',
        data: { name: name },
        dataType: 'json',
        success: function(isDuplicated) {
            if (isDuplicated === true) {

                resultElement.text("이미 사용 중인 이름입니다.").css('color', 'red');
                isNameChecked.val("false");
                alert("중복된 이름입니다. 다른 이름을 사용해주세요."); // 팝업 추가
            } else {

                resultElement.text("사용 가능한 이름입니다.").css('color', 'green');
                isNameChecked.val("true");
                alert("사용 가능한 이름입니다."); // 팝업 추가
            }
        },
        error: function(xhr) {
            console.error("중복 확인 AJAX 호출 실패. Status:", xhr.status, "URL:", url);
            resultElement.text("서버 또는 네트워크 오류 발생").css('color', 'red').css('font-weight', 'bold');
            isNameChecked.val("false");
            alert("중복 확인에 실패했습니다.");
        }
    });
}

// ---------------------- 2. 등록폼 유효성 검사 ----------------------
function validateForm() {
    const nameChecked = document.getElementById("isNameChecked").value === "true";
    if (!nameChecked) {
        alert("창고 이름 중복 확인을 해주세요.");
        return false;
    }

    // 추가: 위도/경도 입력 확인
    const lat = document.getElementById("latitude").value;
    const lng = document.getElementById("longitude").value;
    if (!lat || !lng) {
        alert("창고 주소를 입력하고 [주소로 위치 확인] 버튼을 눌러 위치를 설정해주세요.");
        return false;
    }

    return true;
}

// ---------------------- 3. 주소 검색 및 좌표 표시 (개선됨) ----------------------
function searchAddress() {
    const address = document.getElementById("address").value.trim();
    // JSP 파일의 <span id="coordResult"> 요소에 메시지를 표시합니다.
    const resultElement = document.getElementById("coordResult");

    if (!address) {
        alert("주소를 입력해주세요.");
        if (resultElement) {
            resultElement.textContent = "주소를 입력해 주세요.";
            resultElement.style.color = 'orange';
        }
        return;
    }

    // 검색 시작 시 사용자에게 피드백 제공
    if (resultElement) {
        resultElement.textContent = "위치 확인 중...";
        resultElement.style.color = 'gray';
    }


    const geocoder = new kakao.maps.services.Geocoder();
    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            const lat = parseFloat(result[0].y);
            const lng = parseFloat(result[0].x);

            // 폼 필드에 위도/경도 값 저장
            document.getElementById("latitude").value = lat;
            document.getElementById("longitude").value = lng;

            const mapContainer = document.getElementById("map");
            const position = new kakao.maps.LatLng(lat, lng);
            const mapOption = { center: position, level: 3 };
            const map = new kakao.maps.Map(mapContainer, mapOption);

            const marker = new kakao.maps.Marker({ position: position });
            marker.setMap(map);

            // 사용자에게 성공적으로 좌표를 찾았음을 알림 (사용자 편의성 향상)
            if (resultElement) {
                resultElement.textContent = `위치 확인 완료: Lat ${lat.toFixed(4)}, Lng ${lng.toFixed(4)}`;
                resultElement.style.color = 'green';
            }
        } else {
            alert("주소를 찾을 수 없습니다. 다시 입력해주세요.");
            // 사용자에게 실패를 알림 (사용자 편의성 향상)
            if (resultElement) {
                resultElement.textContent = "주소를 찾을 수 없습니다.";
                resultElement.style.color = 'red';
            }
        }
    });
}

// ---------------------- 4. 등록 페이지 지도 초기화 ----------------------
function initMapForRegister(mapId) {
    if (typeof kakao === "undefined" || typeof kakao.maps === "undefined") {
        console.error("Kakao 지도 API가 로드되지 않았습니다."); return;
    }

    const mapContainer = document.getElementById(mapId);
    // 기본 위치를 서울 시청으로 설정
    const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
    const mapOption = { center: defaultPosition, level: 7 }; // 넓은 범위의 레벨
    const map = new kakao.maps.Map(mapContainer, mapOption);
}

// ---------------------- 5. 목록 페이지 지도 표시 ----------------------
function initMapForList(mapId, data) {
    if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined' || !Array.isArray(data) || data.length === 0) {
        // 지도를 표시할 수 없는 경우 처리
        console.warn("창고 목록 데이터가 없거나 Kakao API가 로드되지 않아 지도를 표시할 수 없습니다.");
        return;
    }

    const mapContainer = document.getElementById(mapId);

    // 데이터가 있을 경우 첫 번째 창고를 기준으로 중심 설정 (아니면 서울)
    const first = data.find(w => w.latitude && w.longitude);
    const lat = Number(first?.latitude) || 37.566826;
    const lng = Number(first?.longitude) || 126.9786567;
    const center = new kakao.maps.LatLng(lat, lng);

    const map = new kakao.maps.Map(mapContainer, { center, level: 8 });
    const bounds = new kakao.maps.LatLngBounds();

    data.forEach(w => {
        if (w.latitude && w.longitude) {
            const position = new kakao.maps.LatLng(Number(w.latitude), Number(w.longitude));

            // 마커 생성
            const marker = new kakao.maps.Marker({ position, map });

            // 항상 보이는 말풍선(CustomOverlay) 생성
            const overlay = new kakao.maps.CustomOverlay({
                map: map,
                position: position,
                content: `<div style="
                    background: #fff;
                    border: 1px solid #000;
                    padding: 3px 6px;
                    font-weight: bold;
                    font-size: 12px;
                    border-radius: 4px;
                    box-shadow: 2px 2px 2px rgba(0,0,0,0.3);
                    white-space: nowrap;
                    text-align: center;
                ">${w.name}</div>`,
                yAnchor: 1 // 마커 바로 위
            });

            bounds.extend(position);
        }
    });

    // 모든 마커가 보이도록 지도 범위 재설정
    if (data.length > 0) {
        map.setBounds(bounds);
    }
}

// ---------------------- 6. 상세 페이지 지도 표시 ----------------------
function initMapForDetail(mapId, warehouse) {
    if (!warehouse || !warehouse.latitude || !warehouse.longitude) return;

    const lat = Number(warehouse.latitude);
    const lng = Number(warehouse.longitude);
    const position = new kakao.maps.LatLng(lat, lng);
    const mapContainer = document.getElementById(mapId);

    const mapOption = { center: position, level: 4 };
    const map = new kakao.maps.Map(mapContainer, mapOption);

    const marker = new kakao.maps.Marker({ position });
    marker.setMap(map);

    // 창고 이름 표시
    const overlay = new kakao.maps.CustomOverlay({
        map: map,
        position: position,
        content: `<div style="
            background: #fff;
            border: 1px solid #000;
            padding: 3px 6px;
            font-weight: bold;
            font-size: 12px;
            border-radius: 4px;
            box-shadow: 2px 2px 2px rgba(0,0,0,0.3);
            white-space: nowrap;
            text-align: center;
        ">${warehouse.name}</div>`,
        yAnchor: 1
    });
}