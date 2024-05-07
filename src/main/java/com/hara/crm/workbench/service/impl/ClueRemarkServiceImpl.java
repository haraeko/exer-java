package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.ClueRemark;
import com.hara.crm.workbench.mapper.ClueRemarkMapper;
import com.hara.crm.workbench.service.ClueRemarkService;
import com.hara.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: ClueRemarkServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }
}
