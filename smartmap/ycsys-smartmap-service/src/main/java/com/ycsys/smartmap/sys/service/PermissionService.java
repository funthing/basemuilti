package com.ycsys.smartmap.sys.service;

import com.ycsys.smartmap.sys.common.config.parseobject.permission.PermissionXmlObject;
import com.ycsys.smartmap.sys.entity.PageHelper;
import com.ycsys.smartmap.sys.entity.Permission;

import java.io.InputStream;
import java.util.List;

/**
 * 权限服务接口
 * Created by lixiaoxin on 2016/11/2.
 */
public interface PermissionService {

    /**获取用户所有的菜单**/
    public List<Permission> getMenus(Integer userId,String system_code);
    /**获取所有的菜单**/
    public List<Permission> getMenus();

    /**初始化权限**/
    void initPermission(PermissionXmlObject pxo);

    /**分页获取所有权限**/
    List<Permission> findAll(PageHelper page);

    /**
     * 根据权限xml流和编码导入权限
     * **/
    void importPermission(InputStream is,String encoding);

    /**根据系统编码获取权限**/
    List<Permission> getMenus(String sys_code);

    /**根据系统编码获取所有权限**/
    List<Permission> getAllPermissions(String sys_code);
}
