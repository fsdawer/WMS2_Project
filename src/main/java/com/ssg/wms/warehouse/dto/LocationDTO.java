package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
// LocationDTO의 유효성 검사를 위해 이 두 개의 import가 필요합니다.

/**
 * 구역 내 위치 (Location) 정보를 담는 DTO입니다.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class LocationDTO {

    // 수정 시에만 사용되므로 등록 시에는 null이 허용됩니다.
    private Long locationId;

    /// 창고 속한 섹션 ID (DB 저장을 위해 필요하지만 폼 바인딩 필수는 아님)
    private Long sectionId;

    /** 위치 코드 (예: A-01-01) */
    @NotBlank(message = "위치 코드는 필수 입력 항목입니다.")
    private String locationCode;

    /** 위치가 있는 층수 */
    @NotNull(message = "층수는 필수 입력 항목입니다.")
    private Integer floorNum;

    /// 위치의 유형 코드 (폼에서 받지 않는 경우 Null 허용)
    private String locationTypeCode;

    /** 해당 위치의 최대 적재 가능 부피 */
    // JSP 폼에서는 maxVolume을 Integer로 처리했으므로 타입을 Integer로 변경합니다.
    @NotNull(message = "최대 부피는 필수 입력 항목입니다.")
    private Integer maxVolume;
}