import com.hara.crm.commons.utils.UploadUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;

/**
 * ClassName: PoiTest
 * Package: PACKAGE_NAME
 * ProjectName:crm-project
 * Description:
 */
public class PoiTest {

    @Test
    public void test() throws Exception{
//        创建HSSWorkbook对象
        HSSFWorkbook workbook = new HSSFWorkbook();//现在的对象是空对象，生成的文件也是空文件
//        对应一页
        HSSFSheet sheet = workbook.createSheet("学生列表");
//        创建一行   从0开始，依次增加
        HSSFRow row = sheet.createRow(0);
//        创建一列    从0开始
        HSSFCell cell = row.createCell(0);
//        创建内容
        cell.setCellValue("学号");
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        cell = row.createCell(2);
        cell.setCellValue("年龄");

        for (int i=1;i<=10;i++){
            //创建新的一行
            row = sheet.createRow(i);
//            创建一列
            cell = row.createCell(0);
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("name"+i);
            cell = row.createCell(2);
            cell.setCellValue(20+i);
        }
//        生成样式对象
        HSSFCellStyle style = workbook.createCellStyle();
//        style.setXXXXXX方法
        style.setAlignment(HorizontalAlignment.CENTER);

//        调用工具函数 生成文件
//        目录必须先创建好   文件会自动生成
        FileOutputStream os = new FileOutputStream("D:\\work4java\\ssm\\crm-project\\filedownloadTest\\studentList.xls");
        workbook.write(os);

        os.close();
        workbook.close();

        System.out.println("--------------");
    }

//    使用poi解析excel文件
    @Test
    public void test2() throws Exception{
//        根据指定的文件生成HSSFWorkbook对象
        FileInputStream fis = new FileInputStream("D:\\work4java\\ssm\\crm-project\\filedownloadTest\\activityList.xls");
        HSSFWorkbook workbook = new HSSFWorkbook(fis);
//       根据对象获取数据
//        封装了一页的信息   从第一页开始
        HSSFSheet sheet = workbook.getSheetAt(0);
//        最后一行
        int lastRowNum = sheet.getLastRowNum();

//        从第一行开始 循环
        HSSFRow row=null;//循环里面  声明变量效率低  建议拿到循环外
        HSSFCell cell=null;
        for (int i=0;i<=lastRowNum;i++){
             row = sheet.getRow(i);
//             row.getLastCellNum()   最后一行加1   所以这里没有=
             for (int j=0;j<row.getLastCellNum();j++){
//获取列   从0开始  依次增加
             cell = row.getCell(j);
                 System.out.print(UploadUtils.getCellValueForStr(cell)+"");
             }
            System.out.println();
        }
    }
}
