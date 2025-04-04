* 加载数据
use "C:\Users\dell\Desktop\CLASS\class2018\class2018\CLASS2018-适用STATA14以上.dta", clear

* 保留指定变量
keep q1__1__open q3__1 q5a q5b a1 a2__1__open a3 a4 a5 a6 a7 a8__1__open a9__1-a9__15 a10 b9_1__1-b9_1__23 b18 b19__1-b19__15 b19__99 b20 c1 c2 c3 c4 c6 c12_1__1__open d2_1__1-d2_1__8  d2_2__1__1__open-d2_2__8__1__open d3_1 d3_2 d4__1__open  d12_1__1-d12_1__9 d12_2__1-d12_2__9 d14__1-d14__7 d16 d17__1-d17__8  d19 d21 e2__1-e2__9  f4__1__open f4__2__open f4_1__1__open f4_1__2__open d12_1__1-d12_1__9 b13_2__5 b1 b2 b3 b17 b24__1-b24__8 d5 d6 e7__1-e7__8 e6__1

*重命名
rename q1__1__open pid
* 年份
gen year = 2018
* 将pid移到最前面
order pid year

* 地区
gen province = q3__1
*gen city = q3_2

* 生成是否为农村的变量
gen is_rural = (q5a == 5)

* 性别
gen is_male = (a1 == 1)

* 生成年龄变量 age_18
gen age = 2018 - a2__1__open

* 根据 a5 生成婚姻状况变量：已婚有配偶为 1，其余为 0
gen married = (a5 == 1)

* 生成六个0-1变量，表示不同的学历
gen education_1 = (a3 == 1)  // 不识字
gen education_2 = (a3 == 2)  // 私塾/扫盲班
gen education_3 = (a3 == 3)  // 小学
gen education_4 = (a3 == 4)  // 初中
gen education_5 = (a3 == 5)  // 高中/中专
gen education_6 = (a3 == 6 | a3 == 7)  // 大专及以上 (包含a3为6或7的情况)
* 如果 a3 为缺失值，则这些变量也为缺失
replace education_1 = . if missing(a3)
replace education_2 = . if missing(a3)
replace education_3 = . if missing(a3)
replace education_4 = . if missing(a3)
replace education_5 = . if missing(a3)
replace education_6 = . if missing(a3)


* 生成表示是否为汉族的变量
gen is_han = (a4 == 1)
* 如果 a4 为缺失值，则新变量取缺失值
replace is_han = . if missing(a4)

* 生成表示是否有宗教信仰的变量
gen has_religion = (a6 == 1)
* 如果 a6 为缺失值，则新变量取缺失值
replace has_religion = . if missing(a6)

* 生成表示是否有伴侣同住的变量
gen has_partner = (a9__1 == 1 | a9__2 == 1)
* 如果 a9_1 和 a9_2 均为空，则新变量为缺失值
replace has_partner = . if missing(a9__1) & missing(a9__2)
* 如果 a9_1 和 a9_2 均为0，则新变量为0
replace has_partner = 0 if a9__1 == 0 & a9__2 == 0
* 如果一个为0，一个为空，则新变量为0
replace has_partner = 0 if (a9__1 == 0 & missing(a9__2)) | (missing(a9__1) & a9__2 == 0)

* 是否与子女同住
gen Living_with_children = (a9__3 == 1 | a9__4 == 1)
replace Living_with_children = . if missing(a9__3) & missing(a9__4)

* 生成表示是否为农业户口的变量
gen is_agriculture_household = (a10 == 1 | a10 == 3)
* 如果 a10 为缺失值，则新变量取缺失值
replace is_agriculture_household = . if missing(a10)


* 生成变量has_chronic_disease，初始化为0
gen has_chronic_disease = 0

* 如果b9_1__1到b9_1__23中有一项取值为1（有），则has_chronic_disease为1
foreach var of varlist b9_1__1-b9_1__23 {
    replace has_chronic_disease = 1 if `var' == 1
}

* 如果所有变量均为2（无），has_chronic_disease保持为0，不需要额外的代码，因为已初始化为0




* 生成变量enjoy_retirement
gen enjoys_retirement = .
* 如果c6为1（是），enjoy_retirement取值为1
replace enjoys_retirement = 1 if c6 == 1
* 如果c6为2（否），enjoy_retirement取值为0
replace enjoys_retirement = 0 if c6 == 2


* 个人年收入
* 生成个人收入变量individual_income
gen individual_income = c12_1__1__open
* 如果c12_1__1__open为9999998（不知道）或9999999（拒答），则individual_income取值为空
replace individual_income = . if c12_1__1__open == 9999998 | c12_1__1__open == 9999999


* 生成每个保险的变量
gen enterprise_pension = .    // 企业职工基本养老保险金
replace enterprise_pension = 1 if d2_1__1 == 1
replace enterprise_pension = 0 if d2_1__1 == 2

gen government_pension = .    // 机关事业单位养老保险金
replace government_pension = 1 if d2_1__2 == 1
replace government_pension = 0 if d2_1__2 == 2

gen urban_rural_pension = .   // 城乡居民基本养老保险金
replace urban_rural_pension = 1 if d2_1__3 == 1
replace urban_rural_pension = 0 if d2_1__3 == 2

gen minimum_living_security = .    // 最低生活保障金或贫困救助金
replace minimum_living_security = 1 if d2_1__4 == 1
replace minimum_living_security = 0 if d2_1__4 == 2

gen senior_allowance = .    // 高龄津贴
replace senior_allowance = 1 if d2_1__5 == 1
replace senior_allowance = 0 if d2_1__5 == 2

gen home_care_subsidy = .    // 居家养老服务补贴（服务券）
replace home_care_subsidy = 1 if d2_1__6 == 1
replace home_care_subsidy = 0 if d2_1__6 == 2

gen family_planning_subsidy = .    // 农村计划生育家庭奖励扶助金
replace family_planning_subsidy = 1 if d2_1__7 == 1
replace family_planning_subsidy = 0 if d2_1__7 == 2

gen government_assistance = .    // 政府其他救助
replace government_assistance = 1 if d2_1__8 == 1
replace government_assistance = 0 if d2_1__8 == 2

* 社保金额
* 生成中间变量
gen temp_security = 0
* 处理d2_2__1__1__open到d2_2__8__1__open中的值，将9998和9999替换为0
replace d2_2__1__1__open = 0 if d2_2__1__1__open == 9998 | d2_2__1__1__open == 9999
replace d2_2__2__1__open = 0 if d2_2__2__1__open == 9998 | d2_2__2__1__open == 9999
replace d2_2__3__1__open = 0 if d2_2__3__1__open == 9998 | d2_2__3__1__open == 9999
replace d2_2__4__1__open = 0 if d2_2__4__1__open == 9998 | d2_2__4__1__open == 9999
replace d2_2__5__1__open = 0 if d2_2__5__1__open == 9998 | d2_2__5__1__open == 9999
replace d2_2__6__1__open = 0 if d2_2__6__1__open == 9998 | d2_2__6__1__open == 9999
replace d2_2__7__1__open = 0 if d2_2__7__1__open == 9998 | d2_2__7__1__open == 9999
replace d2_2__8__1__open = 0 if d2_2__8__1__open == 9998 | d2_2__8__1__open == 9999

* 计算社保金额
replace temp_security = temp_security + d2_2__1__1__open if !missing(d2_2__1__1__open)
replace temp_security = temp_security + d2_2__2__1__open if !missing(d2_2__2__1__open)
replace temp_security = temp_security + d2_2__3__1__open if !missing(d2_2__3__1__open)
replace temp_security = temp_security + d2_2__4__1__open if !missing(d2_2__4__1__open)
replace temp_security = temp_security + d2_2__5__1__open if !missing(d2_2__5__1__open)
replace temp_security = temp_security + d2_2__6__1__open if !missing(d2_2__6__1__open)
replace temp_security = temp_security + d2_2__7__1__open if !missing(d2_2__7__1__open)
replace temp_security = temp_security + d2_2__8__1__open if !missing(d2_2__8__1__open)
* 生成社会保障变量，根据条件判断
gen social_security = . 
replace social_security = temp_security if ( !missing(d2_2__1__1__open) | !missing(d2_2__2__1__open) | !missing(d2_2__3__1__open) | !missing(d2_2__4__1__open) | !missing(d2_2__5__1__open) | !missing(d2_2__6__1__open) | !missing(d2_2__7__1__open) | !missing(d2_2__8__1__open))
* 删除中间变量
drop temp_security


* 房产套数
gen housing = d4__1__open
replace housing = . if housing == 99998  // 将99998的值置为缺失值


* 生成是否提供社区服务的9个新的0-1变量
gen has_visit_home = (d12_1__1 == 1) if !missing(d12_1__1)
replace has_visit_home = 0 if d12_1__1 == 2 | missing(d12_1__1)
replace has_visit_home = . if d12_1__1 == 3 | missing(d12_1__1)


gen has_hotline = (d12_1__2 == 1) if !missing(d12_1__2)
replace has_hotline = 0 if d12_1__2 == 2 | missing(d12_1__2)
replace has_hotline = . if d12_1__2 == 3 | missing(d12_1__2)


gen has_accompany_medical = (d12_1__3 == 1) if !missing(d12_1__3)
replace has_accompany_medical = 0 if d12_1__3 == 2 | missing(d12_1__3)
replace has_accompany_medical = . if d12_1__3 == 3 | missing(d12_1__3)


gen has_shopping_help = (d12_1__4 == 1) if !missing(d12_1__4)
replace has_shopping_help = 0 if d12_1__4 == 2 | missing(d12_1__4)
replace has_shopping_help = . if d12_1__4 == 3 | missing(d12_1__4)


gen has_legal_assistance = (d12_1__5 == 1) if !missing(d12_1__5)
replace has_legal_assistance = 0 if d12_1__5 == 2 | missing(d12_1__5) 
replace has_legal_assistance = . if d12_1__5 == 3 | missing(d12_1__5) 


gen has_housekeeping_help = (d12_1__6 == 1) if !missing(d12_1__6)
replace has_housekeeping_help = 0 if d12_1__6 == 2 | missing(d12_1__6)
replace has_housekeeping_help = . if d12_1__6 == 3 | missing(d12_1__6)


gen has_meal_service = (d12_1__7 == 1) if !missing(d12_1__7)
replace has_meal_service = 0 if d12_1__7 == 2 | missing(d12_1__7)
replace has_meal_service = . if d12_1__7 == 3 | missing(d12_1__7)


gen has_daycare = (d12_1__8 == 1) if !missing(d12_1__8)
replace has_daycare = 0 if d12_1__8 == 2 | missing(d12_1__8)
replace has_daycare = . if d12_1__8 == 3 | missing(d12_1__8)


gen has_counseling = (d12_1__9 == 1) if !missing(d12_1__9)
replace has_counseling = 0 if d12_1__9 == 2 | missing(d12_1__9)
replace has_counseling = . if d12_1__9 == 3 | missing(d12_1__9)




* 生成社区服务的9个新的0-1变量
gen visit_home = (d12_2__1 == 1) if !missing(d12_2__1)
replace visit_home = 0 if d12_2__1 == 2 | missing(d12_2__1)

gen hotline = (d12_2__2 == 1) if !missing(d12_2__2)
replace hotline = 0 if d12_2__2 == 2 | missing(d12_2__2)

gen accompany_medical = (d12_2__3 == 1) if !missing(d12_2__3)
replace accompany_medical = 0 if d12_2__3 == 2 | missing(d12_2__3)

gen shopping_help = (d12_2__4 == 1) if !missing(d12_2__4)
replace shopping_help = 0 if d12_2__4 == 2 | missing(d12_2__4)

gen legal_assistance = (d12_2__5 == 1) if !missing(d12_2__5)
replace legal_assistance = 0 if d12_2__5 == 2 | missing(d12_2__5) 

gen housekeeping_help = (d12_2__6 == 1) if !missing(d12_2__6)
replace housekeeping_help = 0 if d12_2__6 == 2 | missing(d12_2__6)

gen meal_service = (d12_2__7 == 1) if !missing(d12_2__7)
replace meal_service = 0 if d12_2__7 == 2 | missing(d12_2__7)

gen daycare = (d12_2__8 == 1) if !missing(d12_2__8)
replace daycare = 0 if d12_2__8 == 2 | missing(d12_2__8)

gen counseling = (d12_2__9 == 1) if !missing(d12_2__9)
replace counseling = 0 if d12_2__9 == 2 | missing(d12_2__9)



* 生成五个对应的 0-1 变量
gen activity_room = (d14__1 == 1) if !missing(d14__1)
replace activity_room = 0 if missing(d14__1) | d14__1 == 0

gen fitness_room = (d14__2 == 1) if !missing(d14__2)
replace fitness_room = 0 if missing(d14__2) | d14__2 == 0

gen chess_room = (d14__3 == 1) if !missing(d14__3)
replace chess_room = 0 if missing(d14__3) | d14__3 == 0

gen library = (d14__4 == 1) if !missing(d14__4)
replace library = 0 if missing(d14__4) | d14__4 == 0

gen outdoor_space = (d14__5 == 1) if !missing(d14__5)
replace outdoor_space = 0 if missing(d14__5) | d14__5 == 0

* 生成距离重要与否的0-1 变量
gen distance_important = .
replace distance_important = 1 if d17__3 == 1
replace distance_important = 0 if d17__3 == 0

* 生成 internet 变量，表示是否上网
gen internet = 1  // 默认为 1（表示上网）
* 如果 d21 取值为 5（从不上网），则将 internet 设置为 0
replace internet = 0 if d21 == 5

*生成是否参加免费体检的变量
gen free_checkup = .
replace free_checkup = 1 if b13_2__5 == 1
replace free_checkup = 0 if b13_2__5 == 2


* 精神健康相关
* 为每个问题生成对应的新变量
gen mood_good = .  // 1. 心情很好
replace mood_good = 0 if e2__1 == 1
replace mood_good = 1 if e2__1 == 2
replace mood_good = 2 if e2__1 == 3

gen lonely = .  // 2. 孤单
replace lonely = 0 if e2__2 == 1
replace lonely = 1 if e2__2 == 2
replace lonely = 2 if e2__2 == 3

gen sad = .  // 3. 很难过
replace sad = 0 if e2__3 == 1
replace sad = 1 if e2__3 == 2
replace sad = 2 if e2__3 == 3

gen good_days = .  // 4. 日子过得不错
replace good_days = 0 if e2__4 == 1
replace good_days = 1 if e2__4 == 2
replace good_days = 2 if e2__4 == 3

gen no_appetite = .  // 5. 不想吃东西
replace no_appetite = 0 if e2__5 == 1
replace no_appetite = 1 if e2__5 == 2
replace no_appetite = 2 if e2__5 == 3

gen bad_sleep = .  // 6. 睡眠不好
replace bad_sleep = 0 if e2__6 == 1
replace bad_sleep = 1 if e2__6 == 2
replace bad_sleep = 2 if e2__6 == 3

gen useless = .  // 7. 觉得自己不中用
replace useless = 0 if e2__7 == 1
replace useless = 1 if e2__7 == 2
replace useless = 2 if e2__7 == 3

gen bored = .  // 8. 没事可做
replace bored = 0 if e2__8 == 1
replace bored = 1 if e2__8 == 2
replace bored = 2 if e2__8 == 3

gen fun_life = .  // 9. 生活中有乐趣
replace fun_life = 0 if e2__9 == 1
replace fun_life = 1 if e2__9 == 2
replace fun_life = 2 if e2__9 == 3

* 反转指定变量的分数
gen mood_good_rev = 2 - mood_good if !missing(mood_good)
gen good_days_rev = 2 - good_days if !missing(good_days)
gen fun_life_rev = 2 - fun_life if !missing(fun_life)

* 计算总分：将所有变量加总
gen mental_health = mood_good_rev + lonely + sad + good_days_rev + no_appetite + bad_sleep + useless + bored + fun_life_rev if ///
    !missing(mood_good_rev, lonely, sad, good_days_rev, no_appetite, bad_sleep, useless, bored, fun_life_rev)

* 检查是否有缺失值：如果任一分量缺失，总分也应为缺失
replace mental_health = . if missing(mood_good_rev, lonely, sad, good_days_rev, no_appetite, bad_sleep, useless, bored, fun_life_rev)

* 删除反转变量
drop mood_good_rev good_days_rev fun_life_rev

* 初始化健在的子女数量变量
gen children_alive = 0

* 如果 f4_1_1_open 不为空，将其值加到 children_alive
replace children_alive = children_alive + f4_1__1__open if !missing(f4_1__1__open)

* 如果 f4_1_2_open 不为空，将其值加到 children_alive
replace children_alive = children_alive + f4_1__2__open if !missing(f4_1__2__open)

replace children_alive = . if missing(f4_1__1__open) & missing(f4_1__2__open)




*新增机制变量相关
* 生成新变量health_status，复制b1的值
gen health_status = b1
* 将无法回答（编码为9）设为缺失值
replace health_status = . if b1 == 9
* 添加变量标签
label variable health_status "自评健康状况（无法回答设为缺失）"

* 生成新变量 health_change，复制 B3 的值
gen health_change = b3
* 将无法回答（编码为9）设为缺失值
replace health_change = . if b3 == 9
* 添加变量标签
label variable health_change "与去年相比的健康变化（无法回答设为缺失）"

* 生成新变量 life_satisfaction，复制 B17 的值
gen life_satisfaction = b17
* 将无法回答（编码为9）设为缺失值
replace life_satisfaction = . if b17 == 9
* 添加变量标签
label variable life_satisfaction "生活满意度（无法回答设为缺失）"

* 生成新变量 caregiver_preference，复制 D5 的值
gen caregiver_preference = d5
* 将无法回答（编码为9）设为缺失值
replace caregiver_preference = . if d5 == 9
* 添加变量标签
label variable caregiver_preference "老年人照料责任主体偏好（无法回答设为缺失）"

* 生成新变量 future_living_arrangement，复制 D6 的值
gen future_living_arrangement = d6
* 将无法回答（编码为9）设为缺失值
replace future_living_arrangement = . if d6 == 9
* 添加变量标签
label variable future_living_arrangement "未来养老计划（无法回答设为缺失）"

replace e7__1 = . if e7__1 == 9
replace e7__2 = . if e7__2 == 9
replace e7__3 = . if e7__3 == 9
replace e7__4 = . if e7__4 == 9
replace e7__5 = . if e7__5 == 9
replace e7__6 = . if e7__6 == 9
replace e7__7 = . if e7__7 == 9
replace e7__8 = . if e7__8 == 9

replace e6__1 = . if e6__1 == 9


* 保留所需变量
keep pid year province is_rural is_male age married education_1 education_2 education_3 education_4 education_5 education_6 ///
    is_han has_religion has_partner Living_with_children is_agriculture_household has_chronic_disease enjoys_retirement ///
    individual_income enterprise_pension government_pension urban_rural_pension minimum_living_security senior_allowance ///
    home_care_subsidy family_planning_subsidy government_assistance social_security housing has_visit_home has_hotline ///
    has_accompany_medical has_shopping_help has_legal_assistance has_housekeeping_help has_meal_service has_daycare has_counseling ///
	visit_home hotline accompany_medical shopping_help legal_assistance housekeeping_help meal_service daycare counseling ///
    activity_room fitness_room chess_room library outdoor_space distance_important internet mood_good lonely sad good_days ///
    no_appetite bad_sleep useless bored fun_life mental_health children_alive mood_good lonely sad good_days no_appetite bad_sleep useless bored fun_life free_checkup health_status health_change life_satisfaction caregiver_preference future_living_arrangement b24__1-b24__8 e7__1-e7__8 e6__1

	
* 将 pid 转换为 double 类型
gen double pid_double = real(pid)
* 设置 pid_double 的显示格式为 %18.0g
format pid_double %18.0g
* 可选：如果你想要删除原来的 pid 变量，可以使用：
drop pid
* 可选：将新的 pid_double 重命名为 pid（如果需要）
rename pid_double pid

* 保存文件到指定路径
save "C:\Users\dell\Desktop\CLASS\面板数据\2018.dta", replace