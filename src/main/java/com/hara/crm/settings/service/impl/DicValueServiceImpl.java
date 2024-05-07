package com.hara.crm.settings.service.impl;

import com.hara.crm.settings.domain.DicValue;
import com.hara.crm.settings.mapper.DicValueMapper;
import com.hara.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: DicValueService
 * Package: com.hara.crm.settings.service.impl
 * ProjectName:crm-project
 * Description:
 */

@Service("dicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
