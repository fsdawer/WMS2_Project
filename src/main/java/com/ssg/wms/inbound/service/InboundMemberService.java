package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.InboundDTO;
import org.springframework.transaction.annotation.Transactional;

public interface InboundMemberService {

    @Transactional
    int createInbound(InboundVO inboundVO);

    InboundDTO getInboundById(int inboundId);
}
