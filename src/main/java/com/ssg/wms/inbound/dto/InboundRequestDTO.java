package com.ssg.wms.inbound.dto;

import lombok.Data;

import java.util.List;

@Data
public class InboundRequestDTO {
    // 화면에서 입력받을 정보에 대한
    // InboundRequestDTO
    // 등록/수정 역할

    private int warehouseId;           // 필수
    private long staffId;              // 필수
    private long memberId;             // 필수
    private String inboundStatus;      // 선택, 기본값: "request"
    private String inboundRejectReason; // 선택, 초기에는 null

    private List<InboundItemRequestDTO> inboundItems; // 1:N 입고 품목

}

@Data
class InboundItemRequestDTO {
    private int productId; // 필수
    private int quantity;  // 필수
    private String unit;   // 선택, 예: "EA", "BOX"
}
