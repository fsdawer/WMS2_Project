package com.ssg.wms.warehouse.mapper;

import com.ssg.wms.warehouse.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface WarehouseAdminMapper {

    // ------------------- 등록 관련 메서드 -------------------

    /** 창고 등록 (Warehouse ID 자동 생성) */
    int insertWarehouse(WarehouseSaveDTO saveDTO);

    /** 구역 등록 (Section ID 자동 생성) */
    // XML 매퍼에 useGeneratedKeys="true" keyProperty="sectionId" 설정이 필요합니다.
    int insertSection(SectionDTO section);

    /** 위치 등록 (Location) - 서비스에서 호출하는 메서드 */
    // 이 메서드를 추가해야 Service Impl에서 오류가 발생하지 않습니다.
    int insertLocation(LocationDTO location);

    /** 창고 이름 중복 확인 */
    int countWarehouseName(@Param("name") String name);

    // ------------------- 조회/수정/삭제 관련 메서드 -------------------

    /** 창고 수정 */
    int updateWarehouse(WarehouseUpdateDTO updateDTO);

    /** 창고 삭제 */
    int deleteWarehouse(Long id);

    /** 창고 상태 업데이트 */
    int updateWarehouseStatus(@Param("id") Long id, @Param("newStatus") Byte newStatus);

    /** 창고 목록 조회 */
    List<WarehouseListDTO> selectWarehouses(WarehouseSearchDTO searchForm);

    /** 창고 상세 조회 */
    WarehouseDetailDTO selectWarehouseDetailById(Long id);
}