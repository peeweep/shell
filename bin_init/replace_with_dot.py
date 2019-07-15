#!/usr/bin/python3


def replace_keywords(source, keyword, keyword_replace):
    if keyword in source:
        for i in source:
            source = source.replace(keyword, keyword_replace)
    return source


source = input('input: ')
keywords = " `!@#$%^&*()_+-－={}:\"<>?;',～！￥…×（）—\\|：“《》？，。/；‘·「」、"
for i in keywords:
    source = replace_keywords(source, i, '.')
    source = replace_keywords(source, '..', '.')
    if source.find('.', 0, len(source)) == 0:
        source = source[1:]
    if source.rfind('.', 0, len(source)) == len(source) - 1:
        source = source[:len(source)-1]

print(source)
