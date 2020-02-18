package com.pein.user.dao.mapper;

import com.pein.user.dao.domain.UserInfoDo;
import com.pein.user.dao.domain.UserInfoDoExample;
import java.util.List;

public interface UserInfoDoMapper {
    int countByExample(UserInfoDoExample example);

    int insert(UserInfoDo record);

    int insertSelective(UserInfoDo record);

    List<UserInfoDo> selectByExample(UserInfoDoExample example);

    UserInfoDo selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(UserInfoDo record);

    int updateByPrimaryKey(UserInfoDo record);
}