/*
* 读取 2018 年数据并生成年份变量
use "C:\Users\dell\Desktop\CLASS\面板数据\2018.dta", clear

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
* 保存为面板数据
save "C:\Users\dell\Desktop\CLASS\面板数据\2.4日回归\1820panel_data.dta", replace
*/
* 1. 读取数据
use "C:\Users\dell\Desktop\CLASS\面板数据\panel_data.dta", clear

* 2. 删除 year == 2016 的观测值
drop if year == 2016

* 3. 确保数据被正确修改
list year if year == 2016  // 应该不会显示任何数据，表示已删除
*设置面板
xtset pid year
* 保存为面板数据
save "C:\Users\dell\Desktop\CLASS\面板数据\2.4日回归\1820panel_data.dta", replace