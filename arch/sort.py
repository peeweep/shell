#!/usr/bin/env python
import os

base = input('以字母排序: ')
base_list = base.split()

# print('所有依赖:')
command = 'echo $(pacman -Si ' + base + \
    ' | grep "Depends On" | awk -F ": " \'{print $2}\')'
depends = os.popen(command).read()
depends_list = depends.split()

# 移除依赖中的版本限制 >= =
temp = []
for i in depends_list:
    if not i in temp:
        if '=' in i:
            i = i.split('=', 1)[0]
            if '>' in i:
                i = i.split('>', 1)[0]
        temp.append(i)
depends = " ".join(temp)

# 获得即是依赖又是包的元素
repeat = []
for i in base_list:
    if i in depends:
        repeat.append(i)
if repeat == []:
    print('\nno repeat\n')
else:
    print('\nrepeat:' + str(repeat) + '\n')

# 移除重复元素
for i in repeat:
    if i in base_list:
        base_list.remove(i)

print(' '.join(sorted(base_list)))
