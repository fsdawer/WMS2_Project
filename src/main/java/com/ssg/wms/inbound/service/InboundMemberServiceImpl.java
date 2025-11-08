package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundItemVO;
import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.repository.InboundMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InboundMemberServiceImpl implements InboundMemberService {

    @Autowired
    private InboundMemberMapper inboundMemberMapper;

    @Transactional
    @Override
    public int createInbound(InboundVO inboundVO) {
        inboundMemberMapper.insertInbound(inboundVO);
        int inboundId = inboundVO.getInboundId();

        if (inboundVO.getInboundItems() != null) {
            for (InboundItemVO item : inboundVO.getInboundItems()) {
                item.setInboundId(inboundId);
                inboundMemberMapper.insertInboundItem(item);
            }
        }
        return inboundId;
    }

    @Override
    public InboundDTO getInboundById(int inboundId) {
        return inboundMemberMapper.selectInboundWithItems(inboundId);
    }

}
