package com.hara.crm.workbench.service.impl;

import com.hara.crm.workbench.domain.ClueActivityRelation;
import com.hara.crm.workbench.mapper.ClueActivityRelationMapper;
import com.hara.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * ClassName: ClueActivityRelationServiceImpl
 * Package: com.hara.crm.workbench.service.impl
 * ProjectName:crm-project
 * Description:
 */
@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Override
    public int saveClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelation) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(clueActivityRelation);
    }

    @Override
    public int removeRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteRelationByClueIdActivityId(clueActivityRelation);
    }
}
