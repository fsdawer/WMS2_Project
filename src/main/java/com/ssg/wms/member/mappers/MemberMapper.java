package com.ssg.wms.member.mappers;

import com.ssg.wms.member.dto.MemberDTO;

public interface MemberMapper {
    MemberDTO getMemberDetails(long memberId);
    long findMemberIdByMemberLoginId(String memberLoginId);
    void insertMember(MemberDTO memberDTO);
    void updateMember(MemberDTO memberDTO);
}
