import re


initial = '''
your strings1 your strings2 your strings3 your strings4 your strings5 your strings6  
'''
lenth_every_line = 14


def cut_text(text, lenth):
    textArr = re.findall('.{'+str(lenth)+'}', text)
    textArr.append(text[(len(textArr)*lenth):])
    return textArr


afterCut = cut_text(initial, lenth_every_line)
result = ''
for i in range(len(afterCut)):
    tmp = afterCut[i]
    result = result + "\n" + tmp
print(result)

