package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.domain.InboundItemVO;
import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.InboundDTO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface InboundMemberMapper {

    // 입고 요청 화면 이동

    // 입고 요청
    int insertInbound(InboundVO inboundVO);

    void insertInboundItem(InboundItemVO item);

    InboundDTO selectInboundWithItems(int inboundId);

    // 입고 요청 목록 조회 (관리자용 - 브랜드, 상태 파라미터로 받아서 검색)

    // 입고 요청 단건 조회

    // 입고 요청 수정

    // 입고 요청 취소

}
