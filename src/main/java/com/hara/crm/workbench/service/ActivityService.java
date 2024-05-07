package com.hara.crm.workbench.service;

import com.hara.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int saveEditActivityById(Activity activity);

    List<Activity> queryAllActivityByCheck();

    int addActivityByUpload(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryActivityForClueByClueId(String clueId);

    List<Activity> queryActivityForClueByNameClueId(Map<String,Object> map);

    List<Activity> queryActivityForClueByIds(String[] ids);

    List<Activity> queryActivityForConvertByNameClueId(Map<String,Object> map);

}
