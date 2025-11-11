package com.ssg.wms.member.controller;

import com.ssg.wms.admin.dto.StaffDTO;
import com.ssg.wms.common.Role;
import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
@Log4j2
public class MemberController {

    private final MemberService memberService;

    @GetMapping("")
    public String getMemberMain() {
        // 메인 화면
        return "member/connect";
    }

    @GetMapping("/login")
    public String getMemberLogin() {
        // 로그인 화면
        return "member/login";
    }

    @PostMapping("/login")
    public String postMemberLogin(@RequestParam("loginId") String id,
                                  HttpSession session,
                                  Model model) {
        // 세션에 저장
        session.setAttribute("loginId", id);
        session.setAttribute("role", Role.MEMBER);

        // 모델에 담아서 뷰로 전달
        model.addAttribute("loginId", id);

        return "member/connect";
    }

    @GetMapping("/register")
    public String getMemberRegister() {
        // 로그인 화면
        return "member/register";
    }

    @PostMapping("/register")
    public String registerMember(@Valid @ModelAttribute MemberDTO memberDTO,
                                 BindingResult bindingResult
                                 ) {
        log.info("memberDTO: " + memberDTO);

        if (bindingResult.hasErrors()) {
            log.info("Member Registration Error");
            return "member/register";
        }

        memberService.insertMember(memberDTO);
        log.info("Member Registration Success");

        return "member/success";
    }

    @Transactional
    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        // 마이페이지 조회
        String id = (String) session.getAttribute("loginId");
        if (id == null) {
            return "redirect:/login"; // 세션 없으면 로그인 페이지로
        }

        // 로그인 ID -> 고유 ID 구하고 고객 정보 얻음
        long memberId = memberService.findMemberIdByMemberLoginId(id);
        MemberDTO memberDTO = memberService.getMemberDetails(memberId);

        model.addAttribute("member", memberDTO);
        return "member/mypage";
    }

}
