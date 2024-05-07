package com.hara.crm.workbench.domain;

/**
 * ClassName: FunnelVO
 * Package: com.hara.crm.workbench.domain
 * ProjectName:crm-project
 * Description:
 */

//为了漏斗图的功能设计的
public class FunnelVO {
    private String name;
    private int value;

    public FunnelVO() {
    }

    public FunnelVO(String name, int value) {
        this.name = name;
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FunnelVO)) return false;

        FunnelVO funnelVO = (FunnelVO) o;

        if (getValue() != funnelVO.getValue()) return false;
        return getName() != null ? getName().equals(funnelVO.getName()) : funnelVO.getName() == null;
    }

    @Override
    public int hashCode() {
        int result = getName() != null ? getName().hashCode() : 0;
        result = 31 * result + getValue();
        return result;
    }

    @Override
    public String toString() {
        return "FunnelVO{" +
                "name='" + name + '\'' +
                ", value=" + value +
                '}';
    }
}
