package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.ArrayList; // ArrayList import 추가
import java.util.List;

/**
 * 창고 구역 (Section) 정보를 담는 DTO입니다.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SectionDTO {

    // 수정 시에만 사용되므로 등록 시에는 null이 허용됩니다.
    private Long sectionId;

    // 이 DTO가 어느 창고에 속하는지 나타내지만, 폼 바인딩에서는 사용되지 않을 수 있습니다.
    private Long warehouseId;

    /**
     * 구역 내 위치(Location) 리스트입니다.
     * @Valid를 통해 LocationDTO 내부 요소의 유효성

     */
    @Valid
    private List<LocationDTO> locations = new ArrayList<>();

    /** 창고 구역 이름 (A/B/C/D 구역) */
    @NotBlank(message = "구역 이름은 필수 입력 항목입니다.")
    private String sectionName;

    /** 창고 구역의 종류 (예: NORMAL, COLD) */
    @NotBlank(message = "구역 타입은 필수 선택 항목입니다.")
    private String sectionType;

    /** 창고 구역의 목적 (창고 구역에 해당하는 목적 설명.) */
    private String sectionPurpose;

    /** 창고 구역에 할당된 면적 */
    @NotNull(message = "면적은 필수 입력 항목입니다.")
    private Integer allocatedArea;
}