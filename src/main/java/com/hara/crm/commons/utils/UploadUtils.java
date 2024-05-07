package com.hara.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

/**
 * ClassName: UploadUtils
 * Package: com.hara.crm.commons.utils
 * ProjectName:crm-project
 * Description:用于上传文件  向cell里注入数据
 */
public class UploadUtils {
    public static String getCellValueForStr(HSSFCell cell){
        String result="";
        if (cell.getCellType()== HSSFCell.CELL_TYPE_STRING){
            result=cell.getStringCellValue();
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN){
            result=cell.getBooleanCellValue()+"";
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
            result=cell.getNumericCellValue()+"";
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA) {
            result =cell.getCellFormula();
        }else {
            result="";
        }
        return result;
    }
}
