package com.ssg.wms.inbound.dto;

import lombok.Getter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
public class InboundDTO {

    private int inboundId;
    private int warehouseId;
    private String warehouseName;
    private int memberId;
    private String memberName;
    private int staffId;
    private String staffName;
    private String inboundStatus; // request, cancelled, approved, rejected
    private String inboundRejectReason;
    private LocalDateTime inboundRequestedAt;
    private LocalDateTime inboundUpdatedAt;
    private LocalDateTime inboundAt;

}

