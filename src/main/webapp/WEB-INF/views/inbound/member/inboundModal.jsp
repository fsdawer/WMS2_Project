<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- 입고 상세 모달 -->
<div class="modal fade" id="inboundModal" tabindex="-1" aria-labelledby="inboundModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <!-- 상품이 많을 수 있으므로 modal-lg -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="inboundModalLabel">입고 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <!-- 입고 기본 정보 -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">입고 번호</label>
                        <input type="text" id="inboundId" class="form-control" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">상태</label>
                        <input type="text" id="inboundStatus" class="form-control" readonly>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">요청자</label>
                        <input type="text" id="partnerName" class="form-control" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">담당자</label>
                        <input type="text" id="staffName" class="form-control" readonly>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">요청일</label>
                        <input type="text" id="inboundRequestedAt" class="form-control" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">입고일</label>
                        <input type="text" id="inboundAt" class="form-control" readonly>
                    </div>
                </div>

                <!-- 상품 리스트 -->
                <h6 class="fw-bold mt-4 mb-2">입고 상품 내역</h6>
                <table class="table table-sm table-bordered">
                    <thead class="table-light">
                    <tr>
                        <th>상품코드</th>
                        <th>상품명</th>
                        <th>수량</th>
                    </tr>
                    </thead>
                    <tbody id="inboundItemsBody">
                    <tr>
                        <td colspan="3" class="text-center">상품 없음</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
