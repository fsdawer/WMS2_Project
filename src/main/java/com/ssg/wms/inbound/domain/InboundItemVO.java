package com.ssg.wms.inbound.domain;

import lombok.Data;

@Data
public class InboundItemVO {
    private int inboundItemId;
    private int inboundId;
    private int productId;
    private int amount;
}
