package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.dto.InboundRequestDTO;
import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import com.ssg.wms.inbound.service.InboundMemberService;
import com.ssg.wms.product_ehs.service.ProductServiceImpl;
import com.sun.org.apache.xpath.internal.operations.Mod;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/inbound/member")
public class InboundMemberController {

    private final InboundMemberService inboundService;
    private final ProductServiceImpl productService;
    
    // 관리자가 승인시에 창고 위치 지정할때 창고 리스트 보려고 사용
//    private final WarehouseService warehouseService

    // 입고 요청 화면 이동
    @GetMapping("/request")
    public String getInboundRequestForm(
//            HttpSession session,
                                        Model model) {
        // 로그인한 사용자의 user_id를 자동으로 가져오도록
        Integer memberId = 1;
//        Integer memberId = (Integer) session.getAttribute("loginMemberId");
//        String memberName = (String) session.getAttribute("loginMemberName");
        String memberName = "엄홍길";
        model.addAttribute("memberId", memberId);
        model.addAttribute("memberName", memberName);

        // 로그인한 사용자가 속한 거래처를 자동으로 가져오도록
        int partnerId = 1;
//        int partnerId = (Integer) session.getAttribute("loginMemberBrandId");
//        String partnerName = (String) session.getAttribute("loginMemberBrandId");
        String partnerName = "아디다스";
        model.addAttribute("partnerId", partnerId);
        model.addAttribute("partnerName", partnerName);

        // 카테고리 데이터 로드
        List<CategoryDTO> categories = productService.getCategory();
        model.addAttribute("categories", categories);
        log.info(categories);

        // 입고요청시에 볼 상품 리스트 데이터 로드
        List<ProductDTO> products = productService.getProductsByPartner(partnerId, categoryCd);
        model.addAttribute("products", products);


        return "inbound/member/request";
    }



    // 입고 요청
    @PostMapping("/inbound/member/request")
    public ResponseEntity<InboundRequestDTO> inboundRequest(HttpSession session,
                                                            @Valid @RequestBody InboundRequestDTO inboundRequestDTO) {

        // 로그인한 사용자의 memberId 가져오도록
        Integer memberId = (Integer) session.getAttribute("loginMemberId");
        inboundRequestDTO.setMemberId(memberId);

        InboundRequestDTO request = inboundService.createInbound(inboundRequestDTO);

        return ResponseEntity.ok(request);
    }

    // 입고 요청 목록 조회 (관리자용 - 브랜드, 상태 파라미터로 받아서 검색)

    // 입고 요청 단건 조회

    // 입고 요청 수정

    // 입고 요청 취소


}
