package com.ssg.wms.inbound.domain;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class InboundVO {

    private int inboundId;
    private int warehouseId;
    private long staffId;
    private long memberId;
    private String inboundStatus;         // request, cancelled, approved, rejected
    private String inboundRejectReason;
    private LocalDateTime inboundRequestedAt;
    private LocalDateTime inboundUpdatedAt;
    private LocalDateTime inboundAt;

}
