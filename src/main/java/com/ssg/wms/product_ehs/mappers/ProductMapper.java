package com.ssg.wms.product_ehs.mappers;

import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;

import java.util.List;

public interface ProductMapper {
    List<ProductDTO> selectProductsByPartner(int partnerId);
    List<CategoryDTO> selectCategory();
}
