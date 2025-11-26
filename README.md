# 🚀 SSG 2차 2팀 프로젝트 

## 📌 프로젝트 소개
- **프로젝트명**: RACL
- **팀명**: 빌더스(Builders)
- **개발 기간**: 2025.11.07 ~ 2025.11.14
- **주요 기능**: WMS 창고관리 (의류 중심)
- **기술 스택**:
  - **Frontend**:
    - HTML5 / CSS3
    - JavaScript (ES6+)
    - jQuery 3.x
    - Bootstrap 5
    - ApexCharts.js
  - **Backend**:
    - Java 17
    - Spring Framework 5.x
    - Spring MVC
    - MyBatis 3.x
    - JSP (JavaServer Pages)
    - Tomcat 9.0
    - HikariCP
    - Gradle
  - **Database**:
    - MySQL 8.x
  - **Tools & Collaboration**:
    - Git
    - GitHub
    - ERD Cloud
    - IntelliJ IDEA

## 👥 팀원
| 역할 | 이름 | GitHub |
|------|------|--------|
| 팀장 | 엄현석 | [@heathcliff4736](https://github.com/heathcliff4736) |
| Git Master | 김형근 | [@geeunii](https://github.com/geeunii) |
| 팀원 | 박용헌 | [@00parkyh](https://github.com/00parkyh) |
| 팀원 | 김도윤 | [@doyooning](https://github.com/doyooning) |
| 팀원 | 장현우 | [@fsdawer](https://github.com/fsdawer) |
| 팀원 | 이재훈 | [@jaehoon0321](https://github.com/jaehoon0321) |

---

## 🌿 브랜치 전략

### 브랜치 구조
```
main (배포용 - 최종 완성본만)
  ↑
develop (개발 통합 - 작업 중인 코드)
  ↑
dev/개인 branch (개인 작업 브랜치)
```

### 브랜치 네이밍 규칙
```bash
dev/개인 branch        # 예: dev/KHG
fix/버그명-이름        # 예: fix/signup-bug-KHG
docs/문서명-이름       # 예: docs/readme-update-KHG
refactor/대상-이름     # 예: refactor/api-KHG
```

---

## 📝 커밋 메시지 규칙

### 타입
| 타입 | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `docs` | 문서 수정 |
| `style` | 코드 포맷팅 (기능 변경 없음) |
| `refactor` | 코드 리팩토링 |
| `test` | 테스트 코드 |
| `chore` | 빌드, 설정 파일 수정 |

### 작성 예시
```bash
git commit -m "feat: 사용자 로그인 API 구현"
git commit -m "fix: 회원가입 시 이메일 중복 체크 버그 수정"
git commit -m "docs: API 명세서 업데이트"
```

---

## 🔄 작업 프로세스

### 1️⃣ 작업 시작
```bash
git checkout develop
git pull origin develop
git checkout dev/KHG(개인 브랜치)
--- 또는 ---
git fetch origin
git merge origin develop
```

### 2️⃣ 작업 & 커밋
```bash
# 파일 수정 후...
git add .
git commit -m "feat: 로그인 페이지 구현"
git push origin dev/KHG(개인 브랜치)
```

### 3️⃣ PR 생성 (GitHub)
1. **Pull requests** 탭 → **New pull request**
2. `base: develop` ← `compare: dev/KHG(개인 브랜치)`
3. 제목/설명 작성 (템플릿 활용)
4. **Reviewers** 최소 1명 지정
5. **Create pull request** 클릭

### 4️⃣ 리뷰 & Merge
- 리뷰어 1명 이상 **Approve** 필요
- 충돌 해결 후 Merge
- Merge 후 브랜치 자동 삭제

### 5️⃣ Merge 후 정리
```bash
git checkout develop
git pull origin develop
git branch -d dev/KHG(개인 브랜치)
```

---

## 👀 코드 리뷰 규칙

- **리뷰 기한**: PR 생성 후 24시간 이내
- **최소 인원**: 1명 이상 Approve
- **리뷰 태도**:
  - 💡 제안: 더 나은 방법 제시
  - ❓ 질문: 궁금한 점
  - ⚠️ 수정 필요: 명확한 이유와 함께
  - ✅ LGTM: Looks Good To Me!

---

## 🔨 충돌 해결 방법

### 충돌 발생 시
```bash
# 1. develop 최신화
git checkout develop
git pull origin develop

# 2. 내 브랜치로 돌아와서 병합
git checkout dev/KHG(개인 브랜치)
git merge develop

# 3. 충돌 파일 수정 (VS Code에서 쉽게 가능)

# 4. 해결 후 커밋
git add .
git commit -m "chore: merge conflict 해결"
git push origin dev/KHG(개인 브랜치)
```

### VS Code에서 충돌 해결
- `Accept Current Change` (내 코드)
- `Accept Incoming Change` (다른 사람 코드)
- `Accept Both Changes` (둘 다)
- 또는 직접 수정

---

## ⚠️ 주의사항

### ❌ 절대 금지
- `main`, `develop` 브랜치에 직접 push
- 다른 사람 브랜치에 push

### ✅ 꼭 지키기
- 작업 시작 전 항상 `git pull origin develop`
- 충돌 발생 시 팀원과 즉시 소통
- PR은 작은 단위로 자주
- 커밋 메시지 규칙 준수

---

## 🚨 긴급 상황

### Hotfix가 필요한 경우
```bash
git checkout main
git checkout -b hotfix/버그명-이름
# 수정 후
git push origin hotfix/버그명-이름
# main과 develop 모두에 PR 생성
```

---

## 🔧 개발 환경 설정

### 최초 1회 설정
```bash
# 1. 저장소 클론

# 2. Git 사용자 정보 설정
git config user.name "홍길동"
git config user.email "gildong@example.com"

# 3. 의존성 설치
npm install  # 또는 필요한 설치 명령어
```

---

## 📦 주요 기능 구현: 출고(Outbound) 시스템

### 1. 기능 개요 및 목표

출고 시스템은 재고를 창고 외부로 내보내는 프로세스를 관리하는 핵심 모듈입니다. 회원이 직접 출고를 요청하면, 관리자가 이를 승인하고 배차 및 운송장 발행까지 처리하는 전 과정을 자동화하고 추적 가능하도록 구현했습니다.

* **구현 범위:** 출고 요청 생성/조회/수정/삭제 (회원), 출고 지시서 목록 조회 및 배차/승인 처리 (관리자).
* **사용자 역할 분리:** `OutboundController.java`를 통해 일반 회원(거래처)의 출고 요청 관리 기능을 제공하며, `outboundOrderController.java`를 통해 관리자(Admin)의 출고 지시 및 배차 관리 기능을 분리하여 처리합니다.

### 2. 주요 기능 및 상세 구현

#### 2.1. 회원(거래처) 기능 (Outbound Request)

| 기능 분류 | 상세 내용 | 관련 파일 |
| :--- | :--- | :--- |
| **목록 조회** | 로그인한 회원의 출고 요청 목록을 조회하며, 상태(`APPROVED`, `PENDING`, `COMPANION`)별 필터링을 지원합니다. | `OutboundController.java`, `OutboundServiceImpl.java` |
| **요청 등록** | 회원이 품목 목록을 포함하여 출고 요청을 생성합니다 (`POST /member/outbound/request`). **요청 등록 시, 트랜잭션 내에서 `outboundRequest`, `outboundItem` 등록과 함께 `outboundOrder` (출고지시서)가 '승인대기' 상태로 자동 생성됩니다.**. | `OutboundController.java`, `OutboundServiceImpl.java` |
| **상세/수정/삭제** | 개별 출고 요청의 상세 정보 조회, 수정(PUT), 삭제(DELETE) 기능을 제공합니다. **요청이 이미 'APPROVED'(승인) 상태인 경우 수정 및 삭제는 불가능**하도록 비즈니스 로직을 구현하여 데이터 무결성을 보장합니다. | `OutboundController.java`, `OutboundServiceImpl.java` |
| **상품 조회** | 출고 요청 작성 시, 회원의 파트너 ID와 카테고리 코드를 기준으로 해당 파트너가 취급하는 상품 목록을 조회합니다 (`/products/byCategory`). | `OutboundController.java` |

#### 2.2. 관리자(Admin) 기능 (Outbound Order & Dispatch)

| 기능 분류 | 상세 내용 | 관련 파일 |
| :--- | :--- | :--- |
| **지시서 목록 조회** | 전체 출고 지시서 목록을 조회하고, 요청일자 기준으로 내림차순 정렬하여 표시합니다. | `outboundOrderController.java`, `outboundOrderMapper.xml` |
| **배차 등록 및 상태 변경** | 특정 출고 지시서에 대해 배차 정보를 등록하고 승인 상태를 업데이트합니다 (`POST /{instructionId}/register`). | `outboundOrderController.java` |
| **트랜잭션 기반 승인 처리** | **관리자가 '승인' 처리를 수행하는 경우, 하나의 트랜잭션 내에서 여러 테이블을 순차적으로 업데이트합니다.** | `OutboundOrderServiceImpl.java` |
| **자동화 프로세스 (승인 시)** | 승인 시 `OutboundOrderServiceImpl`에서 다음 단계를 자동 처리합니다: 1. `outboundOrder` 상태 업데이트. 2. 연관된 `outboundRequest`의 상태 및 창고 ID 업데이트. 3. 배차(`Dispatch`) 정보 신규 생성 또는 수정. 4. 고유 운송장 번호를 생성하여 운송장(`Waybill`) 레코드 생성. | `OutboundOrderServiceImpl.java`, `outboundOrderMapper.xml` |
| **유효성 검증** | 배차 등록 시, 요청된 적재 박스 수(`loadedBox`)가 차량의 최대 적재량(`maximumBOX`)을 초과하는지 검증합니다. | `outboundOrderController.java` |

### 3. 도메인 및 데이터 구조

| 도메인 엔티티 | DTO 클래스 | 주요 필드 및 역할 |
| :--- | :--- | :--- |
| **출고 요청** | `OutboundDTO` | `outboundRequestId`, `outboundDate`, `approvedStatus` (승인 상태), `requestedDeliveryDate`, `outboundRequestItems` (요청 품목 리스트) 등 |
| **출고 지시서** | `OutboundOrderDTO` | `approvedOrderID`, `outboundRequestID` (FK), `approvedStatus`, `carId`, `driverName`, `loadedBox`, `maximumBOX`, `warehouseId` (배차 및 창고 정보 포함) |
| **상태 관리** | `OutboundStatus` | **열거형(Enum)**으로 상태를 정의 (`APPROVED`: 승인, `PENDING`: 승인대기, `COMPANION`: 반려)하고, 한글-영문 변환을 위한 정적 메서드 `fromKorean`을 제공하여 비즈니스 로직에 활용. |

### 4. 기술 스택 및 핵심 기술

* **언어 및 프레임워크:** Java, Spring Framework (Controller, Service, Repository 패턴)
* **데이터베이스:** MyBatis (Mapper)
  * `outboundOrderMapper.xml`을 통해 출고 지시서 목록 조회 및 상세 조회를 위한 복합적인 SQL 쿼리(JOIN)를 관리합니다.
* **트랜잭션 관리:** `@Transactional` 어노테이션을 사용하여 출고 요청 생성(`createOutboundRequest`) 및 출고 지시서 상태 업데이트(`updateOrderStatus`)와 같은 핵심 비즈니스 로직에 **데이터 일관성**을 위한 트랜잭션 처리를 적용했습니다.
* **RESTful API:** 회원 기능을 위한 `OutboundController`에서 `@RestController` 대신 `@Controller`와 `@ResponseBody`를 혼용하여 페이지 반환과 JSON 응답을 모두 처리할 수 있도록 구현했습니다.
* **데이터 매핑:** DTO 클래스에 `@Data`, `@Builder`, `@AllArgsConstructor`, `@NoArgsConstructor` (Lombok)를 활용하여 데이터 객체 코드를 단순화하고 가독성을 높였습니다.
* **로그 관리:** `log4j2`를 사용하여 요청 처리 과정 및 중요 트랜잭션의 성공/실패 여부를 상세히 로깅하여 문제 발생 시 추적 용이성을 확보했습니다.

---

**마지막 업데이트**: 2025.11.12
