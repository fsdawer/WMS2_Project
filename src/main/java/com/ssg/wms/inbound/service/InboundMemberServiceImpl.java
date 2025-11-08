package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.dto.InboundRequestDTO;
import com.ssg.wms.inbound.repository.InboundMemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class InboundMemberServiceImpl implements InboundMemberService {

    @Autowired
    private InboundMemberMapper inboundMemberMapper;

    @Transactional
    public void createInbound(InboundRequestDTO inboundRequestDTO) {
        inboundMemberMapper.insertInbound(inboundRequestDTO);


    }

}
