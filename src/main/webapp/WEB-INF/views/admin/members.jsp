<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="admin-header.jsp" %>

    <div class="container">
        <h1>고객 관리</h1>

        <!-- 검색 조건 컨테이너 -->
        <div class="search-container">
            <div class="search-title">검색 조건</div>
            <form class="search-form" method="get" action="${pageContext.request.contextPath}/admin/members">
                <div class="form-group">
                    <label for="keyword">검색어 (이름/아이디)</label>
                    <input type="text" id="keyword" name="keyword"
                           placeholder="이름 또는 아이디를 입력하세요"
                           value="${param.keyword}">
                </div>

                <div class="form-group">
                    <label for="status">상태</label>
                    <select id="status" name="status">
                        <option value="">전체</option>
                        <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                        <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                        <option value="REJECTED" ${param.status == 'REJECTED' ? 'selected' : ''}>승인 거절</option>
                        <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>승인 대기</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="startDate">생성일 (시작)</label>
                    <input type="date" id="startDate" name="startDate"
                           value="${param.startDate}">
                </div>

                <div class="form-group">
                    <label for="endDate">생성일 (종료)</label>
                    <input type="date" id="endDate" name="endDate"
                           value="${param.endDate}">
                </div>

                <div class="button-group">
                    <button type="button" class="btn btn-reset" onclick="resetForm()">초기화</button>
                    <button type="submit" class="btn btn-search">검색</button>
                </div>
            </form>
        </div>

        <!-- 고객 목록 컨테이너 -->
        <div class="list-container">
            <div class="list-header">
                <div class="list-title">고객 목록</div>
                <div class="total-count">전체 <strong>${totalCount != null ? totalCount : 0}</strong>명</div>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>상태</th>
                        <th>생성일</th>
                        <th>수정일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty members}">
                            <tr>
                                <td colspan="7" class="no-data">조회된 고객이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="member" items="${members}" varStatus="status">
                                <tr onclick="viewMemberDetail(${member.memberId})">
                                    <td>${status.count}</td>
                                    <td>${member.loginId}</td>
                                    <td>${member.name}</td>
                                    <td>${member.email}</td>
                                    <td>
                                            <span class="status-badge
                                                ${member.status == 'ACTIVE' ? 'status-active' :
                                                  member.status == 'INACTIVE' ? 'status-inactive' :
                                                  member.status == 'REJECTED' ? 'status-rejected' :
                                                  'status-pending'}">
                                                    ${member.status == 'ACTIVE' ? '활성' :
                                                            member.status == 'INACTIVE' ? '비활성' :
                                                                    member.status == 'REJECTED' ? '정지' :
                                                                            member.status == 'PENDING' ? '승인 대기' : member.status}
                                            </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${member.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${member.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 (선택사항) -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <button ${currentPage == 0 ? 'disabled' : ''}
                            onclick="goToPage(0)">처음</button>
                    <button ${currentPage == 0 ? 'disabled' : ''}
                            onclick="goToPage(${currentPage - 1})">이전</button>

                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                        <button class="${i == currentPage ? 'active' : ''}"
                                onclick="goToPage(${i})">${i + 1}</button>
                    </c:forEach>

                    <button ${currentPage == totalPages - 1 ? 'disabled' : ''}
                            onclick="goToPage(${currentPage + 1})">다음</button>
                    <button ${currentPage == totalPages - 1 ? 'disabled' : ''}
                            onclick="goToPage(${totalPages - 1})">마지막</button>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 상세 정보 모달 -->
    <div id="memberModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>고객 상세 정보</h2>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- AJAX로 로드될 내용 -->
            </div>
            <div class="modal-footer" id="modalFooter">
                <!-- 상태에 따라 동적으로 버튼 표시 -->
            </div>
        </div>
    </div>

<script>
    // 검색 폼 초기화
    function resetForm() {
        document.getElementById('keyword').value = '';
        document.getElementById('status').value = '';
        document.getElementById('startDate').value = '';
        document.getElementById('endDate').value = '';
    }

    // 고객 상세 보기 (모달)
    function viewMemberDetail(memberId) {
        if (!memberId) return;

        // AJAX로 상세 정보 가져오기
        fetch('${pageContext.request.contextPath}/admin/members/' + memberId)
            .then(response => response.json())
            .then(member => {
                displayMemberDetail(member);
            })
            .catch(error => {
                console.error('Error:', error);
                alert('고객 정보를 불러오는데 실패했습니다.');
            });
    }

    // 모달에 고객 정보 표시
    function displayMemberDetail(member) {
        const modalBody = document.getElementById('modalBody');
        const modalFooter = document.getElementById('modalFooter');

        // 날짜 포맷 함수
        const formatDate = (dateString) => {
            if (!dateString) return '-';
            const date = new Date(dateString);
            return date.toLocaleString('ko-KR', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        };

        const formatDateOnly = (dateString) => {
            if (!dateString) return '-';
            const date = new Date(dateString);
            return date.toLocaleDateString('ko-KR');
        };

        // 상태 한글 변환
        const statusText = {
            'ACTIVE': '활성',
            'INACTIVE': '비활성',
            'SUSPENDED': '정지',
            'PENDING': '승인 대기'
        };

        // 상세 정보 표시
        modalBody.innerHTML = `
                <div class="detail-row">
                    <div class="detail-label">회원 ID</div>
                    <div class="detail-value">${member.memberId}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">로그인 ID</div>
                    <div class="detail-value">${member.loginId}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">이름</div>
                    <div class="detail-value">${member.name}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">이메일</div>
                    <div class="detail-value">${member.email}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">전화번호</div>
                    <div class="detail-value">${member.phone || '-'}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">상태</div>
                    <div class="detail-value">
                        <span class="status-badge status-${member.status.toLowerCase()}">
                            ${statusText[member.status] || member.status}
                        </span>
                    </div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">가입일</div>
                    <div class="detail-value">${formatDateOnly(member.createdAt)}</div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">최종 로그인</div>
                    <div class="detail-value">${formatDate(member.lastLoginAt)}</div>
                </div>
            `;

        // 상태에 따른 버튼 표시
        if (member.status === 'PENDING') {
            modalFooter.innerHTML = `
                    <button class="btn btn-reject" onclick="handleMemberStatus(${member.memberId}, 'reject')">거절</button>
                    <button class="btn btn-approve" onclick="handleMemberStatus(${member.memberId}, 'approve')">승인</button>
                    <button class="btn btn-close" onclick="closeModal()">닫기</button>
                `;
        } else {
            modalFooter.innerHTML = `
                    <button class="btn btn-close" onclick="closeModal()">닫기</button>
                `;
        }

        // 모달 표시
        document.getElementById('memberModal').style.display = 'block';
    }

    // 회원 상태 처리 (승인/거절)
    function handleMemberStatus(memberId, action) {
        const actionText = action === 'approve' ? '승인' : '거절';

        if (!confirm(`정말로 이 회원을 ${actionText}하시겠습니까?`)) {
            return;
        }

        // AJAX로 상태 변경 요청
        fetch('${pageContext.request.contextPath}/admin/members/' + memberId + '/' + action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            }
        })
            .then(response => {
                if (response.ok) {
                    alert(`회원 ${actionText} 처리가 완료되었습니다.`);
                    closeModal();
                    location.reload(); // 목록 새로고침
                } else {
                    alert(`회원 ${actionText} 처리에 실패했습니다.`);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert(`회원 ${actionText} 처리 중 오류가 발생했습니다.`);
            });
    }

    // 모달 닫기
    function closeModal() {
        document.getElementById('memberModal').style.display = 'none';
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('memberModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // 페이지 이동
    function goToPage(page) {
        const form = document.querySelector('.search-form');
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'page';
        input.value = page;
        form.appendChild(input);
        form.submit();
    }
</script>

<!-- / Content -->
<%@ include file="admin-footer.jsp" %>
