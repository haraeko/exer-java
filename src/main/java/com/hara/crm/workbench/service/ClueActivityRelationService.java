package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * ClassName: ClueActivityRelationService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface ClueActivityRelationService {
    int saveClueActivityRelationByList(List<ClueActivityRelation> clueActivityRelation);

    int removeRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);

}
