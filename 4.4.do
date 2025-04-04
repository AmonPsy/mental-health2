cd "C:\Users\dell\Desktop\CLASS\面板数据\4.4更多的机制"

use "C:\Users\dell\Desktop\CLASS\面板数据\2.4日回归\1820panel_data.dta",clear
keep if pid < 20110010101
* 将individual_income 转换为万元
replace individual_income = individual_income / 10000
replace social_security = social_security / 10000


* 设置面板数据结构
xtset pid year

****回归
**准备工作

* 已有变量的标签
label variable mental_health "精神健康得分"
label variable is_rural "是否农村"
label variable age "年龄"
label variable is_male "是否为男性"
label variable married "是否有配偶"
label variable education_1 "不识字"
label variable education_2 "私塾/扫盲班"
label variable education_3 "小学"
label variable education_4 "初中"
label variable education_5 "高中/中专"
label variable education_6 "大专及以上"
label variable is_han "是否为汉族"
label variable has_religion "是否有宗教信仰"
label variable has_partner "是否和伴侣同住"
label variable Living_with_children "是否与子女同住"
label variable is_agriculture_household "是否为农业户口"
label variable has_chronic_disease "是否有慢性病"
label variable enjoys_retirement "是否享受离/退休"
label variable individual_income "个人年收入（万元）"
label variable enterprise_pension "是否有企业养老金"
label variable government_pension "是否有事业单位养老金"
label variable urban_rural_pension "是否有城乡居民养老金"
label variable minimum_living_security "是否有最低生活保障"
label variable senior_allowance "是否有老年津贴"
label variable home_care_subsidy "是否有居家养老补贴"
label variable family_planning_subsidy "是否有计划生育补贴"
label variable government_assistance "是否有政府救助"
label variable social_security "每年的社会保障金额（万元）"
label variable housing "房产数"
label variable distance_important "是否认为距离会影响外出活动"
label variable internet "是否有互联网使用"
label variable children_alive "健在子女数"
label variable free_check "免费体检"

foreach var in has_visit_home has_hotline has_accompany_medical has_shopping_help has_legal_assistance ///
                has_housekeeping_help has_meal_service has_daycare has_counseling activity_room ///
                fitness_room chess_room library outdoor_space {
    
    * 计算社区层面的均值
    egen mean_`var' = mean(`var'), by(communityID year)

    * 生成社区层面的二元变量（0/1）
    gen community_`var' = (mean_`var' > 0.5)

}

* 新增变量的标签
/*
label variable community_activity_room "是否有活动室"
label variable community_fitness_room "是否有健身房"
label variable community_chess_room "是否有棋牌麻将室"
label variable community_library "是否有图书馆"
label variable community_outdoor_space "是否有室外活动场地"
*/

label variable community_has_visit_home "是否有上门探访"
label variable community_has_hotline "是否有老年人服务热线"
label variable community_has_accompany_medical "是否有陪同就医服务"
label variable community_has_shopping_help "是否有购物协助"
label variable community_has_legal_assistance "是否有法律援助"
label variable community_has_housekeeping_help "是否有家政服务"
label variable community_has_meal_service "是否有老年饭桌服务"
label variable community_has_daycare "是否有日托站或托老所"
label variable community_has_counseling "是否有心理咨询服务"


**** 回归
*只看农村样本
keep if is_rural == 1
*此时只有9081的观测




****机制一
*社区服务对生活满意度的影响
xtreg life_satisfaction community_has_accompany_medical ///
      community_has_visit_home community_has_hotline ///
      community_has_shopping_help community_has_legal_assistance ///
      community_has_housekeeping_help community_has_meal_service ///
      community_has_daycare community_has_counseling ///
      age is_male married education_1 education_2 education_3 ///
      education_4 education_5 education_6 is_han has_religion ///
      is_agriculture_household has_chronic_disease enjoys_retirement ///
      enterprise_pension government_pension urban_rural_pension ///
      minimum_living_security senior_allowance home_care_subsidy ///
      family_planning_subsidy government_assistance social_security ///
      housing internet children_alive i.year, fe vce(cluster pid)

outreg2 using mechanism_test.xls, replace ctitle("Step 1: life_satisfaction Regression") label

* 生活满意度对精神健康的影响
xtreg mental_health life_satisfaction ///
      community_has_visit_home community_has_hotline ///
      community_has_shopping_help ///
      community_has_legal_assistance community_has_housekeeping_help ///
      community_has_meal_service community_has_daycare ///
      community_has_counseling age is_male married education_1 education_2 ///
      education_3 education_4 education_5 education_6 is_han has_religion ///
      is_agriculture_household has_chronic_disease enjoys_retirement ///
      enterprise_pension government_pension urban_rural_pension ///
      minimum_living_security senior_allowance home_care_subsidy ///
      family_planning_subsidy government_assistance social_security ///
      housing internet children_alive i.year, fe vce(cluster pid)

outreg2 using mechanism_test.xls, append ctitle("Step 2: Mental Health Regression with life_satisfaction") label

* 社区服务影响精神健康，同时控制生活满意度
xtreg mental_health life_satisfaction community_has_accompany_medical ///
      community_has_visit_home community_has_hotline ///
      community_has_shopping_help community_has_legal_assistance ///
      community_has_housekeeping_help community_has_meal_service ///
      community_has_daycare community_has_counseling age is_male ///
      married education_1 education_2 education_3 education_4 education_5 ///
      education_6 is_han has_religion is_agriculture_household ///
      has_chronic_disease enjoys_retirement enterprise_pension ///
      government_pension urban_rural_pension minimum_living_security ///
      senior_allowance home_care_subsidy family_planning_subsidy ///
      government_assistance social_security housing internet ///
      children_alive i.year, fe vce(cluster pid)

outreg2 using mechanism_test.xls, append ctitle("Step 3: Mental Health Regression with Mediation") label




***机制二
