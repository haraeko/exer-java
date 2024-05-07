package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.Clue;

import java.util.Map;

/**
 * ClassName: ClueService
 * Package: com.hara.crm.workbench.service
 * ProjectName:crm-project
 * Description:
 */
public interface ClueService {

    int saveCreateClue(Clue clue);

    Clue queryClueForDetailById(String id);

//    转换

    void saveCustomer(Map<String,Object> map);



}
