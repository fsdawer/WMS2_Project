package com.ssg.wms.inbound.dto;

import lombok.Data;

@Data
public class InboundItemDTO {
    private int inboundItemId;
    private int inboundId;
    private int productId;
    private String productName;
    private int amount;
}
