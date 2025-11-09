<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../../includes/header.jsp" %>
<%-- 여기에 내용 입력 --%>
<div class="container mt-5">

    <h3>입고 요청</h3>

    <form id="inboundRequestForm" method="post" action="/inbound/member/request">
        <!-- 사용자 정보 (hidden) -->
        <input type="hidden" name="memberId" value="${memberId}"/>

        <!-- 창고 선택 -->
        <div class="mb-3">
            <label for="warehouseId" class="form-label">창고</label>
            <select class="form-select" id="warehouseId" name="warehouseId" required>
                <option value="" disabled selected>선택</option>
                <c:forEach var="wh" items="${warehouses}">
                    <option value="${wh.warehouseId}">${wh.warehouseName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- 입고 품목 테이블 -->
        <h5>입고 품목</h5>
        <table class="table table-bordered" id="inboundItemsTable">
            <thead>
            <tr>
                <th>상품</th>
                <th>수량</th>
                <th>액션</th>
            </tr>
            </thead>
            <tbody>
            <tr class="inboundItemRow">
                <td>
                    <select name="inboundRequestItems[0].productId" class="form-select" required>
                        <option value="" disabled selected>상품 선택</option>
                        <c:forEach var="p" items="${products}">
                            <option value="${p.productId}">${p.productName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td><input type="number" name="inboundRequestItems[0].amount" class="form-control" min="1" required>
                </td>
                <td>
                    <button type="button" class="btn btn-danger btn-sm removeItemBtn">삭제</button>
                </td>
            </tr>
            </tbody>
        </table>

        <button type="button" id="addItemBtn" class="btn btn-secondary btn-sm mb-3">품목 추가</button>
        <br/>
        <button type="submit" class="btn btn-primary">입고 요청</button>
    </form>
</div>
<script>
    let itemIndex = 1; // 신규 row 인덱스

    // 품목 추가
    $('#addItemBtn').click(function () {
        let newRow = `
        <tr class="inboundItemRow">
            <td>
                <select name="inboundRequestItems[${itemIndex}].productId" class="form-select" required>
                    <option value="" disabled selected>상품 선택</option>
                    <c:forEach var="p" items="${products}">
                        <option value="${p.productId}">${p.productName}</option>
                    </c:forEach>
                </select>
            </td>
            <td><input type="number" name="inboundRequestItems[${itemIndex}].amount" class="form-control" min="1" required></td>
            <td><button type="button" class="btn btn-danger btn-sm removeItemBtn">삭제</button></td>
        </tr>`;
        $('#inboundItemsTable tbody').append(newRow);
        itemIndex++;
    });

    // 품목 삭제
    $(document).on('click', '.removeItemBtn', function () {
        $(this).closest('tr').remove();
    });
</script>


<%-- <h4 class="fw-bold p-4">Blank Page</h4> --%>
<%@ include file="../../includes/footer.jsp" %>