package com.ssg.wms.admin.controller;

import com.ssg.wms.admin.dto.MemberSearchCriteriaDTO;
import com.ssg.wms.admin.dto.StaffDTO;
import com.ssg.wms.admin.service.AdminService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Log4j2
public class AdminController {
//    private final AdminService adminService;

    @GetMapping("/")
    public String getAdminMain() {
        // 메인 화면
        return "admin/connect";
    }

    @GetMapping("/login")
    public String getAdminLogin() {
        // 로그인 화면
        return "admin/login";
    }

    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        // 마이페이지 조회
        return "admin/mypage";
    }

    @GetMapping("/members")
    public String getMembers(@ModelAttribute MemberSearchCriteriaDTO criteria, HttpSession session) {
        // 고객 목록 조회
        return "admin/members";
    }

    @GetMapping("/memebers/{memberId}")
    public String getMembersDetail(@PathVariable long memberId, HttpSession session) {
        // 고객 상세 조회
        return "admin/members/{memberId}";
    }
}
