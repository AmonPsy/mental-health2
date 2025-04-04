* 读取 2016 年数据并生成年份变量
use "C:\Users\dell\Desktop\CLASS\面板数据\2016.dta", clear

* 将 2018 年数据追加到当前数据集中
append using "C:\Users\dell\Desktop\CLASS\面板数据\2018.dta"
* 将 2020 年数据追加到当前数据集中
append using "C:\Users\dell\Desktop\CLASS\面板数据\2020.dta"
* 将部分变量放到最前面
order pid communityID year

* 检查是否合并成功
list pid year if _n <= 10  // 显示前 10 行数据
duplicates report pid year  // 检查是否存在重复记录（同一 pid 和 year）
* 删除重复id和年份的变量
duplicates drop pid year, force
duplicates report pid year

*设置面板
xtset pid year

replace city = subinstr(city, "市", "", .)

*为18年对应变量生成city变量
gen city_18 = city if year == 2018  // 生成新变量用于存储填充后的city_18

bysort pid (year): replace city_18 = city[_n-1] if year == 2018 & city[_n-1] == city[_n+1]
bysort pid (year): replace city_18 = city[_n-1] if year == 2018 & city[_n+1] == ""
bysort pid (year): replace city_18 = city[_n+1] if year == 2018 & city[_n-1] == ""

replace city = city_18 if year == 2018
drop city_18  // 清理临时变量

*为18年对应变量生成communityID变量，但不确定能不能用
gen double communityID_18 = communityID if year == 2018  

bysort pid (year): replace communityID_18 = communityID[_n-1] if year == 2018 & communityID[_n-1] == communityID[_n+1]
bysort pid (year): replace communityID_18 = communityID[_n-1] if year == 2018 & missing(communityID[_n+1])
bysort pid (year): replace communityID_18 = communityID[_n+1] if year == 2018 & missing(communityID[_n-1])

replace communityID = communityID_18 if year == 2018
drop communityID_18 

* 保存为面板数据
save "C:\Users\dell\Desktop\CLASS\面板数据\panel_data.dta", replace
