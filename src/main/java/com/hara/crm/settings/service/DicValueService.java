package com.hara.crm.settings.service;

import com.hara.crm.settings.domain.DicValue;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: DicValueService
 * Package: com.hara.crm.settings.service
 * ProjectName:crm-project
 * Description:
 */

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
