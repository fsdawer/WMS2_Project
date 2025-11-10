<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String contextPath = request.getContextPath(); %>
<%@ include file="../../member/member-header.jsp" %>

<div class="container mt-4">
    <h4 class="fw-bold mb-3">입고 요청 목록</h4>

    <!-- 입고 요청 리스트 테이블 -->
    <table class="table table-bordered" id="inboundTable">
        <thead>
        <tr>
            <th>입고 번호</th>
            <th>요청자</th>
            <th>요청일시</th>
            <th>
                상태
                <!-- 상태 필터 드롭다운 -->
                <select id="statusFilter" class="form-select w-auto d-inline mb-3">
                    <option value="">전체</option>
                    <option value="request" ${param.status == 'request' ? 'selected' : ''}>대기</option>
                    <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>취소</option>
                    <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>승인</option>
                    <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>반려</option>
                </select>
            </th>
        </tr>
        </thead>
        <tbody id="inboundTableBody">
        <c:forEach var="item" items="${list}">
            <tr style="cursor:pointer;">
                <td>${item.inboundId}</td>
                <td>${item.memberName}</td>
                <td>${item.inboundRequestedDate}</td>
                <td>${item.inboundStatusKor}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty list}">
            <tr>
                <td colspan="4" class="text-center">조회된 데이터가 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<!-- 모달 JSP 인클루드 -->
<%@ include file="inboundModal.jsp" %>

<!-- axios, bootstrap, jQuery -->
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function() {
        // 상태 필터 변경 시 리스트 새로고침
        $("#statusFilter").change(function() {
            var status = $(this).val();

            $.ajax({
                url: "<%=contextPath%>/inbound/member/list",
                type: "get",
                data: { status: status },
                success: function(data) {
                    var newBody = $(data).find("#inboundTableBody").html();
                    $("#inboundTableBody").html(newBody);
                },
                error: function() {
                    alert("리스트 조회 중 오류가 발생했습니다.");
                }
            });
        });
    });

    // 테이블 행 클릭 시 상세 모달 띄우기
    $(document).on('click', '#inboundTableBody tr', function() {
        var inboundId = $(this).find('td:first').text().trim();
        openInboundModal(inboundId);
    });

    // 모달 관련 전역 변수
    const inboundModalElement = document.getElementById('inboundModal');
    const inboundModal = new bootstrap.Modal(inboundModalElement);

    // 상세 조회 및 모달 표시
    function openInboundModal(inboundId) {
        axios.get("<%=contextPath%>/inbound/member/" + inboundId) // 수정된 경로
            .then(function(response) {
                const data = response.data;
                if (!data) {
                    alert('데이터를 불러올 수 없습니다.');
                    return;
                }

                // 상세 데이터 세팅
                document.getElementById('inboundId').value = data.inboundId;
                document.getElementById('inboundStatus').value = data.inboundStatus;
                document.getElementById('partnerName').value = data.partnerName || '';
                document.getElementById('memberName').value = data.memberName || '';
                document.getElementById('staffName').value = data.staffName || '';
                document.getElementById('inboundRequestedAt').value =
                    data.inboundRequestedAt ? data.inboundRequestedAt.substring(0, 10) : '';
                document.getElementById('inboundAt').value =
                    data.inboundAt ? data.inboundAt.substring(0, 10) : '';

                // 상품 목록 테이블 초기화 및 추가
                const tbody = document.getElementById('inboundItemsBody');
                tbody.innerHTML = '';
                if (data.inboundItems && data.inboundItems.length > 0) {
                    data.inboundItems.forEach(function(item) {
                        const row = `
                            <tr>
                                <td>${item.productId}</td>
                                <td>${item.productName}</td>
                                <td>${item.quantity}</td>
                            </tr>`;
                        tbody.insertAdjacentHTML('beforeend', row);
                    });
                } else {
                    tbody.innerHTML = '<tr><td colspan="3" class="text-center">상품 없음</td></tr>';
                }

                inboundModal.show();
            })
            .catch(function(error) {
                console.error(error);
                if (error.response && error.response.status === 403) {
                    alert('해당 입고 내역에 접근할 권한이 없습니다.');
                } else if (error.response && error.response.status === 404) {
                    alert('입고 내역을 찾을 수 없습니다.');
                } else {
                    alert('입고 상세 조회 중 오류가 발생했습니다.');
                }
            });
    }
</script>

<%@ include file="../../member/member-footer.jsp" %>
