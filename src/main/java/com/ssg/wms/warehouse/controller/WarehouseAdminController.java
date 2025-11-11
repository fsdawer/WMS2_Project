package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.dto.*;
import com.ssg.wms.warehouse.service.WarehouseAdminService;
import com.ssg.wms.warehouse.service.WarehouseMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;

import javax.validation.Valid;
import java.util.List;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/admin/warehouses")
public class WarehouseAdminController {

    private final WarehouseAdminService warehouseAdminService;
    private final WarehouseMemberService memberService;
    private final ObjectMapper objectMapper;
    private static final Long MOCK_ADMIN_ID = 1L;

    @Autowired
    public WarehouseAdminController(
            WarehouseAdminService warehouseAdminService,
            @Qualifier("warehousesMemberServiceImpl")
            WarehouseMemberService memberService,
            ObjectMapper objectMapper) {
        this.warehouseAdminService = warehouseAdminService;
        this.memberService = memberService;
        this.objectMapper = objectMapper;
    }

    // ------------------- 1. View Controller (화면 로드 및 폼 처리) -------------------

    @GetMapping({"", "/location"})
    public String adminListIndex(@ModelAttribute("searchForm") WarehouseSearchDTO searchForm, Model model) {

        List<WarehouseListDTO> list = warehouseAdminService.findWarehouses(searchForm);
        model.addAttribute("warehouseList", list);
        model.addAttribute("userRole", "ADMIN");

        // ✨ JSON 변환 및 모델 추가 로직 ✨
        try {
            String jsonList = objectMapper.writeValueAsString(list);
            model.addAttribute("jsWarehouseData", jsonList);
        } catch (Exception e) {
            System.err.println("WarehouseListDTO JSON 변환 오류: " + e.getMessage());
            model.addAttribute("jsWarehouseData", "[]");
        }

        return "warehouse/list";
    }

    @GetMapping("/register")
    public String getWarehouseRegisterView(Model model) {
        // DTO 객체가 이미 Flash Attribute로 넘어왔다면 재사용
        if (!model.containsAttribute("saveDTO")) {
            model.addAttribute("saveDTO", new WarehouseSaveDTO());
        }
        return "warehouse/register";
    }

    @PostMapping("/register")
    public String registerNewWarehouse(
            @Valid @ModelAttribute("saveDTO") WarehouseSaveDTO saveDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes) {

        // 1. DTO 유효성 검사 (바인딩 오류 및 @Valid 검사)
        if (bindingResult.hasErrors()) {
            // BindingResult와 입력 데이터를 Flash Attribute로 전달하여, GET /register 뷰에서 오류 및 데이터를 복원하도록 처리
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            return "redirect:/admin/warehouses/register";
        }

        try {
            saveDTO.setAdminId(MOCK_ADMIN_ID);
            Long newWarehouseId = warehouseAdminService.saveWarehouse(saveDTO);

            // 2. 성공: 창고 리스트 페이지로 리다이렉트
            redirectAttributes.addFlashAttribute("message", "✅ " + newWarehouseId + "번 창고 등록이 완료되었습니다.");
            return "redirect:/admin/warehouses";

        } catch (IllegalArgumentException e) {
            // 3. 비즈니스 오류 (예: 이름 중복, 층수 초과 등)
            // BindingResult에 필드 오류를 추가하고, 데이터와 함께 리다이렉트
            bindingResult.rejectValue("name", "name.duplicate", e.getMessage()); // 이름 중복은 name 필드에 연결
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            redirectAttributes.addFlashAttribute("error", "비즈니스 오류: " + e.getMessage()); // 일반 오류 메시지 전달
            return "redirect:/admin/warehouses/register";

        } catch (Exception e) {
            // 4. 시스템/API 오류 (예: Geocoding 실패, DB 연결 오류 등)
            // Global 오류 메시지를 BindingResult에 추가하고, 데이터와 함께 리다이렉트
            bindingResult.reject("globalError", "시스템 오류로 등록 실패: " + e.getMessage());
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            redirectAttributes.addFlashAttribute("error", "시스템 오류: 등록 중 예상치 못한 오류 발생."); // 일반 오류 메시지 전달

            // 디버깅을 위해 콘솔에 예외 출력
            e.printStackTrace();
            return "redirect:/admin/warehouses/register";
        }
    }

    // ------------------- (나머지 메서드는 변경 없음) -------------------

    @GetMapping("/{whid}")
    public String getAdminDetailView(@PathVariable("whid") Long warehouseId, Model model, RedirectAttributes redirectAttributes) {
        try {
            WarehouseDetailDTO detail = memberService.findWarehouseDetailById(warehouseId);
            model.addAttribute("detail", detail);
            model.addAttribute("userRole", "ADMIN");
            return "warehouse/detail";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "조회하려는 창고 정보를 찾을 수 없습니다.");
            return "redirect:/admin/warehouses";
        }
    }

    @GetMapping("/{whid}/modify")
    public String getModifyForm(@PathVariable("whid") Long warehouseId, Model model, RedirectAttributes redirectAttributes) {
        try {
            WarehouseDetailDTO detailDTO = memberService.findWarehouseDetailById(warehouseId);
            model.addAttribute("detailDTO", detailDTO);

            if (!model.containsAttribute("updateDTO")) { model.addAttribute("updateDTO", new WarehouseUpdateDTO()); }

            model.addAttribute("userRole", "ADMIN");
            return "warehouse/modify";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "수정하려는 창고 정보를 찾을 수 없습니다.");
            return "redirect:/admin/warehouses";
        }
    }

    @PostMapping("/{whid}")
    public String updateWarehouse(@PathVariable("whid") Long warehouseId,
                                  @Valid @ModelAttribute("updateDTO") WarehouseUpdateDTO updateDTO,
                                  BindingResult bindingResult,
                                  RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.updateDTO", bindingResult);
            redirectAttributes.addFlashAttribute("updateDTO", updateDTO);
            return "redirect:/admin/warehouses/" + warehouseId + "/modify";
        }

        try {
            updateDTO.setAdminId(MOCK_ADMIN_ID);
            warehouseAdminService.updateWarehouse(warehouseId, updateDTO);

            redirectAttributes.addFlashAttribute("message", warehouseId + "번 창고 수정이 완료되었습니다.");
            return "redirect:/admin/warehouses/" + warehouseId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "수정 실패: " + e.getMessage());
            return "redirect:/admin/warehouses/" + warehouseId;
        }
    }

    @PostMapping("/{whid}/delete")
    public String deleteWarehouse(@PathVariable("whid") Long warehouseId, RedirectAttributes redirectAttributes) {
        try {
            warehouseAdminService.deleteWarehouse(warehouseId);
            redirectAttributes.addFlashAttribute("message", "창고(" + warehouseId + ")가 삭제되었습니다.");
            return "redirect:/admin/warehouses";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "삭제 실패: " + e.getMessage());
            return "redirect:/admin/warehouses/" + warehouseId;
        }
    }

    @GetMapping("/api/check/name")
    @ResponseBody
    public Boolean checkNameDuplication(@RequestParam String name) {
        return warehouseAdminService.checkNameDuplication(name);
    }
}