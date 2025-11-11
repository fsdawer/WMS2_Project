<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String contextPath = request.getContextPath(); %>
<%@ include file="../../member/member-header.jsp" %>

<div class="container mt-4">
    <h4 class="fw-bold mb-3">입고 요청 목록</h4>

    <!-- 입고 요청 리스트 테이블 -->
    <table class="table table-bordered" id="inboundTable">
        <thead>
        <tr>
            <th>입고 번호</th>
            <th>브랜드</th>
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
            <tr style="cursor:pointer" data-inbound-id="${item.inboundId}">
                <td>${item.inboundId}</td>
                <td>${item.partnerName}</td>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    $(document).ready(function() {
        const inboundModalElement = document.getElementById('inboundModal');
        const inboundModal = new bootstrap.Modal(inboundModalElement);

        // 전역 변수 선언
        let categories = [];
        let products = [];

        function formatDate(dateInput) {
            if (!dateInput) return '';
            if (typeof dateInput === 'string') return dateInput.length >= 16 ? dateInput.substring(0,16).replace('T',' ') : dateInput;
            if (dateInput instanceof Date) return dateInput.toISOString().substring(0,16).replace('T',' ');
            return String(dateInput);
        }

        // 상품 렌더링 함수
        function renderInboundItems(items, categories, products) {
            const tbody = document.getElementById('inboundItemsBody');
            tbody.innerHTML = '';

            if (!items || items.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">입고 상품이 없습니다.</td></tr>';
                return;
            }

            items.forEach((item, index) => {
                // 카테고리 select
                let categoryOptions = '';
                categories.forEach(function(c) {
                    const selected = c.categoryCd === item.categoryCd ? 'selected' : '';
                    categoryOptions += '<option value="' + c.categoryCd + '" ' + selected + '>' + c.categoryName + '</option>';
                });

                // 초기에는 현재 상품만 표시 (DB에서 가져온 데이터)
                const initialProductOption = '<option value="' + item.productId + '" data-category="' + item.categoryCd + '" selected>' + item.productName + '</option>';

                const row = '<tr>' +
                    '<td>' +
                    '<select class="form-select categorySelect" data-original-category="' + item.categoryCd + '">' +
                    categoryOptions +
                    '</select>' +
                    '</td>' +
                    '<td>' +
                    '<select class="form-select productSelect" data-original-product="' + item.productId + '">' +
                    initialProductOption +
                    '</select>' +
                    '</td>' +
                    '<td class="text-end">' +
                    '<input type="number" class="form-control quantity" value="' + item.quantity + '" min="1"/>' +
                    '</td>' +
                    '<td>' +
                    '<button type="button" class="btn btn-sm btn-danger removeItemBtn">삭제</button>' +
                    '</td>' +
                    '</tr>';

                tbody.insertAdjacentHTML('beforeend', row);
            });
        }


        // 카테고리 변경 시 상품 목록 API 호출
        $(document).on('change', '.categorySelect', function() {
            const partnerId = $('#inboundModal').data('partnerId');
            const selectedCategory = $(this).val();
            const productSelect = $(this).closest('tr').find('.productSelect');

            if (!selectedCategory) {
                productSelect.html('<option value="">카테고리를 먼저 선택하세요</option>').prop('disabled', true);
                return;
            }

            // 로딩 표시
            productSelect.html('<option>로딩 중...</option>').prop('disabled', true);

            // API 호출하여 해당 카테고리+거래처의 상품 목록 가져오기
            axios.get('<%=contextPath%>/products/by-category-and-partner', {
                params: {
                    categoryCd: selectedCategory,
                    partnerId: partnerId
                }
            })
                .then(function(response) {
                    const products = response.data;
                    productSelect.empty().prop('disabled', false);

                    if (!products || products.length === 0) {
                        productSelect.append('<option value="">상품이 없습니다</option>');
                        return;
                    }

                    products.forEach(function(p) {
                        productSelect.append('<option value="' + p.productId + '" data-category="' + p.categoryCd + '">' + p.productName + '</option>');
                    });
                })
                .catch(function(err) {
                    console.error('상품 목록 조회 오류:', err);
                    productSelect.html('<option value="">조회 실패</option>').prop('disabled', false);
                    alert('상품 목록을 불러오는데 실패했습니다.');
                });
        });

        // 모달 열기
        function openInboundModal(inboundId) {
            axios.get('<%=contextPath%>/inbound/member/' + inboundId)
                .then(function(response) {
                    const data = response.data;

                    if (!data) {
                        alert('데이터를 불러올 수 없습니다.');
                        return;
                    }

                    // 전역 변수 초기화
                    categories = data.categories || [];
                    products = data.products || [];

                    // partnerId를 저장
                    $('#inboundModal').data('partnerId', data.partnerId);

                    // 기본 정보
                    document.getElementById('inboundId').value = data.inboundId || '';
                    document.getElementById('inboundStatus').value = data.inboundStatusKor || '';
                    document.getElementById('warehouseName').value = data.warehouseName || '미지정';
                    document.getElementById('partnerName').value = data.partnerName || '';
                    document.getElementById('memberName').value = data.memberName || '';
                    document.getElementById('staffName').value = data.staffName || '미지정';
                    document.getElementById('inboundRequestedAt').value = formatDate(data.inboundRequestedAt);
                    document.getElementById('inboundAt').value = formatDate(data.inboundAt) || '미지정';

                    // 반려 사유
                    const rejectSection = document.getElementById('rejectReasonSection');
                    if (data.inboundStatus === 'rejected' && data.inboundRejectReason) {
                        document.getElementById('inboundRejectReason').value = data.inboundRejectReason;
                        rejectSection.style.display = 'block';
                    } else {
                        rejectSection.style.display = 'none';
                    }

                    // 상품 렌더링
                    renderInboundItems(data.inboundItems, categories, products);

                    inboundModal.show();
                })
                .catch(function(err) {
                    console.error('입고 상세 조회 오류:', err);
                    alert('입고 상세 조회 중 오류가 발생했습니다.');
                });
        }

        // 테이블 행 클릭
        $(document).on('click', '#inboundTableBody tr', function() {
            const inboundId = $(this).find('td:first').text().trim();
            if (inboundId) openInboundModal(inboundId);
        });

        // 상품 select 변경 시 category 자동 설정
        $(document).on('change', '.productSelect', function() {
            const selected = this.selectedOptions[0];
            if (selected) {
                $(this).closest('tr').find('.categorySelect').val(selected.dataset.category);
            }
        });

        // 상품 삭제
        $(document).on('click', '.removeItemBtn', function() {
            $(this).closest('tr').remove();
        });

        // 상품 추가
        $('#addInboundItemBtn').click(function() {
            const tbody = document.getElementById('inboundItemsBody');
            let categoryOptions = '<option value="">카테고리 선택</option>';
            categories.forEach(function(c) {
                categoryOptions += '<option value="' + c.categoryCd + '">' + c.categoryName + '</option>';
            });

            const row = '<tr>' +
                '<td>' +
                '<select class="form-select categorySelect">' +
                categoryOptions +
                '</select>' +
                '</td>' +
                '<td>' +
                '<select class="form-select productSelect" disabled>' +
                '<option value="">카테고리를 먼저 선택하세요</option>' +
                '</select>' +
                '</td>' +
                '<td class="text-end"><input type="number" class="form-control quantity" value="1" min="1"/></td>' +
                '<td><button type="button" class="btn btn-sm btn-danger removeItemBtn">삭제</button></td>' +
                '</tr>';
            tbody.insertAdjacentHTML('beforeend', row);
        });

        // 전역 노출
        window.openInboundModal = openInboundModal;
    });
</script>




<%@ include file="../../member/member-footer.jsp" %>
